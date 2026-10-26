import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/logic/quality.dart';
import 'package:game/models/prescription.dart';
import 'package:game/widgets/job_status.dart';

void main() {
  final order = prescriptionOrders.first;
  const result = PreparationResult(stars: 2, notes: ['Eksik kimyasal: X.']);
  late DateTime clock;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    clock = DateTime(2026, 10, 25, 12);
  });

  test('iş terazide oyuncuyu bekler; tartımdan sonra süre işler, dolunca hazır olur', () async {
    final store = await JobStore.load(now: () => clock);
    var job = await store.start(order, result);
    expect(store.needsAction(job), isTrue);
    expect(job.slots.single.station, LabStation.terazi);

    // Beklemek tartımı yapmaz.
    clock = clock.add(const Duration(hours: 1));
    expect(store.needsAction(store.jobFor(order.magistralName)!), isTrue);

    await store.completeAction(order.magistralName);
    job = store.jobFor(order.magistralName)!;
    expect(store.remaining(job), order.prepTime);
    clock = clock.add(const Duration(minutes: 4));
    expect(store.remaining(job), order.prepTime - const Duration(minutes: 4));

    clock = clock.add(order.prepTime);
    expect(store.remaining(job), Duration.zero);
    expect(store.isReady(job), isTrue);
    expect(store.progress(job), 1.0);
  });

  test('yanlış tartım bir yıldız götürür ve açıklaması teslimde görünür', () async {
    final store = await JobStore.load(now: () => clock);
    await store.start(order, const PreparationResult(stars: 3, notes: []));
    // "ad 50 g" unutulup vazelinden 50 g tartıldı.
    final mistakes = evaluateWeighing(order, {'Salisilik Asit': 2.5, 'Sıvı Parafin': 1.25, 'Beyaz Vazelin': 50});
    await store.completeAction(order.magistralName, mistakes: mistakes);
    final job = store.jobFor(order.magistralName)!;
    expect(job.stars, 2);
    expect(job.notes.first, 'Tartım: Beyaz Vazelin 50 g tartıldı, doğrusu 46,25 g.');
    expect(job.notes.last, order.calcHint);

    // Yıldız 1'in altına düşmez.
    final low = await JobStore.load(now: () => clock);
    await low.start(prescriptionOrders[1], const PreparationResult(stars: 1, notes: []));
    await low.completeAction(prescriptionOrders[1].magistralName, mistakes: ['x']);
    expect(low.jobFor(prescriptionOrders[1].magistralName)!.stars, 1);
  });

  test('uygulama kapanıp açılınca iş ve sonucu kaldığı yerden devam eder', () async {
    final first = await JobStore.load(now: () => clock);
    await first.start(order, result);
    await first.completeAction(order.magistralName);

    clock = clock.add(const Duration(minutes: 3));
    final reopened = await JobStore.load(now: () => clock);
    final job = reopened.jobFor(order.magistralName)!;
    expect(reopened.remaining(job), order.prepTime - const Duration(minutes: 3));
    expect(job.stars, 2);
    expect(job.notes, result.notes);
  });

  test('hazır olmayan iş teslim edilemez, hazır olan teslim edilip silinir', () async {
    final store = await JobStore.load(now: () => clock);
    await store.start(order, result);
    expect(await store.deliver(order.magistralName), isNull);
    await store.completeAction(order.magistralName);
    expect(await store.deliver(order.magistralName), isNull);

    clock = clock.add(order.prepTime);
    final delivered = await store.deliver(order.magistralName);
    expect(delivered?.stars, 2);
    expect(store.jobFor(order.magistralName), isNull);

    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.jobs, isEmpty);
  });

  test('bozuk kayıt oyunu açılmaz hâle getirmez', () async {
    SharedPreferences.setMockInitialValues({'prep_jobs_v1': 'bozuk{'});
    final store = await JobStore.load(now: () => clock);
    expect(store.jobs, isEmpty);
  });

  test('ikinci iş dolu istasyonda bekler, laboratuvar bunu gösterir', () async {
    final store = await JobStore.load(now: () => clock);
    final second = prescriptionOrders[1];
    await store.start(order, result);
    await store.start(second, result);
    await store.completeAction(order.magistralName);
    await store.completeAction(second.magistralName);
    final job = store.jobFor(second.magistralName)!;
    expect(job.readyAt.isAfter(clock.add(second.prepTime)), isTrue);

    final havan = store.station(LabStation.havan);
    expect(havan.job!.magistralName, order.magistralName);
    expect(havan.queued, 1);

    // Kaydedilip açılınca adım zamanları aynı kalır.
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.jobFor(second.magistralName)!.readyAt, job.readyAt);
  });

  test('kremde ısıtma bitince iş oyuncuyu bekler, termometreden sonra devam eder', () async {
    final cream = prescriptionOrders[2]; // tartım (oyuncu), ısıtma 10 (oyuncu), emülsifikasyon 9, soğuma 8
    final store = await JobStore.load(now: () => clock);
    await store.start(cream, result);
    await store.completeAction(cream.magistralName); // tartım
    final job = store.jobFor(cream.magistralName)!;
    expect(job.slots.map((s) => s.label), ['Tartım', 'Isıtma']);
    expect(job.pending.map((p) => p.label), ['Emülsifikasyon', 'Soğuma']);

    // Isıtma süresi dolmadan oyuncu bir şey yapamaz.
    clock = clock.add(const Duration(minutes: 9));
    expect(store.needsAction(store.jobFor(cream.magistralName)!), isFalse);
    await store.completeAction(cream.magistralName);
    expect(store.jobFor(cream.magistralName)!.pending, hasLength(2));

    // Süre dolunca iş durur: hazır değil, oyuncuyu bekliyor; beklemek bitirmez.
    clock = clock.add(const Duration(minutes: 30));
    var j = store.jobFor(cream.magistralName)!;
    expect(store.needsAction(j), isTrue);
    expect(store.isReady(j), isFalse);

    // Kayıt açılıp kapansa da bekleme sürer.
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.needsAction(reopened.jobFor(cream.magistralName)!), isTrue);

    // Termometreden sonra kalan adımlar şu andan planlanır.
    final actionAt = clock;
    await store.completeAction(cream.magistralName);
    j = store.jobFor(cream.magistralName)!;
    expect(j.pending, isEmpty);
    expect(j.slots[2].start, actionAt);
    expect(j.readyAt, actionAt.add(const Duration(minutes: 17)));
    clock = clock.add(const Duration(minutes: 17));
    expect(store.isReady(j), isTrue);
  });

  test('acele et süreyi ve kaliteyi yarıya indirir: 3 → 2 → 1 → 1', () async {
    final store = await JobStore.load(now: () => clock);
    await store.start(order, const PreparationResult(stars: 3, notes: []));
    await store.completeAction(order.magistralName);
    expect(store.remaining(store.jobFor(order.magistralName)!), const Duration(minutes: 8));

    await store.rush(order.magistralName);
    var job = store.jobFor(order.magistralName)!;
    expect(store.remaining(job), const Duration(minutes: 4));
    expect(job.stars, 2);
    expect(job.notes.single, contains('Acele'));

    await store.rush(order.magistralName);
    await store.rush(order.magistralName);
    job = store.jobFor(order.magistralName)!;
    expect(job.stars, 1);
    expect(store.remaining(job), const Duration(minutes: 1));
    expect(job.notes, hasLength(1));
    expect(store.rushesLeft, JobStore.dailyRushes - 3);
  });

  test('acele sonrası aynı istasyonu bekleyen iş öne kayar ve bu kayıtta kalır', () async {
    final store = await JobStore.load(now: () => clock);
    final second = prescriptionOrders[1];
    await store.start(order, result);
    await store.start(second, result);
    await store.completeAction(order.magistralName);
    await store.completeAction(second.magistralName);
    final before = store.jobFor(second.magistralName)!.readyAt;

    clock = clock.add(const Duration(minutes: 1));
    await store.rush(order.magistralName); // SA havanı 3. yerine 2. dakikada biter
    final moved = store.jobFor(second.magistralName)!;
    expect(moved.slots[1].start, clock.add(const Duration(minutes: 1)));
    expect(moved.readyAt, before.subtract(const Duration(minutes: 1)));
    expect(moved.stars, 2); // yalnız acele edilen işin kalitesi düşer

    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.jobFor(second.magistralName)!.readyAt, moved.readyAt);
  });

  test('oyuncu adımı beklerken acele edilmez; günde 5 hak, ertesi gün yenilenir', () async {
    final store = await JobStore.load(now: () => clock);
    await store.start(order, result);
    expect(store.canRush(store.jobFor(order.magistralName)!), isFalse); // tartım bekliyor
    await store.completeAction(order.magistralName);
    for (var i = 0; i < 6; i++) {
      await store.rush(order.magistralName);
    }
    expect(store.rushesLeft, 0);
    expect(store.canRush(store.jobFor(order.magistralName)!), isFalse);

    clock = clock.add(const Duration(days: 1));
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.rushesLeft, JobStore.dailyRushes);
  });

  test('istasyonlardan önceki kayıt biçimi de açılır', () async {
    SharedPreferences.setMockInitialValues({
      'prep_jobs_v1':
          '[{"magistralName":"Eski","startedAt":${clock.millisecondsSinceEpoch},"durationSeconds":600,"stars":3,"notes":[]}]',
    });
    final store = await JobStore.load(now: () => clock);
    expect(store.remaining(store.jobs.single), const Duration(minutes: 10));
  });

  test('kalan süre dakika:saniye ya da saat dakika olarak yazılır', () {
    expect(formatRemaining(const Duration(minutes: 9, seconds: 5)), '09:05');
    expect(formatRemaining(const Duration(hours: 1, minutes: 5)), '1 sa 05 dk');
  });
}
