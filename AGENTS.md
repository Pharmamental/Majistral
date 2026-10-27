# Majistral Oyunu: Proje Rehberi

Eczacılık öğrencilerine majistral hazırlamayı öğreten süreli mobil oyun (Flutter). Hekimlerden
reçete gelir, oyuncu istasyonlarda hazırlığı kurar, iş gerçek zamanda biter, hızlandırma yalnız
ödüllü reklamla. İlk sürüm tek bölüm: merhem ve krem.

## Kullanıcıyla konuşma
Tuğrul yazılımcı değil. Önce tek cümleyle sonuç, kısa cümle, günlük dil. Teknik terim gerekiyorsa
yanında ne demek olduğunu yaz. Komut ya da dosya adını ancak Tuğrul'un bir şey yapması gerekiyorsa göster.

## Önce oku
- **Tasarım belgesi (bağlayıcı, taslak 1):** https://claude.ai/artifact/9ytxK1M2T3wpncCGRKi86x
  Kod onunla çelişirse dur ve Tuğrul'a sor; belgeyi koda uysun diye sessizce değiştirme.
- Kararlar ve içerik: `C:\YZ\knowledge\concepts\majistral-egitim-icerik-haritasi.md`
- Majistral bilgisi ve kaynaklar: `C:\YZ\knowledge\concepts\majistral-ilaclar.md`
- Oyun mekaniği, ekonomi, reklam: `C:\YZ\800-Arsenal 🛠️\Oyunlastirma\CLAUDE.md` ve
  `Sureli-Oyunlar.md`, `Ekonomi-Etik-ve-Duzenleme.md`
- Ekran ve bileşen tasarımı: `C:\YZ\800-Arsenal 🛠️\Tasarim-Rehberi\CLAUDE.md`

## Değişmeyen kurallar
- **İçerik doğruluğu:** Her formül ve miktar en az iki kaynaktan (Türk Farmakopesi, ders notları,
  Allen/Aulton) doğrulanmadan oyuna girmez. Rehber metinleri aynen kopyalanmaz.
- **Para:** Tek para birimi. Ücretli hızlandırıcı, rastgele paket, araya giren reklam yok.
  Reklam hiçbir zaman düşünme adımını atlatmaz.
- **Süre:** Bekleme süreleri sunucu saatiyle hesaplanır (cihaz saati hilesine karşı).
- **Ceza yok:** Hata kaliteyi düşürür, ürün her zaman satılır; hazır ürün bozulmaz.

## Kalite kapısı
`C:\Game` klasöründen `flutter analyze` ve `flutter test`. Temiz = 0 hata, 0 uyarı.
Doğrulamadan "bitti" denmez.

## Git
Depo: https://github.com/Pharmamental/Majistral (dal `main`). Tuğrul git bilmez; git işlerini
asistan yönetir.
- Oturum başında, koda dokunmadan önce: `git pull --rebase`.
- İş bitince: `git add -A`, Türkçe kısa commit mesajı, `git pull --rebase`, `git push`.
- Yeni dal açma, force push yapma, geçmişi değiştirme (`reset --hard`, `rebase -i`,
  `commit --amend`); riskli ya da geri alınamaz bir işlemde önce Tuğrul'a sor.

## Proje yapısı
```
lib/
├── main.dart          Uygulama girişi (MajistralApp)
├── theme/             tokens (renk, boşluk, köşe, AppText yazı stilleri), app_theme
├── models/            shop_item (ShopItem, Station), prescription, prep_job
├── data/              stations, market_items, orders (taslak içerik, doğrulanmadı)
├── logic/             quality (1–3 yıldız hesabı), schedule (adımları istasyonlara yerleştirir),
│                      job_store (süren işler, telefona kayıt,
│                      JobScope ile ekranlara verilir)
├── screens/           home (alt çubuklu kabuk), orders (Reçeteler), preparation (Hazırlama),
│                      lab (Laboratuvar), market
└── widgets/           chunky_button (3B düğme), game_tab_bar (alt çubuk), back_pill, prescription_card,
                       job_status, result_view, market_widgets, thermometer_panel/painter
```

