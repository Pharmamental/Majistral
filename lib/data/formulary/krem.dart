import '../../models/formula.dart';
import '../../models/prescription.dart';
import '../references.dart';

// Formüller BP, DAB, DAC/NRF, APF, USP ve hastane/üniversite rezeptur listelerinden; metinler bizim.
const kremRefs = <Reference>[
  Reference(
    id: 'krem-dab',
    kind: ReferenceKind.farmakope,
    citation: 'Deutsches Arzneibuch (DAB): Wasserhaltige hydrophile Salbe, Nichtionische hydrophile Creme, '
        'Kühlcreme ve Wasserhaltige Wollwachsalkoholsalbe monografları. Deutscher Apotheker Verlag, Stuttgart.',
    url: 'https://www.bfarm.de',
  ),
  Reference(
    id: 'krem-bpc',
    kind: ReferenceKind.farmakope,
    citation: 'British Pharmaceutical Codex 1968: Salicylic Acid and Sulphur Cream. Pharmaceutical Society of '
        'Great Britain, Londra, 1968.',
  ),
  Reference(
    id: 'krem-dmd',
    kind: ReferenceKind.devlet,
    citation: 'NHS Dictionary of Medicines and Devices (dm+d), majistral krem kayıtları (Virtual Medicinal '
        'Product). NHS Business Services Authority, Birleşik Krallık.',
    url: 'https://dmd-browser.nhsbsa.nhs.uk',
  ),
  Reference(
    id: 'krem-uksh',
    kind: ReferenceKind.universite,
    citation: 'Steffen-Slotty G. Rezepturen/Defekturen Dermatologie, 2. baskı. Universitätsklinikum '
        'Schleswig-Holstein (UKSH), Stabsstelle Apotheke, Campus Lübeck, 2024.',
    url: 'https://www.uksh.de/uksh_media/Dateien_Verwaltung/Apotheke/Dokumente/'
        'Brosch%C3%BCre+Rezepturen_Defekturen+Dermatologie-p-834042.pdf',
  ),
  Reference(
    id: 'krem-altmeyer',
    kind: ReferenceKind.kitap,
    citation: 'Altmeyer P, Bacharach-Buhles M. Altmeyers Enzyklopädie: Dermatologie, Allergologie, '
        'Umweltmedizin, rezeptur maddeleri (basılı hâli: Therapielexikon Dermatologie und Allergologie, '
        'Springer). Springer Medizin.',
    url: 'https://www.altmeyers.org',
  ),
  Reference(
    id: 'krem-zl',
    kind: ReferenceKind.devlet,
    citation: 'Zentrallaboratorium Deutscher Apotheker (ZL). Ringversuch 2021: Clotrimazol 1 % in '
        'Nichtionischer hydrophiler Creme DAB. ABDA, Eschborn, 2021.',
    url: 'https://www.zentrallabor.com',
  ),
  Reference(
    id: 'krem-ankara',
    kind: ReferenceKind.universite,
    citation: 'Ankara Üniversitesi Eczacılık Fakültesi. Kozmetik kremler ders notu: stearat kremi '
        '(vanishing krem). AçıkDers, Ankara Üniversitesi.',
    url: 'https://acikders.ankara.edu.tr/mod/resource/view.php?id=165268',
  ),
];

