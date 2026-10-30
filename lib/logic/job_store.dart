import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/dried_plants.dart';
import '../data/economy.dart';
import '../data/lab_tools.dart';
import '../data/orders.dart';
import '../models/garden.dart';
import '../models/patient_question.dart';
import '../models/prep_job.dart';
import '../models/prescription.dart';
import '../models/shop_item.dart';

/// Duvardaki gelen reçeteleri ve kabul edilmiş reçeteleri tutar, telefona
/// kaydeder.
///
/// Duvar (Tuğrul, 2026-10-27): en fazla [wallLimit] reçete birikir; yenisi her
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
  JobStore._(this._prefs, this.now, this._jobs, this._orders, this._wall, this._nextId, this._due, this._random);

  // Kimliksiz eski kayıtlar (v1, v2) bu düzene çevrilmez, okunmaz.
  static const _key = 'prep_jobs_v3';
  static const _wallKey = 'wall_v1';
  static const _deliveriesKey = 'deliveries_v1';
  static const _profileKey = 'profile_v1';
  static const _gardenKey = 'garden_v1';
  static const _economyKey = 'economy_v1';
  static const _patientKey = 'patient_v1';

  /// Duvarda en fazla birikecek reçete; vitrindeki çay fanusu artırır ([wallLimit]).
  /// 3'ten 4'e çıktı (ekonomi 2. tur, 2026-10-29): "X sonra dön" = 4 × 60 dk.
  static const wallSize = 4;

  /// Tohum düşmesinin şansı; testler sabit tohumla verir.
  final math.Random _random;

  /// İki reçetenin gelişi arasındaki süre (2026-10-29: 10 dk'dan 60 dk'ya; 10 dk'da
  /// duvar hep doluydu ve çok oynayanın geliri az oynayanın 6,5 katıydı, 60 dk'da
  /// 2,5 katı). Yer tutucu; kapalı testte ayarlanacak.
  static const arrivalEvery = Duration(minutes: 60);

  final SharedPreferences _prefs;
  final DateTime Function() now;
  final List<PrepJob> _jobs;
  final List<PrescriptionOrder> _orders;
  final List<IncomingOrder> _wall;

  /// Bir sonraki gelişin kimliği; reçeteler [_orders] sırasıyla döner.
  int _nextId;

  /// Sayacın dolduğu an: duvarda yer varsa yeni reçete bu anda gelir.
  DateTime _due;

  static Future<JobStore> load({DateTime Function()? now, List<PrescriptionOrder>? orders, math.Random? random}) async {
    final prefs = await SharedPreferences.getInstance();
    final clock = now ?? DateTime.now;
    final known = orders ?? prescriptionOrders;
    final keys = {for (final o in known) o.key};
    bool isKnown(String key) => keys.contains(key);
    final jobs = <PrepJob>[];
    final wall = <IncomingOrder>[];
    int? nextId;
    DateTime? due;
    List<String>? seen;
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
        if (saved['seen'] case final List list) seen = [for (final c in list) c as String];
      }
    } on Object {
      // Bozuk kayıt oyunu açılmaz hâle getirmesin; boş başla.
      jobs.clear();
      wall.clear();
      nextId = null;
    }
    final store = JobStore._(
        prefs, clock, jobs, known, wall, nextId ?? 0, due ?? clock().add(arrivalEvery), random ?? math.Random());
    // Kilit kaydından önceki oyun: o güne dek gelmiş reçetelerin maddeleri açık.
    if (seen != null) {
      store._seenChemicals.addAll(seen);
    } else {
      for (var i = 0; i < math.min(store._nextId, known.length); i++) {
        store._see(known[i]);
      }
    }
    try {
      final raw = prefs.getString(_gardenKey);
      if (raw != null) store._garden = Garden.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      // Bozuk bahçe kaydı boş bahçeyle başlar.
    }
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
          // Bahçeden önce (her şey açıkken) rafa konmuş fanus yetiştirilmiş sayılır.
          if (store._showcase[i] case final plant?) store._garden.grown.add(plant);
        }
      }
    } on Object {
      // Varsayılan adlarla devam.
    }
    try {
      final raw = prefs.getString(_patientKey);
      if (raw != null) store._patients = PatientBook.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      // Bozuk soru defteri boş başlar.
    }
    // Ekonomi: ilk açılışta kasada [startCoins], rafta her maddeden bir paket.
    try {
      final raw = prefs.getString(_economyKey);
      if (raw == null) {
        store._coins = startCoins;
        for (final MapEntry(:key, :value) in packs.entries) {
          store._stock[key] = value.grams.toDouble();
        }
        await store._saveEconomy();
      } else {
        final e = jsonDecode(raw) as Map<String, dynamic>;
        store._coins = e['coins'] as int;
        store._debt = e['debt'] as int;
        store._earned = e['earned'] as int? ?? 0;
        for (final MapEntry(:key, :value) in (e['stock'] as Map<String, dynamic>).entries) {
          store._stock[key] = (value as num).toDouble();
        }
        store._tools.addAll([for (final t in e['tools'] as List) t as String]);
      }
    } on Object {
      // Bozuk ekonomi kaydı: kasa boş başlar, raf boş; eksikler depodan gelir.
    }
    // İlk açılış: duvar dolu başlar, sayaç şimdi başlar.
    if (nextId == null) {
      while (store._wall.length < store.wallLimit) {
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

  /// [slot]. yere [plant] fanusunu koyar (null: rafı boşaltır). Fanus ilk kez
  /// konurken o bitkiden fanus bedeli kadar (3-5) çiçek harcanır, sonra kalıcıdır (2026-10-29;
  /// `unlockAll` vitrini açmaz). Başka yerdeyse oradan alınır, aynı fanus iki
  /// kez durmaz.
  Future<void> setShowcase(int slot, String? plant) async {
    if (plant != null) {
      final opened = _garden.grown.contains(plant);
      if (!_garden.openFanus(plant)) return;
      if (!opened) await _saveGarden();
    }
    for (var i = 0; i < showcaseSize; i++) {
      if (_showcase[i] == plant) _showcase[i] = null;
    }
    _showcase[slot] = plant;
    await _saveProfile();
  }

  // ---- Bahçe ve vitrin etkileri (Tuğrul, 2026-10-29)

  Garden _garden = Garden();

  /// Bahçenin durumu (salt okunur kullanılır; değişiklik aşağıdaki yöntemlerle).
  Garden get garden => _garden;

  /// Son teslimde düşen tohum (yarı ihtimalle yok); teslim penceresi gösterir.
  String? get lastDrop => _lastDrop;
  String? _lastDrop;

  /// Vitrinde [group] grubundan duran en güçlü fanusun etkisi; aynı gruptan
  /// iki fanus toplanmaz. Yoksa 0.
  int showcaseBonus(PlantGroup group) {
    var best = 0;
    for (final name in _showcase) {
      final p = name == null ? null : driedPlantNamed(name);
      if (p != null && p.group == group && p.bonus > best) best = p.bonus;
    }
    return best;
  }

  /// Duvarda birikebilecek reçete: 3 + vitrindeki çay fanusu.
  int get wallLimit => wallSize + showcaseBonus(PlantGroup.cay);

  /// Günlük acele hakkı (vitrin artık hakkı değil kaliteyi korur, 2026-10-29).
  int get rushLimit => dailyRushes;

  /// Bugün kaç acele daha kaliteyi düşürmez (vitrindeki boğaz fanusu).
  int get protectedRushesLeft => (showcaseBonus(PlantGroup.bogaz) - _rushesUsed).clamp(0, 3);

  // ---- Para, stok, aletler (Tuğrul, 2026-10-29, "önerilerle"; data/economy.dart)

  int _coins = 0;
  int _debt = 0;
  final Map<String, double> _stock = {};
  final Set<String> _tools = {};

  /// Kasadaki para.
  int get coins => _coins;

  /// Ecza deposuna veresiye borcu; teslimlerden kendiliğinden kesilir.
  int get debt => _debt;

  /// Bugüne dek kazanılan para: teslim, bahşiş, çiçek satışı (istatistik).
  int get earned => _earned;
  int _earned = 0;

  /// Doğru bilinen hasta sorusu (istatistik).
  int get rightAnswers => _patients.rightAnswers;

  /// Raftaki madde, gram.
  double stockOf(String chemical) => _stock[chemical] ?? 0;

  /// Raftaki paket sayısı; açılmış paket de bir paket sayılır.
  int packsOf(String chemical) {
    final p = packs[chemical];
    return p == null ? 0 : (stockOf(chemical) / p.grams - 1e-9).ceil().clamp(0, 1 << 30);
  }

  /// Son teslimin parası (teslim penceresi gösterir).
  Payout? get lastPayout => _lastPayout;
  Payout? _lastPayout;

  /// Alet elde mi: ücretsiz kademe hep elde, ücretlisi satın alınınca.
  bool ownsTool(ShopItem item) => item.price == 0 || _tools.contains(item.name);

  /// Ödeyerek alır; para yetmezse hiçbir şey yapmaz.
  Future<bool> _spend(int price, void Function() give) async {
    if (_coins < price) return false;
    _coins -= price;
    give();
    await _saveEconomy();
    return true;
  }

  Future<bool> buyTool(ShopItem item) =>
      ownsTool(item) ? Future.value(false) : _spend(item.price, () => _tools.add(item.name));

  /// Bir paket kimyasal alır.
  Future<bool> buyPack(String chemical) => buyPacks(chemical, 1);

  /// [count] paket birden alır (marketteki miktar seçimi: 1, 5, 10, 20, 100).
  Future<bool> buyPacks(String chemical, int count) {
    final p = packs[chemical];
    if (p == null || count < 1) return Future.value(false);
    return _spend(p.price * count, () => _stock[chemical] = stockOf(chemical) + p.grams * count);
  }

  /// Bahçenin sıradaki kilitli parselini açar.
  Future<bool> buyParcel() async {
    final i = _garden.beds.length - Garden.openBeds;
    if (i >= parcelPrices.length) return false;
    final ok = await _spend(parcelPrices[i], () => _garden.beds.add(null));
    if (ok) await _saveGarden();
    return ok;
  }

  /// Sıradaki parselin fiyatı; hepsi açıksa null.
  int? get nextParcelPrice {
    final i = _garden.beds.length - Garden.openBeds;
    return i < parcelPrices.length ? parcelPrices[i] : null;
  }

  /// Elindeki bir kurutulmuş çiçeği markette satar (Tuğrul, 2026-10-29).
  Future<bool> sellFlower(String plant) async {
    final p = driedPlantNamed(plant);
    final have = _garden.flowers[plant] ?? 0;
    if (p == null || have < 1) return false;
    _garden.flowers[plant] = have - 1;
    _coins += flowerSellPrices[p.tier]!;
    await _saveGarden();
    await _saveEconomy();
    return true;
  }

  /// Reçeteyi almak için eksik olan paketlerin bedeli (0: raf yetiyor).
  int missingCost(PrescriptionOrder order) {
    var cost = 0;
    for (final MapEntry(:key, :value) in gramsFor(order).entries) {
      final p = packs[key];
      if (p == null || freeChemicals.contains(key)) continue;
      var have = stockOf(key);
      while (have < value) {
        have += p.grams;
        cost += p.price;
      }
    }
    return cost;
  }

  /// "Al" anında malzemeyi raftan düşer; eksik paketi alır, para yetmezse ecza
  /// deposu veresiye verir (oyuncu hiçbir zaman takılmaz).
  void _consume(PrescriptionOrder order) {
    for (final MapEntry(:key, :value) in gramsFor(order).entries) {
      final p = packs[key];
      if (p == null || freeChemicals.contains(key)) continue;
      while (stockOf(key) < value) {
        if (_coins >= p.price) {
          _coins -= p.price;
        } else {
          _debt += p.price - _coins;
          _coins = 0;
        }
        _stock[key] = stockOf(key) + p.grams;
      }
      _stock[key] = stockOf(key) - value;
    }
  }

  /// Teslim parasını öder; önce depo borcu kesilir.
  void _earn(int amount) {
    _earned += amount;
    final cut = math.min(_debt, amount);
    _debt -= cut;
    _coins += amount - cut;
  }

  Future<void> _saveEconomy() async {
    await _prefs.setString(
      _economyKey,
      jsonEncode({'coins': _coins, 'debt': _debt, 'earned': _earned, 'stock': _stock, 'tools': _tools.toList()}),
    );
    notifyListeners();
  }

  // ---- Aletlerin etkisi (2026-10-29)

  /// Adımın süresi, eldeki aletlerle: adımın marketteki yükseltmesi alınınca
  /// o aletin yüzdesi kadar kısalır (Tuğrul, 2026-10-29: yükseltme yalnız süre).
  Duration stepDuration(PrescriptionStep step) {
    final faster = upgradeFor(step.label, owns: ownsTool)?.faster ?? 0;
    return Duration(seconds: (step.minutes * 60 * (100 - faster) / 100).round());
  }

  /// [bed]. parsele tohum eker.
  Future<bool> plant(int bed, String plant) => _gardenChange(() => _garden.plant(bed, plant, now()));

  /// Olgun bitkiyi hasat eder (bir çiçek); adı döner, olgun değilse null.
  Future<String?> harvest(int bed) async {
    final plant = _garden.harvest(bed, now());
    if (plant != null) await _saveGarden();
    return plant;
  }

  /// Testler için: elde tohum verir.
  @visibleForTesting
  Future<void> giveSeed(String plant) async {
    _garden.seeds[plant] = (_garden.seeds[plant] ?? 0) + 1;
    await _saveGarden();
  }

  Future<bool> _gardenChange(bool Function() change) async {
    final ok = change();
    if (ok) await _saveGarden();
    return ok;
  }

  Future<void> _saveGarden() async {
    await _prefs.setString(_gardenKey, jsonEncode(_garden.toJson()));
    notifyListeners();
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
    if (_wall.length >= wallLimit) return null;
    return _due.difference(now());
  }

  void _arrive() {
    final order = _orders[_nextId % _orders.length];
    _see(order);
    _wall.add(IncomingOrder(id: _nextId++, magistralName: order.magistralName, orderKey: order.key));
  }

  /// Markette açık kimyasallar (Tuğrul, 2026-10-29): bir madde, onu isteyen
  /// ilk reçete duvara gelince açılır; o güne dek kilitli durur.
  bool chemicalUnlocked(String chemical) => _seenChemicals.contains(chemical);
  final Set<String> _seenChemicals = {};

  void _see(PrescriptionOrder order) => _seenChemicals.addAll(order.ingredients.map((i) => i.name));

  /// Uygulama kapalıyken dolan sayaçlar da sayılır: her geliş kendi anında
  /// olur ve sayaç o andan başlar. Duvar dolunca geliş bekletilir.
  void _catchUp() {
    var changed = false;
    while (_wall.length < wallLimit && !now().isBefore(_due)) {
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
        steps.fold(Duration.zero, (sum, s) => sum + stepDuration(s));
  }

  /// [tool] adım kartında şu an çalışan işler.
  List<({PrepJob job, StepRun run})> runsOn(LabTool tool) => [
        for (final job in _jobs)
          if (running(job) case final run? when run.tool == tool.name) (job: job, run: run),
      ];

  /// [tool] adım kartı şu an hangi reçetede çalışıyor (ilki); boşsa null.
  ({PrepJob job, StepRun run})? busyWith(LabTool tool) => runsOn(tool).firstOrNull;

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
      return later ? 'Önce ${step.label.toLowerCase()} yapılmalı.' : 'Bu adımı zaten yaptın.';
    }
    final runs = runsOn(tool);
    if (runs.isNotEmpty) return 'Bu adım şu an ${runs.first.job.magistralName} için çalışıyor. O bitince başlatabilirsin.';
    return null;
  }

  /// Duvardaki reçeteyi alır, tezgâha indirir; adımlarını oyuncu laboratuvarda
  /// başlatır. Malzeme bu anda raftan düşer (eksik paket alınır ya da depo
  /// veresiye verir). Duvar doluyken sayaç dolmuşsa yeni reçete hemen gelir.
  Future<PrepJob?> accept(IncomingOrder incoming) async {
    _catchUp();
    if (!_wall.any((o) => o.id == incoming.id)) return null;
    if (_wall.length >= wallLimit && !now().isBefore(_due)) _due = now();
    _wall.removeWhere((o) => o.id == incoming.id);
    _consume(orderKeyed(incoming.orderKey));
    await _saveEconomy();
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
      StepRun(label: step.label, tool: tool.name, start: start, end: start.add(stepDuration(step))),
    ]);
    await _save();
    notifyListeners();
  }

  /// Günde izlenebilecek ödüllü reklam, yani acele et hakkı (tasarım belgesi).
  /// Vitrindeki boğaz fanusu ilk acelelerin kaliteyi düşürmesini önler.
  static const dailyRushes = 5;
  static const _rushKey = 'rush_v1';

  /// Bugün kullanılan acele hakkı. Gün cihaz saatine göre değişir.
  int get _rushesUsed {
    final saved = _prefs.getString(_rushKey)?.split('|');
    if (saved == null || saved.length != 2 || saved[0] != _today) return 0;
    return int.tryParse(saved[1]) ?? 0;
  }

  /// Bugün kalan acele et hakkı.
  int get rushesLeft => (rushLimit - _rushesUsed).clamp(0, rushLimit);

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
  /// Vitrinde boğaz fanusu varsa günün ilk 1-3 acelesi kaliteyi düşürmez.
  Future<void> rush(int id) async {
    final job = this.job(id);
    if (job == null || !canRush(job)) return;
    final protected = protectedRushesLeft > 0;
    final note = protected
        ? 'Acele ettin, vitrindeki fanus kaliteyi korudu.'
        : 'Acele ettin, kalite yarıya indi.';
    final run = running(job)!;
    _jobs[_jobs.indexOf(job)] = job.copyWith(
      runs: [...job.runs.take(job.runs.length - 1), run.copyWith(end: now().add(stepLeftAfterRush(job)))],
      stars: protected ? job.stars : (job.stars / 2).ceil().clamp(1, 3),
      notes: job.notes.contains(note) ? job.notes : [...job.notes, note],
    );
    await _prefs.setString(_rushKey, '$_today|${_rushesUsed + 1}');
    await _save();
    notifyListeners();
  }

  /// Hazır işi teslim eder, listeden çıkarır ve teslim kaydına yazar. Hazır
  /// değilse hiçbir şey yapmaz.
  Future<PrepJob?> deliver(int id) async {
    final job = this.job(id);
    if (job == null || !isReady(job)) return null;
    _jobs.remove(job);
    // Teslim parası: günün ilk teslimleri emeği iki kat öder; cilt fanusu emeği artırır.
    final today = now();
    final earlierToday = _deliveries
        .where((d) => d.at.year == today.year && d.at.month == today.month && d.at.day == today.day)
        .length;
    _lastPayout = payoutFor(
      orderOf(job),
      job.stars,
      dailyBonus: earlierToday < dailyBonusDeliveries,
      laborBonusPercent: showcaseBonus(PlantGroup.cilt),
    );
    _earn(_lastPayout!.coins);
    await _saveEconomy();
    _deliveries.add(Delivery(
      magistralName: job.magistralName,
      orderKey: job.orderKey,
      stars: job.stars,
      at: now(),
      steps: [for (final s in orderOf(job).steps) s.label],
    ));
    await _prefs.setString(_deliveriesKey, jsonEncode([for (final d in _deliveries) d.toJson()]));
    // Teslimlerin yarısı bahçeye bir tohum getirir.
    _lastDrop = _garden.dropSeed(_random, bonusPercent: showcaseBonus(PlantGroup.ferah));
    await _prefs.setString(_gardenKey, jsonEncode(_garden.toJson()));
    await _save();
    notifyListeners();
    return job;
  }

  PatientBook _patients = PatientBook();

  /// Teslimden sonra hastanın sorusu (Tuğrul, 2026-10-30): önce zamanı gelen
  /// eski soru, yoksa bu reçeteden henüz sorulmamış biri. Günde en çok
  /// [dailyPatientQuestions] soru gelir; sorulacak soru yoksa null.
  PatientQuestion? nextPatientQuestion(PrepJob job) {
    if (_patients.day == _today && _patients.today >= dailyPatientQuestions) return null;
    for (final id in _patients.dueAt(now())) {
      final order = _orders.where((o) => id.startsWith('${o.key}|')).firstOrNull;
      if (order == null) continue;
      if (buildPatientQuestion(id, order, _random, returning: true) case final question?) return question;
    }
    final order = orderOf(job);
    final fresh = questionIdsFor(order).where((id) => !_patients.asked.containsKey(id)).toList();
    if (fresh.isEmpty) return null;
    // Önce tür seçilir: evet, hayır soruları sayıca çok, öbürlerini boğmasın.
    final kinds = fresh.map(questionKind).toSet().toList();
    final kind = kinds[_random.nextInt(kinds.length)];
    final pick = fresh.where((id) => questionKind(id) == kind).toList();
    return buildPatientQuestion(pick[_random.nextInt(pick.length)], order, _random);
  }

  /// Tezgâhta bekleyen soru ve verilen cevap (Tuğrul, 2026-10-30): pencere
  /// açılmaz, soru Reçeteler sekmesinin tezgâhında küçük bir kâğıtta çıkar.
  PatientQuestion? get pendingQuestion => _pending;
  PatientQuestion? _pending;
  int? get pendingChoice => _pendingChoice;
  int? _pendingChoice;

  /// Hasta tezgâha gelir; soracak soru yoksa bir şey olmaz.
  void askPatient(PrepJob job) {
    _pending = nextPatientQuestion(job);
    _pendingChoice = null;
    notifyListeners();
  }

  /// Soru kâğıdını tezgâhtan kaldırır.
  void closePatient() {
    _pending = null;
    _pendingChoice = null;
    notifyListeners();
  }

  /// Doğru cevabın bahşişi: son teslimin parasının yüzdesi, yukarı yuvarlanır.
  int get patientTip => ((_lastPayout?.coins ?? 0) * patientTipPercent / 100).ceil();

  /// Hastanın sorusunu cevaplar; doğruysa bahşiş kasaya girer.
  Future<bool> answerPatient(PatientQuestion question, int choice) async {
    final right = choice == question.answer;
    // Tezgâhtaki kâğıt bir kez cevaplanır.
    if (identical(question, _pending)) {
      if (_pendingChoice != null) return right;
      _pendingChoice = choice;
    }
    _patients.today = _patients.day == _today ? _patients.today + 1 : 1;
    _patients.day = _today;
    _patients.record(question.id, right: right, now: now());
    if (right) _earn(patientTip);
    await _prefs.setString(_patientKey, jsonEncode(_patients.toJson()));
    await _saveEconomy();
    notifyListeners();
    return right;
  }

  Future<void> _save() async {
    await _prefs.setString(_key, jsonEncode([for (final j in _jobs) j.toJson()]));
    await _prefs.setString(
      _wallKey,
      jsonEncode({
        'wall': [for (final o in _wall) o.toJson()],
        'nextId': _nextId,
        'due': _due.millisecondsSinceEpoch,
        'seen': _seenChemicals.toList(),
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
