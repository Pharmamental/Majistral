import '../../models/formula.dart';
import '../../models/prescription.dart';
import '../references.dart';

// Formüller BP/BPC pudra ve oral toz monograflarından, WHO ORS belgesinden, USP topikal toz monograflarından
// ve dozları Martindale/BNF'de bulunan kapsüllerden derlendi.
const tozRefs = <Reference>[
  Reference(
    id: 'toz-bpc-1973',
    kind: ReferenceKind.farmakope,
    citation: 'British Pharmaceutical Codex 1973. Pharmaceutical Society of Great Britain, The Pharmaceutical '
        'Press, Londra, 1973.',
  ),
  Reference(
    id: 'toz-who-ors',
    kind: ReferenceKind.devlet,
    citation: 'WHO, UNICEF. Oral Rehydration Salts: Production of the New ORS (WHO/FCH/CAH/06.1). Dünya Sağlık '
        'Örgütü, Cenevre, 2006.',
    url: 'https://iris.who.int/handle/10665/69227',
  ),
  Reference(
    id: 'toz-bnf',
    kind: ReferenceKind.kitap,
    citation: 'Joint Formulary Committee. British National Formulary (BNF). BMJ Group ve Pharmaceutical Press, '
        'Londra.',
    url: 'https://bnf.nice.org.uk',
  ),
  Reference(
    id: 'toz-bnfc',
    kind: ReferenceKind.kitap,
    citation: 'Paediatric Formulary Committee. BNF for Children (BNFC). BMJ Group, Pharmaceutical Press ve RCPCH '
        'Publications, Londra.',
    url: 'https://bnfc.nice.org.uk',
  ),
  Reference(
    id: 'toz-allen-2016',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr. Basics of Compounding: Capsules. Int J Pharm Compd 2016;20(2):125-34.',
    url: 'https://ijpc.com/Abstracts/Abstract.cfm?ABS=4114',
  ),
  Reference(
    id: 'toz-allen-ursodiol',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr. Ursodiol 150-mg Capsules. Int J Pharm Compd 2003;7(5):382.',
    url: 'https://ijpc.com/Abstracts/Abstract_basic.cfm?ABS=1568',
  ),
  Reference(
    id: 'toz-klinger-2021',
    kind: ReferenceKind.makale,
    citation: 'Klinger J, Daniels R. Assessing a mass-based method for the preparation of low-dosed paediatric '
        'capsules with baclofen and spironolactone. Pharmacy (Basel) 2021;9(1):56.',
    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC8005994/',
  ),
  Reference(
    id: 'toz-yeow-2011',
    kind: ReferenceKind.makale,
    citation: 'Yeow ST ve ark. Askorbik asit ve laktozun yığın ve vurgulu yoğunluk ölçümleri. Drug Des Devel Ther '
        '2011;5:465-9.',
    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC3232173/',
  ),
  Reference(
    id: 'toz-taketomo-kaptopril',
    kind: ReferenceKind.makale,
    citation: 'Taketomo CK, Chu SA, Cheng MH, Corpuz RP. Stability of captopril in powder papers under three storage '
        'conditions. Am J Hosp Pharm 1990;47(8):1799-801.',
    url: 'https://pubmed.ncbi.nlm.nih.gov/2202207/',
  ),
  Reference(
    id: 'toz-smpc-kaptopril',
    kind: ReferenceKind.devlet,
    citation: 'Captopril 5 mg/5 ml Oral Solution, ürün bilgisi (SmPC) bölüm 4.2. electronic medicines compendium, '
        'Birleşik Krallık.',
    url: 'https://www.medicines.org.uk/emc/product/5249/smpc',
  ),
  Reference(
    id: 'toz-wasilewski-klonidin',
    kind: ReferenceKind.makale,
    citation: 'Wasilewski M, Curti C, Panuccio C ve ark. Pre-formulation and stability study of 20-mcg clonidine '
        'hydrochloride pediatric capsules. J Pediatr Pharmacol Ther 2022;27(7):625-31.',
    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC9514770/',
  ),
  Reference(
    id: 'toz-anmf',
    kind: ReferenceKind.devlet,
    citation: 'Australasian Neonatal Medicines Formulary (ANMF): Clonidine (v5.0, 2024) ve Nifedipine (v1.0, 2024) '
        'monografları. South Eastern Sydney Local Health District, Avustralya.',
    url: 'https://www.seslhd.health.nsw.gov.au/royal-hospital-for-women/australasian-neonatal-medicines-formulary-anmf',
  ),
  Reference(
    id: 'toz-helin-tanninen-nifedipin',
    kind: ReferenceKind.makale,
    citation: 'Helin-Tanninen M, Naaranlahti T, Kontra K, Savolainen K. Nifedipine capsules may provide a viable '
        'alternative to oral powders for paediatric patients. J Clin Pharm Ther 2007;32(1):49-55.',
    url: 'http://urn.fi/URN:ISBN:978-952-61-1291-6',
  ),
];

