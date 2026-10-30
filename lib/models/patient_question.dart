import 'dart:math' as math;

import '../data/market_items.dart';
import '../data/patient_uses.dart';
import 'prescription.dart';

/// Teslimden sonra hastanın sorduğu soru; reçete penceresinde okunan bilgiden
/// üretilir, reçete o anda kapalıdır.
class PatientQuestion {
  const PatientQuestion({
    required this.id,
    required this.order,
    required this.ask,
    required this.options,
    required this.answer,
    required this.explain,
    required this.returning,
  });

  /// Reçetenin adı, "|" ve soru türü: "use" ya da "item:Sıvı Parafin".
  final String id;
  final PrescriptionOrder order;
  final String ask;
  final List<String> options;

  /// Doğru şıkkın [options] içindeki yeri.
  final int answer;

  /// Cevaptan sonra gösterilen açıklama.
  final String explain;

  /// Hasta daha önce yanlış bildiğin soruyu yeniden soruyor.
  final bool returning;
}

/// Bu reçeteden sorulabilecek sorular; kuşkulu reçetede yok.
List<String> questionIdsFor(PrescriptionOrder order) {
  if (unverifiedOrders.contains(order.key)) return const [];
  return [
    if (orderUses.containsKey(order.key)) '${order.key}|use',
    for (final i in order.ingredients)
      if (i.name != 'Distile Su' && chemicalRole(i.name) != null) '${order.key}|item:${i.name}',
  ];
}

/// [id]'den soruyu kurar. Şıklar her seferinde karışır; hiçbir yanlış şık bu
/// ilaç için doğru olamaz. Kurulamazsa (reçete değişmişse) null.
PatientQuestion? buildPatientQuestion(String id, PrescriptionOrder order, math.Random rnd, {bool returning = false}) {
  final kind = id.substring(id.indexOf('|') + 1);
  final String ask, correct, explain;
  final List<String> wrong;
  if (kind == 'use') {
    final uses = orderUses[order.key];
    if (uses == null) return null;
    ask = 'Bu ilaç ne işe yarıyor?';
    correct = useAnswers[uses.first]!;
    explain = order.usedFor;
    final family = useFamilies[uses.first];
    final others = [for (final k in useAnswers.keys) if (!uses.contains(k)) k]..shuffle(rnd);
    wrong = [
      ...others.where((k) => useFamilies[k] == family),
      ...others.where((k) => useFamilies[k] != family),
    ].take(2).map((k) => useAnswers[k]!).toList();
  } else if (kind.startsWith('item:')) {
    final name = kind.substring('item:'.length);
    final role = chemicalRole(name);
    if (role == null) return null;
    ask = 'İçindeki $name ne işe yarıyor?';
    correct = role;
    explain = role;
    final group = chemicalGroups.firstWhere((g) => g.items.any((i) => i.name == name));
    final others = [
      for (final g in chemicalGroups)
        if (g != group)
          for (final i in g.items)
            if (i.name != 'Distile Su') i.description,
    ]..shuffle(rnd);
    wrong = others.take(2).toList();
  } else {
    return null;
  }
  final options = [correct, ...wrong]..shuffle(rnd);
  return PatientQuestion(
    id: id,
    order: order,
    ask: ask,
    options: options,
    answer: options.indexOf(correct),
    explain: explain,
    returning: returning,
  );
}

/// Sorulan soruların defteri. Yanlış bilinen soru 1, 3 ve 7 gün sonra yeniden
/// gelir; üçünü de bilince biter. İlk seferde bilinen soru bir daha gelmez.
class PatientBook {
  PatientBook({Map<String, ({int box, DateTime? due})>? asked, this.day = '', this.today = 0}) : asked = asked ?? {};

  static const repeatDays = [1, 3, 7];

  /// Soru → yeniden sorulacağı an; `due` null ise bitti.
  final Map<String, ({int box, DateTime? due})> asked;

  /// [day] günü cevaplanan soru sayısı.
  String day;
  int today;

  /// Zamanı gelmiş sorular, en eskisi önde.
  List<String> dueAt(DateTime now) {
    final ids = [
      for (final e in asked.entries)
        if (e.value.due case final due? when !due.isAfter(now)) e.key,
    ];
    ids.sort((a, b) => asked[a]!.due!.compareTo(asked[b]!.due!));
    return ids;
  }

  void record(String id, {required bool right, required DateTime now}) {
    final box = asked[id]?.box;
    if (!right) {
      asked[id] = (box: 1, due: now.add(Duration(days: repeatDays.first)));
    } else if (box == null || box >= repeatDays.length) {
      asked[id] = (box: 0, due: null);
    } else {
      asked[id] = (box: box + 1, due: now.add(Duration(days: repeatDays[box])));
    }
  }

  Map<String, Object> toJson() => {
        'asked': {
          for (final e in asked.entries) e.key: [e.value.box, e.value.due?.millisecondsSinceEpoch ?? 0],
        },
        'day': day,
        'today': today,
      };

  factory PatientBook.fromJson(Map<String, dynamic> json) => PatientBook(
        asked: {
          for (final e in (json['asked'] as Map<String, dynamic>).entries)
            e.key: (
              box: (e.value as List)[0] as int,
              due: (e.value as List)[1] == 0 ? null : DateTime.fromMillisecondsSinceEpoch((e.value as List)[1] as int),
            ),
        },
        day: json['day'] as String,
        today: json['today'] as int,
      );
}
