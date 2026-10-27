import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/widgets/job_status.dart';

import 'test_helpers.dart';

void main() {
  final order = prescriptionOrders.first; // %5 SA: levigasyon 3, karıştırma 4, etiket 1
  final zno = prescriptionOrders[1]; // levigasyon 4, karıştırma 6, etiket 2
  final cream = prescriptionOrders[2]; // ısıtma 10 (oyun), emülsifikasyon 9, soğuma 8
  final tools = {for (final t in labTools()) t.name: t};
  final havan = tools['Porselen havan']!;
  final celik = tools['Çelik spatül']!;
  final plastik = tools['Plastik spatül']!;
  final banyo = tools['Ocak ve su banyosu']!;
  final kavanoz = tools['Kavanoz']!;
  final kapsul = tools['Porselen kapsül']!;
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
    expect(store.nextStep(job)!.label, 'Levigasyon');
    expect(store.remaining(job), order.prepTime);
  });

  test('her adımı oyuncu başlatır; adım bitince sıradakini bekler, sonunda hazır', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, order);
    await store.startStep(jobOf(store, order)!.id, havan);
    var job = jobOf(store, order)!;
    expect(store.running(job)!.label, 'Levigasyon');
    expect(store.needsAction(job), isFalse);
    expect(store.remaining(job), order.prepTime);

    // Süre dolunca iş kendiliğinden ilerlemez: karıştırma için oyuncuyu bekler.
    clock = clock.add(const Duration(minutes: 30));
    expect(store.needsAction(job), isTrue);
    expect(store.remaining(job), const Duration(minutes: 5));

    await store.startStep(jobOf(store, order)!.id, plastik);
    clock = clock.add(const Duration(minutes: 4));
    await store.startStep(jobOf(store, order)!.id, kavanoz);
    clock = clock.add(const Duration(minutes: 1));
    job = jobOf(store, order)!;
    expect(store.isReady(job), isTrue);
    expect([for (final r in job.runs) r.tool], ['Porselen havan', 'Plastik spatül', 'Kavanoz']);
  });

  test('uygun olmayan alete neden yazılır ve o aletle adım başlamaz', () async {
    final store = await JobStore.load(now: () => clock);
    final job = await take(store, order);
    expect(store.whyNot(havan, job), isNull);
    expect(store.whyNot(plastik, job), 'Bu aleti daha sonra kullanacaksın; önce Levigasyon.');
    expect(store.whyNot(banyo, job), 'Bu reçetede bu alete gerek yok.');
    await store.startStep(jobOf(store, order)!.id, plastik);
    expect(jobOf(store, order)!.runs, isEmpty);

    await store.startStep(jobOf(store, order)!.id, havan);
    expect(store.whyNot(havan, jobOf(store, order)!), 'Şu an Levigasyon sürüyor.');
    clock = clock.add(const Duration(minutes: 3));
    final j = jobOf(store, order)!;
    // Salisilik asit çelikle tepkir; plastik spatül uygun.
    expect(store.whyNot(celik, j), contains('çelikle tepkimeye girer'));
    expect(store.whyNot(plastik, j), isNull);
    expect(store.whyNot(havan, j), 'Bu aletle işin bitti.');
  });

  test('kremde emülsifikasyon ve soğuma porselen kapsülde; spatül bu reçetede gerekmez', () async {
    final store = await JobStore.load(now: () => clock);
    var job = await take(store, cream);
    expect(store.whyNot(plastik, job), 'Bu reçetede bu alete gerek yok.');
    expect(store.whyNot(kapsul, job), 'Bu aleti daha sonra kullanacaksın; önce Isıtma.');
    await store.startStep(job.id, banyo); // termometre oyunu ekranda; burada doğrudan başlar
    clock = clock.add(const Duration(minutes: 10));
    await store.startStep(job.id, kapsul);
    clock = clock.add(const Duration(minutes: 9));
    await store.startStep(job.id, kapsul);
    clock = clock.add(const Duration(minutes: 8));
    job = store.job(job.id)!;
    expect([for (final r in job.runs) r.tool], ['Ocak ve su banyosu', 'Porselen kapsül', 'Porselen kapsül']);
    expect(store.isReady(job), isTrue);
  });

  test('cam havan levigasyonda kullanılamaz', () async {
    final cam = labTools(owns: (i) => isOwned(i) || i.name == 'Cam havan').firstWhere((t) => t.name == 'Cam havan');
    final store = await JobStore.load(now: () => clock);
    final job = await take(store, zno);
    expect(store.whyNot(cam, job), 'Cam havan kaygandır, tozu ezmez.');
  });

  test('bir alet aynı anda tek reçetede çalışır; farklı aletler farklı reçetelerde aynı anda', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, order);
    await take(store, zno);
    await store.startStep(jobOf(store, order)!.id, havan);
    final second = jobOf(store, zno)!;
    expect(store.whyNot(havan, second), 'Alet dolu: ${order.magistralName} bitince kullanabilirsin.');
    expect(store.busyWith(havan)!.job.magistralName, order.magistralName);

    // İki reçete de karıştırmada: biri plastik, öbürü çelik spatülle aynı anda.
    clock = clock.add(const Duration(minutes: 3));
    await store.startStep(jobOf(store, zno)!.id, havan);
    clock = clock.add(const Duration(minutes: 4));
    await store.startStep(jobOf(store, order)!.id, plastik);
    await store.startStep(jobOf(store, zno)!.id, celik);
    expect(store.busyWith(plastik)!.job.magistralName, order.magistralName);
    expect(store.busyWith(celik)!.job.magistralName, zno.magistralName);
  });

  test('uygulama kapanıp açılınca adımlar kaldığı yerden devam eder', () async {
    final first = await JobStore.load(now: () => clock);
    await take(first, order);
    await first.startStep(jobOf(first, order)!.id, havan);

    clock = clock.add(const Duration(minutes: 1));
    final reopened = await JobStore.load(now: () => clock);
    final job = jobOf(reopened, order)!;
    expect(reopened.running(job)!.end.difference(clock), const Duration(minutes: 2));
    expect(job.stars, 3);
  });

  test('hazır olmayan iş teslim edilemez, hazır olan teslim edilip silinir', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, order);
    expect(await store.deliver(jobOf(store, order)!.id), isNull);
    for (final t in [havan, plastik, kavanoz]) {
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
    await store.startStep(jobOf(store, zno)!.id, havan); // 4 dk
    await store.rush(jobOf(store, zno)!.id);
    var job = jobOf(store, zno)!;
    expect(store.running(job)!.end.difference(clock), const Duration(minutes: 2));
    expect(job.stars, 2);
    expect(job.notes.single, contains('Acele'));

    await store.rush(jobOf(store, zno)!.id);
    await store.rush(jobOf(store, zno)!.id);
    job = jobOf(store, zno)!;
    expect(job.stars, 1);
    expect(store.running(job)!.end.difference(clock), const Duration(seconds: 30));
    expect(job.notes, hasLength(1));
    expect(store.rushesLeft, JobStore.dailyRushes - 3);
  });

  test('oyuncuyu bekleyen reçetede acele edilmez; günde 5 hak, ertesi gün yenilenir', () async {
    final store = await JobStore.load(now: () => clock);
    await take(store, cream);
    expect(store.canRush(jobOf(store, cream)!), isFalse);

    await take(store, order);
    await store.startStep(jobOf(store, order)!.id, havan);
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
    expect([for (final w in store.wall) w.magistralName], [for (final o in prescriptionOrders) o.magistralName]);
    expect(store.untilNextArrival, isNull);
    clock = clock.add(const Duration(hours: 2));
    expect(store.wall, hasLength(JobStore.wallSize));
  });

  test('sayaç doluyken reçete alınca yenisi hemen gelir, sayaç o andan başlar', () async {
    final store = await JobStore.load(now: () => clock);
    clock = clock.add(const Duration(minutes: 15)); // sayaç 10. dakikada doldu, duvar dolu
    await take(store, order);
    expect(store.wall, hasLength(3)); // yerine hemen yenisi geldi
    expect(store.wall.last.magistralName, order.magistralName); // reçeteler sırayla döner

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
    for (final o in prescriptionOrders) {
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
    final store = await JobStore.load(now: () => clock);
    final first = await take(store, order);
    clock = clock.add(const Duration(minutes: 10));
    final second = await take(store, order); // dönüşte yeniden gelen salisilik asit
    expect(second.id, isNot(first.id));
    await store.startStep(first.id, havan);
    expect(store.running(store.job(first.id)!), isNotNull);
    expect(store.running(store.job(second.id)!), isNull);
  });

  test('kalan süre dakika:saniye ya da saat dakika olarak yazılır', () {
    expect(formatRemaining(const Duration(minutes: 9, seconds: 5)), '09:05');
    expect(formatRemaining(const Duration(hours: 1, minutes: 5)), '1 sa 05 dk');
  });
}
