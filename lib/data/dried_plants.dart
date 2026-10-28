/// Vitrin rafındaki fanuslar (Tuğrul, 2026-10-28, "ilaç koymak çok iyi değil"):
/// ceviz tabanlı cam fanusta kurutulmuş tıbbi bitki. İkonlar
/// tools/ikon_blok/uretici.html "Vitrin" grubunda. Nasıl kazanılacakları sonra
/// belirlenecek; şimdilik hepsi açık (`unlockAll`).
class DriedPlant {
  const DriedPlant(this.name, this.latin, this.use, this.file);

  final String name;
  final String latin;

  /// Eczanede neyde kullanıldığı, tek satır.
  final String use;
  final String file;

  String get imagePath => 'assets/images/ikon/ikon_fanus_$file.png';
}

const driedPlants = <DriedPlant>[
  DriedPlant('Papatya', 'Matricaria chamomilla', 'Yatıştırıcı çay, cilt bakımı', 'papatya'),
  DriedPlant('Lavanta', 'Lavandula angustifolia', 'Yağı merhem ve kremlerde', 'lavanta'),
  DriedPlant('Nane', 'Mentha × piperita', 'Mentol, ferahlatıcı', 'nane'),
  DriedPlant('Adaçayı', 'Salvia officinalis', 'Gargara, ağız bakımı', 'adacayi'),
  DriedPlant('Aynısefa', 'Calendula officinalis', 'Yara merhemi', 'aynisefa'),
  DriedPlant('Kekik', 'Thymus vulgaris', 'Öksürük şurubu', 'kekik'),
  DriedPlant('Biberiye', 'Rosmarinus officinalis', 'Kas ve eklem yağı', 'biberiye'),
  DriedPlant('Ihlamur', 'Tilia platyphyllos', 'Soğuk algınlığı çayı', 'ihlamur'),
  DriedPlant('Rezene', 'Foeniculum vulgare', 'Gaz giderici çay', 'rezene'),
  DriedPlant('Ekinezya', 'Echinacea purpurea', 'Bağışıklık', 'ekinezya'),
  DriedPlant('Sarı kantaron', 'Hypericum perforatum', 'Kantaron yağı, yara', 'kantaron'),
  DriedPlant('Hatmi', 'Althaea officinalis', 'Öksürük, boğaz', 'hatmi'),
  DriedPlant('Gelincik', 'Papaver rhoeas', 'Eski öksürük şurupları', 'gelincik'),
  DriedPlant('Defne', 'Laurus nobilis', 'Defne yağı, saç ve cilt', 'defne'),
  DriedPlant('Okaliptüs', 'Eucalyptus globulus', 'Nefes açıcı buhar', 'okaliptus'),
  DriedPlant('Mürver', 'Sambucus nigra', 'Mürver şurubu', 'murver'),
];

DriedPlant? driedPlantNamed(String name) {
  for (final p in driedPlants) {
    if (p.name == name) return p;
  }
  return null;
}
