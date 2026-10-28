import '../../models/formula.dart';
import '../../models/prescription.dart';
import '../references.dart';

// Formüller BP/BPC monograflarından, DAC/NRF'den ve hakemli stabilite çalışmalarından (Trissel'de derli) alındı.
const suspansiyonRefs = <Reference>[
  Reference(
    id: 'suspansiyon-bpc1973',
    kind: ReferenceKind.farmakope,
    citation: 'British Pharmaceutical Codex 1973. Pharmaceutical Society of Great Britain, The Pharmaceutical '
        'Press, Londra, 1973.',
  ),
  Reference(
    id: 'suspansiyon-marriott',
    kind: ReferenceKind.kitap,
    citation: 'Marriott JF, Wilson KA, Langley CA, Belcher D. Pharmaceutical Compounding and Dispensing, '
        '2. baskı. Pharmaceutical Press, Londra, 2010.',
  ),
  Reference(
    id: 'suspansiyon-allen-1996a',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr, Erickson MA. Stability of acetazolamide, allopurinol, azathioprine, clonazepam, and '
        'flucytosine in extemporaneously compounded oral liquids. Am J Health-Syst Pharm 1996;53(16):1944-9.',
  ),
  Reference(
    id: 'suspansiyon-allen-1996b',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr, Erickson MA. Stability of baclofen, captopril, diltiazem hydrochloride, '
        'dipyridamole, and flecainide acetate in extemporaneously compounded oral liquids. '
        'Am J Health-Syst Pharm 1996;53(18):2179-84.',
  ),
  Reference(
    id: 'suspansiyon-allen-1996c',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr, Erickson MA. Stability of ketoconazole, metolazone, metronidazole, procainamide '
        'hydrochloride, and spironolactone in extemporaneously compounded oral liquids. '
        'Am J Health-Syst Pharm 1996;53(17):2073-8.',
  ),
  Reference(
    id: 'suspansiyon-allen-1996d',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr, Erickson MA. Stability of labetalol hydrochloride, metoprolol tartrate, verapamil '
        'hydrochloride, and spironolactone with hydrochlorothiazide in extemporaneously compounded oral liquids. '
        'Am J Health-Syst Pharm 1996;53(19):2304-9.',
  ),
  Reference(
    id: 'suspansiyon-allen-1998a',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr, Erickson MA. Stability of alprazolam, chloroquine phosphate, cisapride, enalapril '
        'maleate, and hydralazine hydrochloride in extemporaneously compounded oral liquids. '
        'Am J Health-Syst Pharm 1998;55(18):1915-20.',
  ),
  Reference(
    id: 'suspansiyon-allen-1998b',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr, Erickson MA. Stability of bethanechol chloride, pyrazinamide, quinidine sulfate, '
        'rifampin, and tetracycline hydrochloride in extemporaneously compounded oral liquids. '
        'Am J Health-Syst Pharm 1998;55(17):1804-9.',
  ),
  Reference(
    id: 'suspansiyon-nahata-amlodipin',
    kind: ReferenceKind.makale,
    citation: 'Nahata MC, Morosco RS, Hipple TF. Stability of amlodipine besylate in two liquid dosage forms. '
        'J Am Pharm Assoc 1999;39(3):375-7.',
  ),
  Reference(
    id: 'suspansiyon-nahata-sildenafil',
    kind: ReferenceKind.makale,
    citation: 'Nahata MC, Morosco RS, Brady MT. Extemporaneous sildenafil citrate oral suspensions for the '
        'treatment of pulmonary hypertension in children. Am J Health-Syst Pharm 2006;63(3):254-7.',
  ),
  Reference(
    id: 'suspansiyon-pettit-tadalafil',
    kind: ReferenceKind.makale,
    citation: 'Pettit RS, Johnson CE, Caruthers RL. Stability of an extemporaneously prepared tadalafil '
        'suspension. Am J Health-Syst Pharm 2012;69(7):592-4.',
  ),
  Reference(
    id: 'suspansiyon-uspharmacist-tadalafil',
    kind: ReferenceKind.makale,
    citation: 'Allen LV Jr. Tadalafil 5 mg/mL Oral Suspension. U.S. Pharmacist, Contemporary Compounding, 2012.',
    url: 'https://www.uspharmacist.com/article/tadalafil-5-mgml-oral-suspension',
  ),
  Reference(
    id: 'suspansiyon-quercia-granisetron',
    kind: ReferenceKind.makale,
    citation: 'Quercia RA, Zhang J, Fan C, Chow MSS. Stability of granisetron hydrochloride in an '
        'extemporaneously prepared oral liquid. Am J Health-Syst Pharm 1997;54(12):1404-6.',
  ),
  Reference(
    id: 'suspansiyon-johnson-ursodiol',
    kind: ReferenceKind.makale,
    citation: 'Johnson CE, Nesbitt J. Stability of ursodiol in an extemporaneously compounded oral liquid. '
        'Am J Health-Syst Pharm 1995;52(16):1798-1800.',
  ),
  Reference(
    id: 'suspansiyon-nhs-dmd',
    kind: ReferenceKind.devlet,
    citation: 'NHS Dictionary of Medicines and Devices (dm+d): Magnesium hydroxide mixture BP, bileşim kaydı. '
        'NHS Business Services Authority.',
    url: 'https://dmd-browser.nhsbsa.nhs.uk/vmp/view/2610',
  ),
  Reference(
    id: 'suspansiyon-abdelrahman-terbinafin',
    kind: ReferenceKind.makale,
    citation: 'Abdel-Rahman SM, Nahata MC. Stability of terbinafine hydrochloride in an extemporaneously '
        'prepared oral suspension at 25 and 4 °C. Am J Health-Syst Pharm 1999;56(3):243-5.',
  ),
  Reference(
    id: 'suspansiyon-digiacinto-ppi',
    kind: ReferenceKind.makale,
    citation: 'DiGiacinto JL, Olsen KM, Bergman KL, Hoie EB. Stability of suspension formulations of '
        'lansoprazole and omeprazole stored in amber-colored plastic oral syringes. '
        'Ann Pharmacother 2000;34(5):600-5.',
  ),
  Reference(
    id: 'suspansiyon-ferron-pantoprazol',
    kind: ReferenceKind.makale,
    citation: 'Ferron GM, Ku S, Abell M ve ark. Oral bioavailability of pantoprazole suspended in sodium '
        'bicarbonate solution. Am J Health-Syst Pharm 2003;60(13):1324-9.',
  ),
  Reference(
    id: 'suspansiyon-dentinger-famotidin',
    kind: ReferenceKind.makale,
    citation: 'Dentinger PJ, Swenson CF, Anaizi NH. Stability of famotidine in an extemporaneously compounded '
        'oral liquid. Am J Health-Syst Pharm 2000;57(14):1340-2.',
  ),
  Reference(
    id: 'suspansiyon-ensom-propranolol',
    kind: ReferenceKind.makale,
    citation: 'Ensom MHH, Kendrick J, Rudolph S, Decarie D. Stability of propranolol in extemporaneously '
        'compounded suspensions. Can J Hosp Pharm 2013;66(2):118-24.',
    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC3633496/',
  ),
  Reference(
    id: 'suspansiyon-skillman-klopidogrel',
    kind: ReferenceKind.makale,
    citation: 'Skillman KL, Caruthers RL, Johnson CE. Stability of an extemporaneously prepared clopidogrel '
        'oral suspension. Am J Health-Syst Pharm 2010;67(7):559-61.',
  ),
  Reference(
    id: 'suspansiyon-donnelly-selekoksib',
    kind: ReferenceKind.makale,
    citation: 'Donnelly RF, Pascuet E, Ma C, Vaillancourt R. Stability of celecoxib oral suspension. '
        'Can J Hosp Pharm 2009;62(6):464-8.',
    url: 'https://cjhp-online.ca/index.php/cjhp/article/view/844',
  ),
  Reference(
    id: 'suspansiyon-mallett-ursodiol',
    kind: ReferenceKind.makale,
    citation: 'Mallett MS, Hagan RL, Peters DA. Stability of ursodiol 25 mg/mL in an extemporaneously '
        'prepared oral liquid. Am J Health-Syst Pharm 1997;54(12):1401-4.',
  ),
  Reference(
    id: 'suspansiyon-fish-sumatriptan',
    kind: ReferenceKind.makale,
    citation: 'Fish DN, Beall HD, Goodwin SD, Fincham JE. Stability of sumatriptan succinate in '
        'extemporaneously prepared oral liquids. Am J Health-Syst Pharm 1997;54(14):1619-22.',
  ),
  Reference(
    id: 'suspansiyon-williams-ondansetron',
    kind: ReferenceKind.makale,
    citation: 'Williams CL, Sanders PL, Laizure SC, Stevens RC, Fox JL. Stability of ondansetron hydrochloride '
        'in syrups compounded from tablets. Am J Hosp Pharm 1994;51(6):806-9.',
  ),
  Reference(
    id: 'suspansiyon-fda-lisinopril',
    kind: ReferenceKind.devlet,
    citation: 'Prinivil / Zestril (lisinopril) ürün bilgisi, "Preparation of Suspension" bölümü. ABD Gıda ve '
        'İlaç Dairesi (FDA) onaylı etiket.',
    url: 'https://dailymed.nlm.nih.gov/dailymed/search.cfm?query=lisinopril',
  ),
  Reference(
    id: 'suspansiyon-fda-losartan',
    kind: ReferenceKind.devlet,
    citation: 'Cozaar (losartan potasyum) ürün bilgisi, "Preparation of Suspension" bölümü. ABD Gıda ve İlaç '
        'Dairesi (FDA) onaylı etiket.',
    url: 'https://dailymed.nlm.nih.gov/dailymed/search.cfm?query=cozaar',
  ),
  Reference(
    id: 'suspansiyon-bauer',
    kind: ReferenceKind.kitap,
    citation: 'Bauer KH, Frömming KH, Führer C. Lehrbuch der Pharmazeutischen Technologie, 9. baskı. '
        'Wissenschaftliche Verlagsgesellschaft, Stuttgart, 2012.',
  ),
  Reference(
    id: 'suspansiyon-saeyoon-sildenafil',
    kind: ReferenceKind.makale,
    citation: 'Sae Yoon A, Sawatdee S, Woradechakul C, Sae Chee K, Atipairin A. Physicochemical and microbiological '
        'stability of the extemporaneous sildenafil citrate oral suspension. Sci Pharm 2015;83(4):659-70.',
    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC4727739/',
  ),
  Reference(
    id: 'suspansiyon-usp-lansoprazol',
    kind: ReferenceKind.farmakope,
    citation: 'USP–NF, Lansoprazole Compounded Oral Suspension monografı. United States Pharmacopeial Convention.',
    url: 'https://www.usp.org',
  ),
  Reference(
    id: 'suspansiyon-morrison-lansoprazol',
    kind: ReferenceKind.makale,
    citation: 'Morrison JT, Lugo RA, Thigpen JC, Brown SD. Stability of extemporaneously prepared lansoprazole '
        'suspension at two temperatures. J Pediatr Pharmacol Ther 2013;18(2):122-7.',
    url: 'https://pmc.ncbi.nlm.nih.gov/articles/PMC3668940/',
  ),
  Reference(
    id: 'suspansiyon-usp-pantoprazol',
    kind: ReferenceKind.farmakope,
    citation: 'USP–NF, Pantoprazole Oral Suspension monografı. United States Pharmacopeial Convention.',
    url: 'https://www.usp.org',
  ),
  Reference(
    id: 'suspansiyon-usp-sumatriptan',
    kind: ReferenceKind.farmakope,
    citation: 'USP–NF, Sumatriptan Succinate Oral Suspension monografı. United States Pharmacopeial Convention.',
    url: 'https://www.usp.org',
  ),
  Reference(
    id: 'suspansiyon-iwk-baklofen',
    kind: ReferenceKind.universite,
    citation: 'IWK Health Centre Pharmacy. Compounding Formula: Baclofen Oral Suspension 10 mg/mL. Halifax, 2017 '
        '(dayanak: Int J Pharm Compd 1997;1(5):321).',
    url: 'https://iwkhealth.ca/sites/default/files/2022-10/baclofen1.pdf',
  ),
  Reference(
    id: 'suspansiyon-nahata-lamotrijin',
    kind: ReferenceKind.makale,
    citation: 'Nahata MC, Morosco RS, Hipple TF. Stability of lamotrigine in two extemporaneously prepared oral '
        'suspensions at 4 and 25 °C. Am J Health-Syst Pharm 1999;56(3):240-2.',
    url: 'https://pubmed.ncbi.nlm.nih.gov/10030509/',
  ),
];

