import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dried_plants.dart';
import '../data/lab_tools.dart';
import '../data/orders.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';

/// Duvardaki gelen reçeteleri ve kabul edilmiş reçeteleri tutar, telefona
/// kaydeder.
///
/// Duvar (Tuğrul, 2026-10-27): en fazla [wallSize] reçete birikir; yenisi her
/// [arrivalEvery]'de bir gelir ve sayaç geldiği anda yeniden başlar. Duvar
/// doluyken sayaç dolsa da reçete gelmez, bekletilir; oyuncu bir reçete alınca
/// süre çoktan dolmuşsa yenisi hemen gelir ve sayaç o andan başlar.
///
/// Her adımı oyuncu başlatır (Tuğrul, 2026-10-27): laboratuvarda bir alete
/// basar, reçeteyi seçer; mini oyunlu adımda önce oyun, sonra süre. Adım
/// bitince reçete sıradaki adım için oyuncuyu bekler. Bir alet aynı anda tek
/// reçetede çalışır.
///
/// Saat şimdilik cihaz saatinden okunur ([now]). Tasarım belgesi saat hilesine
/// karşı sunucu saatini istiyor; sunucu gelince yalnız [now] değişecek.
class JobStore extends ChangeNotifier {
  JobStore._(this._prefs, this.now, this._jobs, this._orders, this._wall, this._nextId, this._due);

  // Kimliksiz eski kayıtlar (v1, v2) bu düzene çevrilmez, okunmaz.
  static const _key = 'prep_jobs_v3';
  static const _wallKey = 'wall_v1';
  static const _deliveriesKey = 'deliveries_v1';
  static const _profileKey = 'profile_v1';

  /// Duvarda en fazla birikecek reçete.
  static const wallSize = 3;

  /// İki reçetenin gelişi arasındaki süre. Yer tutucu; kapalı testte ayarlanacak.
  static const arrivalEvery = Duration(minutes: 10);

  final SharedPreferences _prefs;
  final DateTime Function() now;
  final List<PrepJob> _jobs;
  final List<PrescriptionOrder> _orders;
  final List<IncomingOrder> _wall;

  /// Bir sonraki gelişin kimliği; reçeteler [_orders] sırasıyla döner.
  int _nextId;

  /// Sayacın dolduğu an: duvarda yer varsa yeni reçete bu anda gelir.
  DateTime _due;

  static Future<JobStore> load({DateTime Function()? now, List<PrescriptionOrder>? orders}) async {
    final prefs = await SharedPreferences.getInstance();
    final clock = now ?? DateTime.now;
    final known = orders ?? prescriptionOrders;
    final keys = {for (final o in known) o.key};
    bool isKnown(String key) => keys.contains(key);
    final jobs = <PrepJob>[];
    final wall = <IncomingOrder>[];
    int? nextId;
    DateTime? due;
    try {
      for (final item in jsonDecode(prefs.getString(_key) ?? '[]') as List) {
        final job = PrepJob.fromJson(item as Map<String, dynamic>);
        // Oyundan çıkarılmış reçetenin kaydı atlanır.
        if (isKnown(job.orderKey)) jobs.add(job);
      }
      final raw = prefs.getString(_wallKey);
      if (raw != null) {
        final saved = jsonDecode(raw) as Map<String, dynamic>;
        for (final item in saved['wall'] as List) {
          final o = IncomingOrder.fromJson(item as Map<String, dynamic>);
          if (isKnown(o.orderKey)) wall.add(o);
        }
        nextId = saved['nextId'] as int;
        due = DateTime.fromMillisecondsSinceEpoch(saved['due'] as int);
      }
    } on Object {
      // Bozuk kayıt oyunu açılmaz hâle getirmesin; boş başla.
      jobs.clear();
      wall.clear();
      nextId = null;
    }
    final store = JobStore._(prefs, clock, jobs, known, wall, nextId ?? 0, due ?? clock().add(arrivalEvery));
    // Teslim kaydı ve profil ayrı anahtarlarda; bozulursa yalnız onlar boş başlar.
    try {
      for (final item in jsonDecode(prefs.getString(_deliveriesKey) ?? '[]') as List) {
        store._deliveries.add(Delivery.fromJson(item as Map<String, dynamic>));
      }
    } on Object {
      store._deliveries.clear();
    }
    try {
      final profile = jsonDecode(prefs.getString(_profileKey) ?? '{}') as Map<String, dynamic>;
      store._playerName = profile['name'] as String? ?? store._playerName;
      store._pharmacyName = profile['pharmacy'] as String? ?? store._pharmacyName;
      final shelf = profile['showcase'] as List?;
      if (shelf != null && shelf.length == showcaseSize) {
        for (var i = 0; i < showcaseSize; i++) {
          // Eski kayıttaki ürün adları (rafta ilaç dururken) fanus değil; boş yer olur.
          final name = shelf[i] as String?;
          store._showcase[i] = name != null && driedPlantNamed(name) != null ? name : null;
        }
      }
    } on Object {
      // Varsayılan adlarla devam.
    }
    // İlk açılış: duvar dolu başlar, sayaç şimdi başlar.
    if (nextId == null) {
      while (store._wall.length < wallSize) {
        store._arrive();
      }
      await store._save();
    }
    return store;
  }

