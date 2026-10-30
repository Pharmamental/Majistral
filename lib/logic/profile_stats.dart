import '../models/prep_job.dart';
import '../models/prescription.dart';

/// Diplomadaki unvan ve kaç teslimden sonra geldiği. Eşikler yer tutucu;
/// kapalı testte ayarlanacak (Tuğrul, 2026-10-28).
typedef Rank = ({String title, int from});

const List<Rank> ranks = [
  (title: 'Stajyer eczacı', from: 0),
  (title: 'Eczacı', from: 10),
  (title: 'Uzman eczacı', from: 30),
  (title: 'Mesul müdür', from: 60),
];

/// [delivered] teslimle ulaşılan unvanın sırası.
int rankIndex(int delivered) => ranks.lastIndexWhere((r) => delivered >= r.from);

/// Bir tekniğin ustalık kademesi ve kaç kez yapılınca geldiği. Ustalık yıldızla
/// ölçülmez: oyunda yıldızı yalnız "acele et" düşürüyor, beceriyi değil reklam
/// kullanımını gösterir (2026-10-28). Eşikler yer tutucu.
typedef Tier = ({String title, int from});

const List<Tier> tiers = [
  (title: 'Başladın', from: 1),
  (title: 'Bronz', from: 5),
  (title: 'Gümüş', from: 15),
  (title: 'Altın', from: 40),
];

/// Bir tekniğin kaç teslimde yapıldığı.
int stepCount(String step, List<Delivery> deliveries) => deliveries.where((d) => d.steps.contains(step)).length;

/// [count] kez yapılan tekniğin kademe sırası; hiç yapılmadıysa -1.
int tierIndex(int count) => tiers.lastIndexWhere((t) => count >= t.from);

/// Son teslimle Bronz, Gümüş ya da Altın'a çıkan teknikler (başarım kutucuğu).
/// [deliveries] son teslimi de içerir; "Başladın" kutucuk çıkarmaz.
List<({String step, int tier, int count})> tierUps(List<Delivery> deliveries) {
  if (deliveries.isEmpty) return const [];
  return [
    for (final step in deliveries.last.steps.toSet())
      if (stepCount(step, deliveries) case final count when tierIndex(count) > 0 && tiers[tierIndex(count)].from == count)
        (step: step, tier: tierIndex(count), count: count),
  ];
}

/// Teslim yapılan farklı gün sayısı.
int daysPlayed(List<Delivery> deliveries) => _days(deliveries).length;

/// En uzun üst üste teslim serisi, gün olarak.
int longestStreak(List<Delivery> deliveries) {
  final days = _days(deliveries).toList()..sort();
  var best = 0, run = 0;
  for (final (i, day) in days.indexed) {
    run = i > 0 && _isNextDay(days[i - 1], day) ? run + 1 : 1;
    if (run > best) best = run;
  }
  return best;
}

Set<DateTime> _days(List<Delivery> deliveries) => {
      for (final d in deliveries) DateTime.utc(d.at.year, d.at.month, d.at.day),
    };

bool _isNextDay(DateTime a, DateTime b) => b.difference(a).inDays == 1;

/// En çok teslim edilen ilaç ve kaç kez; teslim yoksa null. Eşitlikte önce yapılan.
({String name, int count})? topRecipe(List<Delivery> deliveries) =>
    _top([for (final d in deliveries) d.magistralName]);

/// En çok teslimde yapılan teknik ve kaç kez; teslim yoksa null.
({String name, int count})? topStep(List<Delivery> deliveries) =>
    _top([for (final d in deliveries) ...d.steps.toSet()]);

({String name, int count})? _top(List<String> names) {
  final counts = <String, int>{};
  for (final n in names) {
    counts[n] = (counts[n] ?? 0) + 1;
  }
  ({String name, int count})? best;
  for (final MapEntry(:key, :value) in counts.entries) {
    if (best == null || value > best.count) best = (name: key, count: value);
  }
  return best;
}

/// Teslim edilmiş reçetelerin formül kitabındaki adları (koleksiyon).
Set<String> preparedFormulas(List<Delivery> deliveries, List<PrescriptionOrder> orders) => {
      for (final d in deliveries)
        for (final o in orders)
          if (o.magistralName == d.magistralName) o.formula,
    };

/// Oyunda hazırlanabilen formüller: koleksiyon yalnız bunları sayar; formül
/// kitabının geri kalanı oyuna geldikçe eklenir.
Set<String> playableFormulas(List<PrescriptionOrder> orders) => {for (final o in orders) o.formula};
