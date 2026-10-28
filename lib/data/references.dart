/// Kaynak türü; Kaynaklar sekmesi bu sırayla gruplar.
enum ReferenceKind {
  farmakope('Farmakopeler ve resmî formülerler'),
  devlet('Devlet kurumları ve yönergeler'),
  kitap('Ders kitapları ve el kitapları'),
  makale('Akademik makaleler'),
  universite('Üniversite ders kaynakları');

  const ReferenceKind(this.title);

  final String title;
}

/// Formül kitabının dayandığı kaynak. Yalnız künye ve adres tutulur; kaynak
/// metninden alıntı yapılmaz (telif). Bloglar ve ticari siteler kaynak olmaz.
class Reference {
  const Reference({
    required this.id,
    required this.kind,
    required this.citation,
    this.url,
  });

  final String id;
  final ReferenceKind kind;

  /// Künye: yazar/kurum, ad, baskı, yayımcı, yıl.
  final String citation;
  final String? url;
}

/// Ortak kaynaklar. Kategori dosyaları (data/formulary/) kendi ek kaynaklarını
/// ayrı listede verir; Kaynaklar sekmesi hepsini birleştirir.
const coreReferences = <Reference>[
  // Kategoriler bu iki sınıflandırmadan sadeleştirildi.
  Reference(
    id: 'usp-1151',
    kind: ReferenceKind.farmakope,
    citation: 'United States Pharmacopeia (USP–NF), genel bölüm <1151> Pharmaceutical Dosage Forms. '
        'United States Pharmacopeial Convention.',
    url: 'https://www.usp.org',
  ),
  Reference(
    id: 'ph-eur',
    kind: ReferenceKind.farmakope,
    citation: 'European Pharmacopoeia (Ph. Eur.), farmasötik şekil monografları: Semi-solid preparations '
        'for cutaneous application (0132), Liquid preparations for cutaneous application (0927), Liquid '
        'preparations for oral use (0672), Powders for cutaneous application (1166), Oral powders (1165), '
        'Capsules (0016). EDQM, Avrupa Konseyi.',
    url: 'https://www.edqm.eu',
  ),
  Reference(
    id: 'usp-795',
    kind: ReferenceKind.farmakope,
    citation: 'USP genel bölüm <795> Pharmaceutical Compounding – Nonsterile Preparations (2023 revizyonu). '
        'United States Pharmacopeial Convention.',
    url: 'https://www.usp.org/compounding/general-chapter-795',
  ),
  Reference(
    id: 'usp-nf',
    kind: ReferenceKind.farmakope,
    citation: 'United States Pharmacopeia – National Formulary (USP–NF): resmî preparat ve majistral '
        '(compounded preparation) monografları. United States Pharmacopeial Convention.',
    url: 'https://www.uspnf.com',
  ),
  Reference(
    id: 'bp',
    kind: ReferenceKind.farmakope,
    citation: 'British Pharmacopoeia, formüle edilmiş preparat monografları. Medicines and Healthcare '
        'products Regulatory Agency (MHRA), Londra.',
    url: 'https://www.pharmacopoeia.com',
  ),
  Reference(
    id: 'tf',
    kind: ReferenceKind.farmakope,
    citation: 'Türk Farmakopesi 2017 (Avrupa Farmakopesi uyumlu). T.C. Sağlık Bakanlığı, Türkiye İlaç ve '
        'Tıbbi Cihaz Kurumu (TİTCK).',
    url: 'https://www.titck.gov.tr',
  ),
  Reference(
    id: 'nrf',
    kind: ReferenceKind.farmakope,
    citation: 'Deutscher Arzneimittel-Codex / Neues Rezeptur-Formularium (DAC/NRF). ABDA – Bundesvereinigung '
        'Deutscher Apothekerverbände, Govi-Verlag.',
    url: 'https://dacnrf.pharmazeutische-zeitung.de',
  ),
  Reference(
    id: 'fn-es',
    kind: ReferenceKind.farmakope,
    citation: 'Formulario Nacional (İspanya ulusal formüleri), 2. baskı ve güncellemeleri. Agencia Española de '
        'Medicamentos y Productos Sanitarios (AEMPS), Madrid.',
    url: 'https://www.aemps.gob.es',
  ),
  Reference(
    id: 'fna',
    kind: ReferenceKind.farmakope,
    citation: 'Formularium der Nederlandse Apothekers (FNA). Koninklijke Nederlandse Maatschappij ter '
        'bevordering der Pharmacie (KNMP), Lahey.',
    url: 'https://www.knmp.nl',
  ),
  Reference(
    id: 'apf',
    kind: ReferenceKind.farmakope,
    citation: 'Australian Pharmaceutical Formulary and Handbook (APF), 25. baskı. Pharmaceutical Society of '
        'Australia, 2021.',
    url: 'https://www.psa.org.au',
  ),
  Reference(
    id: 'edqm-pf',
    kind: ReferenceKind.farmakope,
    citation: 'European Paediatric Formulary (PaedForm). EDQM, Avrupa Konseyi.',
    url: 'https://www.edqm.eu/en/european-paediatric-formulary',
  ),
  Reference(
    id: 'titck-ieu',
    kind: ReferenceKind.devlet,
    citation: 'İyi Eczacılık Uygulamaları Kılavuzu. Türkiye İlaç ve Tıbbi Cihaz Kurumu (TİTCK).',
    url: 'https://www.titck.gov.tr/storage/legislation/sGvnnJYO.pdf',
  ),
  Reference(
    id: 'teb-rehber',
    kind: ReferenceKind.devlet,
    citation: 'Majistral İlaç Rehberi. Türk Eczacıları Birliği (TEB), Ankara ve Gazi Üniversiteleri '
        'Eczacılık Fakülteleri Farmasötik Teknoloji Anabilim Dalları katkısıyla, 2015.',
    url: 'https://www.teb.org.tr',
  ),
  Reference(
    id: 'coe-2016',
    kind: ReferenceKind.devlet,
    citation: 'Resolution CM/Res(2016)1 on quality and safety assurance requirements for medicinal products '
        'prepared in pharmacies. Avrupa Konseyi Bakanlar Komitesi, 2016.',
    url: 'https://rm.coe.int/168065c132',
  ),
  Reference(
    id: 'who-mf',
    kind: ReferenceKind.devlet,
    citation: 'WHO Model Formulary 2008. Dünya Sağlık Örgütü (WHO), Cenevre.',
    url: 'https://www.who.int',
  ),
  Reference(
    id: 'allen',
    kind: ReferenceKind.kitap,
    citation: 'Allen LV Jr. The Art, Science, and Technology of Pharmaceutical Compounding. American '
        'Pharmacists Association (APhA).',
  ),
  Reference(
    id: 'ansel',
    kind: ReferenceKind.kitap,
    citation: 'Allen LV Jr. Ansel’s Pharmaceutical Dosage Forms and Drug Delivery Systems. Wolters Kluwer.',
  ),
  Reference(
    id: 'aulton',
    kind: ReferenceKind.kitap,
    citation: 'Aulton ME, Taylor KMG (ed.). Aulton’s Pharmaceutics: The Design and Manufacture of Medicines. '
        'Elsevier.',
  ),
  Reference(
    id: 'remington',
    kind: ReferenceKind.kitap,
    citation: 'Adejare A (ed.). Remington: The Science and Practice of Pharmacy, 23. baskı. Academic Press, 2021.',
  ),
  Reference(
    id: 'trissel',
    kind: ReferenceKind.kitap,
    citation: 'Allen LV Jr. Trissel’s Stability of Compounded Formulations. American Pharmacists Association.',
  ),
  Reference(
    id: 'rps-handbook',
    kind: ReferenceKind.kitap,
    citation: 'Jackson M, Lowey A (ed.). Handbook of Extemporaneous Preparation: A Guide to Pharmaceutical '
        'Compounding. Pharmaceutical Press, 2010.',
  ),
  Reference(
    id: 'jew',
    kind: ReferenceKind.kitap,
    citation: 'Jew RK, Soo-Hoo W, Erush SC. Extemporaneous Formulations for Pediatric, Geriatric, and Special '
        'Needs Patients. American Society of Health-System Pharmacists (ASHP).',
  ),
  Reference(
    id: 'martindale',
    kind: ReferenceKind.kitap,
    citation: 'Martindale: The Complete Drug Reference. Pharmaceutical Press.',
  ),
  Reference(
    id: 'ijpc',
    kind: ReferenceKind.makale,
    citation: 'International Journal of Pharmaceutical Compounding (IJPC): hakemli majistral formül makaleleri.',
    url: 'https://www.ijpc.com',
  ),
];
