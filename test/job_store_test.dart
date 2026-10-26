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

  test('başlatılan işin kalan süresi saatle azalır, süre dolunca hazır olur', () async {
    final store = await JobStore.load(now: () => clock);
    final job = await store.start(order, result);
    expect(store.remaining(job), order.prepTime);
    expect(store.isReady(job), isFalse);

    clock = clock.add(const Duration(minutes: 4));
    expect(store.remaining(job), order.prepTime - const Duration(minutes: 4));

    clock = clock.add(order.prepTime);
    expect(store.remaining(job), Duration.zero);
    expect(store.isReady(job), isTrue);
    expect(store.progress(job), 1.0);
  });

  test('uygulama kapanıp açılınca iş ve sonucu kaldığı yerden devam eder', () async {
    final first = await JobStore.load(now: () => clock);
    await first.start(order, result);

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
    final first = await store.start(order, result);
    final second = await store.start(prescriptionOrders[1], result);
    expect(second.readyAt.isAfter(clock.add(prescriptionOrders[1].prepTime)), isTrue);

    final terazi = store.station(LabStation.terazi);
    expect(terazi.job!.magistralName, first.magistralName);
    expect(terazi.queued, 1);

    // Kaydedilip açılınca adım zamanları aynı kalır.
    final reopened = await JobStore.load(now: () => clock);
    expect(reopened.jobFor(second.magistralName)!.readyAt, second.readyAt);
  });

  test('kremde ısıtma bitince iş oyuncuyu bekler, termometreden sonra devam eder', () async {
    final cream = prescriptionOrders[2]; // tartım 3, ısıtma 10 (oyuncu), emülsifikasyon 9, soğuma 8
    final store = await JobStore.load(now: () => clock);
    final job = await store.start(cream, result);
    expect(job.slots.map((s) => s.label), ['Tartım', 'Isıtma']);
    expect(job.pending.map((p) => p.label), ['Emülsifikasyon', 'Soğuma']);

    // Isıtma süresi dolmadan oyuncu bir şey yapamaz.
    clock = clock.add(const Duration(minutes: 12));
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
