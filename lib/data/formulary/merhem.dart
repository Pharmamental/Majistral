import '../../models/formula.dart';
import '../../models/prescription.dart';
import '../references.dart';

// Formüller resmî monograflardan (USP–NF, BP, DAB, DAC/NRF) ve kaynak listesindeki kitap ve kılavuzlardan alındı.
const merhemRefs = <Reference>[
  Reference(
    id: 'merhem-dab',
    kind: ReferenceKind.farmakope,
    citation: 'Deutsches Arzneibuch (DAB), resmî preparat monografları (Wollwachsalkoholsalbe, Hydrophile Salbe, '
        'Zinksalbe, Weiche Zinkpaste). Deutscher Apotheker Verlag, Stuttgart; Govi-Verlag, Eschborn.',
    url: 'https://www.bfarm.de',
  ),
  Reference(
    id: 'merhem-bnf',
    kind: ReferenceKind.farmakope,
    citation: 'British National Formulary (BNF): Emollients ve Skin bölümleri. BMJ Group ve Pharmaceutical Press, '
        'Londra (NICE aracılığıyla).',
    url: 'https://bnf.nice.org.uk',
  ),
  Reference(
    id: 'merhem-dmd',
    kind: ReferenceKind.devlet,
    citation: 'Dictionary of Medicines and Devices (dm+d): majistral (special order) merhem kayıtları. NHS Business '
        'Services Authority, Birleşik Krallık.',
    url: 'https://dmd-browser.nhsbsa.nhs.uk',
  ),
  Reference(
    id: 'merhem-cdc',
    kind: ReferenceKind.devlet,
    citation: 'Centers for Disease Control and Prevention (CDC). Scabies: Clinical Care / Treatment (çökeltilmiş '
        'kükürt %5–10 vazelinde). Atlanta, ABD.',
    url: 'https://www.cdc.gov/scabies/hcp/clinical-care/index.html',
  ),
  Reference(
    id: 'merhem-south-farber',
    kind: ReferenceKind.makale,
    citation: 'South DA, Farber EM. Urea ointment in the nonsurgical avulsion of nail dystrophies – a reappraisal. '
        'Cutis. 1980;25(6):609–612.',
  ),
  Reference(
    id: 'merhem-altmeyer',
    kind: ReferenceKind.kitap,
    citation: 'Altmeyer P, Bacharach-Buhles M. Altmeyers Enzyklopädie – Dermatologie, Allergologie, Umweltmedizin: '
        'Rezepturen (DAB, DAC/NRF). Çevrimiçi başvuru eseri.',
    url: 'https://www.altmeyers.org',
  ),
  Reference(
    id: 'merhem-pz',
    kind: ReferenceKind.makale,
    citation: 'Pharmazeutische Zeitung: NRF güncellemeleri (2000) ve "Menthol in Nasen- und Hustensalben" reçete '
        'makaleleri. Avoxa – Mediengruppe Deutscher Apotheker, Eschborn.',
    url: 'https://www.pharmazeutische-zeitung.de',
  ),
];

