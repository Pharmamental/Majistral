import '../../models/formula.dart';
import '../../models/prescription.dart';
import '../references.dart';

// Formüller resmî monograflardan (USP–NF, BP, DAC/NRF, PaedForm) ve ders kitaplarından; her biri en az iki kaynakta.
const cozeltiRefs = <Reference>[
  Reference(
    id: 'cozelti-nahata',
    kind: ReferenceKind.kitap,
    citation: 'Nahata MC, Pai VB. Pediatric Drug Formulations, 6. baskı. Harvey Whitney Books, Cincinnati, 2011.',
  ),
  Reference(
    id: 'cozelti-altmeyer',
    kind: ReferenceKind.kitap,
    citation: 'Altmeyer P, Bacharach-Buhles M. Altmeyers Enzyklopädie – Dermatologie: NRF reçete maddeleri '
        '(çevrim içi başvuru kitabı). Ruhr-Universität Bochum kökenli, sürekli güncellenir.',
    url: 'https://www.altmeyers.org',
  ),
  Reference(
    id: 'cozelti-who-handrub',
    kind: ReferenceKind.devlet,
    citation: 'WHO. Guide to Local Production: WHO-recommended Handrub Formulations (WHO/IER/PSP/2010.5). '
        'Dünya Sağlık Örgütü, Cenevre, 2010.',
    url: 'https://www.who.int/publications/i/item/WHO-IER-PSP-2010.5',
  ),
  Reference(
    id: 'cozelti-iarc-kolposkopi',
    kind: ReferenceKind.devlet,
    citation: 'Prendiville W, Sankaranarayanan R. Colposcopy and Treatment of Cervical Precancer, Ek 5. IARC '
        'Technical Publication No. 45. Uluslararası Kanser Araştırma Ajansı (IARC/WHO), Lyon, 2017.',
    url: 'https://publications.iarc.who.int/Book-And-Report-Series/Iarc-Technical-Publications/Colposcopy-And-Treatment-Of-Cervical-Precancer-2017',
  ),
];