  List<PrepJob> get jobs => List.unmodifiable(_jobs);

  /// Teslim edilen reçeteler, eskiden yeniye (profil: unvan, ustalık, koleksiyon).
  List<Delivery> get deliveries => List.unmodifiable(_deliveries);
  final List<Delivery> _deliveries = [];

  /// Profildeki diploma: oyuncunun ve eczanesinin adı.
  String get playerName => _playerName;
  String get pharmacyName => _pharmacyName;
  // Varsayılan ad yok: "Eczacı" unvanla karışıyordu (2026-10-28); diploma "Adını yaz" der.
  String _playerName = '';
  String _pharmacyName = 'Majistral Eczanesi';

  /// Diplomadaki adları değiştirir; boş ad yazılırsa eskisi kalır.
  Future<void> rename({required String player, required String pharmacy}) async {
    if (player.trim().isNotEmpty) _playerName = player.trim();
    if (pharmacy.trim().isNotEmpty) _pharmacyName = pharmacy.trim();
    await _saveProfile();
  }

  /// Profildeki vitrin rafı (Tuğrul, 2026-10-28): fanusta bitki kurusu
  /// (`driedPlants`, adla); boş yer null.
  static const showcaseSize = 3;
  List<String?> get showcase => List.unmodifiable(_showcase);
  final List<String?> _showcase = List.filled(showcaseSize, null);

  /// [slot]. yere [plant] fanusunu koyar (null: rafı boşaltır). Fanusların
  /// kazanılma kuralı henüz yok: her şey açıkken (`unlockAll`) hepsi konur.
  /// Başka yerdeyse oradan alınır, aynı fanus iki kez durmaz.
  Future<void> setShowcase(int slot, String? plant) async {
    if (plant != null && (driedPlantNamed(plant) == null || !unlockAll)) return;
    for (var i = 0; i < showcaseSize; i++) {
      if (_showcase[i] == plant) _showcase[i] = null;
    }
    _showcase[slot] = plant;
    await _saveProfile();
  }

  Future<void> _saveProfile() async {
    await _prefs.setString(
      _profileKey,
      jsonEncode({'name': _playerName, 'pharmacy': _pharmacyName, 'showcase': _showcase}),
    );
    notifyListeners();
  }

  /// Duvardaki gelen reçeteler; sırası gelmiş olanlar burada duvara asılır.
  List<IncomingOrder> get wall {
    _catchUp();
    return List.unmodifiable(_wall);
  }

  /// Bir sonraki reçeteye kalan süre; duvar doluysa null.
  Duration? get untilNextArrival {
    _catchUp();
    if (_wall.length >= wallSize) return null;
    return _due.difference(now());
  }

  void _arrive() {
    final order = _orders[_nextId % _orders.length];
    _wall.add(IncomingOrder(id: _nextId++, magistralName: order.magistralName, orderKey: order.key));
  }

  /// Uygulama kapalıyken dolan sayaçlar da sayılır: her geliş kendi anında
  /// olur ve sayaç o andan başlar. Duvar dolunca geliş bekletilir.
  void _catchUp() {
    var changed = false;
    while (_wall.length < wallSize && !now().isBefore(_due)) {
      _arrive();
      _due = _due.add(arrivalEvery);
      changed = true;
    }
    if (changed) _save();
  }

  PrepJob? job(int id) {
    for (final j in _jobs) {
      if (j.id == id) return j;
    }
    return null;
  }

