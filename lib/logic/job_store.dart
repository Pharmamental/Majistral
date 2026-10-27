import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/lab_tools.dart';
import '../data/orders.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';

/// Kabul edilmiş reçeteleri tutar ve telefona kaydeder.
///
/// Her adımı oyuncu başlatır (Tuğrul, 2026-10-27): laboratuvarda bir alete
/// basar, reçeteyi seçer; mini oyunlu adımda önce oyun, sonra süre. Adım
/// bitince reçete sıradaki adım için oyuncuyu bekler. Bir alet aynı anda tek
/// reçetede çalışır.
///
/// Saat şimdilik cihaz saatinden okunur ([now]). Tasarım belgesi saat hilesine
/// karşı sunucu saatini istiyor; sunucu gelince yalnız [now] değişecek.
class JobStore extends ChangeNotifier {
  JobStore._(this._prefs, this.now, this._jobs, this._orders);

  // Alet seçimiyle planlanan eski kayıtlar (v1) bu düzene çevrilmez, okunmaz.
  static const _key = 'prep_jobs_v2';

  final SharedPreferences _prefs;
  final DateTime Function() now;
  final List<PrepJob> _jobs;
  final List<PrescriptionOrder> _orders;

  static Future<JobStore> load({DateTime Function()? now, List<PrescriptionOrder>? orders}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    final known = orders ?? prescriptionOrders;
    final jobs = <PrepJob>[];
    if (raw != null) {
      try {
        for (final item in jsonDecode(raw) as List) {
          final job = PrepJob.fromJson(item as Map<String, dynamic>);
          // Oyundan çıkarılmış reçetenin kaydı atlanır.
          if (known.any((o) => o.magistralName == job.magistralName)) jobs.add(job);
        }
      } on Object {
        // Bozuk kayıt oyunu açılmaz hâle getirmesin; boş başla.
        jobs.clear();
      }
    }
    return JobStore._(prefs, now ?? DateTime.now, jobs, known);
  }

  List<PrepJob> get jobs => List.unmodifiable(_jobs);

  PrepJob? jobFor(String magistralName) {
    for (final job in _jobs) {
      if (job.magistralName == magistralName) return job;
    }
    return null;
  }

  PrescriptionOrder orderOf(PrepJob job) => _orders.firstWhere((o) => o.magistralName == job.magistralName);

  /// Sırası gelen ama başlatılmamış adım; bütün adımlar başlatıldıysa null.
  PrescriptionStep? nextStep(PrepJob job) {
    final steps = orderOf(job).steps;
    return job.runs.length < steps.length ? steps[job.runs.length] : null;
  }

  /// Şu an çalışan adım.
  StepRun? running(PrepJob job) => job.runningAt(now());

  /// Reçete sıradaki adımı oyuncunun başlatmasını bekliyor.
  bool needsAction(PrepJob job) => running(job) == null && nextStep(job) != null;

  /// Bütün adımlar bitti, teslim edilebilir.
  bool isReady(PrepJob job) => running(job) == null && nextStep(job) == null;

  /// Çalışan adımın kalan süresi ve başlamamış adımların süreleri.
  Duration remaining(PrepJob job) {
    final run = running(job);
    final steps = orderOf(job).steps.skip(job.runs.length);
    return (run == null ? Duration.zero : run.end.difference(now())) +
        Duration(minutes: steps.fold(0, (sum, s) => sum + s.minutes));
  }

  /// [tool] şu an hangi reçetenin hangi adımında çalışıyor; boşsa null.
  ({PrepJob job, StepRun run})? busyWith(LabTool tool) {
    for (final job in _jobs) {
      final run = running(job);
      if (run != null && run.tool == tool.name) return (job: job, run: run);
    }
    return null;
  }

  /// [tool] bu reçetenin sıradaki adımında şimdi kullanılabilir mi? Değilse
  /// oyuncuya gösterilecek neden.
  String? whyNot(LabTool tool, PrepJob job) {
    final steps = orderOf(job).steps;
    final run = running(job);
    if (run != null) return 'Şu an ${run.label} sürüyor.';
    final step = nextStep(job);
    if (step == null) return 'Hazır, teslim edebilirsin.';
    if (!steps.any((s) => s.tool == tool.kind)) return 'Bu reçetede bu alete gerek yok.';
    if (step.tool != tool.kind) {
      final later = steps.skip(job.runs.length).any((s) => s.tool == tool.kind);
      return later ? 'Bu aleti daha sonra kullanacaksın; önce ${step.label}.' : 'Bu aletle işin bitti.';
    }
    final reason = step.notWith[tool.name];
    if (reason != null) return reason;
    final busy = busyWith(tool);
    if (busy != null) return 'Alet dolu: ${busy.job.magistralName} bitince kullanabilirsin.';
    return null;
  }

