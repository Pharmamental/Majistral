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

/// Bir adımın ustalığı: kaç teslimde yapıldı, o teslimlerin ortalama yıldızı.
typedef Mastery = ({int count, double stars});

Mastery masteryOf(String step, List<Delivery> deliveries) {
  final done = [for (final d in deliveries) if (d.steps.contains(step)) d.stars];
  if (done.isEmpty) return (count: 0, stars: 0);
  return (count: done.length, stars: done.reduce((a, b) => a + b) / done.length);
}

/// Bütün teslimlerin ortalama yıldızı; teslim yoksa 0.
double averageStars(List<Delivery> deliveries) =>
    deliveries.isEmpty ? 0 : deliveries.fold(0, (sum, d) => sum + d.stars) / deliveries.length;

/// Teslim edilmiş reçetelerin formül kitabındaki adları (koleksiyon).
Set<String> preparedFormulas(List<Delivery> deliveries, List<PrescriptionOrder> orders) => {
      for (final d in deliveries)
        for (final o in orders)
          if (o.magistralName == d.magistralName) o.formula,
    };

/// Yıldızı "2,8" biçiminde yazar.
String formatStars(double stars) => stars.toStringAsFixed(1).replaceAll('.', ',');
