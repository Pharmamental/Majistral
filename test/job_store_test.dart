import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/widgets/job_status.dart';

import 'test_helpers.dart';

void main() {
  final order = prescriptionOrders.first; // %5 SA: ezme 1, levigasyon 3, geometrik seyreltme 4
  final zno = prescriptionOrders[1]; // levigasyon 5, geometrik seyreltme 7
  final cream = prescriptionOrders[2]; // eritme 6 (oyun), çözme 4, emülsifikasyon 9, soğutma 8
  final tools = {for (final t in labTools()) t.name: t};
  final ezme = tools['Ezme']!;
  final levigasyon = tools['Levigasyon']!;
  final seyreltme = tools['Geometrik seyreltme']!;
  final eritme = tools['Eritme']!;
  final cozme = tools['Çözme']!;
  final emulsiyon = tools['Emülsifikasyon']!;
  final sogutma = tools['Soğutma']!;
  late DateTime clock;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    clock = DateTime(2026, 10, 25, 12);
  });

  test('kabul edilen reçete ilk adımı oyuncunun başlatmasını bekler', () async {
    final store = await JobStore.load(now: () => clock);
    final job = await take(store, order);
    expect(store.needsAction(job), isTrue);
    expect(store.isReady(job), isFalse);
    expect(store.nextStep(job)!.label, 'Ezme');
    expect(store.remaining(job), order.prepTime);
  });

  test('her adımı oyuncu başlatır; adım bitince sıradakini bekler, sonunda hazır', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, order); // ezme 1, levigasyon 3, geometrik seyreltme 4
    await store.startStep(jobOf(store, order)!.id, ezme);
    var job = jobOf(store, order)!;
    expect(store.running(job)!.label, 'Ezme');
    expect(store.needsAction(job), isFalse);
    expect(store.remaining(job), order.prepTime);

    // Süre dolunca iş kendiliğinden ilerlemez: levigasyon için oyuncuyu bekler.
    clock = clock.add(const Duration(minutes: 30));
    expect(store.needsAction(job), isTrue);
    expect(store.remaining(job), const Duration(minutes: 7));

    await store.startStep(jobOf(store, order)!.id, levigasyon);
    clock = clock.add(const Duration(minutes: 3));
    await store.startStep(jobOf(store, order)!.id, seyreltme);
    clock = clock.add(const Duration(minutes: 4));
    job = jobOf(store, order)!;
    expect(store.isReady(job), isTrue);
    expect([for (final r in job.runs) r.tool], ['Ezme', 'Levigasyon', 'Geometrik seyreltme']);
  });

  test('sırası gelmemiş ya da reçetede olmayan adıma neden yazılır, o adım başlamaz', () async {
    final store = await JobStore.load(now: () => clock);
    final job = await take(store, order);
    expect(store.whyNot(ezme, job), isNull);
    expect(store.whyNot(eritme, job), 'Bu reçetede bu adım yok.');
    expect(store.whyNot(levigasyon, job), 'Bu adım daha sonra; önce Ezme.');
    await store.startStep(jobOf(store, order)!.id, levigasyon);
    expect(jobOf(store, order)!.runs, isEmpty);

    await store.startStep(jobOf(store, order)!.id, ezme);
    expect(store.whyNot(levigasyon, jobOf(store, order)!), 'Şu an Ezme sürüyor.');
    clock = clock.add(const Duration(minutes: 1));
    final j = jobOf(store, order)!;
    expect(store.whyNot(levigasyon, j), isNull);
    expect(store.whyNot(ezme, j), 'Bu adım bitti.');
  });

  test('kremde yağ fazı eritilir, su fazındakiler çözülür, kapsülde emülsiyon yapılıp soğutulur', () async {
    final store = await JobStore.load(now: () => clock);
    var job = await take(store, cream); // eritme 6, çözme 4, emülsifikasyon 9, soğutma 8
    expect(store.whyNot(seyreltme, job), 'Bu reçetede bu adım yok.');
    expect(store.whyNot(emulsiyon, job), 'Bu adım daha sonra; önce Eritme.');
    for (final (step, minutes) in [(eritme, 6), (cozme, 4), (emulsiyon, 9), (sogutma, 8)]) {
      await store.startStep(job.id, step); // termometre oyunu ekranda; burada doğrudan başlar
      clock = clock.add(Duration(minutes: minutes));
    }
    job = store.job(job.id)!;
    expect([for (final r in job.runs) r.label], ['Eritme', 'Çözme', 'Emülsifikasyon', 'Soğutma']);
    expect(store.isReady(job), isTrue);
  });

  test('alet kuralı uyarı olarak adımda durur: salisilik asitte çelik spatül, cam havan', () {
    final steps = {for (final s in order.steps) s.label: s};
    expect(steps['Ezme']!.notWith['Çelik spatül'], contains('çelikle tepkimeye girer'));
    expect(zno.steps.first.notWith['Cam havan'], 'Cam havan kaygandır, tozu ezmez.');
    expect(tools['Levigasyon']!.equipment,
        unlockAll ? 'Porselen havan · Merhem değirmeni' : 'Porselen havan · Merhem taşı ve spatül');
  });

  test('bir adım kartı aynı anda tek reçetede çalışır; farklı kartlar farklı reçetelerde aynı anda', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, order);
    await take(store, zno);
    await store.startStep(jobOf(store, order)!.id, ezme);
    await store.startStep(jobOf(store, zno)!.id, levigasyon); // levigasyon 5 dk
    expect(store.busyWith(ezme)!.job.magistralName, order.magistralName);
    expect(store.busyWith(levigasyon)!.job.magistralName, zno.magistralName);

    clock = clock.add(const Duration(minutes: 1)); // ezme bitti; levigasyon kartı dolu
    final sa = jobOf(store, order)!;
    expect(store.whyNot(levigasyon, sa), 'Dolu: ${zno.magistralName} bitince yapabilirsin.');
    clock = clock.add(const Duration(minutes: 4));
    expect(store.whyNot(levigasyon, jobOf(store, order)!), isNull);
  });

  test('uygulama kapanıp açılınca adımlar kaldığı yerden devam eder', () async {
    final first = await JobStore.load(now: () => clock);
    await take(first, order);
    await first.startStep(jobOf(first, order)!.id, ezme);

    clock = clock.add(const Duration(seconds: 20));
    final reopened = await JobStore.load(now: () => clock);
    final job = jobOf(reopened, order)!;
    expect(reopened.running(job)!.end.difference(clock), const Duration(seconds: 40));
    expect(job.stars, 3);
  });

  test('hazır olmayan iş teslim edilemez, hazır olan teslim edilip silinir', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, order);
    expect(await store.deliver(jobOf(store, order)!.id), isNull);
    for (final t in [ezme, levigasyon, seyreltme]) {
      await store.startStep(jobOf(store, order)!.id, t);
      clock = clock.add(const Duration(minutes: 10));
    }
    expect((await store.deliver(jobOf(store, order)!.id))?.stars, 3);
    expect(jobOf(store, order), isNull);
    expect((await JobStore.load(now: () => clock)).jobs, isEmpty);
  });

  test('bozuk kayıt oyunu açılmaz hâle getirmez', () async {
    SharedPreferences.setMockInitialValues({'prep_jobs_v3': 'bozuk{'});
    expect((await JobStore.load(now: () => clock)).jobs, isEmpty);
    SharedPreferences.setMockInitialValues({'prep_jobs_v3': '[{"magistralName": 3}]'});
    expect((await JobStore.load(now: () => clock)).jobs, isEmpty);
  });

  test('acele et çalışan adımın süresini ve kaliteyi yarıya indirir: 3 → 2 → 1 → 1', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, zno);
    await store.startStep(jobOf(store, zno)!.id, levigasyon); // 5 dk
    await store.rush(jobOf(store, zno)!.id);
    var job = jobOf(store, zno)!;
    expect(store.running(job)!.end.difference(clock), const Duration(minutes: 2, seconds: 30));
    expect(job.stars, 2);
    expect(job.notes.single, contains('Acele'));

    await store.rush(jobOf(store, zno)!.id);
    await store.rush(jobOf(store, zno)!.id);
    job = jobOf(store, zno)!;
    expect(job.stars, 1);
    expect(store.running(job)!.end.difference(clock), const Duration(milliseconds: 37500));
    expect(job.notes, hasLength(1));
    expect(store.rushesLeft, JobStore.dailyRushes - 3);
  });

  test('oyuncuyu bekleyen reçetede acele edilmez; günde 5 hak, ertesi gün yenilenir', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, cream);
    expect(store.canRush(jobOf(store, cream)!), isFalse);

    await take(store, order);
    await store.startStep(jobOf(store, order)!.id, ezme);
    for (var i = 0; i < 6; i++) {
      await store.rush(jobOf(store, order)!.id);
    }
    expect(store.rushesLeft, 0);
    expect(store.canRush(jobOf(store, order)!), isFalse);

    clock = clock.add(const Duration(days: 1));
    expect((await JobStore.load(now: () => clock)).rushesLeft, JobStore.dailyRushes);
  });

  test('ilk açılışta duvar 3 reçeteyle dolu; doluyken yeni reçete gelmez', () async {
    final store = await JobStore.load(now: () => clock);
    expect([for (final w in store.wall) w.magistralName],
        [for (final o in prescriptionOrders.take(JobStore.wallSize)) o.magistralName]);
    expect(store.untilNextArrival, isNull);
    clock = clock.add(const Duration(hours: 2));
    expect(store.wall, hasLength(JobStore.wallSize));
  });

  test('sayaç doluyken reçete alınca yenisi hemen gelir, sayaç o andan başlar', () async {
    final store = await JobStore.load(now: () => clock);
    clock = clock.add(const Duration(minutes: 15)); // sayaç 10. dakikada doldu, duvar dolu
    await take(store, order);
    expect(store.wall, hasLength(3)); // yerine hemen yenisi geldi
    expect(store.wall.last.magistralName, prescriptionOrders[JobStore.wallSize].magistralName); // sırayla döner

    await take(store, zno);
    expect(store.wall, hasLength(2));
    expect(store.untilNextArrival, JobStore.arrivalEvery);
  });

  test('sayaç dolmadan alınırsa yenisi sayaç dolunca gelir', () async {
    final store = await JobStore.load(now: () => clock);
    clock = clock.add(const Duration(minutes: 4));
    await take(store, order);
    expect(store.wall, hasLength(2));
    expect(store.untilNextArrival, const Duration(minutes: 6));
    clock = clock.add(const Duration(minutes: 6));
    expect(store.wall, hasLength(3));
  });

  test('kapalıyken de reçete gelir ama duvar 3\'ü geçmez; kayıtta kalır', () async {
    final store = await JobStore.load(now: () => clock);
    for (final o in prescriptionOrders.take(JobStore.wallSize)) {
      await take(store, o);
    }
    expect(store.wall, isEmpty);
    clock = clock.add(const Duration(minutes: 25));
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.wall, hasLength(2)); // 10. ve 20. dakikada
    expect(reopened.untilNextArrival, const Duration(minutes: 5));
    clock = clock.add(const Duration(hours: 3));
    expect(reopened.wall, hasLength(3));
  });

  test('aynı reçete ikinci kez gelince iki iş ayrı tutulur', () async {
    // Üç reçetelik dönüşte salisilik asit 10 dakika sonra yeniden gelir.
    final store = await JobStore.load(now: () => clock, orders: prescriptionOrders.take(3).toList());
    final first = await take(store, order);
    clock = clock.add(const Duration(minutes: 10));
    final second = await take(store, order); // dönüşte yeniden gelen salisilik asit
    expect(second.id, isNot(first.id));
    await store.startStep(first.id, ezme);
    expect(store.running(store.job(first.id)!), isNotNull);
    expect(store.running(store.job(second.id)!), isNull);
  });

  test('kalan süre dakika:saniye ya da saat dakika olarak yazılır', () {
    expect(formatRemaining(const Duration(minutes: 9, seconds: 5)), '09:05');
    expect(formatRemaining(const Duration(hours: 1, minutes: 5)), '1 sa 05 dk');
  });
}