const merhemFormulas = <Formula>[
  // ---------------------------------------------------------------- Bazlar
  Formula(
    name: 'Beyaz merhem (USP)',
    category: FormulaCategory.merhem,
    use: 'İlaç katılacak sade, yağlı hidrokarbon merhem bazıdır; cildi örter ve nem kaybını azaltır.',
    ingredients: [
      Ingredient('Beyaz balmumu', '5 g'),
      Ingredient('Beyaz vazelin', '95 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Balmumu su banyosunda eritilir, vazelin eklenip birlikte tamamen sıvılaştırılır.'),
      FormulaStep('Soğutma', 'Banyodan alınır, katılaşıp donmaya başlayana kadar sürekli karıştırılır.'),
    ],
    refs: ['usp-nf', 'ansel', 'remington'],
  ),
  Formula(
    name: 'Sarı merhem (USP)',
    category: FormulaCategory.merhem,
    use: 'Beyaz merhemin ağartılmamış eşidir; renk önemli olmayan yağlı preparatlarda baz olarak kullanılır.',
    ingredients: [
      Ingredient('Sarı balmumu', '5 g'),
      Ingredient('Sarı vazelin', '95 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Sarı balmumu su banyosunda eritilir, sarı vazelin eklenip birlikte sıvılaştırılır.'),
      FormulaStep('Soğutma', 'Karışım banyodan alınır, donana kadar karıştırılarak soğutulur.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Hidrofil vazelin (USP)',
    category: FormulaCategory.merhem,
    use: 'Su ya da sulu çözelti çekebilen susuz absorpsiyon bazıdır; sulu maddeleri yağlı merheme katmaya yarar.',
    ingredients: [
      Ingredient('Kolesterol', '3 g'),
      Ingredient('Stearil alkol', '3 g'),
      Ingredient('Beyaz balmumu', '8 g'),
      Ingredient('Beyaz vazelin', '86 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Stearil alkol, balmumu ve vazelin su banyosunda birlikte eritilir.'),
      FormulaStep('Çözme', 'Kolesterol sıcak eriyiğe eklenir, tamamen çözünene kadar karıştırılır.'),
      FormulaStep('Soğutma', 'Banyodan alınır, katılaşana kadar karıştırmaya devam edilir.'),
    ],
    refs: ['usp-nf', 'ansel'],
  ),
  Formula(
    name: 'Basit merhem (BP, beyaz)',
    category: FormulaCategory.merhem,
    use: 'Yün yağı içeren yumuşak bir yağlı bazdır; beyaz renkli merhemlerde taşıyıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Yün yağı (lanolin)', '5 g'),
      Ingredient('Sert parafin', '5 g'),
      Ingredient('Setostearil alkol', '5 g'),
      Ingredient('Beyaz vazelin', '85 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Sert parafin ve setostearil alkol önce eritilir, sonra yün yağı ve vazelin eklenir.'),
      FormulaStep('Soğutma', 'Eriyik banyodan alınır, soğuyup katılaşana kadar karıştırılır.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Basit merhem (BP, sarı)',
    category: FormulaCategory.merhem,
    use: 'Basit merhemin sarı vazelinle yapılan eşidir; renkli ya da koyu preparatlarda baz olur.',
    ingredients: [
      Ingredient('Yün yağı (lanolin)', '5 g'),
      Ingredient('Sert parafin', '5 g'),
      Ingredient('Setostearil alkol', '5 g'),
      Ingredient('Sarı vazelin', '85 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'En yüksek erime noktalı sert parafinden başlanarak bütün maddeler eritilir.'),
      FormulaStep('Soğutma', 'Karışım donana kadar karıştırılarak soğutulur.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Emülsiyon yapıcı merhem (BP)',
    category: FormulaCategory.merhem,
    use: 'Kuru ciltte yumuşatıcı ve sabun yerine kullanılır; suyla yıkanabilen ilaç bazıdır.',
    ingredients: [
      Ingredient('Emülsiyon yapıcı mum', '30 g'),
      Ingredient('Beyaz vazelin', '50 g'),
      Ingredient('Sıvı parafin', '20 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Emülsiyon yapıcı mum, vazelin ve sıvı parafin su banyosunda birlikte eritilir.'),
      FormulaStep('Soğutma', 'Eriyik katılaşana kadar sürekli karıştırılır.'),
    ],
    refs: ['bp', 'aulton', 'merhem-bnf'],
  ),
  Formula(
    name: 'Setomakrogol emülsiyon yapıcı merhem (BP)',
    category: FormulaCategory.merhem,
    use: 'İyonik olmayan emülgatörlü, suyla yıkanabilen bazdır; anyonik bazla geçimsiz ilaçlar için seçilir.',
    ingredients: [
      Ingredient('Setomakrogol emülsiyon yapıcı mum', '30 g'),
      Ingredient('Sıvı parafin', '20 g'),
      Ingredient('Beyaz vazelin', '50 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Üç madde su banyosunda birlikte eritilir.'),
      FormulaStep('Soğutma', 'Banyodan alınan eriyik donana kadar karıştırılır.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Yün alkolleri merhemi (BP)',
    category: FormulaCategory.merhem,
    use: 'Su tutabilen, su içinde yağ tipi krem hazırlamaya da yarayan yumuşatıcı bir absorpsiyon bazıdır.',
    ingredients: [
      Ingredient('Yün alkolleri', '6 g'),
      Ingredient('Sert parafin', '24 g'),
      Ingredient('Beyaz vazelin', '10 g'),
      Ingredient('Sıvı parafin', '60 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Sert parafin, vazelin ve sıvı parafin eritilir, yün alkolleri eriyikte dağıtılır.'),
      FormulaStep('Soğutma', 'Karışım soğuyup koyulaşana kadar karıştırılır.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Yün yağı alkolleri merhemi (DAB)',
    category: FormulaCategory.merhem,
    use: 'Alman farmakopesinin su çekebilen yağlı bazıdır; birçok majistral merhem ve kremin temelidir.',
    ingredients: [
      Ingredient('Yün yağı alkolleri', '6 g'),
      Ingredient('Setostearil alkol', '0,5 g'),
      Ingredient('Beyaz vazelin', '93,5 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Yün yağı alkolleri ve setostearil alkol vazelinle birlikte su banyosunda eritilir.'),
      FormulaStep('Soğutma', 'Eriyik banyodan alınır, homojen ve katı olana kadar karıştırılır.'),
    ],
    refs: ['merhem-dab', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Hidrofil merhem (DAB)',
    category: FormulaCategory.merhem,
    use: 'Suyla yıkanabilen susuz bazdır; su eklenince yağ içinde su değil, su içinde yağ kremi verir.',
    ingredients: [
      Ingredient('Emülsiyon yapıcı setostearil alkol', '30 g'),
      Ingredient('Sıvı parafin', '35 g'),
      Ingredient('Beyaz vazelin', '35 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Emülsiyon yapıcı setostearil alkol, sıvı parafin ve vazelin birlikte eritilir.'),
      FormulaStep('Soğutma', 'Eriyik katılaşana kadar karıştırılarak soğutulur.'),
    ],
    refs: ['merhem-dab', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Polietilen glikol merhemi (USP)',
    category: FormulaCategory.merhem,
    use: 'Yağ içermeyen, suda çözünen ve kolay yıkanan bazdır; suda çözünen ilaçlar için uygundur.',
    ingredients: [
      Ingredient('Polietilen glikol 3350', '40 g'),
      Ingredient('Polietilen glikol 400', '60 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'PEG 3350 yaklaşık 65 °C\'de su banyosunda eritilir.'),
      FormulaStep('Karıştırma', 'Sıvı PEG 400 eriyiğe eklenir ve iyice karıştırılır.'),
      FormulaStep('Soğutma', 'Karışım banyodan alınır, donana kadar karıştırılır.'),
    ],
    refs: ['usp-nf', 'ansel'],
  ),
  Formula(
    name: 'Su alabilen polietilen glikol merhemi (USP)',
    category: FormulaCategory.merhem,
    use: 'İçine %6–25 sulu çözelti katılacak PEG merhemi için daha sert, su tutan bazdır.',
    ingredients: [
      Ingredient('Polietilen glikol 3350', '35 g'),
      Ingredient('Stearil alkol', '5 g'),
      Ingredient('Polietilen glikol 400', '60 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'PEG 3350 ve stearil alkol su banyosunda birlikte eritilir.'),
      FormulaStep('Karıştırma', 'PEG 400 eriyiğe katılıp karışım homojen olana kadar karıştırılır.'),
      FormulaStep('Soğutma', 'Banyodan alınır, katılaşana kadar karıştırmaya devam edilir.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Makrogol merhemi (DAC)',
    category: FormulaCategory.merhem,
    use: 'Yağsız, suda çözünen bir bazdır; yağlı merhemin istenmediği yerlerde etkin maddeyi taşır.',
    ingredients: [
      Ingredient('Makrogol 300', '50 g'),
      Ingredient('Makrogol 1500', '50 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Makrogol 1500 su banyosunda eritilir, makrogol 300 eklenir.'),
      FormulaStep('Soğutma', 'Karışım banyodan alınır, donana kadar karıştırılır.'),
    ],
    refs: ['nrf', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Parafin merhemi (BP)',
    category: FormulaCategory.merhem,
    use: 'Sıcak iklimde de kıvamını koruyan, sertleştirilmiş yağlı bir merhem bazıdır.',
    ingredients: [
      Ingredient('Beyaz balmumu', '2 g'),
      Ingredient('Sert parafin', '3 g'),
      Ingredient('Setostearil alkol', '5 g'),
      Ingredient('Beyaz vazelin', '90 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Balmumu, sert parafin ve setostearil alkol eritilir, ardından vazelin eklenir.'),
      FormulaStep('Soğutma', 'Eriyik banyodan alınır, katılaşana kadar karıştırılır.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Sıvı parafin ve beyaz vazelin merhemi (50/50)',
    category: FormulaCategory.merhem,
    use: 'Çok kuru, pullanan ciltte bol sürülen yumuşak bir yumuşatıcıdır.',
    ingredients: [
      Ingredient('Sıvı parafin', '50 g'),
      Ingredient('Beyaz vazelin', '50 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Vazelin su banyosunda hafifçe eritilir.'),
      FormulaStep('Karıştırma', 'Sıvı parafin eriyiğe eklenir ve iyice karıştırılır.'),
      FormulaStep('Soğutma', 'Karışım ayrışmasın diye donana kadar karıştırılarak soğutulur.'),
    ],
    refs: ['merhem-bnf', 'martindale'],
  ),
  Formula(
    name: 'Hidrofobik baz jel (DAC)',
    category: FormulaCategory.merhem,
    use: 'Sıcaklıkla kıvamı az değişen, polietilenle jelleşmiş saydam bir hidrokarbon bazıdır.',
    ingredients: [
      Ingredient('Polietilen', '5 g'),
      Ingredient('Sıvı parafin', '95 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Polietilen sıvı parafin içinde yüksek ısıda tamamen eritilir.'),
      FormulaStep('Soğutma', 'Sıcak karışım hızla soğutulur; böylece polietilen ağ kurar ve jel oluşur.'),
    ],
    refs: ['nrf', 'ansel', 'merhem-altmeyer'],
  ),
  // ----------------------------------------------------- Çinko oksitli olanlar
  Formula(
    name: 'Yara merhemi (çinko oksit %20, NRF)',
    category: FormulaCategory.merhem,
    use: 'Tahriş olmuş, pişik ve sürtünmeye uğramış cildi kalın bir tabakayla örter ve korur.',
    ingredients: [
      Ingredient('Çinko oksit', '20 g'),
      Ingredient('Buğday nişastası', '10 g'),
      Ingredient('Orta zincirli trigliseritler', '10 g'),
      Ingredient('Oleik asit', '0,1 g'),
      Ingredient('Yün yağı (lanolin)', '30 g'),
      Ingredient('Beyaz vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit ve nişasta topaklarını dağıtmak için birlikte elenir.'),
      FormulaStep('Eritme', 'Yün yağı ve vazelin hafif ısıyla yumuşatılıp birleştirilir.'),
      FormulaStep('Soğutma', 'Baz oda sıcaklığına inene kadar karıştırılır.'),
      FormulaStep('Levigasyon', 'Tozlar trigliserit ve oleik asitle havanda pürüzsüz bir hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Hamur eşit miktarlarda baz eklenerek kademeli olarak inceltilir.'),
    ],
    refs: ['nrf', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Çinko oksit merhemi %20 (USP)',
    category: FormulaCategory.merhem,
    use: 'Pişik ve hafif tahrişte cildi koruyan, hafif büzücü bir merhemdir.',
    ingredients: [
      Ingredient('Çinko oksit', '20 g'),
      Ingredient('Sıvı parafin', '15 g'),
      Ingredient('Beyaz merhem', '65 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit ince elekten geçirilerek topakları açılır.'),
      FormulaStep('Levigasyon', 'Toz, sıvı parafinle havanda pürüzsüz bir hamur olana kadar ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Beyaz merhem hamura eşit parçalar hâlinde katılarak karıştırılır.'),
    ],
    refs: ['usp-nf', 'ansel', 'remington'],
  ),
  Formula(
    name: 'Çinko merhemi %15 (BP)',
    category: FormulaCategory.merhem,
    use: 'Pişik ve hafif cilt tahrişinde koruyucu ve hafif büzücü olarak sürülür.',
    ingredients: [
      Ingredient('Çinko oksit', '15 g'),
      Ingredient('Basit merhem', '85 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit elenerek ince ve topaksız hâle getirilir.'),
      FormulaStep('Levigasyon', 'Toz, basit merhemin küçük bir kısmıyla merhem taşında pürüzsüzce ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan basit merhem kademeli olarak katılır.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Çinko merhemi %10 (DAB)',
    category: FormulaCategory.merhem,
    use: 'Su çekebilen yün yağı alkolü bazında, nemli ve tahrişli ciltte koruyucu çinko merhemidir.',
    ingredients: [
      Ingredient('Çinko oksit', '10 g'),
      Ingredient('Yün yağı alkolleri merhemi', '90 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit ince elekten geçirilir.'),
      FormulaStep('Levigasyon', 'Toz bazın küçük bir kısmıyla havanda ezilerek pürüzsüz hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Kalan baz eşit parçalar hâlinde eklenip karıştırılır.'),
    ],
    refs: ['merhem-dab', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Çinko oksit patı %25 (USP)',
    category: FormulaCategory.merhem,
    use: 'Sert, kalın tabaka bırakan koruyucu pattır; ıslak ve sızıntılı lezyonlarda salgıyı emer.',
    ingredients: [
      Ingredient('Çinko oksit', '25 g'),
      Ingredient('Nişasta', '25 g'),
      Ingredient('Beyaz vazelin', '50 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit ve nişasta birlikte elenerek karıştırılır.'),
      FormulaStep('Levigasyon', 'Toz karışımı vazelinin bir kısmıyla merhem taşında ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan vazelin kademeli olarak eklenir; çok toz olduğu için sıkı ezilir.'),
    ],
    refs: ['usp-nf', 'ansel', 'bp'],
  ),
  Formula(
    name: 'Yumuşak çinko patı %30 (DAB)',
    category: FormulaCategory.merhem,
    use: 'Çinko patından daha kolay sürülen yumuşak pattır; pişik ve hassas ciltte örtücü olarak kullanılır.',
    ingredients: [
      Ingredient('Çinko oksit', '30 g'),
      Ingredient('Sıvı parafin (koyu)', '40 g'),
      Ingredient('Beyaz vazelin', '20 g'),
      Ingredient('Beyaz balmumu', '10 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit ince elekten geçirilir.'),
      FormulaStep('Eritme', 'Balmumu, vazelin ve sıvı parafin su banyosunda birlikte eritilir.'),
      FormulaStep('Soğutma', 'Baz katılaşana kadar karıştırılarak soğutulur.'),
      FormulaStep('Levigasyon', 'Çinko oksit bazın bir kısmıyla havanda pürüzsüzce ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan baz eşit parçalar hâlinde katılarak pat tamamlanır.'),
    ],
    refs: ['merhem-dab', 'nrf', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Lipofil çinko oksit patı %30 (NRF)',
    category: FormulaCategory.merhem,
    use: 'Nişastasız, yağlı çinko patıdır; kuruyan ve tahriş olan cildi korur.',
    ingredients: [
      Ingredient('Çinko oksit', '30 g'),
      Ingredient('Sarı vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit topaksız olsun diye elenir.'),
      FormulaStep('Levigasyon', 'Toz, vazelinin küçük bir kısmıyla merhem taşında ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan vazelin kademeli olarak eklenip karıştırılır.'),
    ],
    refs: ['nrf', 'merhem-pz'],
  ),
  Formula(
    name: 'Lassar patı (çinko oksit ve salisilik asit patı)',
    category: FormulaCategory.merhem,
    use: 'Sedef ve kronik kalınlaşmış lezyonlarda örtücü ve hafif keratolitik pattır.',
    ingredients: [
      Ingredient('Çinko oksit', '24 g'),
      Ingredient('Salisilik asit', '2 g'),
      Ingredient('Nişasta', '24 g'),
      Ingredient('Beyaz vazelin', '50 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit kristalleri porselen havanda ince toz olana kadar ezilir.'),
      FormulaStep('Elekten geçirme', 'Salisilik asit, çinko oksit ve nişasta birlikte elenerek karıştırılır.'),
      FormulaStep('Eritme', 'Vazelin su banyosunda eritilir.'),
      FormulaStep('Karıştırma', 'Toz karışımı eriyiğe azar azar katılır ve dağıtılır.'),
      FormulaStep('Soğutma', 'Tozlar çökmesin diye pat donana kadar karıştırılır.'),
    ],
    refs: ['bp', 'usp-nf', 'martindale'],
  ),
  Formula(
    name: 'Çinko ve hint yağı merhemi (BP)',
    category: FormulaCategory.merhem,
    use: 'Bebek bezi bölgesinde cildi idrar ve nemden koruyan yumuşak bir merhemdir.',
    ingredients: [
      Ingredient('Çinko oksit', '7,5 g'),
      Ingredient('Hint yağı', '50 g'),
      Ingredient('Yer fıstığı yağı', '30,5 g'),
      Ingredient('Setostearil alkol', '2 g'),
      Ingredient('Beyaz balmumu', '10 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit ince elekten geçirilir.'),
      FormulaStep('Eritme', 'Balmumu ve setostearil alkol yağlarla birlikte su banyosunda eritilir.'),
      FormulaStep('Levigasyon', 'Çinko oksit eriyiğin bir kısmıyla havanda pürüzsüzce ezilir.'),
      FormulaStep('Karıştırma', 'Hamur kalan eriyiğe katılarak dağıtılır.'),
      FormulaStep('Soğutma', 'Toz çökmesin diye merhem donana kadar karıştırılır.'),
    ],
    refs: ['bp', 'merhem-bnf'],
  ),
  Formula(
    name: 'Kalamin merhemi %15 (BP)',
    category: FormulaCategory.merhem,
    use: 'Kaşıntılı ve hafif tahrişli ciltte yatıştırıcı ve koruyucu olarak sürülür.',
    ingredients: [
      Ingredient('Kalamin', '15 g'),
      Ingredient('Beyaz vazelin', '85 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Kalamin tozu topakları dağılsın diye elenir.'),
      FormulaStep('Levigasyon', 'Kalamin, vazelinin küçük bir kısmıyla merhem taşında ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan vazelin eşit parçalar hâlinde katılarak karıştırılır.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  // ------------------------------------------------- Salisilik asit ve kükürt
  Formula(
    name: 'Salisilik asit merhemi %2 (BP)',
    category: FormulaCategory.merhem,
    use: 'Pullanan ve kalınlaşmış ciltte hafif keratolitik olarak kullanılır.',
    ingredients: [
      Ingredient('Salisilik asit', '2 g'),
      Ingredient('Yün alkolleri merhemi', '98 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit porselen havanda ince toz olana kadar ezilir.'),
      FormulaStep('Elekten geçirme', 'Ezilen toz ince elekten geçirilir.'),
      FormulaStep('Eritme', 'Yün alkolleri merhemi su banyosunda eritilir.'),
      FormulaStep('Karıştırma', 'Salisilik asit eriyiğe katılıp dağıtılır.'),
      FormulaStep('Soğutma', 'Merhem donana kadar karıştırılarak soğutulur.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Salisilik asitli vazelin %5',
    category: FormulaCategory.merhem,
    use: 'Kalın pullu sedef ve nasırlı ciltte pulları yumuşatıp kaldırmak için kullanılır.',
    ingredients: [
      Ingredient('Salisilik asit', '5 g'),
      Ingredient('Sıvı parafin', '3 g'),
      Ingredient('Beyaz vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit porselen havanda ince toz olana kadar ezilir; metal spatül kullanılmaz.'),
      FormulaStep('Levigasyon', 'Toz sıvı parafinle pürüzsüz bir hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Vazelin hamura eşit parçalar hâlinde eklenerek karıştırılır.'),
    ],
    refs: ['fn-es', 'nrf', 'merhem-altmeyer', 'martindale'],
  ),
  Formula(
    name: 'Salisilik asitli vazelin %10',
    category: FormulaCategory.merhem,
    use: 'Çok kalın, inatçı pullanma ve nasırlarda daha güçlü keratolitik olarak kullanılır.',
    ingredients: [
      Ingredient('Salisilik asit', '10 g'),
      Ingredient('Sıvı parafin', '10 g'),
      Ingredient('Beyaz vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit porselen havanda ince toz olana kadar ezilir.'),
      FormulaStep('Levigasyon', 'Toz sıvı parafinle ezilerek topaksız bir hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Vazelin kademeli olarak katılır; plastik ya da porselen spatül kullanılır.'),
    ],
    refs: ['nrf', 'merhem-altmeyer', 'martindale'],
  ),
  Formula(
    name: 'Salisilik asit %3 ve kükürt %3 merhemi',
    category: FormulaCategory.merhem,
    use: 'Seboreik dermatit ve kepekli, pullu saçlı deride keratolitik ve antiseptik olarak kullanılır.',
    ingredients: [
      Ingredient('Salisilik asit', '3 g'),
      Ingredient('Çökeltilmiş kükürt', '3 g'),
      Ingredient('Sarı vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit porselen havanda ince toz olana kadar ezilir.'),
      FormulaStep('Elekten geçirme', 'Salisilik asit ve kükürt birlikte elenerek karıştırılır.'),
      FormulaStep('Levigasyon', 'Toz karışımı vazelinin küçük bir kısmıyla pürüzsüzce ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan vazelin eşit parçalar hâlinde katılır.'),
    ],
    refs: ['merhem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Salisilik asit %2 ve kükürt %2, emülsiyon yapıcı merhemde',
    category: FormulaCategory.merhem,
    use: 'Akne ve seboreik dermatitte suyla kolay yıkanan hafif keratolitik merhemdir.',
    ingredients: [
      Ingredient('Salisilik asit', '2 g'),
      Ingredient('Çökeltilmiş kükürt', '2 g'),
      Ingredient('Emülsiyon yapıcı merhem', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit porselen havanda ezilerek ince toz yapılır.'),
      FormulaStep('Elekten geçirme', 'Salisilik asit ve kükürt birlikte elenir.'),
      FormulaStep('Levigasyon', 'Tozlar bazın küçük bir kısmıyla merhem taşında ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan baz kademeli olarak eklenip karıştırılır.'),
    ],
    refs: ['merhem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Kükürt merhemi %10 (USP)',
    category: FormulaCategory.merhem,
    use: 'Uyuz ve seboreik dermatitte antiparaziter ve keratolitik olarak kullanılır.',
    ingredients: [
      Ingredient('Çökeltilmiş kükürt', '10 g'),
      Ingredient('Sıvı parafin', '10 g'),
      Ingredient('Beyaz merhem', '80 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Kükürt topakları açılsın diye ince elekten geçirilir.'),
      FormulaStep('Levigasyon', 'Kükürt sıvı parafinle havanda pürüzsüz bir hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Beyaz merhem eşit parçalar hâlinde katılarak karıştırılır.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Kükürtlü vazelin %6',
    category: FormulaCategory.merhem,
    use: 'Bebekte ve gebede uyuz tedavisinde güvenli bir seçenek olarak geceleri sürülür.',
    ingredients: [
      Ingredient('Çökeltilmiş kükürt', '6 g'),
      Ingredient('Beyaz vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Kükürt ince elekten geçirilir.'),
      FormulaStep('Levigasyon', 'Kükürt az miktar vazelinle merhem taşında pürüzsüzce ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan vazelin kademeli olarak katılır.'),
    ],
    refs: ['merhem-cdc', 'martindale'],
  ),
  Formula(
    name: 'Kükürtlü vazelin %10',
    category: FormulaCategory.merhem,
    use: 'Yetişkinde uyuz tedavisinde art arda birkaç gece sürülen kükürtlü merhemdir.',
    ingredients: [
      Ingredient('Çökeltilmiş kükürt', '10 g'),
      Ingredient('Beyaz vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Kükürt elenerek topaksız hâle getirilir.'),
      FormulaStep('Levigasyon', 'Kükürt vazelinin küçük bir kısmıyla ezilerek hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Kalan vazelin eşit parçalar hâlinde eklenir.'),
    ],
    refs: ['merhem-cdc', 'martindale'],
  ),
  // ------------------------------------------------------------ Mantar ilaçları
  Formula(
    name: 'Whitfield merhemi (bileşik benzoik asit merhemi, USP)',
    category: FormulaCategory.merhem,
    use: 'Ayak mantarı gibi yüzeysel mantar enfeksiyonlarında antifungal ve keratolitik olarak kullanılır.',
    ingredients: [
      Ingredient('Benzoik asit', '6 g'),
      Ingredient('Salisilik asit', '3 g'),
      Ingredient('Polietilen glikol merhemi', '91 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Benzoik asit ve salisilik asit porselen havanda birlikte ince toz yapılır.'),
      FormulaStep('Levigasyon', 'Toz karışımı PEG merheminin bir kısmıyla pürüzsüzce ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan PEG merhemi kademeli olarak katılır.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Whitfield merhemi (bileşik benzoik asit merhemi, BP)',
    category: FormulaCategory.merhem,
    use: 'Yüzeysel mantar enfeksiyonlarında kullanılan, emülsiyon yapıcı bazda Whitfield merhemidir.',
    ingredients: [
      Ingredient('Benzoik asit', '6 g'),
      Ingredient('Salisilik asit', '3 g'),
      Ingredient('Emülsiyon yapıcı merhem', '91 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'İki asit porselen havanda ince toz olana kadar ezilir.'),
      FormulaStep('Elekten geçirme', 'Toz karışımı ince elekten geçirilir.'),
      FormulaStep('Eritme', 'Emülsiyon yapıcı merhem su banyosunda eritilir.'),
      FormulaStep('Karıştırma', 'Asitler eriyiğe katılıp dağıtılır.'),
      FormulaStep('Soğutma', 'Merhem donana kadar karıştırılarak soğutulur.'),
    ],
    refs: ['bp', 'merhem-bnf'],
  ),
  Formula(
    name: 'Bileşik undesilenik asit merhemi (USP)',
    category: FormulaCategory.merhem,
    use: 'Ayak mantarı ve kasık mantarı gibi yüzeysel mantar enfeksiyonlarında kullanılır.',
    ingredients: [
      Ingredient('Undesilenik asit', '5 g'),
      Ingredient('Çinko undesilenat', '20 g'),
      Ingredient('Polietilen glikol merhemi', '75 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko undesilenat elenerek topakları açılır.'),
      FormulaStep('Eritme', 'PEG merhemi su banyosunda hafif ısıyla eritilir.'),
      FormulaStep('Karıştırma', 'Sıvı undesilenik asit ve çinko undesilenat eriyiğe katılıp dağıtılır.'),
      FormulaStep('Soğutma', 'Toz çökmesin diye merhem donana kadar karıştırılır.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  // ------------------------------------------------------------- İhtiyol
  Formula(
    name: 'İhtiyol merhemi %10 (USP)',
    category: FormulaCategory.merhem,
    use: 'Çıban ve kıl dibi iltihabında yumuşatıcı ve hafif antiseptik olarak sürülür.',
    ingredients: [
      Ingredient('İhtiyol (amonyum bitüminosülfonat)', '10 g'),
      Ingredient('Susuz lanolin', '10 g'),
      Ingredient('Beyaz vazelin', '80 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'İhtiyol lanolinle merhem taşında iyice karıştırılır.'),
      FormulaStep('Geometrik seyreltme', 'Vazelin eşit parçalar hâlinde eklenerek karışım homojen yapılır.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'İhtiyol merhemi %10 (BP)',
    category: FormulaCategory.merhem,
    use: 'Yün yağı oranı yüksek, yumuşak bir ihtiyol merhemidir; iltihaplı küçük cilt lezyonlarında kullanılır.',
    ingredients: [
      Ingredient('İhtiyol (amonyum bitüminosülfonat)', '10 g'),
      Ingredient('Yün yağı (lanolin)', '45 g'),
      Ingredient('Sarı vazelin', '45 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Yün yağı ve sarı vazelin su banyosunda birlikte eritilir.'),
      FormulaStep('Soğutma', 'Baz koyulaşana kadar karıştırılarak soğutulur.'),
      FormulaStep('Karıştırma', 'İhtiyol yarı soğumuş baza katılır ve homojen olana kadar karıştırılır.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  // ------------------------------------------------------------- Ditranol
  Formula(
    name: 'Ditranollü vazelin %0,1',
    category: FormulaCategory.merhem,
    use: 'Sedef plaklarında düşük dozla başlanan ditranol tedavisinin ilk basamağıdır.',
    ingredients: [
      Ingredient('Ditranol', '0,1 g'),
      Ingredient('Sıvı parafin', '2 g'),
      Ingredient('Beyaz vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Levigasyon', 'Ditranol sıvı parafinle havanda ezilerek ince bir hamur yapılır; eldiven giyilir.'),
      FormulaStep('Geometrik seyreltme', 'Az miktar etkin madde olduğu için vazelin kademeli ve titizlikle katılır.'),
    ],
    refs: ['nrf', 'bp', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Salisilik asitli ditranollü vazelin %0,5',
    category: FormulaCategory.merhem,
    use: 'Sedefte doz artırılırken kullanılır; salisilik asit ditranolün bozulmasını yavaşlatır.',
    ingredients: [
      Ingredient('Ditranol', '0,5 g'),
      Ingredient('Salisilik asit', '2 g'),
      Ingredient('Sıvı parafin', '2 g'),
      Ingredient('Beyaz vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit porselen havanda ince toz olana kadar ezilir.'),
      FormulaStep('Levigasyon', 'Ditranol ve salisilik asit sıvı parafinle pürüzsüz bir hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Vazelin eşit parçalar hâlinde katılır; metal spatül kullanılmaz.'),
    ],
    refs: ['nrf', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Ditranollü Lassar patı %0,1',
    category: FormulaCategory.merhem,
    use: 'Sedef plaklarında ditranolü yalnız lezyonda tutan, sağlam deriye yayılmayan sert pattır.',
    ingredients: [
      Ingredient('Ditranol', '0,1 g'),
      Ingredient('Lassar patı (çinko oksit ve salisilik asit patı)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Levigasyon', 'Ditranol patın küçük bir kısmıyla havanda ezilerek dağıtılır.'),
      FormulaStep('Geometrik seyreltme', 'Kalan pat eşit parçalar hâlinde katılarak renk eşitlenene kadar karıştırılır.'),
    ],
    refs: ['bp', 'merhem-bnf', 'nrf'],
  ),
  // ------------------------------------------------- Antiseptik ve anestezik
  Formula(
    name: 'Setrimid emülsiyon yapıcı merhemi %3 (BP)',
    category: FormulaCategory.merhem,
    use: 'Küçük yaralarda ve seboreik ciltte antiseptik, suyla yıkanabilen merhemdir.',
    ingredients: [
      Ingredient('Setrimid', '3 g'),
      Ingredient('Setostearil alkol', '27 g'),
      Ingredient('Beyaz vazelin', '50 g'),
      Ingredient('Sıvı parafin', '20 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Setostearil alkol, vazelin ve sıvı parafin su banyosunda eritilir.'),
      FormulaStep('Çözme', 'Setrimid sıcak eriyiğe katılır ve dağılıp çözünene kadar karıştırılır.'),
      FormulaStep('Soğutma', 'Merhem donana kadar karıştırılarak soğutulur.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Lidokain merhemi %5',
    category: FormulaCategory.merhem,
    use: 'Küçük cilt ve mukoza işlemlerinde, yanık ve kaşıntıda yüzeyi uyuşturmak için kullanılır.',
    ingredients: [
      Ingredient('Lidokain (baz)', '5 g'),
      Ingredient('Polietilen glikol merhemi', '95 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'PEG merhemi su banyosunda hafif ısıyla eritilir.'),
      FormulaStep('Çözme', 'Lidokain eriyiğe katılır ve tamamen çözünene kadar karıştırılır.'),
      FormulaStep('Soğutma', 'Merhem donana kadar karıştırılarak soğutulur.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),
  Formula(
    name: 'Benzokain merhemi %5',
    category: FormulaCategory.merhem,
    use: 'Güneş yanığı, böcek sokması ve hemoroitte ağrı ve kaşıntıyı yüzeysel olarak gidermeye yarar.',
    ingredients: [
      Ingredient('Benzokain', '5 g'),
      Ingredient('Polietilen glikol merhemi', '95 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Benzokain havanda ince toz olana kadar ezilir.'),
      FormulaStep('Eritme', 'PEG merhemi su banyosunda eritilir.'),
      FormulaStep('Çözme', 'Benzokain eriyikte çözünene kadar karıştırılır.'),
      FormulaStep('Soğutma', 'Banyodan alınan merhem donana kadar karıştırılır.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),
  Formula(
    name: 'Dibukain merhemi %1',
    category: FormulaCategory.merhem,
    use: 'Hemoroit, küçük yanık ve kaşıntıda uzun etkili yüzeysel lokal anestezik merhemdir.',
    ingredients: [
      Ingredient('Dibukain (baz)', '1 g'),
      Ingredient('Sıvı parafin', '4 g'),
      Ingredient('Beyaz vazelin', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Dibukain havanda ince toz olana kadar ezilir.'),
      FormulaStep('Levigasyon', 'Toz sıvı parafinle ezilerek pürüzsüz bir hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Vazelin eşit parçalar hâlinde katılarak karıştırılır.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),
  Formula(
    name: 'Povidon iyot merhemi %10',
    category: FormulaCategory.merhem,
    use: 'Küçük yara, sıyrık ve yanıklarda enfeksiyonu önlemek için antiseptik olarak sürülür.',
    ingredients: [
      Ingredient('Povidon iyot', '10 g'),
      Ingredient('Polietilen glikol merhemi', '90 g'),
    ],
    steps: [
      FormulaStep('Levigasyon', 'Povidon iyot tozu PEG merheminin küçük bir kısmıyla pürüzsüzce ezilir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan PEG merhemi kademeli olarak katılıp renk eşitlenir.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),
  // ------------------------------------------------------------- Diğerleri
  Formula(
    name: 'Üre patı %40 (tırnak)',
    category: FormulaCategory.merhem,
    use: 'Mantarlı ya da kalınlaşmış tırnağı cerrahi olmadan yumuşatıp kaldırmak için kapalı pansumanla sürülür.',
    ingredients: [
      Ingredient('Üre', '40 g'),
      Ingredient('Yün yağı (lanolin)', '20 g'),
      Ingredient('Beyaz vazelin', '40 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Üre kristalleri havanda çok ince toz olana kadar ezilir.'),
      FormulaStep('Levigasyon', 'Üre tozu yün yağıyla havanda pürüzsüz bir hamur yapılır.'),
      FormulaStep('Geometrik seyreltme', 'Vazelin eşit parçalar hâlinde eklenerek pat tamamlanır.'),
    ],
    refs: ['nrf', 'merhem-south-farber', 'merhem-altmeyer'],
  ),
  Formula(
    name: 'Magnezyum sülfat patı (Morison patı, BP)',
    category: FormulaCategory.merhem,
    use: 'Çıban ve karbonküllerde iltihabı çekmek için pansumanla uygulanan higroskopik pattır.',
    ingredients: [
      Ingredient('Kurutulmuş magnezyum sülfat', '45 g'),
      Ingredient('Fenol', '0,5 g'),
      Ingredient('Gliserin', '55 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kurutulmuş magnezyum sülfat havanda ince toz olana kadar ezilir.'),
      FormulaStep('Elekten geçirme', 'Toz ince elekten geçirilir; havadan nem çekmesin diye hızlı çalışılır.'),
      FormulaStep('Çözme', 'Fenol gliserinin içinde çözülür.'),
      FormulaStep('Karıştırma', 'Magnezyum sülfat gliserine azar azar katılıp homojen pat olana kadar karıştırılır.'),
    ],
    refs: ['bp', 'merhem-bnf'],
  ),
  Formula(
    name: 'Mentollü burun merhemi %0,6',
    category: FormulaCategory.merhem,
    use: 'Nezle ve burun tıkanıklığında burun girişine sürülerek ferahlık verir.',
    ingredients: [
      Ingredient('Levomentol', '0,6 g'),
      Ingredient('Sıvı parafin ve beyaz vazelin karışımı', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Mentol kristalleri havanda ezilir.'),
      FormulaStep('Çözme', 'Mentol, uçmasın diye ısıtmadan bazın küçük bir kısmında çözülür.'),
      FormulaStep('Geometrik seyreltme', 'Kalan baz eşit parçalar hâlinde katılarak karıştırılır.'),
    ],
    refs: ['nrf', 'merhem-pz'],
  ),
];
