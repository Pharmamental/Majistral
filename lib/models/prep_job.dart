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

/// Duvarda bekleyen, henüz alınmamış reçete. Aynı reçete birden çok kez
/// gelebilir; her gelişin kendi kimliği ([id]) var, alınınca işin kimliği olur.
class IncomingOrder {
  const IncomingOrder({required this.id, required this.magistralName});

  final int id;
  final String magistralName;

  Map<String, Object> toJson() => {'id': id, 'magistralName': magistralName};

  factory IncomingOrder.fromJson(Map<String, dynamic> json) =>
      IncomingOrder(id: json['id'] as int, magistralName: json['magistralName'] as String);
}

/// Kabul edilmiş bir reçete: başlatılan adımları ([runs], reçetedeki sırayla)
/// ve teslimde gösterilecek sonuç. Telefonda saklanır ki uygulama kapanınca da
/// süre devam etsin.
class PrepJob {
  const PrepJob({
    required this.id,
    required this.magistralName,
    required this.acceptedAt,
    required this.stars,
    required this.notes,
    this.runs = const [],
  });

  /// Duvardan gelişinin kimliği; aynı reçetenin iki işi bununla ayrılır.
  final int id;
  final String magistralName;
  final DateTime acceptedAt;

  /// Başlatılmış adımlar; runs[i] reçetenin i. adımıdır.
  final List<StepRun> runs;
  final int stars;
  final List<String> notes;

  /// [at] anında çalışan adım; yoksa null.
  StepRun? runningAt(DateTime at) => runs.isNotEmpty && runs.last.runningAt(at) ? runs.last : null;

  PrepJob copyWith({List<StepRun>? runs, int? stars, List<String>? notes}) => PrepJob(
        id: id,
        magistralName: magistralName,
        acceptedAt: acceptedAt,
        runs: runs ?? this.runs,
        stars: stars ?? this.stars,
        notes: notes ?? this.notes,
      );

  Map<String, Object> toJson() => {
        'id': id,
        'magistralName': magistralName,
        'acceptedAt': acceptedAt.millisecondsSinceEpoch,
        'runs': [for (final r in runs) r.toJson()],
        'stars': stars,
        'notes': notes,
      };

  factory PrepJob.fromJson(Map<String, dynamic> json) => PrepJob(
        id: json['id'] as int,
        magistralName: json['magistralName'] as String,
        acceptedAt: DateTime.fromMillisecondsSinceEpoch(json['acceptedAt'] as int),
        runs: [for (final r in json['runs'] as List) StepRun.fromJson(r as Map<String, dynamic>)],
        stars: json['stars'] as int,
        notes: [for (final n in json['notes'] as List) n as String],
      );
}

/// Teslim edilen bir reçetenin kaydı (Tuğrul, 2026-10-28): profildeki unvan,
/// ustalık ve koleksiyon bu kayıttan hesaplanır.
class Delivery {
  const Delivery({required this.magistralName, required this.stars, required this.at, required this.steps});

  final String magistralName;
  final int stars;
  final DateTime at;

  /// Reçetenin adımları, teslim anındaki sırasıyla.
  final List<String> steps;

  Map<String, Object> toJson() => {
        'magistralName': magistralName,
        'stars': stars,
        'at': at.millisecondsSinceEpoch,
        'steps': steps,
      };

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
        magistralName: json['magistralName'] as String,
        stars: json['stars'] as int,
        at: DateTime.fromMillisecondsSinceEpoch(json['at'] as int),
        steps: [for (final s in json['steps'] as List) s as String],
      );
}
