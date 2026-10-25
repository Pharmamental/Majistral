import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:game/data/orders.dart';
import 'package:game/logic/job_store.dart';
import 'package:game/logic/quality.dart';
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

  test('kalan süre dakika:saniye ya da saat dakika olarak yazılır', () {
    expect(formatRemaining(const Duration(minutes: 9, seconds: 5)), '09:05');
    expect(formatRemaining(const Duration(hours: 1, minutes: 5)), '1 sa 05 dk');
  });
}
