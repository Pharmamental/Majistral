import 'prescription.dart';

/// Bir adımın istasyondaki zaman dilimi.
class StepSlot {
  const StepSlot({
    required this.label,
    required this.station,
    required this.start,
    required this.end,
  });

  final String label;
  final LabStation station;
  final DateTime start;
  final DateTime end;

  Map<String, Object> toJson() => {
        'label': label,
        'station': station.name,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      };

  factory StepSlot.fromJson(Map<String, dynamic> json) => StepSlot(
        label: json['label'] as String,
        station: LabStation.values.byName(json['station'] as String),
        start: DateTime.fromMillisecondsSinceEpoch(json['start'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(json['end'] as int),
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
  });

  final String magistralName;
  final DateTime startedAt;

  /// Adımlar sırasıyla; başlarken bir kez planlanır, sonra değişmez.
  final List<StepSlot> slots;
  final int stars;
  final List<String> notes;

  DateTime get readyAt => slots.isEmpty ? startedAt : slots.last.end;
  Duration get duration => readyAt.difference(startedAt);

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
      stars: json['stars'] as int,
      notes: [for (final n in json['notes'] as List) n as String],
    );
  }
}
