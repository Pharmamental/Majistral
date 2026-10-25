/// Başlatılmış bir hazırlık: hangi reçete, ne zaman başladı, ne kadar sürer ve
/// teslimde gösterilecek sonuç. Telefonda saklanır ki uygulama kapanınca da
/// süre devam etsin.
class PrepJob {
  const PrepJob({
    required this.magistralName,
    required this.startedAt,
    required this.duration,
    required this.stars,
    required this.notes,
  });

  final String magistralName;
  final DateTime startedAt;
  final Duration duration;
  final int stars;
  final List<String> notes;

  DateTime get readyAt => startedAt.add(duration);

  Map<String, Object> toJson() => {
        'magistralName': magistralName,
        'startedAt': startedAt.millisecondsSinceEpoch,
        'durationSeconds': duration.inSeconds,
        'stars': stars,
        'notes': notes,
      };

  factory PrepJob.fromJson(Map<String, dynamic> json) => PrepJob(
        magistralName: json['magistralName'] as String,
        startedAt: DateTime.fromMillisecondsSinceEpoch(json['startedAt'] as int),
        duration: Duration(seconds: json['durationSeconds'] as int),
        stars: json['stars'] as int,
        notes: [for (final n in json['notes'] as List) n as String],
      );
}
