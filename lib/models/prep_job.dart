import 'prescription.dart';

/// Bir adımın istasyondaki zaman dilimi.
class StepSlot {
  const StepSlot({
    required this.label,
    required this.station,
    required this.start,
    required this.end,
    this.interactive = false,
  });

  final String label;
  final LabStation station;
  final DateTime start;
  final DateTime end;

  /// Süre dolunca oyuncuyu bekleyen adım (ısıtma).
  final bool interactive;

  Map<String, Object> toJson() => {
        'label': label,
        'station': station.name,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        if (interactive) 'interactive': true,
      };

  factory StepSlot.fromJson(Map<String, dynamic> json) => StepSlot(
        label: json['label'] as String,
        station: LabStation.values.byName(json['station'] as String),
        start: DateTime.fromMillisecondsSinceEpoch(json['start'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(json['end'] as int),
        interactive: json['interactive'] as bool? ?? false,
      );
}

/// Henüz zamanı planlanmamış adım: oyuncunun yapacağı bir adımın arkasında
/// bekler; o adım bitince planlanır.
class PendingStep {
  const PendingStep({
    required this.label,
    required this.station,
    required this.minutes,
    this.interactive = false,
  });

  factory PendingStep.of(PrescriptionStep s) =>
      PendingStep(label: s.label, station: s.station, minutes: s.minutes, interactive: s.interactive);

  final String label;
  final LabStation station;
  final int minutes;
  final bool interactive;

  Map<String, Object> toJson() => {
        'label': label,
        'station': station.name,
        'minutes': minutes,
        if (interactive) 'interactive': true,
      };

  factory PendingStep.fromJson(Map<String, dynamic> json) => PendingStep(
        label: json['label'] as String,
        station: LabStation.values.byName(json['station'] as String),
        minutes: json['minutes'] as int,
        interactive: json['interactive'] as bool? ?? false,
      );
}

/// Başlatılmış bir hazırlık: hangi reçete, ne zaman başladı, adımlarının
/// istasyonlardaki zamanları ve teslimde gösterilecek sonuç. Telefonda saklanır
/// ki uygulama kapanınca da süre devam etsin.
class PrepJob {
  const PrepJob({
    required this.magistralName,
    required this.startedAt,
    required this.slots,
    required this.stars,
    required this.notes,
    this.pending = const [],
  });

  final String magistralName;
  final DateTime startedAt;

  /// Planlanmış adımlar sırasıyla; planlandıktan sonra değişmez.
  final List<StepSlot> slots;

  /// Oyuncunun yapacağı adımın arkasında bekleyen, henüz planlanmamış adımlar.
  final List<PendingStep> pending;
  final int stars;
  final List<String> notes;

  DateTime get readyAt => slots.isEmpty ? startedAt : slots.last.end;
  Duration get duration => readyAt.difference(startedAt);

  /// Oyuncunun yapması gereken bir adımda mı duruyor ([at] anında)?
  bool needsActionAt(DateTime at) =>
      slots.isNotEmpty && slots.last.interactive && !at.isBefore(slots.last.end) && pending.isNotEmpty;

  /// Bütün adımlar bitti mi?
  bool doneAt(DateTime at) => pending.isEmpty && !at.isBefore(readyAt);

  PrepJob copyWith({List<StepSlot>? slots, List<PendingStep>? pending}) => PrepJob(
        magistralName: magistralName,
        startedAt: startedAt,
        slots: slots ?? this.slots,
        pending: pending ?? this.pending,
        stars: stars,
        notes: notes,
      );

  /// [at] anında çalışan adım; adımlar arasında sıra bekleniyorsa ya da iş
  /// bittiyse null.
  StepSlot? activeAt(DateTime at) {
    for (final s in slots) {
      if (!at.isBefore(s.start) && at.isBefore(s.end)) return s;
    }
    return null;
  }

  /// [at] anında sırası gelmemiş ilk adım (istasyon dolu, bekliyor).
  StepSlot? waitingAt(DateTime at) {
    if (activeAt(at) != null) return null;
    for (final s in slots) {
      if (at.isBefore(s.start)) return s;
    }
    return null;
  }

  Map<String, Object> toJson() => {
        'magistralName': magistralName,
        'startedAt': startedAt.millisecondsSinceEpoch,
        'slots': [for (final s in slots) s.toJson()],
        if (pending.isNotEmpty) 'pending': [for (final p in pending) p.toJson()],
        'stars': stars,
        'notes': notes,
      };

  factory PrepJob.fromJson(Map<String, dynamic> json) {
    final startedAt = DateTime.fromMillisecondsSinceEpoch(json['startedAt'] as int);
    final rawSlots = json['slots'] as List?;
    return PrepJob(
      magistralName: json['magistralName'] as String,
      startedAt: startedAt,
      slots: rawSlots != null
          ? [for (final s in rawSlots) StepSlot.fromJson(s as Map<String, dynamic>)]
          // İstasyonlardan önceki kayıt biçimi: tek parça iş, ambalaj masasında.
          : [
              StepSlot(
                label: 'Hazırlık',
                station: LabStation.ambalaj,
                start: startedAt,
                end: startedAt.add(Duration(seconds: json['durationSeconds'] as int? ?? 0)),
              ),
            ],
      pending: [
        for (final p in (json['pending'] as List?) ?? const []) PendingStep.fromJson(p as Map<String, dynamic>),
      ],
      stars: json['stars'] as int,
      notes: [for (final n in json['notes'] as List) n as String],
    );
  }
}