const cozeltiFormulas = <Formula>[
  // ---------- Ağızdan alınan çözeltiler ve şuruplar ----------
  Formula(
    name: 'Basit şurup %85',
    category: FormulaCategory.cozelti,
    use: 'Ağızdan alınan sıvı ilaçlarda tatlandırıcı ve taşıyıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Sakkaroz', '85 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Şekeri suyun bir kısmında karıştırarak ve hafifçe ısıtarak tamamen çöz.'),
      FormulaStep('Soğutma', 'Şurubu kapalı kapta oda sıcaklığına kadar soğumaya bırak.'),
      FormulaStep('Hacme tamamlama', 'Soğuyan şurubu saf suyla 100 mL\'ye tamamla.'),
      FormulaStep('Süzme', 'Bulanıklık kalırsa pamuktan süzerek berraklaştır.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Koruyucusuz basit şurup %66,7',
    category: FormulaCategory.cozelti,
    use: 'Çocuk ilaçlarında koruyucu madde içermeyen tatlı taşıyıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Sakkaroz', '66,7 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Şekeri suda ısıtarak, karıştırarak tamamen çöz.'),
      FormulaStep('Soğutma', 'Şurubu kapağı kapalı soğut, buharlaşan suyu kaybetme.'),
      FormulaStep('Hacme tamamlama', 'Kaybolan suyu ekleyip kütleyi 100 g\'a tamamla.'),
    ],
    refs: ['bp', 'edqm-pf'],
  ),
  Formula(
    name: 'Portakal şurubu',
    category: FormulaCategory.cozelti,
    use: 'Acı ilaçların tadını örtmek için tatlandırıcı ve kokulu taşıyıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Tatlı portakal kabuğu tentürü', '5 mL'),
      Ingredient('Susuz sitrik asit', '0,5 g'),
      Ingredient('Talk', '1,5 g'),
      Ingredient('Sakkaroz', '82 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Talkı tentür ve sitrik asitle havanda iyice karıştır, sonra biraz su ekle.'),
      FormulaStep('Süzme', 'Karışımı filtre kâğıdından süzerek yağların bulanıklığını gider.'),
      FormulaStep('Çözme', 'Süzüntüde şekeri ısıtmadan, karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Şurubu filtreden geçirilen suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Modifiye Shohl solüsyonu',
    category: FormulaCategory.cozelti,
    use: 'Böbrek tübüler asidozu gibi metabolik asidozda kanı alkalileştirmek için kullanılır.',
    ingredients: [
      Ingredient('Sitrik asit monohidrat', '14 g'),
      Ingredient('Sodyum sitrat dihidrat', '9,8 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sitrik asidi ve sodyum sitratı suyun yarısında karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Berrak çözeltiyi saf suyla 100 mL\'ye tamamla.'),
      FormulaStep('Süzme', 'Tozdan gelen lifler için çözeltiyi süz.'),
    ],
    refs: ['cozelti-nahata', 'martindale'],
  ),
  Formula(
    name: 'Sodyum sitrat ve sitrik asit oral çözeltisi',
    category: FormulaCategory.cozelti,
    use: 'İdrarı ve kanı alkalileştirmek, böbrek taşını önlemek için kullanılır.',
    ingredients: [
      Ingredient('Sodyum sitrat dihidrat', '10 g'),
      Ingredient('Sitrik asit monohidrat', '6,68 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'İki tuzu suyun bir kısmında karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Çözeltiyi saf suyla 100 mL\'ye tamamla.'),
      FormulaStep('Süzme', 'Berrak olması için çözeltiyi süz.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),
  Formula(
    name: 'Potasyum sitrat ve sitrik asit oral çözeltisi',
    category: FormulaCategory.cozelti,
    use: 'İdrarı alkalileştirmek ve potasyum vermek için böbrek taşı hastalarında kullanılır.',
    ingredients: [
      Ingredient('Potasyum sitrat monohidrat', '22 g'),
      Ingredient('Sitrik asit monohidrat', '6,68 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Potasyum sitratı ve sitrik asidi suyun yarısında karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Çözeltiyi saf suyla 100 mL\'ye tamamla.'),
      FormulaStep('Süzme', 'Çözeltiyi süzerek berraklaştır.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),
  Formula(
    name: 'Sodyum bikarbonat oral çözeltisi %8,4',
    category: FormulaCategory.cozelti,
    use: 'Metabolik asidozda ağızdan bikarbonat vermek için kullanılır (1 mmol/mL).',
    ingredients: [
      Ingredient('Sodyum bikarbonat', '8,4 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Bikarbonatı ısıtmadan, soğuk suda yavaşça karıştırarak çöz; ısı karbondioksit kaçırır.'),
      FormulaStep('Hacme tamamlama', 'Çözeltiyi saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['cozelti-nahata', 'martindale', 'usp-795'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Kafein sitrat oral çözeltisi 20 mg/mL',
    category: FormulaCategory.cozelti,
    use: 'Prematüre bebeklerde apne nöbetlerini azaltmak için kullanılır.',
    ingredients: [
      Ingredient('Susuz kafein', '1 g'),
      Ingredient('Sitrik asit monohidrat', '1 g'),
      Ingredient('Saf su', '25 mL'),
      Ingredient('Basit şurup', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Kafeini ve sitrik asidi suda karıştırarak tamamen çöz.'),
      FormulaStep('Karıştırma', 'Berrak çözeltiye şurubun bir kısmını ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Basit şurupla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'trissel', 'cozelti-nahata'],
  ),
  Formula(
    name: 'Oral rehidrasyon çözeltisi (düşük ozmolarite)',
    category: FormulaCategory.cozelti,
    use: 'İshal ve kusmada kaybedilen su ve tuzları yerine koymak için içirilir.',
    ingredients: [
      Ingredient('Sodyum klorür', '2,6 g'),
      Ingredient('Susuz glukoz', '13,5 g'),
      Ingredient('Potasyum klorür', '1,5 g'),
      Ingredient('Trisodyum sitrat dihidrat', '2,9 g'),
      Ingredient('İçme suyu', 'ad 1000 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Tuzları ve glukozu suyun bir kısmında karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Çözeltiyi suyla tam 1 litreye tamamla; az ya da çok su ozmolariteyi bozar.'),
    ],
    refs: ['who-mf', 'bp', 'martindale'],
  ),
  Formula(
    name: 'Joulie çözeltisi (fosfat oral çözeltisi)',
    category: FormulaCategory.cozelti,
    use: 'Hipofosfatemide ve fosfat kaybettiren raşitizmde ağızdan fosfat vermek için kullanılır.',
    ingredients: [
      Ingredient('Disodyum hidrojen fosfat', '13,6 g'),
      Ingredient('Fosforik asit %85', '5,88 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Disodyum fosfatı suyun bir kısmında karıştırarak çöz.'),
      FormulaStep('Karıştırma', 'Fosforik asidi yavaşça ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Çözeltiyi saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['cozelti-nahata', 'jew'],
  ),
  Formula(
    name: 'Magnezyum sitrat oral çözeltisi',
    category: FormulaCategory.cozelti,
    use: 'Kolonoskopi ve ameliyat öncesinde bağırsağı boşaltmak için müshil olarak içirilir.',
    ingredients: [
      Ingredient('Magnezyum karbonat', '15 g'),
      Ingredient('Susuz sitrik asit', '27,4 g'),
      Ingredient('Basit şurup', '60 mL'),
      Ingredient('Talk', '5 g'),
      Ingredient('Limon yağı', '0,1 mL'),
      Ingredient('Potasyum bikarbonat', '2,5 g'),
      Ingredient('Saf su', 'ad 350 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sitrik asidi sıcak suyun bir kısmında çöz.'),
      FormulaStep('Nötralleştirme', 'Magnezyum karbonatı azar azar ekle, köpüğü bekleyerek tamamen çözünmesini sağla.'),
      FormulaStep('Karıştırma', 'Limon yağını talkla ezip şurupla birlikte çözeltiye kat.'),
      FormulaStep('Süzme', 'Talkı ve bulanıklığı filtre kâğıdından süzerek ayır.'),
      FormulaStep('Hacme tamamlama', 'Kaynatılmış suyla 350 mL\'ye tamamla, şişede bikarbonatı ekleyip hemen kapat.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),

  // ---------- Ağız içi: gargara ve ağız çalkalama ----------
  Formula(
    name: 'Sodyum florür ağız çalkalama çözeltisi %0,05',
    category: FormulaCategory.cozelti,
    use: 'Diş çürüğünü önlemek için her gün ağız çalkalanır, yutulmaz.',
    ingredients: [
      Ingredient('Sodyum florür', '0,05 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sodyum florürü suyun bir kısmında karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Çözeltiyi saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['martindale', 'remington', 'usp-795'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Sodyum florür ağız çalkalama çözeltisi %0,2',
    category: FormulaCategory.cozelti,
    use: 'Diş çürüğünü önlemek için haftada bir ağız çalkalanır, yutulmaz.',
    ingredients: [
      Ingredient('Sodyum florür', '0,2 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sodyum florürü suda karıştırarak tamamen çöz.'),
      FormulaStep('Hacme tamamlama', 'Çözeltiyi saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['martindale', 'remington', 'usp-795'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Klorheksidin glukonat gargarası %0,2',
    category: FormulaCategory.cozelti,
    use: 'Diş eti iltihabında ve ağız yarasında mikropları azaltmak için gargara yapılır.',
    ingredients: [
      Ingredient('Klorheksidin glukonat çözeltisi %20', '1 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Klorheksidin çözeltisini suyun bir kısmına ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['bp', 'martindale', 'usp-795'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Klorheksidin glukonat ağız çalkalama çözeltisi %0,12',
    category: FormulaCategory.cozelti,
    use: 'Diş eti iltihabını ve plak oluşumunu azaltmak için ağız çalkalanır.',
    ingredients: [
      Ingredient('Klorheksidin glukonat çözeltisi %20', '0,6 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Klorheksidin çözeltisini suyun bir kısmında karıştırarak seyrelt.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'martindale', 'usp-795'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Povidon iyot gargarası %1',
    category: FormulaCategory.cozelti,
    use: 'Ağız ve boğaz enfeksiyonlarında antiseptik olarak gargara yapılır, yutulmaz.',
    ingredients: [
      Ingredient('Povidon iyot', '1 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Povidon iyodu suyun bir kısmında yavaşça karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['bp', 'martindale', 'usp-795'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),

  // ---------- Deri üzerine: antiseptik ve ilaçlı çözeltiler ----------
  Formula(
    name: 'Povidon iyot topikal çözeltisi %10',
    category: FormulaCategory.cozelti,
    use: 'Yara ve ameliyat öncesi deri antisepsisinde kullanılır.',
    ingredients: [
      Ingredient('Povidon iyot', '10 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Povidon iyodu suya azar azar serpip topaklanmadan karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'martindale', 'usp-795'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Hidrojen peroksit çözeltisi %3',
    category: FormulaCategory.cozelti,
    use: 'Küçük yaraları temizlemek için köpürtücü antiseptik olarak kullanılır.',
    ingredients: [
      Ingredient('Hidrojen peroksit çözeltisi %30', '10 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Derişik peroksidi eldivenle, suyun içine yavaşça ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'tf', 'martindale'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Hidrojen peroksit çözeltisi %6',
    category: FormulaCategory.cozelti,
    use: 'Kullanmadan önce seyreltilerek ağız çalkalama ve yara temizliği için kullanılır.',
    ingredients: [
      Ingredient('Hidrojen peroksit çözeltisi %30', '20 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Derişik peroksidi suyun içine yavaşça döküp karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['bp', 'martindale'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Lugol çözeltisi (kuvvetli iyot çözeltisi %5)',
    category: FormulaCategory.cozelti,
    use: 'Tiroit ameliyatı öncesinde ve iyot desteği için ağızdan damla olarak verilir.',
    ingredients: [
      Ingredient('İyot', '5 g'),
      Ingredient('Potasyum iyodür', '10 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Potasyum iyodürü çok az suda çöz, iyodu bu derişik çözeltide karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'İyot tamamen çözününce saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'bp'],
  ),
  Formula(
    name: 'İyot tentürü %2',
    category: FormulaCategory.cozelti,
    use: 'Küçük kesik ve sıyrıklarda deri antiseptiği olarak sürülür.',
    ingredients: [
      Ingredient('İyot', '2 g'),
      Ingredient('Sodyum iyodür', '2,4 g'),
      Ingredient('Etanol %96', '50 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'İyodu ve sodyum iyodürü alkolde karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'İyot topikal çözeltisi %2 (sulu)',
    category: FormulaCategory.cozelti,
    use: 'Alkol yakmasın diye açık yarada sulu iyotlu antiseptik olarak kullanılır.',
    ingredients: [
      Ingredient('İyot', '2 g'),
      Ingredient('Sodyum iyodür', '2,4 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sodyum iyodürü az suda çöz, iyodu bu çözeltide karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Salisilik asitli yağ %10',
    category: FormulaCategory.cozelti,
    use: 'Sedef hastalığında ve saçlı derideki kalın pulları yumuşatıp kaldırmak için sürülür.',
    ingredients: [
      Ingredient('Salisilik asit', '10 g'),
      Ingredient('Rafine hint yağı', '60 g'),
      Ingredient('Oktildodekanol', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Salisilik asit kristallerini havanda ince toz olana dek ez.'),
      FormulaStep('Çözme', 'Tozu hint yağında hafifçe ısıtarak, karıştırarak tamamen çöz.'),
      FormulaStep('Soğutma', 'Berrak çözeltiyi karıştırarak oda sıcaklığına soğut.'),
      FormulaStep('Hacme tamamlama', 'Oktildodekanolle 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Eozin çözeltisi %1 (sulu)',
    category: FormulaCategory.cozelti,
    use: 'Bebeklerde pişik ve sulanan deri kıvrımlarında kurutucu, antiseptik boya olarak sürülür.',
    ingredients: [
      Ingredient('Eozin disodyum', '1 g'),
      Ingredient('Susuz sitrik asit', '0,0175 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sitrik asidi ve eozini suyun bir kısmında karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 g\'a tamamla.'),
      FormulaStep('Süzme', 'Çözünmeyen boya tanesi kalmasın diye süz.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Alüminyum subasetat çözeltisi',
    category: FormulaCategory.cozelti,
    use: 'Burow çözeltisinin hazırlanmasında kullanılan büzücü ara çözeltidir.',
    ingredients: [
      Ingredient('Alüminyum sülfat', '14,5 g'),
      Ingredient('Asetik asit %36', '16 mL'),
      Ingredient('Çöktürülmüş kalsiyum karbonat', '7 g'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Alüminyum sülfatı soğuk suyun bir kısmında çöz.'),
      FormulaStep('Karıştırma', 'Asetik asidi ekleyip karıştır.'),
      FormulaStep('Nötralleştirme', 'Kalsiyum karbonatı suyla bulamaç yapıp azar azar ekle, köpük bitene dek karıştır.'),
      FormulaStep('Süzme', 'Bir gece bekletip çöken kalsiyum sülfatı süzerek ayır.'),
      FormulaStep('Hacme tamamlama', 'Çökeltiyi suyla yıkayıp süzüntüyü 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Burow çözeltisi (alüminyum asetat topikal çözeltisi)',
    category: FormulaCategory.cozelti,
    use: 'Sulanan egzama ve böcek sokmasında seyreltilip büzücü kompres olarak uygulanır.',
    ingredients: [
      Ingredient('Alüminyum subasetat çözeltisi', '54,5 mL'),
      Ingredient('Buzlu asetik asit', '1,5 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Subasetat çözeltisine buzlu asetik asidi ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
      FormulaStep('Süzme', 'Bulanıklık varsa süzerek berraklaştır.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Alüminyum klorür hekzahidrat çözeltisi %20 (izopropanollü)',
    category: FormulaCategory.cozelti,
    use: 'Koltuk altı, el ve ayakta aşırı terlemede gece kuru deriye sürülür.',
    ingredients: [
      Ingredient('Alüminyum klorür hekzahidrat', '20 g'),
      Ingredient('Saf su', '20 g'),
      Ingredient('İzopropil alkol', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Alüminyum klorürü suda karıştırarak çöz.'),
      FormulaStep('Karıştırma', 'İzopropil alkolü azar azar ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'İzopropil alkolle 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer', 'martindale', 'usp-795'],
    shelfLife: '35 gün, oda sıcaklığında ya da buzdolabında (sulu, koruyuculu; USP <795>)',
  ),
  Formula(
    name: 'Alüminyum klorür hekzahidrat çözeltisi %15 (izopropanollü)',
    category: FormulaCategory.cozelti,
    use: 'Hassas derili hastalarda aşırı terlemeyi azaltmak için daha düşük güçte kullanılır.',
    ingredients: [
      Ingredient('Alüminyum klorür hekzahidrat', '15 g'),
      Ingredient('Saf su', '15 g'),
      Ingredient('İzopropil alkol', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Alüminyum klorürü suda tamamen çöz.'),
      FormulaStep('Karıştırma', 'İzopropil alkolü yavaşça ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'İzopropil alkolle 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer', 'usp-795'],
    shelfLife: '35 gün, oda sıcaklığında ya da buzdolabında (sulu, koruyuculu; USP <795>)',
  ),
  Formula(
    name: 'Eozin çözeltisi %2 (sulu)',
    category: FormulaCategory.cozelti,
    use: 'Pişik ve sulanan deri bölgelerinde kurutucu, antiseptik boya olarak sürülür.',
    ingredients: [
      Ingredient('Eozin disodyum', '2 g'),
      Ingredient('Susuz sitrik asit', '0,025 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sitrik asidi ve eozini suyun bir kısmında karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 g\'a tamamla.'),
      FormulaStep('Süzme', 'Çözünmeyen boya tanesi kalmasın diye süz.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Eozin çözeltisi %1 (etanollü)',
    category: FormulaCategory.cozelti,
    use: 'Bakteri üremesi riski az olsun diye alkollü taşıyıcıda antiseptik boya olarak kullanılır.',
    ingredients: [
      Ingredient('Eozin disodyum', '1 g'),
      Ingredient('Etanol %96', '20 g'),
      Ingredient('Susuz sitrik asit', '0,04 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Eozini ve sitrik asidi suyun bir kısmında çöz.'),
      FormulaStep('Karıştırma', 'Etanolü ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Etakridin laktat çözeltisi %0,1',
    category: FormulaCategory.cozelti,
    use: 'Enfekte, sulanan deri yaralarında antiseptik kompres olarak kullanılır.',
    ingredients: [
      Ingredient('Etakridin laktat monohidrat', '0,1 g'),
      Ingredient('Etanol %90', '20 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Etakridin laktatı ılık suyun bir kısmında çöz.'),
      FormulaStep('Karıştırma', 'Etanolü ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Etakridin laktat çözeltisi %0,05',
    category: FormulaCategory.cozelti,
    use: 'Hassas ve geniş yaralarda daha seyreltik antiseptik kompres olarak kullanılır.',
    ingredients: [
      Ingredient('Etakridin laktat monohidrat', '0,05 g'),
      Ingredient('Etanol %90', '20 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Etakridin laktatı ılık suda karıştırarak çöz.'),
      FormulaStep('Karıştırma', 'Etanolü ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Klotrimazol çözeltisi %1',
    category: FormulaCategory.cozelti,
    use: 'Deri ve tırnak çevresi mantar enfeksiyonlarında ince tabaka sürülür.',
    ingredients: [
      Ingredient('Klotrimazol', '1 g'),
      Ingredient('Makrogol 400', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Klotrimazolü makrogolün bir kısmında karıştırarak tamamen çöz.'),
      FormulaStep('Hacme tamamlama', 'Makrogol 400 ile 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Salisilik asitli izopropanol spiriti %2',
    category: FormulaCategory.cozelti,
    use: 'Saçlı deride kepek ve pullanmayı gidermek için keratolitik olarak sürülür.',
    ingredients: [
      Ingredient('Salisilik asit', '2 g'),
      Ingredient('Saf su', '36,5 g'),
      Ingredient('İzopropil alkol', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Salisilik asidi izopropil alkolün bir kısmında karıştırarak çöz.'),
      FormulaStep('Karıştırma', 'Suyu azar azar ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'İzopropil alkolle 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer', 'usp-795'],
    shelfLife: '35 gün, oda sıcaklığında ya da buzdolabında (sulu, koruyuculu; USP <795>)',
  ),
  Formula(
    name: 'Salisilik asitli akne spiriti %5',
    category: FormulaCategory.cozelti,
    use: 'Aknede gözenek tıkacını açmak için yüze ince sürülür.',
    ingredients: [
      Ingredient('Salisilik asit', '5 g'),
      Ingredient('Propilen glikol', '10 g'),
      Ingredient('İzopropil alkol', '40 g'),
      Ingredient('Saf su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Salisilik asidi izopropil alkol ve propilen glikolde karıştırarak çöz.'),
      FormulaStep('Karıştırma', 'Suyu yavaşça ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer', 'usp-795'],
    shelfLife: '35 gün, oda sıcaklığında ya da buzdolabında (sulu, koruyuculu; USP <795>)',
  ),
  Formula(
    name: 'Minoksidil saç spiriti %5',
    category: FormulaCategory.cozelti,
    use: 'Erkek tipi saç dökülmesinde saçlı deriye günde iki kez sürülür.',
    ingredients: [
      Ingredient('Minoksidil', '5 g'),
      Ingredient('İzopropil palmitat', '1 g'),
      Ingredient('Makrogol-40-gliserol hidroksistearat', '2,5 g'),
      Ingredient('Propilen glikol', '15 g'),
      Ingredient('Etanol %70', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Minoksidili propilen glikol ve etanolün bir kısmında karıştırarak çöz.'),
      FormulaStep('Karıştırma', 'İzopropil palmitatı ve makrogol türevini ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Etanol %70 ile 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Minoksidil saç spiriti %2',
    category: FormulaCategory.cozelti,
    use: 'Kadın tipi saç dökülmesinde saçlı deriye günde iki kez sürülür.',
    ingredients: [
      Ingredient('Minoksidil', '2 g'),
      Ingredient('İzopropil palmitat', '1 g'),
      Ingredient('Makrogol-40-gliserol hidroksistearat', '2,5 g'),
      Ingredient('Propilen glikol', '7,5 g'),
      Ingredient('Etanol %70', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Minoksidili propilen glikol ve etanolde karıştırarak çöz.'),
      FormulaStep('Karıştırma', 'İzopropil palmitatı ve makrogol türevini ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Etanol %70 ile 100 g\'a tamamla.'),
    ],
    refs: ['nrf', 'cozelti-altmeyer'],
  ),
  Formula(
    name: 'Kalsiyum hidroksit çözeltisi (kireç suyu)',
    category: FormulaCategory.cozelti,
    use: 'Losyon ve linimentlerde yağı sabunlaştırarak emülsiyon kurmak için ve yumuşak alkali olarak kullanılır.',
    ingredients: [
      Ingredient('Kalsiyum hidroksit', '0,3 g'),
      Ingredient('Saf su', '100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Kalsiyum hidroksidi soğuk suyla kapalı şişede bir saat boyunca ara ara çalkala.'),
      FormulaStep('Süzme', 'Fazla kireç çökünce üstteki berrak doymuş çözeltiyi ayırıp kullan.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),

  // ---------- Aromatik sular, ruhlar ve linimentler ----------
  Formula(
    name: 'Nane suyu %0,2',
    category: FormulaCategory.cozelti,
    use: 'Ağızdan alınan sıvılara ferahlık ve tat vermek için taşıyıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Nane yağı', '0,2 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Nane yağını suyla şişede uzun süre kuvvetle çalkala, birkaç saat beklet.'),
      FormulaStep('Süzme', 'Çözünmeyen yağ damlacıklarını ıslatılmış filtreden süzerek ayır.'),
      FormulaStep('Hacme tamamlama', 'Filtreden su geçirerek 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Kafur ruhu %10',
    category: FormulaCategory.cozelti,
    use: 'Kas ve eklem ağrısında deriye ovularak hafif kızartıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Kafur', '10 g'),
      Ingredient('Etanol %96', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Kafuru alkolün bir kısmında karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Etanolle 100 mL\'ye tamamla.'),
      FormulaStep('Süzme', 'Kâğıttan süzerek berraklaştır.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Metil salisilat linimenti %25',
    category: FormulaCategory.cozelti,
    use: 'Kas ve eklem ağrısında deriye ovularak sıcaklık veren ağrı kesici olarak kullanılır.',
    ingredients: [
      Ingredient('Metil salisilat', '25 mL'),
      Ingredient('Yer fıstığı yağı', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Metil salisilatı yağın bir kısmına ekleyip homojen olana dek karıştır.'),
      FormulaStep('Hacme tamamlama', 'Yer fıstığı yağıyla 100 mL\'ye tamamla.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Aromatik amonyak ruhu',
    category: FormulaCategory.cozelti,
    use: 'Bayılma hissinde koklatılarak refleks uyarıcı olarak kullanılır.',
    ingredients: [
      Ingredient('Amonyum karbonat', '3,4 g'),
      Ingredient('Kuvvetli amonyak çözeltisi', '9 mL'),
      Ingredient('Limon yağı', '1 mL'),
      Ingredient('Lavanta yağı', '0,1 mL'),
      Ingredient('Muskat yağı', '0,1 mL'),
      Ingredient('Etanol %96', '70 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Amonyum karbonatı amonyak çözeltisi ve suyun bir kısmında çöz, kapalı kapta beklet.'),
      FormulaStep('Karıştırma', 'Uçucu yağları alkolde çözüp sulu çözeltiye ekleyerek karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
      FormulaStep('Süzme', 'Bir gün bekletip kapalı huniden süz.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  Formula(
    name: 'Yeşil sabun tentürü',
    category: FormulaCategory.cozelti,
    use: 'Kepek ve yağlı saçlı deride temizleyici şampuan olarak kullanılır.',
    ingredients: [
      Ingredient('Yeşil sabun', '65 g'),
      Ingredient('Lavanta yağı', '2 mL'),
      Ingredient('Etanol %96', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Lavanta yağını alkolün bir kısmıyla karıştır.'),
      FormulaStep('Çözme', 'Yeşil sabunu bu alkolde karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Etanolle 100 mL\'ye tamamla.'),
      FormulaStep('Süzme', 'Bir gün bekletip pamuktan süz.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),

  // ---------- Kulak damlaları ----------
  Formula(
    name: 'Sodyum bikarbonat kulak damlası %5',
    category: FormulaCategory.cozelti,
    use: 'Sertleşmiş kulak kirini yumuşatıp çıkarmak için kulağa damlatılır.',
    ingredients: [
      Ingredient('Sodyum bikarbonat', '5 g'),
      Ingredient('Gliserol', '30 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Bikarbonatı ısıtmadan yaklaşık 60 mL suda çöz.'),
      FormulaStep('Karıştırma', 'Gliserolü ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['bp', 'martindale', 'usp-795'],
    shelfLife: '14 gün, buzdolabında (sulu, koruyucusuz; USP <795>)',
  ),
  Formula(
    name: 'Asetik asit kulak çözeltisi %2',
    category: FormulaCategory.cozelti,
    use: 'Dış kulak yolu iltihabında asit ortam kurarak mikropları baskılamak için damlatılır.',
    ingredients: [
      Ingredient('Buzlu asetik asit', '2 g'),
      Ingredient('Propilen glikol', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Asetik asidi propilen glikolün bir kısmına ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Propilen glikolle 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'martindale'],
    shelfLife: '180 gün, oda sıcaklığında, sıkı kapalı (susuz; USP <795>)',
  ),
  Formula(
    name: 'Karbamid peroksit kulak damlası %6,5',
    category: FormulaCategory.cozelti,
    use: 'Kulak kirini köpürterek yumuşatmak ve çıkarmak için kulağa damlatılır.',
    ingredients: [
      Ingredient('Karbamid peroksit', '6,5 g'),
      Ingredient('Susuz gliserol', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Ezme', 'Karbamid peroksit kristallerini kuru havanda ince toz olana dek ez.'),
      FormulaStep('Çözme', 'Tozu susuz gliserolde ısıtmadan, karıştırarak çöz.'),
      FormulaStep('Hacme tamamlama', 'Susuz gliserolle 100 g\'a tamamla.'),
    ],
    refs: ['usp-nf', 'martindale'],
  ),

  // ---------- Boyalar ve kolodyonlar ----------
  Formula(
    name: 'Salisilik asitli kolodyon %12',
    category: FormulaCategory.cozelti,
    use: 'Siğil ve nasırları yumuşatıp soymak için yalnız üzerine sürülür.',
    ingredients: [
      Ingredient('Salisilik asit', '12 g'),
      Ingredient('Esnek kolodyon', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Salisilik asidi ateşten uzakta esnek kolodyonun bir kısmında çöz.'),
      FormulaStep('Hacme tamamlama', 'Esnek kolodyonla 100 mL\'ye tamamla, şişeyi hemen kapat.'),
    ],
    refs: ['bp', 'martindale'],
  ),
  Formula(
    name: 'Esnek kolodyon',
    category: FormulaCategory.cozelti,
    use: 'Deride çatlamayan koruyucu bir zar bırakır, siğil boyalarına taşıyıcı olur.',
    ingredients: [
      Ingredient('Kafur', '2 g'),
      Ingredient('Hint yağı', '3 g'),
      Ingredient('Kolodyon', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Çözme', 'Kafuru kolodyonun bir kısmında ateşten uzakta çöz.'),
      FormulaStep('Karıştırma', 'Hint yağını ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Kolodyonla 100 g\'a tamamla, buharlaşmasın diye hemen kapat.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),

  // ---------- Alkoller ----------
  Formula(
    name: 'Etanol %70',
    category: FormulaCategory.cozelti,
    use: 'Deri ve küçük alet antisepsisinde en etkili alkol derişimi olarak kullanılır.',
    ingredients: [
      Ingredient('Etanol %96', '72,9 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Alkolü suyla karıştır; karışım ısınır ve hacmi biraz küçülür.'),
      FormulaStep('Soğutma', 'Karışımı oda sıcaklığına soğumaya bırak.'),
      FormulaStep('Hacme tamamlama', 'Soğuyunca saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['tf', 'remington'],
    shelfLife: '35 gün, oda sıcaklığında ya da buzdolabında (sulu, koruyuculu; USP <795>)',
  ),
  Formula(
    name: 'İzopropil alkol %70',
    category: FormulaCategory.cozelti,
    use: 'Deri silmek ve ovma alkolü olarak kullanılır.',
    ingredients: [
      Ingredient('İzopropil alkol', '70 mL'),
      Ingredient('Saf su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'İzopropil alkolü suyla karıştır.'),
      FormulaStep('Soğutma', 'Karışımın sıcaklığı oda sıcaklığına dönsün.'),
      FormulaStep('Hacme tamamlama', 'Saf suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['usp-nf', 'remington'],
  ),
  // ---------- 62 maddeye çıkış (2026-10-29): eldeki maddelerle yapılabilen yeni formüller ----------
  Formula(
    name: 'Benzoik asit çözeltisi %5',
    category: FormulaCategory.cozelti,
    use: 'Ağızdan alınan karışımlara az miktarda katılan koruyucu stok çözeltidir; mantar ve küf üremesini önler.',
    ingredients: [
      Ingredient('Benzoik asit', '5 g'),
      Ingredient('Propilen glikol', '75 mL'),
      Ingredient('Arıtılmış su (kaynatılıp soğutulmuş)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Benzoik asidi propilen glikolde karıştırarak tamamen çöz.'),
      FormulaStep('Hacme tamamlama', 'Suyu küçük paylarla, durmadan karıştırarak ekle ve 100 mL\'ye tamamla.'),
    ],
    refs: ['bp', 'suspansiyon-bpc1973'],
    shelfLife: '35 gün, oda sıcaklığında, sıkı kapalı (sulu, koruyuculu; USP <795>)',
  ),
  Formula(
    name: 'Etanollü el antiseptiği %80 (WHO)',
    category: FormulaCategory.cozelti,
    use: 'Sağlık çalışanlarının ellerini yıkamadan, ovarak mikroptan arındırmak için kullanılır.',
    ingredients: [
      Ingredient('Etanol %96', '83,33 mL'),
      Ingredient('Hidrojen peroksit %3', '4,17 mL'),
      Ingredient('Gliserol %98', '1,45 mL'),
      Ingredient('Arıtılmış su (steril ya da kaynatılıp soğutulmuş)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Etanole önce hidrojen peroksidi, sonra gliserolü ekle; gliserol kalıbını biraz suyla çalkalayıp kaba boşalt.'),
      FormulaStep('Hacme tamamlama', 'Suyla 100 mL\'ye tamamla, kapağı hemen kapatıp hafifçe çalkala.'),
    ],
    refs: ['cozelti-who-handrub', 'fnfb3'],
    shelfLife: '35 gün, oda sıcaklığında, sıkı kapalı (etanol ≥%40, koruyuculu; USP <795>); kullanmadan önce 72 saat bekletilir (WHO)',
  ),
  Formula(
    name: 'İzopropanollü el antiseptiği %75 (WHO)',
    category: FormulaCategory.cozelti,
    use: 'Etanol bulunmadığında ellerin yıkamadan, ovarak mikroptan arındırılması için kullanılır.',
    ingredients: [
      Ingredient('İzopropil alkol %99,8', '75,15 mL'),
      Ingredient('Hidrojen peroksit %3', '4,17 mL'),
      Ingredient('Gliserol %98', '1,45 mL'),
      Ingredient('Arıtılmış su (steril ya da kaynatılıp soğutulmuş)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'İzopropil alkole hidrojen peroksidi ve gliserolü ekleyip karıştır.'),
      FormulaStep('Hacme tamamlama', 'Suyla 100 mL\'ye tamamla, buharlaşmasın diye kapağı hemen kapat.'),
    ],
    refs: ['cozelti-who-handrub', 'fnfb3'],
    shelfLife: '35 gün, oda sıcaklığında, sıkı kapalı (izopropanol ≥%40, koruyuculu; USP <795>); kullanmadan önce 72 saat bekletilir (WHO)',
  ),
  Formula(
    name: 'Asetik asit çözeltisi %5 (kolposkopi)',
    category: FormulaCategory.cozelti,
    use: 'Kolposkopide rahim ağzına sürülür; anormal hücreli alanlar beyazlaşarak görünür olur.',
    ingredients: [
      Ingredient('Buzlu asetik asit', '5 mL'),
      Ingredient('Distile su', '95 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Asidi suyun içine dikkatle ekle, tersini yapma; iyice karıştır.'),
      FormulaStep('Hacme tamamlama', 'Distile suyla 100 mL\'ye tamamla.'),
    ],
    refs: ['cozelti-iarc-kolposkopi', 'fnfb3'],
    shelfLife: 'Aynı gün; artan çözelti gün sonunda atılır (IARC)',
  ),
];