const suspansiyonFormulas = <Formula>[
  // Tabletten hazırlanan oral süspansiyonlar (1:1 süspansiyon bazı + tatlandırılmış baz).
  Formula(
    name: 'Asetazolamid oral süspansiyonu 25 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Tablet yutamayan hastada glokom ve epilepside asetazolamidi sıvı olarak vermek için.',
    ingredients: [
      Ingredient('Asetazolamid tableti (250 mg)', '10 tablet (2,5 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda ince, topaksız bir toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL taşıyıcıyla ıslatıp pürüzsüz bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı macuna azar azar ekleyip her seferde karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Havanı taşıyıcıyla çalkalayıp şişeye aktarın ve 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996a', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Allopürinol oral süspansiyonu 20 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda ve yutma güçlüğünde ürik asidi düşürmek için.',
    ingredients: [
      Ingredient('Allopürinol tableti (100 mg)', '20 tablet (2 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Allopürinol tabletlerini havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu az miktar taşıyıcıyla ezerek düzgün bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Kalan taşıyıcıyı küçük porsiyonlarla ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Karışımı şişeye alın, havanı yıkayan taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996a', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Baklofen oral süspansiyonu 10 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda serebral palsi ve omurilik hastalıklarında kas sertliğini (spastisite) çözen baklofeni ölçülü dozla vermek için.',
    ingredients: [
      Ingredient('Baklofen tableti (25 mg)', '40 tablet (1 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda iyice ezin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç damla taşıyıcıyla akıcı olmayan bir macuna çevirin.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı yavaş yavaş ekleyerek macunu açın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996b', 'suspansiyon-iwk-baklofen'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Diltiazem oral süspansiyonu 12 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Tablet yutamayan hastada göğüs ağrısı ve yüksek tansiyon tedavisi için.',
    ingredients: [
      Ingredient('Diltiazem HCl tableti (60 mg)', '20 tablet (1,2 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Film kaplı tabletleri havanda kaplama parçası kalmayacak kadar ezin.'),
      FormulaStep('Levigasyon', 'Tozu biraz taşıyıcıyla ıslatıp macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı porsiyon porsiyon ekleyip homojen hâle getirin.'),
      FormulaStep('Hacme tamamlama', 'Şişeye alıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996b', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Dipiridamol oral süspansiyonu 10 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda pıhtı önleyici tedavide dipiridamolü sıvı vermek için.',
    ingredients: [
      Ingredient('Dipiridamol tableti (50 mg)', '20 tablet (1 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Sarı kaplı tabletleri havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu az taşıyıcıyla sürterek topaksız macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar katıp karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarın ve taşıyıcıyla 100 mL\'ye getirin.'),
    ],
    refs: ['suspansiyon-allen-1996b', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Metolazon oral süspansiyonu 1 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda ödemde idrar söktürücü olarak küçük dozlarda kullanmak için.',
    ingredients: [
      Ingredient('Metolazon tableti (10 mg)', '10 tablet (100 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'On tableti havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu az miktar taşıyıcıyla düzgün bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırmaya devam edin.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996c', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Enalapril oral süspansiyonu 1 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda yüksek tansiyon ve kalp yetmezliğinde enalaprili sıvı olarak vermek için.',
    ingredients: [
      Ingredient('Enalapril maleat tableti (20 mg)', '5 tablet (100 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Beş tableti havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL taşıyıcıyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı küçük paylarla ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1998a', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Lamotrijin oral süspansiyonu 1 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Tablet yutamayan çocuklarda epilepside lamotrijini küçük, ölçülebilir dozlarla vermek için.',
    ingredients: [
      Ingredient('Lamotrijin tableti (100 mg)', '1 tablet (100 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tableti havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu az taşıyıcıyla sürterek macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye alıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-nahata-lamotrijin', 'trissel'],
    shelfLife: '91 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Labetalol oral süspansiyonu 40 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Yüksek tansiyonda tablet yutamayan hastaya labetalol vermek için.',
    ingredients: [
      Ingredient('Labetalol HCl tableti (200 mg)', '20 tablet (4 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Film kaplı tabletleri havanda kaplaması dağılana dek ezin.'),
      FormulaStep('Levigasyon', 'Bol tozu birkaç mL taşıyıcıyla koyu bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı küçük porsiyonlarla ekleyip açın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996d', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Metoprolol tartrat oral süspansiyonu 10 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda yüksek tansiyonda metoprolol vermek için.',
    ingredients: [
      Ingredient('Metoprolol tartrat tableti (100 mg)', '10 tablet (1 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu az taşıyıcıyla ıslatıp macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar katarak karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996d', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Verapamil oral süspansiyonu 50 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda ritim bozukluğunda verapamili sıvı olarak vermek için.',
    ingredients: [
      Ingredient('Verapamil HCl tableti (80 mg, hızlı salımlı)', '25 tablet (2 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 40 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Hızlı salımlı tabletleri havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu biraz taşıyıcıyla sürterek macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı porsiyon porsiyon ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye alıp taşıyıcıyla 40 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996d', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Betanekol oral süspansiyonu 5 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'İdrar torbası boşalamama ve reflüde betanekolü sıvı olarak vermek için.',
    ingredients: [
      Ingredient('Betanekol klorür tableti (25 mg)', '20 tablet (500 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL taşıyıcıyla düzgün macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1998b', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Amlodipin oral süspansiyonu 1 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda yüksek tansiyonda amlodipini küçük dozlarla vermek için.',
    ingredients: [
      Ingredient('Amlodipin besilat tableti (5 mg)', '20 tablet (100 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Yirmi tableti havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL taşıyıcıyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-nahata-amlodipin', 'trissel'],
    shelfLife: 'Buzdolabında 91 gün, oda sıcaklığında 56 gün; ışıktan koru',
  ),
  Formula(
    name: 'Amlodipin oral süspansiyonu 1 mg/mL (metilselüloz–şurup)',
    category: FormulaCategory.suspansiyon,
    use: 'Hazır taşıyıcı bulunmadığında amlodipini eczanede hazırlanan bazla vermek için.',
    ingredients: [
      Ingredient('Amlodipin besilat tableti (5 mg)', '20 tablet (100 mg)'),
      Ingredient('Metilselüloz', '0,5 g'),
      Ingredient('Arıtılmış su', '50 mL'),
      Ingredient('Basit şurup', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Şişirme', 'Metilselülozu ılık suya serpip soğukta bekletin, berrak %1\'lik jel olsun.'),
      FormulaStep('Ezme', 'Tabletleri havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL metilselüloz jeliyle macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Kalan jeli ve şurubu azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp basit şurupla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-nahata-amlodipin', 'trissel'],
    shelfLife: 'Buzdolabında 91 gün, oda sıcaklığında 56 gün',
  ),
  Formula(
    name: 'Sildenafil oral süspansiyonu 2,5 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda akciğer damar basıncı yüksekliğinde (pulmoner hipertansiyon) sildenafil vermek için.',
    ingredients: [
      Ingredient('Sildenafil sitrat tableti (25 mg)', '10 tablet (250 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Film kaplı tabletleri havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu az taşıyıcıyla sürterek macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı porsiyonlarla ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-nahata-sildenafil', 'trissel'],
    shelfLife: '91 gün, buzdolabında ya da oda sıcaklığında',
  ),
  Formula(
    name: 'Sildenafil oral süspansiyonu 2,5 mg/mL (metilselüloz–şurup)',
    category: FormulaCategory.suspansiyon,
    use: 'Hazır taşıyıcı yokken sildenafili eczanede hazırlanan bazla vermek için.',
    ingredients: [
      Ingredient('Sildenafil sitrat tableti (25 mg)', '10 tablet (250 mg)'),
      Ingredient('Metilselüloz', '0,5 g'),
      Ingredient('Arıtılmış su', '50 mL'),
      Ingredient('Basit şurup', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Şişirme', 'Metilselülozu ılık suya serpip soğutarak şişirin ve %1\'lik jel elde edin.'),
      FormulaStep('Ezme', 'Tabletleri havanda kaplama parçası kalmayacak kadar ezin.'),
      FormulaStep('Levigasyon', 'Tozu biraz metilselüloz jeliyle macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Kalan jeli, sonra şurubu azar azar katıp karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp basit şurupla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-nahata-sildenafil', 'trissel', 'suspansiyon-saeyoon-sildenafil'],
    shelfLife: '90 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Ursodeoksikolik asit oral süspansiyonu 25 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Bebeklerde safra akışı bozukluğunda ursodiolü sıvı olarak vermek için.',
    ingredients: [
      Ingredient('Ursodeoksikolik asit kapsülü (250 mg)', '10 kapsül içeriği (2,5 g)'),
      Ingredient('Gliserin', '8 mL'),
      Ingredient('Süspansiyon bazı', '50 mL'),
      Ingredient('Portakal şurubu', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kapsülleri açıp tozu havanda inceltin.'),
      FormulaStep('Levigasyon', 'Suyu sevmeyen tozu gliserinle sürterek ıslak bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Süspansiyon bazını küçük paylarla ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp portakal şurubuyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-mallett-ursodiol', 'trissel'],
    shelfLife: '60 gün, oda sıcaklığında ya da buzdolabında; ışıktan koru',
  ),
  // Mide asidi baskılayıcılar.
  Formula(
    name: 'Omeprazol oral süspansiyonu 2 mg/mL (sodyum bikarbonatlı)',
    category: FormulaCategory.suspansiyon,
    use: 'Yutamayan ya da sondayla beslenen hastada mide asidini baskılamak için.',
    ingredients: [
      Ingredient('Omeprazol kapsülü (20 mg)', '10 kapsül (200 mg)'),
      Ingredient('Sodyum bikarbonat', '8,4 g'),
      Ingredient('Arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sodyum bikarbonatı suda çözüp %8,4\'lük çözelti hazırlayın.'),
      FormulaStep('Karıştırma', 'Kapsülleri açıp pelletleri çözeltiye boşaltın, dağılana dek ara ara karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Bikarbonat çözeltisiyle 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-digiacinto-ppi', 'trissel'],
    shelfLife: '45 gün, buzdolabında (oda sıcaklığında 14 gün); ışıktan koru',
  ),
  Formula(
    name: 'Lansoprazol oral süspansiyonu 3 mg/mL (sodyum bikarbonatlı)',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda ve sondalı hastada reflü ve ülser tedavisi için.',
    ingredients: [
      Ingredient('Lansoprazol kapsülü (30 mg)', '10 kapsül (300 mg)'),
      Ingredient('Sodyum bikarbonat', '4,2 g'),
      Ingredient('Arıtılmış su', 'ad 50 mL'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sodyum bikarbonatı suda çözerek 50 mL %8,4\'lük çözelti yapın.'),
      FormulaStep('Karıştırma', 'Kapsül içindeki granülleri çözeltiye boşaltıp tamamen dağılana dek karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Süspansiyon bazı ve tatlandırılmış baz karışımıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-usp-lansoprazol', 'suspansiyon-morrison-lansoprazol', 'trissel'],
    shelfLife: '90 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Pantoprazol oral süspansiyonu 2 mg/mL (sodyum bikarbonatlı)',
    category: FormulaCategory.suspansiyon,
    use: 'Sondayla beslenen hastada mide asidini baskılamak için.',
    ingredients: [
      Ingredient('Pantoprazol tableti (40 mg)', '5 tablet (200 mg)'),
      Ingredient('Sodyum bikarbonat', '8,4 g'),
      Ingredient('Arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sodyum bikarbonatı suda çözüp %8,4\'lük çözelti hazırlayın.'),
      FormulaStep('Ezme', 'Mide asidine dayanıklı kaplı tabletleri havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL bikarbonat çözeltisiyle macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Çözeltiyi azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Bikarbonat çözeltisiyle 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-ferron-pantoprazol', 'trissel', 'suspansiyon-usp-pantoprazol'],
    shelfLife: '14 gün, buzdolabında; ışıktan koru',
  ),
  Formula(
    name: 'Famotidin oral süspansiyonu 8 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda reflü ve mide ülserinde famotidini sıvı vermek için.',
    ingredients: [
      Ingredient('Famotidin tableti (40 mg)', '20 tablet (800 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu az taşıyıcıyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı porsiyonlarla ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-dentinger-famotidin', 'trissel'],
    shelfLife: '95 gün, buzdolabında; ışıktan koru',
  ),
  // Diğer pediatrik oral süspansiyonlar.
  Formula(
    name: 'Propranolol oral süspansiyonu 2 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Bebeklerde hemanjiyom tedavisinde propranololü küçük dozlarla vermek için.',
    ingredients: [
      Ingredient('Propranolol HCl tableti (40 mg)', '5 tablet (200 mg)'),
      Ingredient('Şekersiz hazır süspansiyon taşıyıcısı', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL taşıyıcıyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-ensom-propranolol', 'trissel'],
    shelfLife: '120 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Lisinopril oral süspansiyonu 1 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Altı yaş üstü çocuklarda yüksek tansiyonda lisinopril vermek için.',
    ingredients: [
      Ingredient('Lisinopril tableti (20 mg)', '5 tablet (100 mg)'),
      Ingredient('Arıtılmış su', '5 mL'),
      Ingredient('Sodyum sitrat–sitrik asit oral çözeltisi', '15 mL'),
      Ingredient('Şekersiz tatlandırılmış baz', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Tabletleri şişede suyla çalkalayıp dağıtın, sitrat çözeltisini ekleyip yeniden çalkalayın.'),
      FormulaStep('Hacme tamamlama', 'Tatlandırılmış bazla 100 mL\'ye tamamlayıp iyice çalkalayın.'),
    ],
    refs: ['suspansiyon-fda-lisinopril', 'trissel'],
    shelfLife: '4 hafta, 25 °C\'nin altında',
  ),
  Formula(
    name: 'Losartan oral süspansiyonu 2,5 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Altı yaş üstü çocuklarda yüksek tansiyonda losartan vermek için.',
    ingredients: [
      Ingredient('Losartan potasyum tableti (50 mg)', '5 tablet (250 mg)'),
      Ingredient('Arıtılmış su', '5 mL'),
      Ingredient('Süspansiyon bazı + şekersiz tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Tabletleri şişede suyla çalkalayın, bir saat bekletip yeniden çalkalayın.'),
      FormulaStep('Hacme tamamlama', 'Taşıyıcı karışımını ekleyip 100 mL\'ye tamamlayın ve çalkalayın.'),
    ],
    refs: ['suspansiyon-fda-losartan', 'trissel'],
    shelfLife: '4 hafta, buzdolabında (2–8 °C)',
  ),
  Formula(
    name: 'Klopidogrel oral süspansiyonu 5 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda ve yutamayan hastada pıhtı önlemek için klopidogrel vermek için.',
    ingredients: [
      Ingredient('Klopidogrel tableti (75 mg)', '4 tablet (300 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 60 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Dört tableti havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu biraz taşıyıcıyla sürterek macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 60 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-skillman-klopidogrel', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Ondansetron oral süspansiyonu 0,8 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Kemoterapi ve ameliyat sonrası bulantı-kusmayı önlemek için.',
    ingredients: [
      Ingredient('Ondansetron tableti (8 mg)', '10 tablet (80 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Film kaplı tabletleri havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu az taşıyıcıyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı porsiyonlarla ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-williams-ondansetron', 'trissel'],
    shelfLife: '42 gün, buzdolabında; ışıktan koru',
  ),
  Formula(
    name: 'Selekoksib oral süspansiyonu 10 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Kapsül yutamayan hastada ağrı ve iltihabı azaltmak için.',
    ingredients: [
      Ingredient('Selekoksib kapsülü (200 mg)', '5 kapsül içeriği (1 g)'),
      Ingredient('Tek bileşenli hazır süspansiyon taşıyıcısı', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kapsülleri açıp içindeki tozu havanda inceltin.'),
      FormulaStep('Levigasyon', 'Suyu sevmeyen tozu birkaç mL taşıyıcıyla iyice ıslatıp macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-donnelly-selekoksib', 'trissel'],
    shelfLife: '93 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Terbinafin oral süspansiyonu 25 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda saçlı deri mantarında terbinafini sıvı vermek için.',
    ingredients: [
      Ingredient('Terbinafin HCl tableti (250 mg)', '10 tablet (2,5 g)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu biraz taşıyıcıyla sürterek macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-abdelrahman-terbinafin', 'trissel'],
    shelfLife: '42 gün, buzdolabında ya da oda sıcaklığında',
  ),
  Formula(
    name: 'Sumatriptan oral süspansiyonu 5 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Tablet yutamayan hastada migren atağını tedavi etmek için.',
    ingredients: [
      Ingredient('Sumatriptan süksinat tableti (100 mg)', '5 tablet (500 mg sumatriptan)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu az taşıyıcıyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı porsiyonlarla ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-fish-sumatriptan', 'trissel', 'suspansiyon-usp-sumatriptan'],
    shelfLife: '14 gün, buzdolabında; ışıktan koru',
  ),
  Formula(
    name: 'Allopürinol oral süspansiyonu 20 mg/mL (vişne şurubu)',
    category: FormulaCategory.suspansiyon,
    use: 'Hazır süspansiyon bazı yokken allopürinolü şurupla sıvı olarak vermek için.',
    ingredients: [
      Ingredient('Allopürinol tableti (100 mg)', '20 tablet (2 g)'),
      Ingredient('Vişne şurubu', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tabletleri havanda ince toz olana dek ezin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL vişne şurubuyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Şurubu azar azar ekleyip her seferde karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp vişne şurubuyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-allen-1996a', 'trissel'],
    shelfLife: '60 gün, buzdolabında ya da oda sıcaklığında; ışıktan koru',
  ),
  Formula(
    name: 'Ursodeoksikolik asit oral süspansiyonu 60 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Safra taşı ve safra akışı bozukluğunda ursodiolü yüksek dozda sıvı vermek için.',
    ingredients: [
      Ingredient('Ursodeoksikolik asit kapsülü (300 mg)', '20 kapsül içeriği (6 g)'),
      Ingredient('Gliserin', '1 mL'),
      Ingredient('Basit şurup', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kapsülleri açıp tozu havanda inceltin.'),
      FormulaStep('Levigasyon', 'Tozu gliserinle sürterek ıslak bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Basit şurubu küçük paylarla ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp şurupla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-johnson-ursodiol', 'trissel'],
    shelfLife: '35 gün, buzdolabında, amber cam şişede, karanlıkta',
  ),
  Formula(
    name: 'Tadalafil oral süspansiyonu 5 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda akciğer damar basıncı yüksekliğinde (pulmoner hipertansiyon) tadalafil vermek için.',
    ingredients: [
      Ingredient('Tadalafil tableti (20 mg)', '15 tablet (300 mg)'),
      Ingredient('Süspansiyon bazı + tatlandırılmış baz (1:1)', 'ad 60 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Film kaplı tabletleri havanda iyice ezip ince toz yapın.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL taşıyıcıyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Taşıyıcıyı azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp taşıyıcıyla 60 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-pettit-tadalafil', 'suspansiyon-uspharmacist-tadalafil', 'trissel'],
    shelfLife: '91 gün, oda sıcaklığında, amber şişede',
  ),
  Formula(
    name: 'Granisetron oral süspansiyonu 0,2 mg/mL',
    category: FormulaCategory.suspansiyon,
    use: 'Kemoterapiye bağlı bulantı-kusmayı önlemek için, sondalı hastada da.',
    ingredients: [
      Ingredient('Granisetron tableti (1 mg)', '12 tablet (12 mg)'),
      Ingredient('Arıtılmış su', '30 mL'),
      Ingredient('Vişne şurubu', 'ad 60 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'On iki tableti havanda ince toz hâline getirin.'),
      FormulaStep('Levigasyon', 'Tozu birkaç mL suyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Kalan suyu, sonra şurubu azar azar ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp vişne şurubuyla 60 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-quercia-granisetron', 'trissel'],
    shelfLife: '14 gün, buzdolabında ya da oda sıcaklığında',
  ),
  // Klasik oral karışımlar (BP/BPC).
  Formula(
    name: 'Magnezyum hidroksit karışımı',
    category: FormulaCategory.suspansiyon,
    use: 'Kabızlıkta yumuşatıcı, hazımsızlıkta asit nötrleştirici olarak.',
    ingredients: [
      Ingredient('Magnezyum sülfat', '4,75 g'),
      Ingredient('Sodyum hidroksit', '1,5 g'),
      Ingredient('Hafif magnezyum oksit', '5,25 g'),
      Ingredient('Kaynatılıp soğutulmuş arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sodyum hidroksiti suyun bir kısmında, magnezyum sülfatı ayrı bir kısmında çözün.'),
      FormulaStep('Levigasyon', 'Magnezyum oksidi sodyum hidroksit çözeltisiyle düzgün bir krema yapın.'),
      FormulaStep('Nötralleştirme', 'Magnezyum sülfat çözeltisini karıştırarak ekleyin, magnezyum hidroksit çöker.'),
      FormulaStep('Süzme', 'Çökeleği süzüp sodyum sülfattan arınana dek suyla yıkayın.'),
      FormulaStep('Hacme tamamlama', 'Çökeleği suyla karıştırıp 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'suspansiyon-nhs-dmd'],
  ),
  Formula(
    name: 'Magnezyum trisilikat karışımı',
    category: FormulaCategory.suspansiyon,
    use: 'Hazımsızlık ve mide yanmasında asidi nötrleştirmek için.',
    ingredients: [
      Ingredient('Magnezyum trisilikat', '5 g'),
      Ingredient('Hafif magnezyum karbonat', '5 g'),
      Ingredient('Sodyum bikarbonat', '5 g'),
      Ingredient('Konsantre nane emülsiyonu', '2,5 mL'),
      Ingredient('Koruyuculu arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Üç tozu havanda birlikte ezip karıştırın.'),
      FormulaStep('Levigasyon', 'Toz karışımını az suyla sürterek akıcı bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Suyu azar azar ekleyip her seferde karıştırın.'),
      FormulaStep('Karıştırma', 'Nane emülsiyonunu katıp karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'suspansiyon-marriott'],
  ),
  Formula(
    name: 'Kaolen karışımı',
    category: FormulaCategory.suspansiyon,
    use: 'Hafif ishalde bağırsakta suyu ve zararlı maddeleri bağlamak için.',
    ingredients: [
      Ingredient('Hafif kaolen', '20 g'),
      Ingredient('Hafif magnezyum karbonat', '5 g'),
      Ingredient('Sodyum bikarbonat', '5 g'),
      Ingredient('Konsantre nane emülsiyonu', '2,5 mL'),
      Ingredient('Koruyuculu arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Kaolen ve karbonatları havanda birlikte ezin.'),
      FormulaStep('Levigasyon', 'Tozları az suyla düzgün bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Suyu porsiyonlarla ekleyip karıştırın.'),
      FormulaStep('Karıştırma', 'Nane emülsiyonunu ekleyip karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'suspansiyon-marriott'],
  ),
  Formula(
    name: 'Pediatrik kaolen karışımı',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda hafif ishalde destek tedavisi için.',
    ingredients: [
      Ingredient('Hafif kaolen', '20 g'),
      Ingredient('Benzoik asit çözeltisi', '2 mL'),
      Ingredient('Ahududu şurubu', '20 mL'),
      Ingredient('Koruyuculu arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Kaoleni elekten geçirip topaklarını ayırın.'),
      FormulaStep('Levigasyon', 'Kaoleni ahududu şurubuyla havanda macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Suyu azar azar ekleyip karıştırın.'),
      FormulaStep('Karıştırma', 'Benzoik asit çözeltisini katıp karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'suspansiyon-bpc1973'],
  ),
  Formula(
    name: 'Pediatrik tebeşir karışımı',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda hafif ishalde kabız edici olarak kullanmak için.',
    ingredients: [
      Ingredient('Tebeşir (kalsiyum karbonat)', '2 g'),
      Ingredient('Toz kitre (tragakant)', '0,2 g'),
      Ingredient('Basit şurup', '10 mL'),
      Ingredient('Konsantre tarçın suyu', '0,4 mL'),
      Ingredient('Koruyuculu arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Tebeşir ile kitreyi havanda kuru olarak birlikte ezin.'),
      FormulaStep('Levigasyon', 'Toz karışımını şurupla sürterek macun yapın.'),
      FormulaStep('Şişirme', 'Az su ekleyip kitrenin şişmesi için karıştırarak bekleyin.'),
      FormulaStep('Geometrik seyreltme', 'Kalan suyu azar azar ekleyip karıştırın.'),
      FormulaStep('Karıştırma', 'Tarçın suyunu katıp karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'suspansiyon-marriott'],
  ),
  Formula(
    name: 'Aromatik magnezyum karbonat karışımı',
    category: FormulaCategory.suspansiyon,
    use: 'Hazımsızlık ve gazda asidi nötrleştirmek için.',
    ingredients: [
      Ingredient('Hafif magnezyum karbonat', '3 g'),
      Ingredient('Sodyum bikarbonat', '5 g'),
      Ingredient('Aromatik kakule tentürü', '3 mL'),
      Ingredient('Koruyuculu arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Ezme', 'Magnezyum karbonat ile sodyum bikarbonatı havanda ezin.'),
      FormulaStep('Levigasyon', 'Tozları az suyla macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Suyu porsiyonlarla ekleyip karıştırın.'),
      FormulaStep('Karıştırma', 'Kakule tentürünü yavaşça katıp karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-bpc1973', 'suspansiyon-marriott'],
  ),
  Formula(
    name: 'Sıvı parafin oral emülsiyonu %50',
    category: FormulaCategory.suspansiyon,
    use: 'Kabızlıkta dışkıyı yumuşatıp kaydırmak için.',
    ingredients: [
      Ingredient('Sıvı parafin', '50 mL'),
      Ingredient('Metilselüloz 20', '2 g'),
      Ingredient('Vanilin', '50 mg'),
      Ingredient('Sodyum sakarin', '5 mg'),
      Ingredient('Benzoik asit çözeltisi', '2 mL'),
      Ingredient('Arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Şişirme', 'Metilselülozu sıcak suya serpip soğuk suyla şişirerek jel yapın.'),
      FormulaStep('Çözme', 'Vanilin ve sakarini benzoik asit çözeltisi ve az suyla çözün.'),
      FormulaStep('Emülsifikasyon', 'Sıvı parafini jele azar azar katıp kuvvetle çalkalayarak emülsiyon yapın.'),
      FormulaStep('Hacme tamamlama', 'Aroma çözeltisini ekleyip suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'suspansiyon-marriott'],
  ),
  Formula(
    name: 'Bentonit magması %5',
    category: FormulaCategory.suspansiyon,
    use: 'Losyon ve süspansiyonlarda tozları askıda tutan taşıyıcı olarak.',
    ingredients: [
      Ingredient('Bentonit', '5 g'),
      Ingredient('Arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Şişirme', 'Bentoniti sıcak suyun yüzeyine azar azar serpip bir gün şişmeye bırakın.'),
      FormulaStep('Karıştırma', 'Şişen kütleyi düzgün bir magma olana dek karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['usp-nf', 'ansel'],
  ),
  // Dışa uygulanan çalkalama losyonları ve linimentler.
  Formula(
    name: 'Kalamin losyonu',
    category: FormulaCategory.suspansiyon,
    use: 'Güneş yanığı, böcek ısırığı ve suçiçeğinde kaşıntıyı yatıştırmak için.',
    ingredients: [
      Ingredient('Kalamin', '15 g'),
      Ingredient('Çinko oksit', '5 g'),
      Ingredient('Bentonit', '3 g'),
      Ingredient('Sodyum sitrat', '0,5 g'),
      Ingredient('Sıvılaştırılmış fenol', '0,5 mL'),
      Ingredient('Gliserol', '5 mL'),
      Ingredient('Arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Çözme', 'Sodyum sitratı suyun bir kısmında çözün.'),
      FormulaStep('Ezme', 'Kalamin, çinko oksit ve bentoniti havanda birlikte ezin.'),
      FormulaStep('Levigasyon', 'Toz karışımını gliserol ve biraz sitrat çözeltisiyle macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Kalan çözeltiyi azar azar ekleyip karıştırın.'),
      FormulaStep('Karıştırma', 'Fenolü katıp iyice karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'apf', 'suspansiyon-marriott'],
  ),
  Formula(
    name: 'Yağlı kalamin losyonu',
    category: FormulaCategory.suspansiyon,
    use: 'Kuru ve kaşıntılı deride yatıştırıcı ve koruyucu olarak.',
    ingredients: [
      Ingredient('Kalamin', '5 g'),
      Ingredient('Lanolin (yün yağı)', '1 g'),
      Ingredient('Oleik asit', '0,5 mL'),
      Ingredient('Yer fıstığı yağı', '50 mL'),
      Ingredient('Kalsiyum hidroksit çözeltisi (kireç suyu)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Eritme', 'Lanolini oleik asit ve yağın bir kısmıyla su banyosunda eritin.'),
      FormulaStep('Ezme', 'Kalamini havanda inceltin.'),
      FormulaStep('Levigasyon', 'Kalamini yağlı karışımla sürterek macun yapın, kalan yağı katın.'),
      FormulaStep('Emülsifikasyon', 'Kireç suyunu ekleyip kuvvetle çalkalayın, oleik asitle sabun oluşup emülsiyon kurulur.'),
      FormulaStep('Hacme tamamlama', 'Kireç suyuyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'suspansiyon-marriott'],
  ),
  Formula(
    name: 'Çinko oksit çalkalama karışımı (Lotio alba)',
    category: FormulaCategory.suspansiyon,
    use: 'Sulanan, kaşıntılı deride kurutucu ve serinletici olarak.',
    ingredients: [
      Ingredient('Çinko oksit', '20 g'),
      Ingredient('Talk', '20 g'),
      Ingredient('Gliserol %85', '30 g'),
      Ingredient('Arıtılmış su', '30 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit ve talkı elekten geçirip topakları ayırın.'),
      FormulaStep('Ezme', 'İki tozu havanda birlikte ezip karıştırın.'),
      FormulaStep('Levigasyon', 'Tozları gliserolle sürterek düzgün bir macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Suyu azar azar katıp karıştırın.'),
    ],
    refs: ['nrf', 'suspansiyon-bauer'],
  ),
  Formula(
    name: 'Ten rengi çinko oksit çalkalama karışımı',
    category: FormulaCategory.suspansiyon,
    use: 'Yüz gibi açık bölgelerde göze batmadan kurutucu ve yatıştırıcı olarak.',
    ingredients: [
      Ingredient('Demir oksit ön karışımı (orta ton)', '0,8 g'),
      Ingredient('Çinko oksit', '20 g'),
      Ingredient('Talk', '20 g'),
      Ingredient('Gliserol %85', '30 g'),
      Ingredient('Arıtılmış su', 'ad 100 g'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Çinko oksit ve talkı elekten geçirin.'),
      FormulaStep('Geometrik seyreltme', 'Demir oksit karışımını tozlara eşit paylarla katıp rengi eşitleyin.'),
      FormulaStep('Levigasyon', 'Renkli tozu gliserolle sürterek macun yapın.'),
      FormulaStep('Hacme tamamlama', 'Suyu azar azar katıp karıştırarak 100 g\'a tamamlayın.'),
    ],
    refs: ['nrf', 'suspansiyon-bauer'],
  ),
  Formula(
    name: 'Benzil benzoat uygulaması %25',
    category: FormulaCategory.suspansiyon,
    use: 'Yetişkinlerde uyuz tedavisi için.',
    ingredients: [
      Ingredient('Benzil benzoat', '25 g'),
      Ingredient('Emülsifiye mum', '2 g'),
      Ingredient('Arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Eritme', 'Emülsifiye mumu benzil benzoatla su banyosunda eritin.'),
      FormulaStep('Emülsifikasyon', 'Aynı sıcaklıktaki suyu yağ fazına azar azar katıp kuvvetle karıştırın.'),
      FormulaStep('Soğutma', 'Emülsiyonu karıştırmayı bırakmadan oda sıcaklığına soğutun.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'who-mf', 'martindale'],
  ),
  Formula(
    name: 'Benzil benzoat uygulaması %12,5 (çocuk)',
    category: FormulaCategory.suspansiyon,
    use: 'Çocuklarda uyuz tedavisinde tahrişi azaltmak için seyreltilmiş biçim.',
    ingredients: [
      Ingredient('Benzil benzoat uygulaması %25', '50 mL'),
      Ingredient('Arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Çalkalanmış %25\'lik uygulamaya eşit hacim suyu azar azar katıp karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Suyla 100 mL\'ye tamamlayıp çalkalayın.'),
    ],
    refs: ['who-mf', 'martindale'],
  ),
  Formula(
    name: 'Bileşik kükürt losyonu',
    category: FormulaCategory.suspansiyon,
    use: 'Akne ve yağlı deride soyucu ve kurutucu olarak.',
    ingredients: [
      Ingredient('Çöktürülmüş kükürt', '4 g'),
      Ingredient('Kilaya tentürü', '0,5 mL'),
      Ingredient('Gliserol', '2 mL'),
      Ingredient('Etanol %95', '6 mL'),
      Ingredient('Kalsiyum hidroksit çözeltisi (kireç suyu)', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Elekten geçirme', 'Kükürdü elekten geçirip topaklarını ayırın.'),
      FormulaStep('Levigasyon', 'Suyu sevmeyen kükürdü kilaya tentürü ve gliserolle havanda ıslatıp macun yapın.'),
      FormulaStep('Geometrik seyreltme', 'Kireç suyunu azar azar ekleyip karıştırın.'),
      FormulaStep('Karıştırma', 'Etanolü yavaşça katıp karıştırın.'),
      FormulaStep('Hacme tamamlama', 'Şişeye aktarıp kireç suyuyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['suspansiyon-bpc1973', 'martindale'],
  ),
  Formula(
    name: 'Kireç linimenti',
    category: FormulaCategory.suspansiyon,
    use: 'Hafif yanık ve tahriş olmuş deride yumuşatıcı ve koruyucu olarak.',
    ingredients: [
      Ingredient('Kalsiyum hidroksit çözeltisi (kireç suyu)', '50 mL'),
      Ingredient('Yer fıstığı yağı', '50 mL'),
    ],
    steps: [
      FormulaStep('Nötralleştirme', 'Kireç suyunu yağa katın; kireç yağdaki serbest yağ asitleriyle kalsiyum sabunu yapar.'),
      FormulaStep('Emülsifikasyon', 'Şişeyi kuvvetle çalkalayarak krem kıvamlı emülsiyon oluşturun.'),
    ],
    refs: ['suspansiyon-bpc1973', 'martindale'],
  ),
  Formula(
    name: 'Beyaz liniment (terebentinli)',
    category: FormulaCategory.suspansiyon,
    use: 'Kas ve eklem ağrısında ovarak kan dolaşımını artıran sıcaklık verici olarak.',
    ingredients: [
      Ingredient('Oleik asit', '8,5 mL'),
      Ingredient('Terebentin yağı', '25 mL'),
      Ingredient('Seyreltik amonyak çözeltisi', '4,5 mL'),
      Ingredient('Amonyum klorür', '1,25 g'),
      Ingredient('Arıtılmış su', 'ad 100 mL'),
    ],
    steps: [
      FormulaStep('Karıştırma', 'Oleik asidi terebentin yağıyla karıştırın.'),
      FormulaStep('Nötralleştirme', 'Amonyağı ılık suyla karıştırıp yağ fazına katın, oleik asitle amonyum sabunu oluşur.'),
      FormulaStep('Çözme', 'Amonyum klorürü kalan suda çözün.'),
      FormulaStep('Emülsifikasyon', 'Tuz çözeltisini azar azar ekleyip kuvvetle çalkalayın.'),
      FormulaStep('Hacme tamamlama', 'Suyla 100 mL\'ye tamamlayın.'),
    ],
    refs: ['bp', 'suspansiyon-marriott'],
  ),
];
