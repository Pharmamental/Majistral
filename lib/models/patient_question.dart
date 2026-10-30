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

  /// Reçetenin adı, "|" ve soru türü: "use", "item:Sıvı Parafin" ya da "has:Üre".
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
    ..._hasIds(order),
  ];
}

/// Sorunun türü: "use", "item" ya da "has". Türler eşit sıklıkta gelsin diye.
String questionKind(String id) => id.substring(id.indexOf('|') + 1).split(':').first;

/// "Bu ilaçta X var mı?" soruları (Tuğrul, 2026-10-30). Evet cevaplıları
/// reçetedeki maddeler; adı ilacın adında geçen madde sorulmaz, cevabı bellidir.
/// Hayır cevaplıları aynı sayıda, reçetede olmayan etkin madde. Yalnız etkin
/// madde seçilir: hazır bazların içinde yağ, emülgatör ve koruyucu bulunur,
/// "Sulu Krem"li ilaçta "Beyaz Vazelin yok" demek yanlış olur.
List<String> _hasIds(PrescriptionOrder order) {
  final have = {for (final i in order.ingredients) i.name};
  final yes = [
    for (final name in have)
      if (name != 'Distile Su' && chemicalRole(name) != null && !_namedIn(order, name)) name,
  ];
  // Market listesinin son üç grubu etkin maddeler.
  final actives = chemicalGroups.skip(5).toList();
  final mine = actives.where((g) => g.items.any((i) => have.contains(i.name))).toList();
  final pool = [
    for (final g in mine.isEmpty ? actives : mine)
      for (final i in g.items)
        if (!have.contains(i.name) && !have.any((h) => _partOf[h] == i.name)) i.name,
  ];
  final start = order.key.codeUnits.fold(0, (a, b) => a + b);
  final no = [
    for (var i = 0; i < math.min(math.max(yes.length, 1), pool.length); i++) pool[(start + i) % pool.length],
  ];
  return [for (final name in [...yes, ...no]) '${order.key}|has:$name'];
}

/// Başka maddenin içinde bulunan madde: kalamin çinko oksittir.
const _partOf = {'Kalamin': 'Çinko Oksit'};

bool _namedIn(PrescriptionOrder order, String name) {
  String low(String s) => s.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
  final title = low(order.magistralName);
  return low(name).split(' ').any((w) => w.length >= 4 && !w.contains('%') && title.contains(w));
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
  } else if (kind.startsWith('has:')) {
    final name = kind.substring('has:'.length);
    final there = order.ingredients.any((i) => i.name == name);
    final names = [for (final i in order.ingredients) i.name];
    final list = names.length == 1 ? names.first : '${names.take(names.length - 1).join(', ')} ve ${names.last}';
    // Evet ve hayır her zaman aynı sırada; karışırsa yanlışlıkla basılır.
    return PatientQuestion(
      id: id,
      order: order,
      ask: 'Bu ilaçta $name var mı?',
      options: const ['Evet, var.', 'Hayır, yok.'],
      answer: there ? 0 : 1,
      explain: 'Reçetede $list var.',
      returning: returning,
    );
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
  PatientBook({Map<String, ({int box, DateTime? due})>? asked, this.day = '', this.today = 0, this.rightAnswers = 0})
      : asked = asked ?? {};

  static const repeatDays = [1, 3, 7];

  /// Soru → yeniden sorulacağı an; `due` null ise bitti.
  final Map<String, ({int box, DateTime? due})> asked;

  /// [day] günü cevaplanan soru sayısı.
  String day;
  int today;

  /// Bugüne dek doğru bilinen soru sayısı (istatistik).
  int rightAnswers;

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
    if (right) rightAnswers++;
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
        'right': rightAnswers,
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
        rightAnswers: json['right'] as int? ?? 0,
      );
}
