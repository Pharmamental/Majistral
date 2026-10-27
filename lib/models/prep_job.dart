/// Oyuncunun bir alette başlattığı adım: hangi adım, hangi alet, ne zaman
/// başladı ve biter.
class StepRun {
  const StepRun({required this.label, required this.tool, required this.start, required this.end});

  final String label;

  /// Aletin adı ("Plastik spatül").
  final String tool;
  final DateTime start;
  final DateTime end;

  bool runningAt(DateTime at) => !at.isBefore(start) && at.isBefore(end);

  StepRun copyWith({DateTime? end}) => StepRun(label: label, tool: tool, start: start, end: end ?? this.end);

  Map<String, Object> toJson() => {
        'label': label,
        'tool': tool,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
      };

  factory StepRun.fromJson(Map<String, dynamic> json) => StepRun(
        label: json['label'] as String,
        tool: json['tool'] as String,
        start: DateTime.fromMillisecondsSinceEpoch(json['start'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(json['end'] as int),
      );
}

/// Kabul edilmiş bir reçete: başlatılan adımları ([runs], reçetedeki sırayla)
/// ve teslimde gösterilecek sonuç. Telefonda saklanır ki uygulama kapanınca da
/// süre devam etsin.
class PrepJob {
  const PrepJob({
    required this.magistralName,
    required this.acceptedAt,
    required this.stars,
    required this.notes,
    this.runs = const [],
  });

  final String magistralName;
  final DateTime acceptedAt;

  /// Başlatılmış adımlar; runs[i] reçetenin i. adımıdır.
  final List<StepRun> runs;
  final int stars;
  final List<String> notes;

  /// [at] anında çalışan adım; yoksa null.
  StepRun? runningAt(DateTime at) => runs.isNotEmpty && runs.last.runningAt(at) ? runs.last : null;

  PrepJob copyWith({List<StepRun>? runs, int? stars, List<String>? notes}) => PrepJob(
        magistralName: magistralName,
        acceptedAt: acceptedAt,
        runs: runs ?? this.runs,
        stars: stars ?? this.stars,
        notes: notes ?? this.notes,
      );

  Map<String, Object> toJson() => {
        'magistralName': magistralName,
        'acceptedAt': acceptedAt.millisecondsSinceEpoch,
        'runs': [for (final r in runs) r.toJson()],
        'stars': stars,
        'notes': notes,
      };

  factory PrepJob.fromJson(Map<String, dynamic> json) => PrepJob(
        magistralName: json['magistralName'] as String,
        acceptedAt: DateTime.fromMillisecondsSinceEpoch(json['acceptedAt'] as int),
        runs: [for (final r in json['runs'] as List) StepRun.fromJson(r as Map<String, dynamic>)],
        stars: json['stars'] as int,
        notes: [for (final n in json['notes'] as List) n as String],
      );
}