## Arayüz kuralları (2026-10-25, Tasarım Rehberi'nden)
- Renk 60-30-10: krem zemin, beyaz kart, kiremit yalnız birincil aksiyon. Hazır/teslim yeşil.
- Yazı: hepsi Nunito (Tuğrul, 2026-10-27), başlık ve düğme en kalın (900); `assets/fonts/`'ta gömülü (OFL).
  Değişken font olduğu için kalınlık `AppText` ile verilir (`fontVariations`); düz
  `TextStyle(fontWeight)` bazı cihazlarda kalın çizmez. Ok için `›` kullan. Yeni font eklemeden önce
  dosyada ş, ğ, İ var mı tara: Fredoka, Lilita One, Titan One, Sniglet'te yok.
- Boşluk 4-8-12-16-20-24-32-40-48, dokunma alanı en az 44.
- Köşe dili "görevine göre" (Tuğrul, 2026-10-27): bilgi kutuları (kart, pencere, iç kutu) kâğıt gibi
  az yuvarlak (`AppRadius.paper` 6, `paperInner` 4); basılan her şey (düğme, sekme, çip) tam hap;
  eşya ve madde ikonlarının kutusu daire. Her öğeye aynı köşeyi verme.
- Birincil aksiyon altta (başparmak bölgesi): kartın en altı ya da ekranın sabit alt çubuğu.
- Öğrenme ekranı (Hazırlama) sade; kutlama (yıldız animasyonu) yalnız teslimde.
- Durum yalnız renkle anlatılmaz: seçimde onay işareti, sayaçta ikon + metin.
- Reçete kartında adım sırası gösterilmez (hazırlamadaki bulmacanın cevabını verir).
- Aletler (2026-10-25): hazırlamada spatül, havan ve çalışma yüzeyi seçilir; kurallar ASHP
  bülteninden (salisilik asit çelik spatülle tepkir; cam havan toz ezmez; parşömen kremde olmaz).
  Kaç alet yanlış olursa olsun alet hatası tek yıldız. Marketteki basamaklar gerçek aletler
  (merhem taşı → Unguator → merhem değirmeni); havanlar
  ve spatüller yükseltme değil, farklı işlerin aletleri (`Station.upgradePath = false`).
  Kaynak listesi: C:\YZ\knowledge\concepts\majistral-alet-ve-makineler.md.
- Laboratuvar (2026-10-26): her hazırlık adımı bir istasyonda çalışır (LabStation: havan,
  merhem taşı, su banyosu, ambalaj masası); bir istasyon aynı anda tek iş yapar, dolu istasyonda
  adım sıra bekler. Adım zamanları iş başlarken planlanır ve sonra değişmez (logic/schedule.dart).