  /// Kimliği [key] olan reçete (`PrescriptionOrder.key`).
  PrescriptionOrder orderKeyed(String key) => _orders.firstWhere((o) => o.key == key);

  PrescriptionOrder orderOf(PrepJob job) => orderKeyed(job.orderKey);

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

  /// [tool] adım kartı şu an hangi reçetede çalışıyor; boşsa null.
  ({PrepJob job, StepRun run})? busyWith(LabTool tool) {
    for (final job in _jobs) {
      final run = running(job);
      if (run != null && run.tool == tool.name) return (job: job, run: run);
    }
    return null;
  }

  /// [tool] adım kartı bu reçetede şimdi başlatılabilir mi? Değilse oyuncuya
  /// gösterilecek neden. Kart, reçetenin sıradaki adımıyla aynı adı taşımalı
  /// (Tuğrul, 2026-10-28: reçetedeki her adım = laboratuvardaki bir kart).
  String? whyNot(LabTool tool, PrepJob job) {
    final steps = orderOf(job).steps;
    final run = running(job);
    if (run != null) return 'Şu an ${run.label} sürüyor.';
    final step = nextStep(job);
    if (step == null) return 'Hazır, teslim edebilirsin.';
    if (!steps.any((s) => s.label == tool.name)) return 'Bu reçetede bu adım yok.';
    if (step.label != tool.name) {
      final later = steps.skip(job.runs.length).any((s) => s.label == tool.name);
      return later ? 'Bu adım daha sonra; önce ${step.label}.' : 'Bu adım bitti.';
    }
    final busy = busyWith(tool);
    if (busy != null) return 'Dolu: ${busy.job.magistralName} bitince yapabilirsin.';
    return null;
  }

  /// Duvardaki reçeteyi alır, tezgâha indirir; adımlarını oyuncu laboratuvarda
  /// başlatır. Duvar doluyken sayaç dolmuşsa yeni reçete hemen gelir.
  Future<PrepJob?> accept(IncomingOrder incoming) async {
    _catchUp();
    if (!_wall.any((o) => o.id == incoming.id)) return null;
    if (_wall.length >= wallSize && !now().isBefore(_due)) _due = now();
    _wall.removeWhere((o) => o.id == incoming.id);
    final job = PrepJob(
      id: incoming.id,
      magistralName: incoming.magistralName,
      orderKey: incoming.orderKey,
      acceptedAt: now(),
      stars: 3,
      notes: const [],
    );
    _jobs.add(job);
    _catchUp();
    await _save();
    notifyListeners();
    return job;
  }

  /// İşin sıradaki adımını [tool] ile şimdi başlatır. Mini oyunlu adımda bu,
  /// oyun bittikten sonra çağrılır. Alet uygun değilse hiçbir şey yapmaz.
  Future<void> startStep(int id, LabTool tool) async {
    final job = this.job(id);
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
  Future<void> rush(int id) async {
    final job = this.job(id);
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

  /// Hazır işi teslim eder, listeden çıkarır ve teslim kaydına yazar. Hazır
  /// değilse hiçbir şey yapmaz.
  Future<PrepJob?> deliver(int id) async {
    final job = this.job(id);
    if (job == null || !isReady(job)) return null;
    _jobs.remove(job);
    _deliveries.add(Delivery(
      magistralName: job.magistralName,
      orderKey: job.orderKey,
      stars: job.stars,
      at: now(),
      steps: [for (final s in orderOf(job).steps) s.label],
    ));
    await _prefs.setString(_deliveriesKey, jsonEncode([for (final d in _deliveries) d.toJson()]));
    await _save();
    notifyListeners();
    return job;
  }

  Future<void> _save() async {
    await _prefs.setString(_key, jsonEncode([for (final j in _jobs) j.toJson()]));
    await _prefs.setString(
      _wallKey,
      jsonEncode({
        'wall': [for (final o in _wall) o.toJson()],
        'nextId': _nextId,
        'due': _due.millisecondsSinceEpoch,
      }),
    );
  }
}

/// Ağaçtaki her ekranın [JobStore]'a ulaşmasını sağlar; depo değişince
/// ona bağlı ekranlar yeniden çizilir.
class JobScope extends InheritedNotifier<JobStore> {
  const JobScope({super.key, required JobStore store, required super.child})
      : super(notifier: store);

  static JobStore of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<JobScope>()!.notifier!;
}
