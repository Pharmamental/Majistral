import '../models/prep_job.dart';
import '../models/prescription.dart';

/// Yeni bir işin adımlarını istasyonlara yerleştirir.
///
/// Adımlar sırayla çalışır; her adım bir öncekinin bittiği andan sonra, kendi
/// istasyonunun boş olduğu ilk aralıkta başlar. Bir istasyon aynı anda tek iş
/// yapar. Daha önce başlamış işlerin zamanları ([busy]) değişmez; yeni iş
/// onların boşluklarına sığar ya da arkalarına girer.
List<StepSlot> planSlots(
  List<PrescriptionStep> steps,
  DateTime start,
  Iterable<StepSlot> busy,
) =>
    _place([for (final s in steps) PendingStep.of(s)], start, busy);

/// Adımları oyuncunun yapacağı ilk adıma kadar (o dahil) planlar; geri
/// kalanları beklemeye bırakır. O adım bitince kalanlar yine bununla planlanır.
({List<StepSlot> slots, List<PendingStep> pending}) planUntilAction(
  List<PendingStep> steps,
  DateTime start,
  Iterable<StepSlot> busy,
) {
  final stop = steps.indexWhere((s) => s.interactive);
  final now = stop == -1 ? steps : steps.sublist(0, stop + 1);
  final later = stop == -1 ? <PendingStep>[] : steps.sublist(stop + 1);
  return (slots: _place(now, start, busy), pending: later);
}

/// Acele et: işin [now] anından sonraki çalışma süresi yarıya iner. Çalışan
/// adım kaldığı yerden yarı sürede biter; sıradaki adımlar yarı süreyle yeniden
/// yerleştirilir. Başka işlerin zamanları ([others]) değişmez, dolu istasyonda
/// sıra beklemek kısalmaz. Bitmiş adımlar olduğu gibi kalır.
List<StepSlot> rushSlots(List<StepSlot> slots, DateTime now, Iterable<StepSlot> others) {
  final done = [for (final s in slots) if (!now.isBefore(s.end)) s];
  final rest = [for (final s in slots) if (now.isBefore(s.end)) s];
  if (rest.isEmpty) return slots;
  final running = !now.isBefore(rest.first.start) ? rest.first : null;
  final kept = [
    ...done,
    if (running != null)
      StepSlot(
        label: running.label,
        station: running.station,
        start: running.start,
        end: now.add(running.end.difference(now) ~/ 2),
        interactive: running.interactive,
      ),
  ];
  final later = running == null ? rest : rest.skip(1).toList();
  final placed = _placeTimed(
    [for (final s in later) (label: s.label, station: s.station, interactive: s.interactive, length: s.end.difference(s.start) ~/ 2)],
    kept.isEmpty ? now : (kept.last.end.isAfter(now) ? kept.last.end : now),
    [...others, ...kept],
  );
  return [...kept, ...placed];
}

typedef _Timed = ({String label, LabStation station, bool interactive, Duration length});

List<StepSlot> _place(List<PendingStep> steps, DateTime start, Iterable<StepSlot> busy) => _placeTimed(
      [
        for (final s in steps)
          (label: s.label, station: s.station, interactive: s.interactive, length: Duration(minutes: s.minutes)),
      ],
      start,
      busy,
    );

List<StepSlot> _placeTimed(List<_Timed> steps, DateTime start, Iterable<StepSlot> busy) {
  final occupied = [...busy];
  final slots = <StepSlot>[];
  var ready = start;
  for (final step in steps) {
    final length = step.length;
    final onStation = occupied.where((s) => s.station == step.station).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    var begin = ready;
    for (final s in onStation) {
      // [begin, begin+length) ile çakışıyorsa bu işin bitişine kay.
      if (begin.isBefore(s.end) && s.start.isBefore(begin.add(length))) begin = s.end;
    }
    final slot = StepSlot(
      label: step.label,
      station: step.station,
      start: begin,
      end: begin.add(length),
      interactive: step.interactive,
    );
    slots.add(slot);
    occupied.add(slot);
    ready = slot.end;
  }
  return slots;
}

/// Bir istasyonun [at] anındaki durumu.
class StationState {
  const StationState({this.job, this.slot, this.queued = 0});

  /// Şu an bu istasyonda çalışan iş ve adımı; boşsa null.
  final PrepJob? job;
  final StepSlot? slot;

  /// Bu istasyonda sırası henüz gelmemiş adım sayısı.
  final int queued;

  bool get busy => slot != null;
}

StationState stationState(LabStation station, Iterable<PrepJob> jobs, DateTime at) {
  PrepJob? activeJob;
  StepSlot? activeSlot;
  var queued = 0;
  for (final job in jobs) {
    for (final s in job.slots) {
      if (s.station != station) continue;
      if (!at.isBefore(s.start) && at.isBefore(s.end)) {
        activeJob = job;
        activeSlot = s;
      } else if (at.isBefore(s.start)) {
        queued++;
      }
    }
  }
  return StationState(job: activeJob, slot: activeSlot, queued: queued);
}
