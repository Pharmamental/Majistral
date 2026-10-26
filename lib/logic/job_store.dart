import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/prep_job.dart';
import '../models/prescription.dart';
import 'quality.dart';
import 'schedule.dart';

/// Süren hazırlıkları tutar ve telefona kaydeder.
///
/// Saat şimdilik cihaz saatinden okunur ([now]). Tasarım belgesi saat hilesine
/// karşı sunucu saatini istiyor; sunucu gelince yalnız [now] değişecek.
class JobStore extends ChangeNotifier {
  JobStore._(this._prefs, this.now, this._jobs);

  static const _key = 'prep_jobs_v1';

  final SharedPreferences _prefs;
  final DateTime Function() now;
  final List<PrepJob> _jobs;

  static Future<JobStore> load({DateTime Function()? now}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    final jobs = <PrepJob>[];
    if (raw != null) {
      try {
        for (final item in jsonDecode(raw) as List) {
          jobs.add(PrepJob.fromJson(item as Map<String, dynamic>));
        }
      } on FormatException {
        // Bozuk kayıt oyunu açılmaz hâle getirmesin; boş başla.
      }
    }
    return JobStore._(prefs, now ?? DateTime.now, jobs);
  }

  List<PrepJob> get jobs => List.unmodifiable(_jobs);

  PrepJob? jobFor(String magistralName) {
    for (final job in _jobs) {
      if (job.magistralName == magistralName) return job;
    }
    return null;
  }

  Duration remaining(PrepJob job) {
    final left = job.readyAt.difference(now());
    return left.isNegative ? Duration.zero : left;
  }

  /// Bütün adımlar bitti, teslim edilebilir.
  bool isReady(PrepJob job) => job.doneAt(now());

  /// İş oyuncunun yapacağı adımda (ısıtma) duruyor mu?
  bool needsAction(PrepJob job) => job.needsActionAt(now());

  /// Oyuncu adımı bitirdi (termometreyi doğru aralıkta tuttu): kalan adımlar
  /// şu andan itibaren istasyonlara planlanır.
  Future<void> completeAction(String magistralName) async {
    final job = jobFor(magistralName);
    if (job == null || !needsAction(job)) return;
    final others = [for (final j in _jobs) if (j != job) ...j.slots];
    final next = planUntilAction(job.pending, now(), [...others, ...job.slots]);
    final i = _jobs.indexOf(job);
    _jobs[i] = job.copyWith(slots: [...job.slots, ...next.slots], pending: next.pending);
    await _save();
    notifyListeners();
  }

  /// 0–1 arası ilerleme.
  double progress(PrepJob job) {
    final total = job.duration.inMilliseconds;
    if (total == 0) return 1;
    final done = total - remaining(job).inMilliseconds;
    return (done / total).clamp(0.0, 1.0);
  }

  /// İstasyonun [now] anındaki durumu (Laboratuvar ekranı).
  StationState station(LabStation station) => stationState(station, _jobs, now());

  Future<PrepJob> start(PrescriptionOrder order, PreparationResult result) async {
    final startedAt = now();
    final plan = planUntilAction(
      [for (final s in order.steps) PendingStep.of(s)],
      startedAt,
      [for (final j in _jobs) ...j.slots],
    );
    final job = PrepJob(
      magistralName: order.magistralName,
      startedAt: startedAt,
      slots: plan.slots,
      pending: plan.pending,
      stars: result.stars,
      notes: result.notes,
    );
    _jobs
      ..removeWhere((j) => j.magistralName == order.magistralName)
      ..add(job);
    await _save();
    notifyListeners();
    return job;
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
