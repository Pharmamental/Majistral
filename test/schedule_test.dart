import 'package:flutter_test/flutter_test.dart';

import 'package:game/data/orders.dart';
import 'package:game/logic/schedule.dart';
import 'package:game/models/prep_job.dart';
import 'package:game/models/prescription.dart';

void main() {
  final t0 = DateTime(2026, 10, 26, 12);
  final sa = prescriptionOrders[0]; // terazi 0 (oyuncu tartar), havan 3, karıştırma 4, ambalaj 1
  final zno = prescriptionOrders[1]; // terazi 0, havan 4, karıştırma 6, ambalaj 2

  PrepJob job(PrescriptionOrder o, List<StepSlot> slots) =>
      PrepJob(magistralName: o.magistralName, startedAt: slots.first.start, slots: slots, stars: 3, notes: const []);

  test('istasyonlar boşken adımlar arka arkaya, toplam süre adımların toplamı', () {
    final slots = planSlots(sa.steps, t0, const []);
    expect([for (final s in slots) s.station],
        [LabStation.terazi, LabStation.havan, LabStation.karistirma, LabStation.ambalaj]);
    expect(slots.first.start, t0);
    for (var i = 1; i < slots.length; i++) {
      expect(slots[i].start, slots[i - 1].end);
    }
    expect(slots.last.end.difference(t0), sa.prepTime);
  });

  test('aynı anda başlayan ikinci iş dolu istasyonda sıra bekler', () {
    final first = planSlots(sa.steps, t0, const []);
    final second = planSlots(zno.steps, t0, first);
    // Havan ilk 3 dk dolu: ikinci işin levigasyonu 3. dakikada başlar.
    expect(second[1].start, t0.add(const Duration(minutes: 3)));
    // Hiçbir istasyonda iki iş çakışmaz.
    for (final a in first) {
      for (final b in second) {
        if (a.station != b.station) continue;
        final cakisir = a.start.isBefore(b.end) && b.start.isBefore(a.end);
        expect(cakisir, isFalse, reason: '${a.station} çakışıyor');
      }
    }
    expect(second.last.end.difference(t0), greaterThan(zno.prepTime));
  });

  test('yeni iş eski işlerin zamanını değiştirmez', () {
    final first = planSlots(sa.steps, t0, const []);
    final copy = [for (final s in first) s.end];
    planSlots(zno.steps, t0, first);
    expect([for (final s in first) s.end], copy);
  });

  test('istasyon durumu: çalışan iş ve sıradaki adım sayısı', () {
    final a = job(sa, planSlots(sa.steps, t0, const []));
    final b = job(zno, planSlots(zno.steps, t0, a.slots));
    final at = t0.add(const Duration(minutes: 1));
    final havan = stationState(LabStation.havan, [a, b], at);
    expect(havan.busy, isTrue);
    expect(havan.job!.magistralName, sa.magistralName);
    expect(havan.queued, 1);
    expect(stationState(LabStation.isitma, [a, b], at).busy, isFalse);
    expect(b.waitingAt(at)!.label, 'Levigasyon');
  });
}