  /// Reçeteyi kabul eder; adımlarını oyuncu laboratuvarda başlatır.
  Future<PrepJob> accept(PrescriptionOrder order) async {
    final job = PrepJob(magistralName: order.magistralName, acceptedAt: now(), stars: 3, notes: const []);
    _jobs
      ..removeWhere((j) => j.magistralName == order.magistralName)
      ..add(job);
    await _save();
    notifyListeners();
    return job;
  }

  /// Reçetenin sıradaki adımını [tool] ile şimdi başlatır. Mini oyunlu adımda
  /// bu, oyun bittikten sonra çağrılır. Alet uygun değilse hiçbir şey yapmaz.
  Future<void> startStep(String magistralName, LabTool tool) async {
    final job = jobFor(magistralName);
    if (job == null || whyNot(tool, job) != null) return;
    final step = nextStep(job)!;
    final start = now();
    _jobs[_jobs.indexOf(job)] = job.copyWith(runs: [
      ...job.runs,
      StepRun(label: step.label, tool: tool.name, start: start, end: start.add(Duration(minutes: step.minutes))),
    ]);
    await _save();
    notifyListeners();
  }

  /// Günde izlenebilecek ödüllü reklam, yani acele et hakkı (tasarım belgesi).
  static const dailyRushes = 5;
  static const _rushKey = 'rush_v1';

  /// Bugün kalan acele et hakkı. Gün cihaz saatine göre değişir.
  int get rushesLeft {
    final saved = _prefs.getString(_rushKey)?.split('|');
    if (saved == null || saved.length != 2 || saved[0] != _today) return dailyRushes;
    return (dailyRushes - (int.tryParse(saved[1]) ?? 0)).clamp(0, dailyRushes);
  }

  String get _today {
    final d = now();
    return '${d.year}-${d.month}-${d.day}';
  }

  /// Çalışan bir adım ve hak var mı? Oyuncuyu bekleyen reçetede acele edilmez.
  bool canRush(PrepJob job) => rushesLeft > 0 && running(job) != null;

  /// Acele edilirse çalışan adımın kalacak süresi (onay penceresinde).
  Duration stepLeftAfterRush(PrepJob job) {
    final run = running(job);
    return run == null ? Duration.zero : run.end.difference(now()) ~/ 2;
  }

  /// Acele et (Tuğrul, 2026-10-26): çalışan adımın kalan süresi yarıya iner,
  /// kalite de yarıya iner ve yukarı yuvarlanır (3 → 2 → 1, en düşük 1).
  Future<void> rush(String magistralName) async {
    final job = jobFor(magistralName);
    if (job == null || !canRush(job)) return;
    const note = 'Acele edildi: her acele kaliteyi yarıya indirir.';
    final run = running(job)!;
    _jobs[_jobs.indexOf(job)] = job.copyWith(
      runs: [...job.runs.take(job.runs.length - 1), run.copyWith(end: now().add(stepLeftAfterRush(job)))],
      stars: (job.stars / 2).ceil().clamp(1, 3),
      notes: job.notes.contains(note) ? job.notes : [...job.notes, note],
    );
    await _prefs.setString(_rushKey, '$_today|${dailyRushes - rushesLeft + 1}');
    await _save();
    notifyListeners();
  }

  /// Hazır işi teslim eder ve listeden çıkarır. Hazır değilse hiçbir şey yapmaz.
  Future<PrepJob?> deliver(String magistralName) async {
    final job = jobFor(magistralName);
    if (job == null || !isReady(job)) return null;
    _jobs.remove(job);
    await _save();
    notifyListeners();
    return job;
  }

  Future<void> _save() =>
      _prefs.setString(_key, jsonEncode([for (final j in _jobs) j.toJson()]));
}

/// Ağaçtaki her ekranın [JobStore]'a ulaşmasını sağlar; depo değişince
/// ona bağlı ekranlar yeniden çizilir.
class JobScope extends InheritedNotifier<JobStore> {
  const JobScope({super.key, required JobStore store, required super.child})
      : super(notifier: store);

  static JobStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<JobScope>()!.notifier!;
}
