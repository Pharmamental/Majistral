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

/// Teslim edilmiş reçetelerin formül kitabındaki adları (koleksiyon).
Set<String> preparedFormulas(List<Delivery> deliveries, List<PrescriptionOrder> orders) => {
      for (final d in deliveries)
        for (final o in orders)
          if (o.magistralName == d.magistralName) o.formula,
    };

/// Oyunda hazırlanabilen formüller: koleksiyon yalnız bunları sayar; formül
/// kitabının geri kalanı oyuna geldikçe eklenir.
Set<String> playableFormulas(List<PrescriptionOrder> orders) => {for (final o in orders) o.formula};
