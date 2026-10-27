import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/lab_tools.dart';
import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/widgets/job_status.dart';

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
  late DateTime clock;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    clock = DateTime(2026, 10, 25, 12);
  });

  test('kabul edilen reçete ilk adımı oyuncunun başlatmasını bekler', () async {
    final store = await JobStore.load(now: () => clock);
    final job = await store.accept(order);
    expect(store.needsAction(job), isTrue);
    expect(store.isReady(job), isFalse);
    expect(store.nextStep(job)!.label, 'Levigasyon');
    expect(store.remaining(job), order.prepTime);
  });

  test('her adımı oyuncu başlatır; adım bitince sıradakini bekler, sonunda hazır', () async {
    final store = await JobStore.load(now: () => clock);
    await store.accept(order);
    await store.startStep(order.magistralName, havan);
    var job = store.jobFor(order.magistralName)!;
    expect(store.running(job)!.label, 'Levigasyon');
    expect(store.needsAction(job), isFalse);
    expect(store.remaining(job), order.prepTime);

    // Süre dolunca iş kendiliğinden ilerlemez: karıştırma için oyuncuyu bekler.
    clock = clock.add(const Duration(minutes: 30));
    expect(store.needsAction(job), isTrue);
    expect(store.remaining(job), const Duration(minutes: 5));

    await store.startStep(order.magistralName, plastik);
    clock = clock.add(const Duration(minutes: 4));
    await store.startStep(order.magistralName, kavanoz);
    clock = clock.add(const Duration(minutes: 1));
    job = store.jobFor(order.magistralName)!;
    expect(store.isReady(job), isTrue);
    expect([for (final r in job.runs) r.tool], ['Porselen havan', 'Plastik spatül', 'Kavanoz']);
  });

  test('uygun olmayan alete neden yazılır ve o aletle adım başlamaz', () async {
    final store = await JobStore.load(now: () => clock);
    final job = await store.accept(order);
    expect(store.whyNot(havan, job), isNull);
    expect(store.whyNot(plastik, job), 'Bu aleti daha sonra kullanacaksın; önce Levigasyon.');
    expect(store.whyNot(banyo, job), 'Bu reçetede bu alete gerek yok.');
    await store.startStep(order.magistralName, plastik);
    expect(store.jobFor(order.magistralName)!.runs, isEmpty);

    await store.startStep(order.magistralName, havan);
    expect(store.whyNot(havan, store.jobFor(order.magistralName)!), 'Şu an Levigasyon sürüyor.');
    clock = clock.add(const Duration(minutes: 3));
    final j = store.jobFor(order.magistralName)!;
    // Salisilik asit çelikle tepkir; plastik spatül uygun.
    expect(store.whyNot(celik, j), contains('çelikle tepkimeye girer'));
    expect(store.whyNot(plastik, j), isNull);
    expect(store.whyNot(havan, j), 'Bu aletle işin bitti.');
  });

  test('cam havan levigasyonda kullanılamaz', () async {
    final cam = labTools(owns: (i) => isOwned(i) || i.name == 'Cam havan').firstWhere((t) => t.name == 'Cam havan');
    final store = await JobStore.load(now: () => clock);
    final job = await store.accept(zno);
    expect(store.whyNot(cam, job), 'Cam havan kaygandır, tozu ezmez.');
  });

  test('bir alet aynı anda tek reçetede çalışır; farklı aletler farklı reçetelerde aynı anda', () async {
    final store = await JobStore.load(now: () => clock);
    await store.accept(order);
    await store.accept(zno);
    await store.startStep(order.magistralName, havan);
    final second = store.jobFor(zno.magistralName)!;
    expect(store.whyNot(havan, second), 'Alet dolu: ${order.magistralName} bitince kullanabilirsin.');
    expect(store.busyWith(havan)!.job.magistralName, order.magistralName);

    // İki reçete de karıştırmada: biri plastik, öbürü çelik spatülle aynı anda.
    clock = clock.add(const Duration(minutes: 3));
    await store.startStep(zno.magistralName, havan);
    clock = clock.add(const Duration(minutes: 4));
    await store.startStep(order.magistralName, plastik);
    await store.startStep(zno.magistralName, celik);
    expect(store.busyWith(plastik)!.job.magistralName, order.magistralName);
    expect(store.busyWith(celik)!.job.magistralName, zno.magistralName);
  });

  test('uygulama kapanıp açılınca adımlar kaldığı yerden devam eder', () async {
    final first = await JobStore.load(now: () => clock);
    await first.accept(order);
    await first.startStep(order.magistralName, havan);

    clock = clock.add(const Duration(minutes: 1));
    final reopened = await JobStore.load(now: () => clock);
    final job = reopened.jobFor(order.magistralName)!;
    expect(reopened.running(job)!.end.difference(clock), const Duration(minutes: 2));
    expect(job.stars, 3);
  });

  test('hazır olmayan iş teslim edilemez, hazır olan teslim edilip silinir', () async {
    final store = await JobStore.load(now: () => clock);
    await store.accept(order);
    expect(await store.deliver(order.magistralName), isNull);
    for (final t in [havan, plastik, kavanoz]) {
      await store.startStep(order.magistralName, t);
      clock = clock.add(const Duration(minutes: 10));
    }
    expect((await store.deliver(order.magistralName))?.stars, 3);
    expect(store.jobFor(order.magistralName), isNull);
    expect((await JobStore.load(now: () => clock)).jobs, isEmpty);
  });

  test('bozuk kayıt oyunu açılmaz hâle getirmez', () async {
    SharedPreferences.setMockInitialValues({'prep_jobs_v2': 'bozuk{'});
    expect((await JobStore.load(now: () => clock)).jobs, isEmpty);
    SharedPreferences.setMockInitialValues({'prep_jobs_v2': '[{"magistralName": 3}]'});
    expect((await JobStore.load(now: () => clock)).jobs, isEmpty);
  });

  test('acele et çalışan adımın süresini ve kaliteyi yarıya indirir: 3 → 2 → 1 → 1', () async {
    final store = await JobStore.load(now: () => clock);
    await store.accept(zno);
    await store.startStep(zno.magistralName, havan); // 4 dk
    await store.rush(zno.magistralName);
    var job = store.jobFor(zno.magistralName)!;
    expect(store.running(job)!.end.difference(clock), const Duration(minutes: 2));
    expect(job.stars, 2);
    expect(job.notes.single, contains('Acele'));

    await store.rush(zno.magistralName);
    await store.rush(zno.magistralName);
    job = store.jobFor(zno.magistralName)!;
    expect(job.stars, 1);
    expect(store.running(job)!.end.difference(clock), const Duration(seconds: 30));
    expect(job.notes, hasLength(1));
    expect(store.rushesLeft, JobStore.dailyRushes - 3);
  });

  test('oyuncuyu bekleyen reçetede acele edilmez; günde 5 hak, ertesi gün yenilenir', () async {
    final store = await JobStore.load(now: () => clock);
    await store.accept(cream);
    expect(store.canRush(store.jobFor(cream.magistralName)!), isFalse);

    await store.accept(order);
    await store.startStep(order.magistralName, havan);
    for (var i = 0; i < 6; i++) {
      await store.rush(order.magistralName);
    }
    expect(store.rushesLeft, 0);
    expect(store.canRush(store.jobFor(order.magistralName)!), isFalse);

    clock = clock.add(const Duration(days: 1));
    expect((await JobStore.load(now: () => clock)).rushesLeft, JobStore.dailyRushes);
  });

  test('kalan süre dakika:saniye ya da saat dakika olarak yazılır', () {
    expect(formatRemaining(const Duration(minutes: 9, seconds: 5)), '09:05');
    expect(formatRemaining(const Duration(hours: 1, minutes: 5)), '1 sa 05 dk');
  });
}