const tozFormulas = <Formula>[
  // ---------------------------------------------------------------- Pudralar
  Formula(
    name: 'Çinko, nişasta ve talk pudrası',
    category: FormulaCategory.toz,
    use: 'Pişik ve terlemeye bağlı tahrişte cildi kuru tutan, koruyan pudradır.',
    ingredients: [
      Ingredient('Çinko oksit', '25 g'),
      Ingredient('Nişasta', '25 g'),
      Ingredient('Talk (asbestsiz, saflaştırılmış)', '50 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Çinko oksitteki topaklar havanda ince toz olana dek ezilir.'),
      FormulaStep('Geometrik seyreltme',
          'Çinko oksit önce nişastayla, sonra talkla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım ince elekten geçirilir, renk ve doku tek düze olur.'),
    ],
    refs: ['bp', 'toz-bpc-1973', 'martindale', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Talk pudrası',
    category: FormulaCategory.toz,
    use: 'Sürtünmeyi azaltıp deriyi kuru tutan basit kaydırıcı pudradır; bebek yüzüne sürülmez.',
    ingredients: [
      Ingredient('Talk (asbestsiz, saflaştırılmış)', '90 g'),
      Ingredient('Nişasta', '10 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Talk ve nişasta havanda hafifçe karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım ince elekten geçirilir, topak kalmaz.'),
    ],
    refs: ['bp', 'toz-bpc-1973', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Klorheksidin pudrası %0,5',
    category: FormulaCategory.toz,
    use: 'Küçük yara çevresinde ve kıvrım bölgelerinde mikrop yükünü azaltan antiseptik pudradır.',
    ingredients: [
      Ingredient('Klorheksidin hidroklorür', '0,5 g'),
      Ingredient('Mısır nişastası (sterilize edilebilir)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Klorheksidin hidroklorür havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Az miktardaki etken madde nişastayla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilip dağılımın eşit olması sağlanır.'),
    ],
    refs: ['toz-bpc-1973', 'martindale'],
  ),
  Formula(
    name: 'Bileşik çinko undesilenat pudrası',
    category: FormulaCategory.toz,
    use: 'Ayak mantarında (atlet ayağı) ayak ve parmak arasına serpilen mantar önleyici pudradır.',
    ingredients: [
      Ingredient('Çinko undesilenat', '20 g'),
      Ingredient('Undesilenik asit', '2 g'),
      Ingredient('Talk (asbestsiz, saflaştırılmış)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Çinko undesilenat havanda ince toz olana dek ezilir.'),
      FormulaStep('Levigasyon', 'Sıvı undesilenik asit, çinko undesilenatın bir kısmıyla ezilerek toza emdirilir.'),
      FormulaStep('Geometrik seyreltme', 'Bu karışım talkla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Pudra elekten geçirilir, yağlı topakçık kalmaz.'),
    ],
    refs: ['toz-bpc-1973', 'martindale', 'toz-bnf'],
  ),
  Formula(
    name: 'Salisilik asitli pudra %3',
    category: FormulaCategory.toz,
    use: 'Aşırı terleyen ve kokan ayaklarda deriyi kurutan, hafif keratolitik pudradır.',
    ingredients: [
      Ingredient('Salisilik asit', '3 g'),
      Ingredient('Çinko, nişasta ve talk pudrası', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit porselen havanda ince toz olana dek ezilir; metal spatül kullanılmaz.'),
      FormulaStep('Geometrik seyreltme', 'Salisilik asit pudra tabanıyla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilip asit kristali kalmaması sağlanır.'),
    ],
    refs: ['toz-bpc-1973', 'martindale'],
  ),
  Formula(
    name: 'Mentollü pudra %1',
    category: FormulaCategory.toz,
    use: 'Kaşıntılı ve terleyen deride serinlik veren, kaşıntıyı azaltan pudradır.',
    ingredients: [
      Ingredient('Mentol', '1 g'),
      Ingredient('Talk (asbestsiz, saflaştırılmış)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Mentol kristalleri birkaç damla alkolle havanda ezilerek çok ince dağıtılır.'),
      FormulaStep('Geometrik seyreltme', 'Mentol talka eşit parçalar hâlinde katılır.'),
      FormulaStep('Elekten geçirme', 'Pudra elekten geçirilir, mentol topağı kalmaz.'),
    ],
    refs: ['fn-es', 'martindale', 'remington', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Kâfurlu mentollü pudra',
    category: FormulaCategory.toz,
    use: 'Kaşıntılı deride serinletici etki için kullanılan, ötektik karışım içeren pudradır.',
    ingredients: [
      Ingredient('Kâfur', '1 g'),
      Ingredient('Mentol', '1 g'),
      Ingredient('Talk (asbestsiz, saflaştırılmış)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kâfur ve mentol havanda birlikte ezilir, sıvı bir ötektik karışım oluşur.'),
      FormulaStep('Geometrik seyreltme',
          'Sıvı karışım az talkla emdirilir, sonra kalan talkla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Pudra elekten geçirilip ıslak topaklar dağıtılır.'),
    ],
    refs: ['ansel', 'allen', 'martindale'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Nistatin pudrası 100.000 IU/g',
    category: FormulaCategory.toz,
    use: 'Kıvrım bölgelerindeki ve bez bölgesindeki kandida (maya mantarı) enfeksiyonunda kullanılır.',
    ingredients: [
      Ingredient('Nistatin', '10.000.000 IU (yaklaşık 2 g, etiket gücüne göre)'),
      Ingredient('Talk (asbestsiz, saflaştırılmış)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Nistatin havanda hafifçe ezilerek topakları dağıtılır.'),
      FormulaStep('Geometrik seyreltme', 'Nistatin talkla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilip etken madde eşit dağıtılır.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),
  Formula(
    name: 'Tolnaftat pudrası %1',
    category: FormulaCategory.toz,
    use: 'Ayak ve kasık mantarında tedaviye ve yeniden çıkmasını önlemeye yarar.',
    ingredients: [
      Ingredient('Tolnaftat', '1 g'),
      Ingredient('Mısır nişastası', '20 g'),
      Ingredient('Talk (asbestsiz, saflaştırılmış)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tolnaftat havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Tolnaftat önce nişastayla, sonra talkla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Pudra elekten geçirilir.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),
  Formula(
    name: 'Mikonazol nitrat pudrası %2',
    category: FormulaCategory.toz,
    use: 'Deri mantarı ve kandida enfeksiyonunda nemli bölgeleri kuru tutarak tedaviye yardım eder.',
    ingredients: [
      Ingredient('Mikonazol nitrat', '2 g'),
      Ingredient('Talk (asbestsiz, saflaştırılmış)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Mikonazol nitrat havanda ince toz olana dek ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Etken madde talkla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
    ],
    refs: ['usp-nf', 'martindale'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Klotrimazol pudrası %1',
    category: FormulaCategory.toz,
    use: 'Ayak, kasık ve kıvrım bölgesi mantarında serpilerek kullanılır.',
    ingredients: [
      Ingredient('Klotrimazol', '1 g'),
      Ingredient('Mısır nişastası', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Klotrimazol havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Klotrimazol nişastayla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Pudra elekten geçirilir.'),
    ],
    refs: ['martindale', 'toz-bnf'],
  ),
  Formula(
    name: 'Talksız çinko oksitli nişasta pudrası %10',
    category: FormulaCategory.toz,
    use: 'Talk istenmeyen bebeklerde bez bölgesini kuru tutan koruyucu pudradır; yüze sürülmez.',
    ingredients: [
      Ingredient('Çinko oksit', '10 g'),
      Ingredient('Mısır nişastası', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Çinko oksit havanda topaksız ince toz olana dek ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Çinko oksit nişastayla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım ince elekten geçirilir.'),
    ],
    refs: ['martindale', 'allen', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, kuru yerde',
  ),
  Formula(
    name: 'Ekonazol nitrat pudrası %1',
    category: FormulaCategory.toz,
    use: 'Ayak ve kıvrım bölgesi mantarında kremle birlikte ya da tek başına serpilerek kullanılır.',
    ingredients: [
      Ingredient('Ekonazol nitrat', '1 g'),
      Ingredient('Talk (asbestsiz, saflaştırılmış)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Ekonazol nitrat havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Ekonazol talkla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Pudra elekten geçirilir.'),
    ],
    refs: ['martindale', 'toz-bnf'],
  ),
  // ---------------------------------------------------------- Oral tozlar
  Formula(
    name: 'Bileşik magnezyum trisilikat oral tozu',
    category: FormulaCategory.toz,
    use: 'Mide ekşimesi ve hazımsızlıkta suyla karıştırılıp içilen antasit tozudur.',
    ingredients: [
      Ingredient('Magnezyum trisilikat', '25 g'),
      Ingredient('Tebeşir (kalsiyum karbonat)', '25 g'),
      Ingredient('Ağır magnezyum karbonat', '25 g'),
      Ingredient('Sodyum bikarbonat', '25 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Sodyum bikarbonat ve topaklı tozlar havanda ayrı ayrı ezilir.'),
      FormulaStep('Karıştırma', 'Dört toz eşit miktarda olduğu için havanda birlikte karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilip tek düze hâle getirilir.'),
    ],
    refs: ['bp', 'toz-bpc-1973'],
  ),
  Formula(
    name: 'Oral rehidratasyon tuzu (WHO, düşük ozmolarite)',
    category: FormulaCategory.toz,
    use: 'İshalde kaybedilen su ve tuzu yerine koymak için 1 litre suda çözülüp içilir.',
    ingredients: [
      Ingredient('Sodyum klorür', '2,6 g'),
      Ingredient('Glukoz (susuz)', '13,5 g'),
      Ingredient('Potasyum klorür', '1,5 g'),
      Ingredient('Trisodyum sitrat dihidrat', '2,9 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tuz ve sitrat kristalleri havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Küçük miktardaki tuzlar glukozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir, her poşet aynı bileşimi taşır.'),
    ],
    refs: ['toz-who-ors', 'bp', 'who-mf'],
  ),
  Formula(
    name: 'Oral rehidratasyon tuzu (bikarbonatlı, eski WHO)',
    category: FormulaCategory.toz,
    use: 'İshalde sıvı kaybını yerine koyan, sitrat yerine bikarbonat içeren eski WHO bileşimidir.',
    ingredients: [
      Ingredient('Sodyum klorür', '3,5 g'),
      Ingredient('Sodyum bikarbonat', '2,5 g'),
      Ingredient('Potasyum klorür', '1,5 g'),
      Ingredient('Glukoz (susuz)', '20 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tuz kristalleri ve bikarbonat havanda ayrı ayrı ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Tuzlar glukozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilip poşetlenmeye hazır hâle gelir.'),
    ],
    refs: ['toz-who-ors', 'bp'],
  ),
  Formula(
    name: 'Efervesan sodyum bikarbonat granülü',
    category: FormulaCategory.toz,
    use: 'Suya atılınca köpürerek çözünen, antasit ve tat düzeltici efervesan granüldür.',
    ingredients: [
      Ingredient('Sitrik asit monohidrat', '15,5 g'),
      Ingredient('Tartarik asit', '31 g'),
      Ingredient('Sodyum bikarbonat', '53,5 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Üç madde kuru havanda ayrı ayrı ince toz hâline getirilir.'),
      FormulaStep('Karıştırma',
          'Tozlar karıştırılıp ılık tabakta çevrilir; sitrik asidin kristal suyu tozu nemli hamur yapar.'),
      FormulaStep('Elekten geçirme', 'Nemli kütle elekten bastırılarak granül yapılır, sonra kurutulur.'),
    ],
    refs: ['ansel', 'remington'],
  ),
  Formula(
    name: 'Parasetamol paket toz 120 mg',
    category: FormulaCategory.toz,
    use: 'Küçük çocukta ateş ve ağrı için tek doz paketlere bölünmüş tozdur.',
    ingredients: [
      Ingredient('Parasetamol', '1,2 g (10 paket için)'),
      Ingredient('Laktoz monohidrat', 'ad 5 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Parasetamol havanda ince toz olana dek ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Parasetamol laktozla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir, sonra 500 mg\'lık 10 pakete bölünür.'),
    ],
    refs: ['martindale', 'toz-bnfc'],
  ),
  Formula(
    name: 'Sodyum bikarbonat paket toz 1 g',
    category: FormulaCategory.toz,
    use: 'Metabolik asidozda ya da idrarı alkalileştirmek için suda çözülerek alınan tek doz tozdur.',
    ingredients: [
      Ingredient('Sodyum bikarbonat', '10 g (10 paket için)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Sodyum bikarbonat havanda topaksız ince toz hâline getirilir.'),
      FormulaStep('Elekten geçirme', 'Toz elekten geçirilir, sonra 1 g\'lık 10 pakete bölünür.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Folik asit paket toz 0,5 mg',
    category: FormulaCategory.toz,
    use: 'Bebek ve küçük çocukta folat eksikliğinde kullanılan tek doz paket tozdur.',
    ingredients: [
      Ingredient('Folik asit', '15 mg (30 paket için)'),
      Ingredient('Laktoz monohidrat', 'ad 9 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Folik asit havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme',
          'Çok az olan folik asit laktozla adım adım eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir, sonra 300 mg\'lık 30 pakete bölünür.'),
    ],
    refs: ['martindale', 'toz-bnfc', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Kalsiyum karbonat paket toz 500 mg',
    category: FormulaCategory.toz,
    use: 'Kalsiyum eksikliğinde ya da böbrek hastasında fosfat bağlayıcı olarak yemekle alınan paket tozdur.',
    ingredients: [
      Ingredient('Kalsiyum karbonat', '15 g (30 paket için)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kalsiyum karbonat havanda topaksız toz hâline getirilir.'),
      FormulaStep('Elekten geçirme', 'Toz elekten geçirilir, sonra 500 mg\'lık 30 pakete bölünür.'),
    ],
    refs: ['martindale', 'toz-bnfc'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Sodyum klorür paket toz 500 mg',
    category: FormulaCategory.toz,
    use: 'Tuz kaybeden bebek ve çocuklarda mamaya ya da suya katılan tuz desteğidir.',
    ingredients: [
      Ingredient('Sodyum klorür', '15 g (30 paket için)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Sodyum klorür kristalleri havanda ince toz hâline getirilir.'),
      FormulaStep('Elekten geçirme', 'Toz elekten geçirilir, sonra 500 mg\'lık 30 pakete bölünür.'),
    ],
    refs: ['martindale', 'toz-bnfc', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  // -------------------------------------------------------------- Kapsüller
  Formula(
    name: 'Kafein kapsülü 100 mg',
    category: FormulaCategory.toz,
    use: 'Uyanıklığı artırmak ve bazı baş ağrılarında yardımcı olarak kullanılır.',
    ingredients: [
      Ingredient('Kafein (susuz)', '3 g (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (0 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kafein havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Kafein laktozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilip tek düze yapılır.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 0 numara kapsüle zımbalama yöntemiyle doldurulur.'),
    ],
    refs: ['martindale', 'allen', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, oda sıcaklığında, kuru yerde',
  ),
  Formula(
    name: 'Kaptopril kapsülü 2,5 mg',
    category: FormulaCategory.toz,
    use: 'Bebek ve çocuklarda yüksek tansiyon ve kalp yetmezliğinde düşük dozda verilen tansiyon ilacıdır.',
    ingredients: [
      Ingredient('Kaptopril 25 mg tablet', '3 tablet (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (3 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletler havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Tablet tozu laktozla birkaç basamakta eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilip tek düze yapılır.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 3 numara kapsüle kapsül makinesiyle doldurulur.'),
    ],
    refs: ['toz-taketomo-kaptopril', 'toz-smpc-kaptopril', 'usp-795'],
    shelfLife: '24 hafta (tabletin son kullanma tarihini geçmez), sıkı kapalı kapta, oda sıcaklığında, kuru yerde',
  ),
  Formula(
    name: 'Klonidin kapsülü 20 mikrogram',
    category: FormulaCategory.toz,
    use: 'Yoğun bakımdaki yenidoğan ve bebeklerde sakinleştirmek ve yoksunluk belirtilerini azaltmak için çok küçük dozda verilir.',
    ingredients: [
      Ingredient('Klonidin hidroklorür 0,15 mg tablet', '4 tablet (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (4 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletler havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Tablet tozu selülozla birkaç basamakta eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Karıştırma', 'Karışım küçük havanda spatülle iyice karıştırılıp tek düze yapılır.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 4 numara kapsüle kapsül makinesiyle doldurulur.'),
    ],
    refs: ['toz-wasilewski-klonidin', 'toz-anmf', 'usp-795'],
    shelfLife: '180 gün (tabletin son kullanma tarihini geçmez), oda sıcaklığında, ışıktan korunarak, kuru yerde',
  ),
  Formula(
    name: 'Sodyum klorür kapsülü 500 mg',
    category: FormulaCategory.toz,
    use: 'Kanda sodyumu düşük olan ya da tuz kaybeden hastalarda tuz desteğidir.',
    ingredients: [
      Ingredient('Sodyum klorür', '15 g (30 kapsül için)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Sodyum klorür kristalleri havanda ince toz olana dek ezilir.'),
      FormulaStep('Elekten geçirme', 'Toz elekten geçirilip akışı düzeltilir.'),
      FormulaStep('Kapsül doldurma', 'Her kapsüle 500 mg gelecek biçimde 30 adet 0 numara kapsül doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı ve kuru yerde',
  ),
  Formula(
    name: 'Sodyum bikarbonat kapsülü 500 mg',
    category: FormulaCategory.toz,
    use: 'Böbrek hastalığına bağlı asidozda kanın asitliğini düzeltmek için kullanılır.',
    ingredients: [
      Ingredient('Sodyum bikarbonat', '15 g (30 kapsül için)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Sodyum bikarbonat havanda topaksız ince toz hâline getirilir.'),
      FormulaStep('Elekten geçirme', 'Toz elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 0 numara kapsüle zımbalama yöntemiyle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı ve kuru yerde',
  ),
  Formula(
    name: 'Riboflavin kapsülü 200 mg',
    category: FormulaCategory.toz,
    use: 'Migren önlemede günde iki kapsül alınan B2 vitaminidir.',
    ingredients: [
      Ingredient('Riboflavin', '6 g (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (000 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Riboflavin ışıktan korunarak havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Riboflavin selülozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir, renk tek düze olur.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 000 numara opak kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'allen', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, oda sıcaklığında, ışıktan korunarak, kuru yerde',
  ),
  Formula(
    name: 'Koenzim Q10 kapsülü 100 mg',
    category: FormulaCategory.toz,
    use: 'Mitokondri hastalıklarında ve migren önlemede kullanılan destektir.',
    ingredients: [
      Ingredient('Koenzim Q10 (ubidekarenon)', '3 g (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (1 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Koenzim Q10 havanda ısıtmadan, hafifçe ezilir; düşük erime noktası nedeniyle bastırılmaz.'),
      FormulaStep('Geometrik seyreltme', 'Koenzim Q10 selülozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 1 numara opak kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'allen', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, 25 °C altında, ışıktan korunarak, kuru yerde',
  ),
  Formula(
    name: 'Nikotinamid kapsülü 500 mg',
    category: FormulaCategory.toz,
    use: 'Pellagra tedavisinde ve bazı deri hastalıklarında kullanılan B3 vitaminidir.',
    ingredients: [
      Ingredient('Nikotinamid', '15 g (30 kapsül için)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Nikotinamid kristalleri havanda ince toz hâline getirilir.'),
      FormulaStep('Elekten geçirme', 'Toz elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 000 numara kapsüle zımbalama yöntemiyle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı ve kuru yerde',
  ),
  Formula(
    name: 'Folik asit kapsülü 1 mg',
    category: FormulaCategory.toz,
    use: 'Folat eksikliği anemisinde ve gebelik öncesi destekte kullanılır.',
    ingredients: [
      Ingredient('Folik asit', '30 mg (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (3 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Folik asit havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Folik asit laktozla birkaç basamakta eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 3 numara kapsüle kapsül makinesiyle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, oda sıcaklığında, ışıktan korunarak, kuru yerde',
  ),
  Formula(
    name: 'Kolekalsiferol kapsülü 1000 IU',
    category: FormulaCategory.toz,
    use: 'D vitamini eksikliğini önlemek ve tedavi etmek için günlük alınır.',
    ingredients: [
      Ingredient('Kolekalsiferol kuru tozu (100.000 IU/g)', '300 mg (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (3 numara)'),
    ],
    steps: [
      FormulaStep('Geometrik seyreltme', 'D vitamini tozu ezilmeden selülozla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilip doz eşitlenir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 3 numara opak kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, 25 °C altında, ışıktan korunarak, sıkı kapalı',
  ),
  Formula(
    name: 'Piridoksin kapsülü 50 mg',
    category: FormulaCategory.toz,
    use: 'B6 vitamini eksikliğinde ve izoniazid kullananlarda sinir hasarını önlemede kullanılır.',
    ingredients: [
      Ingredient('Piridoksin hidroklorür', '1,5 g (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (2 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Piridoksin havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Piridoksin laktozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 2 numara kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, oda sıcaklığında, ışıktan korunarak, kuru yerde',
  ),
  Formula(
    name: 'Tiamin kapsülü 100 mg',
    category: FormulaCategory.toz,
    use: 'B1 vitamini eksikliğinde, özellikle alkol kullanımına bağlı eksiklikte kullanılır.',
    ingredients: [
      Ingredient('Tiamin hidroklorür', '3 g (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (2 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tiamin havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Tiamin laktozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 2 numara kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı ve kuru yerde',
  ),
  Formula(
    name: 'Ursodeoksikolik asit kapsülü 150 mg',
    category: FormulaCategory.toz,
    use: 'Kolesterol safra taşını eritmede ve bazı karaciğer hastalıklarında kullanılır.',
    ingredients: [
      Ingredient('Ursodeoksikolik asit', '4,5 g (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (1 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Ursodeoksikolik asit havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Etken madde selülozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 1 numara kapsüle zımbalama yöntemiyle doldurulur.'),
    ],
    refs: ['ijpc', 'martindale', 'toz-allen-ursodiol', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, kuru yerde',
  ),
  Formula(
    name: 'Allopurinol kapsülü 50 mg',
    category: FormulaCategory.toz,
    use: 'Ürik asit yüksekliğinde, düşük doz gereken çocuk ve böbrek hastalarında kullanılır.',
    ingredients: [
      Ingredient('Allopurinol 100 mg tablet', '15 tablet (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (2 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletler havanda kaplama ve topak kalmayana dek ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Tablet tozu laktozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 2 numara kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnfc', 'usp-795', 'toz-allen-2016'],
    shelfLife: '180 gün ya da tabletin son kullanma tarihi (hangisi önceyse), oda sıcaklığında, kuru yerde',
  ),
  Formula(
    name: 'Nifedipin kapsülü 1 mg',
    category: FormulaCategory.toz,
    use: 'Bebek ve çocuklarda yüksek tansiyonu düşürmek için düşük dozda verilen damar genişletici ilaçtır.',
    ingredients: [
      Ingredient('Nifedipin', '30 mg (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (3 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Nifedipin loş ışıkta havanda ince toz hâline getirilir; gün ışığında hızla bozunur.'),
      FormulaStep('Geometrik seyreltme', 'Etken madde laktozla birkaç basamakta eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Karıştırma', 'Karışım birkaç dakika karıştırılıp tek düze yapılır.'),
      FormulaStep('Kapsül doldurma', 'Toz loş ışıkta 30 adet 3 numara opak kapsüle doldurulur.'),
    ],
    refs: ['toz-helin-tanninen-nifedipin', 'toz-anmf', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, ışıktan korunarak (karanlık torbada), kuru yerde',
  ),
  Formula(
    name: 'Hidroklorotiyazid kapsülü 5 mg',
    category: FormulaCategory.toz,
    use: 'Çocuklarda ödem ve yüksek tansiyonda düşük doz idrar söktürücü olarak kullanılır.',
    ingredients: [
      Ingredient('Hidroklorotiyazid', '150 mg (30 kapsül için)'),
      Ingredient('Mannitol', 'ad 30 kapsül (3 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Hidroklorotiyazid havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Etken madde mannitolle birkaç basamakta eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 3 numara kapsüle kapsül makinesiyle doldurulur.'),
    ],
    refs: ['nrf', 'martindale', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, kuru ve ışıksız',
  ),
  Formula(
    name: 'Furosemid kapsülü 6 mg',
    category: FormulaCategory.toz,
    use: 'Çocuklarda ödem ve kalp yetmezliğinde düşük doz idrar söktürücü olarak kullanılır.',
    ingredients: [
      Ingredient('Furosemid', '180 mg (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (3 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Furosemid ışıktan korunarak havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Etken madde laktozla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 3 numara opak kapsüle doldurulur.'),
    ],
    refs: ['fna', 'martindale', 'toz-bnfc', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, ışıktan korunarak, kuru yerde',
  ),
  Formula(
    name: 'Kalsiyum karbonat kapsülü 500 mg',
    category: FormulaCategory.toz,
    use: 'Kalsiyum desteği olarak ya da yemekle alınan fosfat bağlayıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Ağır kalsiyum karbonat', '15 g (30 kapsül için)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kalsiyum karbonat havanda topaksız toz hâline getirilir.'),
      FormulaStep('Elekten geçirme', 'Toz elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 00 numara kapsüle zımbalama yöntemiyle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı, kuru ve ışıksız',
  ),
  Formula(
    name: 'Magnezyum oksit kapsülü 250 mg',
    category: FormulaCategory.toz,
    use: 'Magnezyum eksikliğinde ve kabızlıkta kullanılan magnezyum desteğidir.',
    ingredients: [
      Ingredient('Ağır magnezyum oksit', '7,5 g (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (00 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Magnezyum oksit havanda topaksız toz hâline getirilir.'),
      FormulaStep('Karıştırma', 'Magnezyum oksit ve selüloz havanda birlikte karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 00 numara kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (nem ve karbondioksit çeker)',
  ),
  Formula(
    name: 'Çinko sülfat kapsülü 220 mg',
    category: FormulaCategory.toz,
    use: 'Çinko eksikliğinde ve yara iyileşmesini desteklemek için kullanılır.',
    ingredients: [
      Ingredient('Çinko sülfat heptahidrat', '6,6 g (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (1 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Çinko sülfat kristalleri havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Çinko sülfat laktozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 1 numara kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı',
  ),
  Formula(
    name: 'Askorbik asit kapsülü 500 mg',
    category: FormulaCategory.toz,
    use: 'C vitamini eksikliğinde (iskorbüt) ve demir emilimini artırmak için kullanılır.',
    ingredients: [
      Ingredient('Askorbik asit', '15 g (30 kapsül için)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Askorbik asit kristalleri havanda ince toz hâline getirilir; metal spatülden kaçınılır.'),
      FormulaStep('Elekten geçirme', 'Toz elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 00 numara kapsüle zımbalama yöntemiyle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'toz-yeow-2011', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı, kuru ve ışıksız',
  ),
  Formula(
    name: 'Plasebo kapsülü',
    category: FormulaCategory.toz,
    use: 'Klinik çalışmalarda ve kör denemelerde etken madde içermeyen karşılaştırma kapsülüdür.',
    ingredients: [
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (1 numara)'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Laktoz elekten geçirilip topakları dağıtılır.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 1 numara kapsüle etkin kapsüllerle aynı görünüşte doldurulur.'),
    ],
    refs: ['allen', 'fna', 'toz-klinger-2021', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı, kuru ve ışıksız',
  ),
  Formula(
    name: 'Parasetamol kapsülü 250 mg',
    category: FormulaCategory.toz,
    use: 'Ara doz gereken hastalarda ağrı ve ateş için kullanılır.',
    ingredients: [
      Ingredient('Parasetamol', '7,5 g (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (00 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Parasetamol havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Parasetamol selülozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 00 numara kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnfc', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı, kuru ve ışıksız',
  ),
  Formula(
    name: 'Ursodeoksikolik asit kapsülü 250 mg',
    category: FormulaCategory.toz,
    use: 'Safra akışı bozukluğunda ve bazı kronik karaciğer hastalıklarında yetişkin dozla kullanılır.',
    ingredients: [
      Ingredient('Ursodeoksikolik asit', '7,5 g (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (0 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Ursodeoksikolik asit havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Etken madde selülozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 0 numara kapsüle zımbalama yöntemiyle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı, kuru ve ışıksız',
  ),
  Formula(
    name: 'Riboflavin kapsülü 50 mg',
    category: FormulaCategory.toz,
    use: 'Riboflavine yanıt veren kalıtsal metabolizma hastalıklarında çocuklara verilen B2 vitaminidir.',
    ingredients: [
      Ingredient('Riboflavin', '1,5 g (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (2 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Riboflavin ışıktan korunarak havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Riboflavin laktozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir, renk tek düze olur.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 2 numara opak kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnfc', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, ışıksız ve kuru',
  ),
  Formula(
    name: 'Kurutulmuş demir(II) sülfat kapsülü 200 mg',
    category: FormulaCategory.toz,
    use: 'Demir eksikliği anemisinin önlenmesi ve tedavisinde kullanılan demir desteğidir.',
    ingredients: [
      Ingredient('Kurutulmuş demir(II) sülfat', '6 g (30 kapsül için)'),
      Ingredient('Laktoz monohidrat', 'ad 30 kapsül (1 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kurutulmuş demir sülfat havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Demir sülfat laktozla eşit parçalar hâlinde karıştırılır.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 1 numara kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnf', 'who-mf', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı ve kuru (nemde oksitlenir)',
  ),
  Formula(
    name: 'Biotin kapsülü 10 mg',
    category: FormulaCategory.toz,
    use: 'Biotinidaz eksikliği gibi kalıtsal metabolizma hastalıklarında kullanılan vitamin desteğidir.',
    ingredients: [
      Ingredient('Biotin', '300 mg (30 kapsül için)'),
      Ingredient('Mikrokristalin selüloz', 'ad 30 kapsül (3 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Biotin havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Biotin selülozla eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 3 numara kapsüle doldurulur.'),
    ],
    refs: ['martindale', 'toz-bnfc', 'toz-klinger-2021', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı, kuru ve ışıksız',
  ),
  Formula(
    name: 'Baklofen kapsülü 2,5 mg',
    category: FormulaCategory.toz,
    use: 'Çocuklarda kas sertliğini (spastisite) azaltmak için düşük dozda verilen kas gevşeticidir.',
    ingredients: [
      Ingredient('Baklofen', '75 mg (30 kapsül için)'),
      Ingredient('Laktoz monohidrat (%0,5 kolloidal silisyum dioksitli)', 'ad 30 kapsül (1 numara)'),
    ],
    steps: [
      FormulaStep('Ezme', 'Baklofen havanda ince toz hâline getirilir.'),
      FormulaStep('Geometrik seyreltme', 'Etken madde laktozla birkaç basamakta eşit parçalar hâlinde seyreltilir.'),
      FormulaStep('Elekten geçirme', 'Karışım elekten geçirilir.'),
      FormulaStep('Kapsül doldurma', 'Toz 30 adet 1 numara kapsüle doldurulur.'),
    ],
    refs: ['toz-klinger-2021', 'toz-bnfc', 'usp-795'],
    shelfLife: '180 gün, oda sıcaklığında, kuru ve ışıksız',
  ),
];
