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
) {
  final occupied = [...busy];
  final slots = <StepSlot>[];
  var ready = start;
  for (final step in steps) {
    final length = Duration(minutes: step.minutes);
    final onStation = occupied.where((s) => s.station == step.station).toList()
      ..sort((a, b) => a.start.compareTo(b.start));
    var begin = ready;
    for (final s in onStation) {
      // [begin, begin+length) ile çakışıyorsa bu işin bitişine kay.
      if (begin.isBefore(s.end) && s.start.isBefore(begin.add(length))) begin = s.end;
    }
    final slot = StepSlot(label: step.label, station: step.station, start: begin, end: begin.add(length));
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