- Oyuncu adımı (2026-10-26): `interactive: true` adımın süresi dolunca iş durur ve oyuncuyu
  bekler (kremde su banyosu: termometreyi 70–75°'de tut, `widgets/heating_sheet.dart`). Kalan
  adımlar ancak oyuncu bitirince, o andan planlanır (`PrepJob.pending`, `JobStore.completeAction`).
- Tartım yok (Tuğrul, 2026-10-27): tartım adımı, terazi istasyonu ve markette terazi kaldırıldı;
  iş levigasyon ya da ısıtmayla başlar. Reçete miktarları kartta yazılı kalır. Formüller ve
  kaynakları `lib/data/orders.dart` başında. Eski kayıtlarda terazi adımı okunurken atlanır.
- Acele et (Tuğrul, 2026-10-26): her basış işin planlanmış kalan çalışma süresini yarıya, kaliteyi de
  yarıya indirir, yıldız yukarı yuvarlanır (3 → 2 → 1, en düşük 1). Günde 5 hak (`JobStore.rush`,
  `rushSlots`). Oyuncu adımı beklerken basılamaz. Acele sonrası erken boşalan istasyonlara arkadaki
  işlerin başlamamış adımları kayar (`compactJobs`); başlamış adımlar yerinde kalır. Bu tek
  istisna dışında planlanmış zamanlar değişmez. Reklam henüz bağlı değil, onay penceresi yerini tutuyor.
- Kimyasal seçimi yok (Tuğrul, 2026-10-26): maddeler reçeteden gelir. Adım sırası da sorulmaz
  (Tuğrul, 2026-10-27): hazırlamada adımlar sabit sırayla gösterilir, oyuncu yalnız alet seçer.
  Her adımın kendi oyuncak blok ikonu var (`stepIcons`, `ikon_adim_<ad>.png`); yeni adım adı
  eklenirse ikonu da çizilir (`test/quality_test.dart` denetler).
- Reçete durum renkleri (2026-10-27): `OrderStatus` (seni bekliyor amber, hazır yeşil, hazırlanıyor
  mavi, yeni kiremit); renkler `AppColors` içinde, yazı tonları açık zeminde ≥5,1:1 ölçüldü. Reçeteler
  sekmesi bu sırayla dizilir; kartın şeridi ve süren işin göstergeleri durumun rengini taşır.
  Birincil düğme her zaman kiremit.
- Tezgâh (Tuğrul, 2026-10-27): Reçeteler başlığı açık duvarda, reçeteler ahşap tezgâhta yan yana;
  sağa sola kaydırılır (`PageView`, yanındaki kartın kenarı görünür). Kartlar tezgâhın raf kenarına
  iki parça kâğıt bantla asılı, hafif eğik (`PaperTape`); durum kartın başında çipte. Kart tezgâhın
  altına kadar uzar, düğmesi en altta (`pinAction`). Duvarda bütün reçetelerin küçük fişleri
  (durum + ad), dokununca o kart gelir; gösterilen kartın fişi durum renginde çerçeveli.
  (`CounterTop`, `orders_screen.dart`). Laboratuvar ve Market de tezgâhta:
  başlık (ve Market sekmeleri) duvarda, liste tezgâhın içinde kayar.
- Süren iş kartı (Tuğrul, 2026-10-27): iş başlayınca madde listesi kartta görünmez; sağ üstte
  "Reçete" düğmesi pencere açar (miktar, her maddenin marketteki görevi, ne işe yarar `purpose`,
  neyde kullanılır `usedFor`; kaynakları `lib/data/orders.dart` başında). Yerine adım şeridi gelir (biten onaylı, süren mavi, oyuncuyu bekleyen amber, sıradaki silik) ve
  büyük "… sonra hazır" sayacı. Acele düğmesinin üstüne bedel satırı ya da şimşek ikonları konmaz.
  Hekim adı yalnız unvan ve ilk ad ("Dr. Deniz").
- Reçete kartı koçan biçiminde (Tuğrul, 2026-10-27): üst kenar yarım daire delikli, alt köşeler
  yuvarlak (`PrescriptionStubBorder`).
- Alt çubuk (Tuğrul, 2026-10-27): ortada laboratuvar, çubuktan taşan büyük daire (porselen havan);
  yanlarda Reçeteler (reçete koçanı) ve Market (tenteli dükkân) oyuncak blok ikonları küçük
  dairelerde (`GameTabBar`). İkonlar `uretici.html` "Sekmeler" grubunda.
- Market hammaddeleri (2026-10-26): `chemicalGroups`, 6 rol grubunda 31 madde; liste ve kaynakları
  beyinde (`knowledge/concepts/majistral-hammaddeler.md`). Reçeteye yeni madde girerse markete de
  eklenir; her maddenin oyuncak blok ikonu olur (`test/market_items_test.dart` ikisini de denetler).
  İkonlar `tools/ikon_blok/uretici.html`'de; görünüşte benzer kardeş maddeler (Tween/Span, setil/
  stearil, iki paraben) aynı kapta çizilir, kapak rengiyle ayrılır.
- Testler gerçek fontu `test/test_fonts.dart` ile yükler; taşma testleri böyle gerçeği yansıtır.
- Süren işler `shared_preferences` ile telefona kaydedilir; saat şimdilik cihaz saati
  (`JobStore.now`). Sunucu saati gelene kadar saat hilesi mümkün; kapanmamış bir açık.
- Ekonomi, reklam ve bildirim henüz yok; satın alma düğmeleri bilerek boş.
- Eski deneme (Temmuz 2026, tek dosya) git geçmişinde: ilk commit `0bd231c`. 2026-10-25'te market
  düzeni, istasyon kademeleri, reçete kartı, termometre ve görseller oradan seçilerek taşındı.
  Taşınmayan görseller (`Capsule`, `Kalıp_ikon`, `Maserasyon_ikon`, `Oyun_tick`, `Carpi`)
  `assets/images/`'ta duruyor.

## Beyne iz bırak
Bu proje Tuğrul'un ikinci beyninin (`C:\YZ`) parçası; proje kartı
`C:\YZ\500-Projects 🏰\Majistral.md`. Biten iş fiş olarak yazılır, fişin ilk satırı `[Majistral]`
ile başlar. Açık iş `C:\YZ\tasks\`'a `project: "Majistral"` ile girer.