const kremFormulas = <Formula>[
  // ---------------------------------------------------------------- Krem bazları
  Formula(
    name: 'Sulu krem (BP)',
    category: FormulaCategory.krem,
    use: 'Kuru ciltte yumuşatıcı olarak ve ilaçlı kremlerde taşıyıcı baz olarak kullanılır.',
    ingredients: [
      Ingredient('Emülsiye edici merhem', '30 g'),
      Ingredient('Fenoksietanol', '1 g'),
      Ingredient('Kaynatılıp soğutulmuş saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Emülsiye edici merhemi su banyosunda yaklaşık 70 °C\'de erit.'),
      FormulaStep('Çözme', 'Fenoksietanolü aynı sıcaklığa ısıtılmış suda çöz.'),
      FormulaStep('Emülsifikasyon', 'Sıcak suyu eriyiğe azar azar ekle ve sürekli karıştır.'),
      FormulaStep('Soğutma', 'Krem kıvam alana kadar yavaşça karıştırarak soğut, eksik suyu tamamla.'),
    ],
    refs: ['bp', 'rps-handbook', 'krem-dmd'],
  ),
  Formula(
    name: 'Setomakrogol krem (BP, Formül A)',
    category: FormulaCategory.krem,
    use: 'Noniyonik, tahriş etmeyen yumuşatıcı ve ilaçları seyreltmek için baz krem olarak kullanılır.',
    ingredients: [
      Ingredient('Setomakrogol emülsiye edici merhem', '30 g'),
      Ingredient('Klorokrezol', '0,1 g'),
      Ingredient('Kaynatılıp soğutulmuş saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Setomakrogol emülsiye edici merhemi su banyosunda 70 °C civarında erit.'),
      FormulaStep('Çözme', 'Klorokrezolü ılık suda çözüp suyu aynı sıcaklığa getir.'),
      FormulaStep('Emülsifikasyon', 'Sulu çözeltiyi eriyik yağ fazına karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Krem donana kadar hafifçe karıştırmaya devam et.'),
    ],
    refs: ['bp', 'krem-dmd'],
  ),
  Formula(
    name: 'Tamponlu krem (BP)',
    category: FormulaCategory.krem,
    use: 'Cildin hafif asidik pH\'ını koruyan yumuşatıcı ve seyreltici baz olarak kullanılır.',
    ingredients: [
      Ingredient('Emülsiye edici merhem', '30 g'),
      Ingredient('Sitrik asit monohidrat', '0,5 g'),
      Ingredient('Disodyum hidrojen fosfat', '2,5 g'),
      Ingredient('Klorokrezol', '0,1 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Emülsiye edici merhemi su banyosunda erit.'),
      FormulaStep('Çözme', 'Sitrik asit, fosfat ve klorokrezolü ısıtılmış suda çöz.'),
      FormulaStep('Emülsifikasyon', 'Sıcak tampon çözeltiyi eriyiğe karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Krem katılaşana kadar karıştırarak soğut.'),
    ],
    refs: ['bp', 'krem-dmd'],
  ),
  Formula(
    name: 'Yağlı krem (BP, hidratlı merhem)',
    category: FormulaCategory.krem,
    use: 'Çok kuru ve pullu ciltte yağlı, su-yağ tipi yumuşatıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Yün yağı alkolleri merhemi', '50 g'),
      Ingredient('Kurutulmuş magnezyum sülfat', '0,5 g'),
      Ingredient('Fenoksietanol', '1 g'),
      Ingredient('Kaynatılıp soğutulmuş saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Yün yağı alkolleri merhemini su banyosunda erit.'),
      FormulaStep('Çözme', 'Magnezyum sülfat ve fenoksietanolü ılık suda çöz.'),
      FormulaStep('Emülsifikasyon', 'Sulu çözeltiyi yağ fazına azar azar katıp her seferinde iyice karıştır.'),
      FormulaStep('Soğutma', 'Krem soğuyup koyulaşana kadar karıştır.'),
    ],
    refs: ['bp', 'krem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Hidrofil merhem (USP, yağ-su krem bazı)',
    category: FormulaCategory.krem,
    use: 'Suyla yıkanabilen, yağ-su tipi taşıyıcı baz olarak kullanılır.',
    ingredients: [
      Ingredient('Metilparaben', '0,025 g'),
      Ingredient('Propilparaben', '0,015 g'),
      Ingredient('Sodyum lauril sülfat', '1 g'),
      Ingredient('Propilen glikol', '12 g'),
      Ingredient('Stearil alkol', '25 g'),
      Ingredient('Beyaz vazelin', '25 g'),
      Ingredient('Saf su', '37 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Stearil alkol ve beyaz vazelini su banyosunda yaklaşık 75 °C\'de erit.'),
      FormulaStep('Çözme', 'Parabenleri, sodyum lauril sülfatı ve propilen glikolü 75 °C\'deki suda çöz.'),
      FormulaStep('Emülsifikasyon', 'Sıcak sulu çözeltiyi eriyik yağ fazına karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Kütle donana kadar karıştırmayı sürdür.'),
    ],
    refs: ['usp-nf', 'remington', 'ansel'],
  ),
  Formula(
    name: 'Soğutucu krem (DAB)',
    category: FormulaCategory.krem,
    use: 'Sürüldüğünde suyunu bırakıp serinlik veren, koruyucu içermeyen yağlı bakım kremidir.',
    ingredients: [
      Ingredient('Sarı balmumu', '7 g'),
      Ingredient('Setil palmitat', '8 g'),
      Ingredient('Rafine yer fıstığı yağı', '60 g'),
      Ingredient('Saf su', '25 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Balmumu, setil palmitat ve yer fıstığı yağını su banyosunda birlikte erit.'),
      FormulaStep('Emülsifikasyon', 'Ilık suyu eriyiğe küçük porsiyonlarla, her birini iyice işleyerek kat.'),
      FormulaStep('Soğutma', 'Krem koyulaşana kadar sabırla karıştırarak soğut.'),
    ],
    refs: ['krem-dab', 'krem-altmeyer', 'krem-uksh'],
  ),
  Formula(
    name: 'Anyonik hidrofil krem (DAB)',
    category: FormulaCategory.krem,
    use: 'Alman farmakopesinin yıkanabilir yağ-su krem bazıdır; üre ve permetrin kremlerinde taşıyıcıdır.',
    ingredients: [
      Ingredient('Emülsiye edici setostearil alkol (Tip A)', '9 g'),
      Ingredient('Koyu sıvı parafin', '10,5 g'),
      Ingredient('Beyaz vazelin', '10,5 g'),
      Ingredient('Saf su', '70 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Setostearil alkol, sıvı parafin ve vazelini su banyosunda 70 °C\'de erit.'),
      FormulaStep('Emülsifikasyon', 'Aynı sıcaklıktaki suyu eriyiğe karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Krem oda sıcaklığına inene kadar karıştır.'),
    ],
    refs: ['krem-dab', 'krem-uksh', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Noniyonik hidrofil krem (DAB)',
    category: FormulaCategory.krem,
    use: 'İyonik olmayan emülgatörlü, katyonik ve anyonik etken maddelerle uyumlu yağ-su krem bazıdır.',
    ingredients: [
      Ingredient('Polisorbat 60', '5 g'),
      Ingredient('Setostearil alkol', '10 g'),
      Ingredient('Gliserol %85', '10 g'),
      Ingredient('Beyaz vazelin', '25 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Setostearil alkol, vazelin ve polisorbat 60\'ı su banyosunda 70 °C\'de erit.'),
      FormulaStep('Çözme', 'Gliserolü suya karıştırıp aynı sıcaklığa ısıt.'),
      FormulaStep('Emülsifikasyon', 'Sıcak sulu fazı eriyiğe sürekli karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Krem kıvamlanana kadar karıştırarak soğut.'),
    ],
    refs: ['krem-dab', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Noniyonik hidrofil krem SR (DAC)',
    category: FormulaCategory.krem,
    use: 'Sorbatla korunmuş, NRF reçetelerinde taşıyıcı olarak kullanılan noniyonik yağ-su krem bazıdır.',
    ingredients: [
      Ingredient('Setostearil alkol', '16,8 g'),
      Ingredient('Makrogol-20-setostearil eter', '4,2 g'),
      Ingredient('2-Etilheksil laurat', '10 g'),
      Ingredient('Gliserol %85', '5 g'),
      Ingredient('Potasyum sorbat', '0,14 g'),
      Ingredient('Susuz sitrik asit', '0,07 g'),
      Ingredient('Saf su', '63,79 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Setostearil alkol, makrogol eter ve etilheksil lauratı su banyosunda erit.'),
      FormulaStep('Çözme', 'Potasyum sorbat, sitrik asit ve gliserolü suda çözüp 70 °C\'ye ısıt.'),
      FormulaStep('Emülsifikasyon', 'Sıcak sulu fazı eriyik yağ fazına karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Krem donana kadar karıştırmaya devam et.'),
    ],
    refs: ['nrf', 'krem-uksh'],
  ),
  Formula(
    name: 'Baz krem (DAC)',
    category: FormulaCategory.krem,
    use: 'Hem su hem yağla seyreltilebilen amfifil krem; birçok NRF kreminde taşıyıcıdır.',
    ingredients: [
      Ingredient('Gliserol monostearat 60', '4 g'),
      Ingredient('Setil alkol', '6 g'),
      Ingredient('Orta zincirli trigliseritler', '7,5 g'),
      Ingredient('Beyaz vazelin', '25,5 g'),
      Ingredient('Makrogol-20-gliserol monostearat', '7 g'),
      Ingredient('Propilen glikol', '10 g'),
      Ingredient('Saf su', '40 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Gliserol monostearat, setil alkol, trigliseritler, vazelin ve makrogol esterini '
          'su banyosunda erit.'),
      FormulaStep('Çözme', 'Propilen glikolü suya karıştırıp eriyikle aynı sıcaklığa getir.'),
      FormulaStep('Emülsifikasyon', 'Sıcak sulu fazı yağ fazına karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Krem oda sıcaklığına inene kadar karıştır.'),
    ],
    refs: ['nrf', 'krem-uksh', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Hidrofobik baz krem (DAC)',
    category: FormulaCategory.krem,
    use: 'Yün yağı içermeyen, su-yağ tipi yağlı krem bazıdır; kuru ciltte ve üreli kremlerde kullanılır.',
    ingredients: [
      Ingredient('Trigliserol diizostearat', '3 g'),
      Ingredient('İzopropil palmitat', '2,4 g'),
      Ingredient('Hidrofobik baz jel (DAC)', '24,6 g'),
      Ingredient('Potasyum sorbat', '0,14 g'),
      Ingredient('Susuz sitrik asit', '0,07 g'),
      Ingredient('Magnezyum sülfat heptahidrat', '0,5 g'),
      Ingredient('Gliserol %85', '5 g'),
      Ingredient('Saf su', '64,29 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Trigliserol diizostearat, izopropil palmitat ve baz jeli homojen olana dek karıştır.'),
      FormulaStep('Çözme', 'Sorbat, sitrik asit, magnezyum sülfat ve gliserolü suda çöz.'),
      FormulaStep('Emülsifikasyon', 'Sulu çözeltiyi yağ fazına küçük porsiyonlarla, kuvvetle karıştırarak kat.'),
    ],
    refs: ['nrf', 'krem-altmeyer', 'krem-uksh'],
  ),
  Formula(
    name: 'Sulu yün yağı alkolleri merhemi (DAB)',
    category: FormulaCategory.krem,
    use: 'Su-yağ tipi yağlı krem; kuru ve kalınlaşmış ciltte yumuşatıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Yün yağı alkolleri merhemi', '50 g'),
      Ingredient('Saf su', '50 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Yün yağı alkolleri merhemini su banyosunda ılıkken erit.'),
      FormulaStep('Emülsifikasyon', 'Ilık suyu eriyiğe azar azar ekleyip her porsiyonu iyice işle.'),
      FormulaStep('Soğutma', 'Krem soğuyup homojen olana kadar karıştır.'),
    ],
    refs: ['krem-dab', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Stearat kremi (kaybolan krem)',
    category: FormulaCategory.krem,
    use: 'Ciltte yağsız, mat bir film bırakan, sabunla emülsiye edilmiş klasik yağ-su kremidir.',
    ingredients: [
      Ingredient('Stearik asit', '15 g'),
      Ingredient('Potasyum hidroksit', '0,7 g'),
      Ingredient('Gliserin', '8 g'),
      Ingredient('Saf su', '76,3 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Stearik asidi su banyosunda yaklaşık 75 °C\'de erit.'),
      FormulaStep('Çözme', 'Potasyum hidroksit ve gliserini suda çözüp aynı sıcaklığa ısıt.'),
      FormulaStep('Nötralleştirme', 'Sıcak alkali çözeltiyi eriyiğe karıştırarak ekle; asidin bir kısmı sabuna '
          'dönüşüp emülgatör olur.'),
      FormulaStep('Soğutma', 'Krem parlak ve koyu kıvam alana kadar karıştırarak soğut.'),
    ],
    refs: ['krem-ankara', 'remington'],
  ),
  Formula(
    name: 'Gliserinli setomakrogol krem %10',
    category: FormulaCategory.krem,
    use: 'Nem tutucu gliserinle zenginleştirilmiş, kuru cilt için yumuşatıcı kremdir.',
    ingredients: [
      Ingredient('Gliserol', '10 g'),
      Ingredient('Setomakrogol krem (Formül A)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Geometrik seyreltme', 'Gliserolü önce az miktar kremle, sonra kalan kremle eşit '
          'porsiyonlarla karıştır.'),
    ],
    refs: ['apf', 'krem-dmd'],
  ),
  Formula(
    name: 'Sulu krem ve emülsiye edici merhem karışımı %50',
    category: FormulaCategory.krem,
    use: 'Sulu kremden daha yağlı, merhemden daha kolay yayılan bir yumuşatıcıdır.',
    ingredients: [
      Ingredient('Sulu krem', '50 g'),
      Ingredient('Emülsiye edici merhem', '50 g'),
    ],
    steps: [
      FormulaStep('Geometrik seyreltme', 'Merhemi sulu kreme eşit porsiyonlarla katıp homojen olana dek karıştır.'),
    ],
    refs: ['krem-dmd', 'bp'],
  ),

  // ---------------------------------------------------------------- Üre ve nemlendiriciler
  Formula(
    name: 'Üreli hidrofil krem %5',
    category: FormulaCategory.krem,
    use: 'Kuru ve hafif pullu ciltte nemlendirici ve yumuşatıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Üre', '5 g'),
      Ingredient('Laktik asit', '1 g'),
      Ingredient('Sodyum laktat çözeltisi %50', '4 g'),
      Ingredient('Koruyuculu anyonik hidrofil krem (sorbik asitli)', '90 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Üre kristallerini havanda ince toz hâline getir.'),
      FormulaStep('Geometrik seyreltme', 'Üreyi kremle eşit porsiyonlarla karıştır.'),
      FormulaStep('Karıştırma', 'Laktik asit ve sodyum laktatı ekleyip üre çözünene kadar karıştır.'),
    ],
    refs: ['nrf', 'krem-uksh', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Üreli hidrofil krem %10',
    category: FormulaCategory.krem,
    use: 'Kalınlaşmış, kuru ve kepeklenen ciltte (iktiyoz, egzama sonrası) nemlendirici olarak kullanılır.',
    ingredients: [
      Ingredient('Üre', '10 g'),
      Ingredient('Laktik asit', '1 g'),
      Ingredient('Sodyum laktat çözeltisi %50', '4 g'),
      Ingredient('Koruyuculu anyonik hidrofil krem (sorbik asitli)', '85 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Üreyi havanda ince toz hâline getir.'),
      FormulaStep('Geometrik seyreltme', 'Üre tozunu kremle azar azar, eşit miktarlarla karıştır.'),
      FormulaStep('Karıştırma', 'Laktik asit ve laktat çözeltisini katıp üre tamamen çözünene dek karıştır.'),
    ],
    refs: ['nrf', 'krem-uksh', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Üreli lipofil krem %10',
    category: FormulaCategory.krem,
    use: 'Çok kuru ciltte daha yağlı, su-yağ tipi üreli nemlendirici olarak kullanılır.',
    ingredients: [
      Ingredient('Üre', '10 g'),
      Ingredient('Laktik asit', '1 g'),
      Ingredient('Sodyum laktat çözeltisi %50', '4 g'),
      Ingredient('Hidrofobik baz krem (DAC)', '85 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Üreyi laktik asit ve sodyum laktat çözeltisinde çöz.'),
      FormulaStep('Geometrik seyreltme', 'Çözeltiyi baz kreme küçük porsiyonlarla işle.'),
    ],
    refs: ['nrf', 'krem-uksh', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Üreli sulu yün yağı alkolleri kremi %10',
    category: FormulaCategory.krem,
    use: 'Yün yağı alkollü su-yağ kremi; iktiyozda ve çatlamış kuru ciltte kullanılır.',
    ingredients: [
      Ingredient('Üre', '10 g'),
      Ingredient('Laktik asit %90', '1 g'),
      Ingredient('Sodyum laktat çözeltisi %50', '4 g'),
      Ingredient('Potasyum sorbat', '0,14 g'),
      Ingredient('Yün yağı alkolleri merhemi', '50 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Üre, laktik asit, laktat ve sorbatı suda çöz.'),
      FormulaStep('Eritme', 'Yün yağı alkolleri merhemini ılık su banyosunda yumuşat.'),
      FormulaStep('Emülsifikasyon', 'Sulu çözeltiyi merheme azar azar katıp her porsiyonu iyice işle.'),
      FormulaStep('Soğutma', 'Krem homojen ve soğuk olana dek karıştır.'),
    ],
    refs: ['nrf', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Üreli sulu krem %20',
    category: FormulaCategory.krem,
    use: 'Kalın, sertleşmiş deride (topuk, avuç içi) keratin yumuşatıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Üre', '20 g'),
      Ingredient('Sulu krem', '80 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Üreyi havanda ince toz hâline getir.'),
      FormulaStep('Geometrik seyreltme', 'Üreyi sulu kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['krem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Laktik asitli sulu krem %10',
    category: FormulaCategory.krem,
    use: 'Kuru, pullu ciltte nem tutucu ve hafif soyucu olarak kullanılır.',
    ingredients: [
      Ingredient('Laktik asit', '10 g'),
      Ingredient('Sulu krem', '90 g'),
    ],
    steps: [
      FormulaStep('Geometrik seyreltme', 'Laktik asidi önce az miktar kremle, sonra kalanla azar azar karıştır.'),
    ],
    refs: ['krem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Dekspantenol ve gliserollü krem %5',
    category: FormulaCategory.krem,
    use: 'Tahriş olmuş, kuru ve iyileşmekte olan ciltte bakım kremi olarak kullanılır.',
    ingredients: [
      Ingredient('Dekspantenol', '5 g'),
      Ingredient('Gliserol', '5 g'),
      Ingredient('Baz krem (DAC)', '90 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Koyu kıvamlı dekspantenolü gliserolle karıştırıp akıcı hâle getir.'),
      FormulaStep('Geometrik seyreltme', 'Karışımı baz kreme eşit porsiyonlarla işle.'),
    ],
    refs: ['krem-uksh', 'martindale'],
  ),
  Formula(
    name: 'Dekspantenol ve gliserollü krem %3',
    category: FormulaCategory.krem,
    use: 'Hassas ve kuru ciltte günlük bakım için daha düşük güçte dekspantenollü kremdir.',
    ingredients: [
      Ingredient('Dekspantenol', '3 g'),
      Ingredient('Gliserol', '3 g'),
      Ingredient('Baz krem (DAC)', '94 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Dekspantenolü gliserolle karıştır.'),
      FormulaStep('Geometrik seyreltme', 'Karışımı baz kreme azar azar, eşit miktarlarla kat.'),
    ],
    refs: ['krem-uksh', 'martindale'],
  ),

  // ---------------------------------------------------------------- Kaşıntı ve ağrı
  Formula(
    name: 'Kapsaisinoid krem %0,025',
    category: FormulaCategory.krem,
    use: 'Kaşıntılı ve nöropatik ağrılı deri bölgelerinde lokal olarak kullanılır.',
    ingredients: [
      Ingredient('Kapsaisinoid konsantresi %2,5 (propilen glikollü)', '1 g'),
      Ingredient('Baz krem (DAC)', '50 g'),
      Ingredient('Propilen glikol', '21 g'),
      Ingredient('Saf su', '28 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Kapsaisinoid konsantresini propilen glikol ve suyla karıştır.'),
      FormulaStep('Geometrik seyreltme', 'Sıvıyı baz kreme küçük porsiyonlarla işle.'),
    ],
    refs: ['nrf', 'krem-uksh', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Kapsaisinoid krem %0,1',
    category: FormulaCategory.krem,
    use: 'Inatçı lokal kaşıntı ve nöropatik ağrıda daha yüksek güçte kullanılır.',
    ingredients: [
      Ingredient('Kapsaisinoid konsantresi %2,5 (propilen glikollü)', '4 g'),
      Ingredient('Baz krem (DAC)', '50 g'),
      Ingredient('Propilen glikol', '18 g'),
      Ingredient('Saf su', '28 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Konsantreyi propilen glikol ve suyla homojen olana dek karıştır.'),
      FormulaStep('Geometrik seyreltme', 'Karışımı baz kreme azar azar kat.'),
    ],
    refs: ['nrf', 'krem-uksh', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Polidokanollü hidrofil krem %5',
    category: FormulaCategory.krem,
    use: 'Kaşıntılı ciltte lokal kaşıntı giderici olarak kullanılır.',
    ingredients: [
      Ingredient('Lauromakrogol 400 (polidokanol)', '5 g'),
      Ingredient('Baz krem (DAC)', '95 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Mumsu polidokanolü ılık su banyosunda sıvılaştır.'),
      FormulaStep('Geometrik seyreltme', 'Polidokanolü baz kreme eşit porsiyonlarla karıştır.'),
    ],
    refs: ['nrf', 'krem-uksh'],
  ),
  Formula(
    name: 'Polidokanollü lipofil krem %5',
    category: FormulaCategory.krem,
    use: 'Kuru ve kaşıntılı ciltte yağlı, kaşıntı giderici krem olarak kullanılır.',
    ingredients: [
      Ingredient('Lauromakrogol 400 (polidokanol)', '5 g'),
      Ingredient('Magnezyum sülfat heptahidrat', '0,1 g'),
      Ingredient('Propilen glikol', '10 g'),
      Ingredient('Saf su', '9,9 g'),
      Ingredient('Emülsiye edici hidrofobik baz jel (DAC)', '75 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Magnezyum sülfatı suda çözüp propilen glikolle karıştır.'),
      FormulaStep('Eritme', 'Polidokanolü ılık su banyosunda sıvılaştırıp baz jele karıştır.'),
      FormulaStep('Emülsifikasyon', 'Sulu fazı jele küçük porsiyonlarla, kuvvetle karıştırarak kat.'),
    ],
    refs: ['nrf', 'krem-uksh', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Mentollü sulu krem %1',
    category: FormulaCategory.krem,
    use: 'Serinlik hissiyle kaşıntıyı hafifletmek için kullanılır.',
    ingredients: [
      Ingredient('Mentol', '1 g'),
      Ingredient('Sulu krem', '99 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Mentol kristallerini havanda ez.'),
      FormulaStep('Levigasyon', 'Mentolü az miktar kremle pürüzsüz bir macun hâline getir.'),
      FormulaStep('Geometrik seyreltme', 'Macunu kalan kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['krem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Mentollü sulu krem %2',
    category: FormulaCategory.krem,
    use: 'Inatçı kaşıntıda daha güçlü serinletici etki için kullanılır.',
    ingredients: [
      Ingredient('Mentol', '2 g'),
      Ingredient('Sulu krem', '98 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Mentolü havanda ince ez.'),
      FormulaStep('Levigasyon', 'Az miktar kremle mentolü pürüzsüz macuna çevir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan kremi azar azar katarak homojen karıştır.'),
    ],
    refs: ['krem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Mentollü setomakrogol krem %2',
    category: FormulaCategory.krem,
    use: 'Sodyum lauril sülfata hassas ciltte serinletici kaşıntı kremi olarak kullanılır.',
    ingredients: [
      Ingredient('Mentol', '2 g'),
      Ingredient('Setomakrogol krem (Formül A)', '98 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Mentol kristallerini havanda ez.'),
      FormulaStep('Levigasyon', 'Mentolü az miktar setomakrogol kremle macun hâline getir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan kremi eşit porsiyonlarla kat.'),
    ],
    refs: ['krem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Mentol %1 ve salisilik asit %1 sulu krem',
    category: FormulaCategory.krem,
    use: 'Kaşıntılı, hafif pullu ciltte serinletici ve hafif soyucu olarak kullanılır.',
    ingredients: [
      Ingredient('Mentol', '1 g'),
      Ingredient('Salisilik asit', '1 g'),
      Ingredient('Sulu krem', '98 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit ve mentolü havanda ayrı ayrı ince ez.'),
      FormulaStep('Levigasyon', 'Tozları az miktar kremle pürüzsüz macun yap; çelik spatül kullanma.'),
      FormulaStep('Geometrik seyreltme', 'Macunu kalan kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['krem-dmd', 'martindale'],
  ),

  // ---------------------------------------------------------------- Soyucu ve akne
  Formula(
    name: 'Salisilik asit ve kükürtlü sulu krem %2',
    category: FormulaCategory.krem,
    use: 'Seboreik dermatit, akne ve pullu deride soyucu ve antiseptik olarak kullanılır.',
    ingredients: [
      Ingredient('Salisilik asit', '2 g'),
      Ingredient('Çöktürülmüş kükürt', '2 g'),
      Ingredient('Sulu krem', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asidi havanda ince toz hâline getir.'),
      FormulaStep('Elekten geçirme', 'Kükürdü topaklarından ayırmak için elekten geçir.'),
      FormulaStep('Levigasyon', 'İki tozu az miktar kremle pürüzsüz macun yap; çelik spatül kullanma.'),
      FormulaStep('Geometrik seyreltme', 'Macunu kalan kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['apf', 'krem-bpc', 'krem-dmd'],
  ),
  Formula(
    name: 'Salisilik asitli sulu krem %5',
    category: FormulaCategory.krem,
    use: 'Kalınlaşmış, pullu deride (sedef plakları, nasır çevresi) keratolitik olarak kullanılır.',
    ingredients: [
      Ingredient('Salisilik asit', '5 g'),
      Ingredient('Sulu krem', '95 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asidi cam olmayan havanda ince toz hâline getir.'),
      FormulaStep('Levigasyon', 'Tozu az miktar kremle pürüzsüz macun yap; çelik spatül kullanma.'),
      FormulaStep('Geometrik seyreltme', 'Macunu kalan kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['apf', 'krem-dmd'],
  ),
  Formula(
    name: 'Kükürtlü sulu krem %5',
    category: FormulaCategory.krem,
    use: 'Akne, seboreik dermatit ve uyuzda antiseptik ve keratolitik olarak kullanılır.',
    ingredients: [
      Ingredient('Çöktürülmüş kükürt', '5 g'),
      Ingredient('Sulu krem', '95 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Kükürdü elekten geçirerek topaklarını aç.'),
      FormulaStep('Levigasyon', 'Kükürdü az miktar kremle pürüzsüz macun yap.'),
      FormulaStep('Geometrik seyreltme', 'Macunu kalan kremle azar azar karıştır.'),
    ],
    refs: ['krem-dmd', 'martindale'],
  ),
  Formula(
    name: 'Kükürtlü sulu krem %2',
    category: FormulaCategory.krem,
    use: 'Yüzdeki akne ve seboreik dermatitte hafif antiseptik krem olarak kullanılır.',
    ingredients: [
      Ingredient('Çöktürülmüş kükürt', '2 g'),
      Ingredient('Sulu krem', '98 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Kükürdü elekten geçir.'),
      FormulaStep('Levigasyon', 'Az miktar kremle kükürdü macun hâline getir.'),
      FormulaStep('Geometrik seyreltme', 'Kalan kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['krem-dmd', 'martindale'],
  ),

  // ---------------------------------------------------------------- Kurutucu, koruyucu
  Formula(
    name: 'Sulu kalamin kremi (BP)',
    category: FormulaCategory.krem,
    use: 'Kaşıntılı ve tahriş olmuş ciltte hafif büzücü ve yatıştırıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Kalamin', '4 g'),
      Ingredient('Çinko oksit', '3 g'),
      Ingredient('Sıvı parafin', '20 g'),
      Ingredient('Kendinden emülsiye edici gliseril monostearat', '5 g'),
      Ingredient('Setomakrogol emülsiye edici mum', '5 g'),
      Ingredient('Fenoksietanol', '0,5 g'),
      Ingredient('Kaynatılıp soğutulmuş saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Sıvı parafin, gliseril monostearat ve setomakrogol mumunu su banyosunda erit.'),
      FormulaStep('Çözme', 'Fenoksietanolü ısıtılmış suda çöz.'),
      FormulaStep('Emülsifikasyon', 'Sıcak suyu eriyiğe karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Krem bazı donana kadar karıştır.'),
      FormulaStep('Ezme', 'Kalamin ve çinko oksidi havanda birlikte ince ez.'),
      FormulaStep('Geometrik seyreltme', 'Tozları kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['bp', 'krem-dmd'],
  ),
  Formula(
    name: 'Salisilik asit ve kükürtlü kalamin kremi %2',
    category: FormulaCategory.krem,
    use: 'Kaşıntılı, yağlı ve pullu ciltte yatıştırıcı ve soyucu olarak kullanılır.',
    ingredients: [
      Ingredient('Salisilik asit', '2 g'),
      Ingredient('Çöktürülmüş kükürt', '2 g'),
      Ingredient('Sulu kalamin kremi', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asidi havanda ince ez.'),
      FormulaStep('Elekten geçirme', 'Kükürdü elekten geçir.'),
      FormulaStep('Levigasyon', 'Tozları az miktar kalamin kremiyle macun yap.'),
      FormulaStep('Geometrik seyreltme', 'Kalan kremi eşit porsiyonlarla kat.'),
    ],
    refs: ['krem-dmd', 'bp'],
  ),
  Formula(
    name: 'Çinko kremi %32 (BP)',
    category: FormulaCategory.krem,
    use: 'Pişik ve tahriş olmuş ciltte koruyucu, büzücü su-yağ kremi olarak kullanılır.',
    ingredients: [
      Ingredient('Çinko oksit', '32 g'),
      Ingredient('Kalsiyum hidroksit', '0,045 g'),
      Ingredient('Oleik asit', '0,5 ml'),
      Ingredient('Yer fıstığı yağı', '32 ml'),
      Ingredient('Yün yağı', '8 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Çinko oksit ve kalsiyum hidroksidi havanda birlikte ez.'),
      FormulaStep('Levigasyon', 'Toz karışımı oleik asit ve yer fıstığı yağıyla pürüzsüz macun yap.'),
      FormulaStep('Eritme', 'Yün yağını ılık su banyosunda yumuşatıp macuna kat.'),
      FormulaStep('Emülsifikasyon', 'Suyu azar azar ekleyip sürekli karıştırarak su-yağ kremi oluştur.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'İhtiyollü krem %10',
    category: FormulaCategory.krem,
    use: 'Yüzeysel iltihaplı deri hastalıklarında ve kıl kökü iltihabında yatıştırıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Amonyum bitüminosülfonat (ihtiyol)', '10 g'),
      Ingredient('Yün yağı alkolleri merhemi', '81 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'İhtiyolü yün yağı alkolleri merhemiyle homojen olana dek karıştır.'),
      FormulaStep('Emülsifikasyon', 'Suyu küçük porsiyonlarla katıp her seferinde iyice işle.'),
    ],
    refs: ['nrf', 'krem-altmeyer'],
  ),
  Formula(
    name: 'İhtiyollü krem %20',
    category: FormulaCategory.krem,
    use: 'Çıban ve derin olmayan apselerde olgunlaştırıcı ve iltihap giderici olarak kullanılır.',
    ingredients: [
      Ingredient('Amonyum bitüminosülfonat (ihtiyol)', '20 g'),
      Ingredient('Yün yağı alkolleri merhemi', '72 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'İhtiyolü merhemle azar azar karıştır.'),
      FormulaStep('Emülsifikasyon', 'Az miktardaki suyu yavaşça işleyerek kremi kur.'),
    ],
    refs: ['nrf', 'krem-altmeyer'],
  ),

  // ---------------------------------------------------------------- Antiseptikler
  Formula(
    name: 'Klorheksidinli krem %0,5',
    category: FormulaCategory.krem,
    use: 'Enfeksiyon riski olan küçük yara ve sıyrıklarda antiseptik krem olarak kullanılır.',
    ingredients: [
      Ingredient('Klorheksidin diglukonat çözeltisi %20', '2,66 g'),
      Ingredient('Baz krem (DAC)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Geometrik seyreltme', 'Klorheksidin çözeltisini baz kreme önce az, sonra eşit porsiyonlarla kat.'),
    ],
    refs: ['nrf', 'krem-uksh'],
  ),
  Formula(
    name: 'Klorheksidinli krem %1',
    category: FormulaCategory.krem,
    use: 'Bakteriyel bulaşma riski yüksek deri bölgelerinde daha güçlü antiseptik olarak kullanılır.',
    ingredients: [
      Ingredient('Klorheksidin diglukonat çözeltisi %20', '5,33 g'),
      Ingredient('Baz krem (DAC)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Geometrik seyreltme', 'Çözeltiyi baz kreme azar azar, her seferinde iyice karıştırarak işle.'),
    ],
    refs: ['nrf', 'krem-uksh'],
  ),
  Formula(
    name: 'Salisilik asitli sulu krem %10',
    category: FormulaCategory.krem,
    use: 'Nasır, kallus ve çok kalın pullu deride güçlü keratolitik olarak kullanılır.',
    ingredients: [
      Ingredient('Salisilik asit', '10 g'),
      Ingredient('Sulu krem', '90 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asidi cam olmayan havanda ince toz hâline getir.'),
      FormulaStep('Levigasyon', 'Tozu az miktar kremle pürüzsüz macun yap; çelik spatül kullanma.'),
      FormulaStep('Geometrik seyreltme', 'Macunu kalan kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['krem-dmd', 'apf'],
  ),
  Formula(
    name: 'Üre ve sodyum klorürlü lipofil krem %10',
    category: FormulaCategory.krem,
    use: 'İktiyoz ve çok kalın, pullu ciltte nemlendirici ve keratin yumuşatıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Üre', '10 g'),
      Ingredient('Sodyum klorür', '10 g'),
      Ingredient('Saf su', '30 g'),
      Ingredient('Yün yağı alkolleri merhemi', '50 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Üre ve sodyum klorürü suda çöz.'),
      FormulaStep('Eritme', 'Yün yağı alkolleri merhemini ılık su banyosunda yumuşat.'),
      FormulaStep('Emülsifikasyon', 'Tuzlu çözeltiyi merheme azar azar katıp her porsiyonu iyice işle.'),
      FormulaStep('Soğutma', 'Krem homojen ve soğuk olana dek karıştır.'),
    ],
    refs: ['nrf', 'krem-altmeyer'],
  ),
  Formula(
    name: 'Setrimidli krem %0,5',
    category: FormulaCategory.krem,
    use: 'Küçük kesik, sıyrık ve yanıklarda antiseptik krem olarak kullanılır.',
    ingredients: [
      Ingredient('Setrimid', '0,5 g'),
      Ingredient('Setostearil alkol', '5 g'),
      Ingredient('Sıvı parafin', '50 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Setostearil alkolü sıvı parafinle su banyosunda erit.'),
      FormulaStep('Çözme', 'Setrimidi 70 °C\'deki suda çöz.'),
      FormulaStep('Emülsifikasyon', 'Sıcak setrimid çözeltisini yağ fazına karıştırarak ekle.'),
      FormulaStep('Soğutma', 'Krem kıvam alana kadar karıştır.'),
    ],
    refs: ['bp', 'martindale'],
  ),

  // ---------------------------------------------------------------- Mantar ve parazit
  Formula(
    name: 'Klotrimazollü krem %1',
    category: FormulaCategory.krem,
    use: 'Deri mantarı ve kandida enfeksiyonlarında kullanılır.',
    ingredients: [
      Ingredient('Klotrimazol', '1 g'),
      Ingredient('Noniyonik hidrofil krem (DAB)', '99 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Klotrimazolü havanda ince toz hâline getir.'),
      FormulaStep('Levigasyon', 'Tozu az miktar kremle pürüzsüz macun yap.'),
      FormulaStep('Geometrik seyreltme', 'Macunu kalan kremle eşit porsiyonlarla karıştır.'),
    ],
    refs: ['krem-zl', 'martindale', 'bp'],
  ),
  Formula(
    name: 'Mikonazol nitratlı krem %2',
    category: FormulaCategory.krem,
    use: 'Deri mantarı, pityriasis versikolor ve kandida enfeksiyonlarında kullanılır.',
    ingredients: [
      Ingredient('Mikonazol nitrat', '2 g'),
      Ingredient('Noniyonik hidrofil krem (DAB)', '98 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Mikonazol nitratı havanda ince ez.'),
      FormulaStep('Levigasyon', 'Tozu az miktar kremle macun hâline getir.'),
      FormulaStep('Geometrik seyreltme', 'Macunu kalan kremle azar azar karıştır.'),
    ],
    refs: ['who-mf', 'martindale', 'bp'],
  ),
  Formula(
    name: 'Permetrinli krem %5',
    category: FormulaCategory.krem,
    use: 'Uyuz (skabiyez) tedavisinde bütün vücuda sürülerek kullanılır.',
    ingredients: [
      Ingredient('Permetrin', '5 g'),
      Ingredient('Anyonik hidrofil krem (DAB)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Yarı katı permetrini ılık su banyosunda sıvılaştır.'),
      FormulaStep('Geometrik seyreltme', 'Sıvı permetrini kreme eşit porsiyonlarla karıştır.'),
    ],
    refs: ['who-mf', 'martindale'],
  ),
  Formula(
    name: 'Permetrinli krem %2,5',
    category: FormulaCategory.krem,
    use: 'Bebek ve küçük çocuklarda uyuz tedavisinde düşük güçte kullanılır.',
    ingredients: [
      Ingredient('Permetrin', '2,5 g'),
      Ingredient('Anyonik hidrofil krem (DAB)', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Eritme', 'Permetrini ılık su banyosunda sıvılaştır.'),
      FormulaStep('Geometrik seyreltme', 'Permetrini kreme azar azar, eşit miktarlarla kat.'),
    ],
    refs: ['krem-uksh', 'martindale'],
  ),
  Formula(
    name: 'Krotamitonlu krem %10',
    category: FormulaCategory.krem,
    use: 'Uyuzda ve kaşıntılı deri hastalıklarında kaşıntı giderici olarak kullanılır.',
    ingredients: [
      Ingredient('Krotamiton', '10 g'),
      Ingredient('Sulu krem', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Geometrik seyreltme', 'Yağlı sıvı krotamitonu kreme küçük porsiyonlarla işle.'),
    ],
    refs: ['bp', 'martindale'],
  ),
];
