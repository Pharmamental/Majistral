# Majistral Oyunu: Proje Rehberi

Eczacılık öğrencilerine majistral hazırlamayı öğreten süreli mobil oyun (Flutter). Hekimlerden
reçete gelir, oyuncu istasyonlarda hazırlığı kurar, iş gerçek zamanda biter, hızlandırma yalnız
ödüllü reklamla. İlk sürüm tek bölüm: merhem ve krem.

## Kullanıcıyla konuşma
Tuğrul yazılımcı değil. Önce tek cümleyle sonuç, kısa cümle, günlük dil. Teknik terim gerekiyorsa
yanında ne demek olduğunu yaz. Komut ya da dosya adını ancak Tuğrul'un bir şey yapması gerekiyorsa göster.

## Oyundaki metinlerin üslubu
Tuğrul, 2026-10-29: "duvara reçete yeri +1 gibi ifadeler… oyunda kullandığın üslubu ve cümle
kalıplarını beğenmiyorum". Oyundaki her yazı, oyuncuyla konuşan düz bir Türkçe cümle olur.
- Matematik ve tablo dili yok: "+1", "+%10", "×2", "0/5", "3/4" yazma; "Duvarda 1 reçete daha
  birikir", "2 Papatya", "Elinde 3 tane var" yaz. Yüzde ancak cümlenin içinde ("%30 daha hızlı").
- Etiket ve iki nokta kalıbı yok: "Oyun etkisi: …", "Büyüme: 2 sa", "Dolu: …", "Sıradaki adım:
  …" yerine cümle kur ("2 sa sonra olgunlaşır", "Sıradaki adım ezme, 1 dk sürer.").
  Tek istisna (Tuğrul, 2026-10-30): vitrin penceresinde kilitli fanusun çiçek sayacı "1/4" yazar.
- "·" ile parça dizme, noktalı virgül ve büyük harfle vurgu ("EŞİTİ", "ALT") yok.
- Oyuncuya "sen" diye, etken çatıyla seslen: "teslim edildi", "kurutuldu", "acele edildi"
  değil "teslim ettin", "kuruttun", "acele ettin".
- Kısa tut; düğmede tek eylem ("Sat", "Teslim et", "Acele et"), açıklama düğmenin üstünde.

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
├── models/            shop_item (ShopItem, Station), prescription, prep_job, formula (formül kitabı)
├── data/              stations, lab_tools (laboratuvardaki aletler), market_items, orders
│                      (elle yazılmış 6 reçete + reçete üretici), order_book (kitaptan 106 reçete
│                      şablonu), references (kaynaklar), formulary +
│                      formulary/<kategori>.dart (311 formül, kategori başına en az 50)
├── logic/             job_store (kabul edilen reçeteler, adım başlatma, acele, telefona kayıt,
│                      JobScope ile ekranlara verilir)
├── screens/           home (alt çubuklu kabuk), orders (Reçeteler), lab (Laboratuvar), market,
│                      profile (Profil), more (Diğer), references (Kaynaklar, Diğer'in içinde)
└── widgets/           chunky_button (3B düğme), game_tab_bar (alt çubuk), back_pill, prescription_card,
                       job_status, tool_sheet (alet → reçete), heating_sheet, mini_games (adım
                       oyunları), mastery_medal, achievement_toast, result_view,
                       market_widgets, thermometer_panel/painter
```

## Arayüz kuralları (2026-10-25, Tasarım Rehberi'nden)
- Renk 60-30-10 (Tuğrul, 2026-10-27, "eski eczane"): porselen beyazı zemin, beyaz kart, kobalt mavisi yalnız birincil aksiyon, koyu ceviz tezgâh (yatay tahtalar, her biri farklı tonda, düzensiz damar; açık ve düz çizgili ahşap da yapay zekâ izi sayıldı). Hazır/teslim yeşil. Krem + kiremit ve Nunito "Claude yaptı" diye belli ettiği için bırakıldı; yapay zekânın varsayılan seçimlerine (krem + terracotta, Inter, Nunito, mor-mavi geçiş) dönme, rengi ve yazıyı eczanenin kendi malzemesinden türet.
- Yazı: hepsi Bitter (eski eczane etiketi gibi tırnaklı), başlık ve düğme en kalın (900); `assets/fonts/`'ta gömülü (OFL).
  Değişken font olduğu için kalınlık `AppText` ile verilir (`fontVariations`); düz
  `TextStyle(fontWeight)` bazı cihazlarda kalın çizmez. Ok için `›` kullan. Yeni font eklemeden önce
  dosyada ş, ğ, İ var mı tara: Fredoka, Lilita One, Titan One, Sniglet'te yok.
- Boşluk 4-8-12-16-20-24-32-40-48, dokunma alanı en az 44.
- Köşe dili "görevine göre" (Tuğrul, 2026-10-27): bilgi kutuları (kart, pencere, iç kutu) kâğıt gibi
  az yuvarlak (`AppRadius.paper` 6, `paperInner` 4); basılan her şey (düğme, sekme, çip) tam hap;
  eşya ve madde ikonlarının kutusu daire. Her öğeye aynı köşeyi verme.
- Birincil aksiyon altta (başparmak bölgesi): kartın en altı ya da ekranın sabit alt çubuğu.
- Sekme başlığı yaldızlı cam tabela (Tuğrul, 2026-10-29, "yaldızlı cam güzel ama her sekmenin
  kendine özel tasarımı olsun"; alternatifler https://claude.ai/artifact/7Kw617fR1DpTUGLSGhH5JJ):
  ekranın üstünde tam genişlik koyu cam, ad varak harfle, durum cümlesi açık varak tonunda,
  altta varak şerit (`TabHeader`, `TabSign`). Cam ve varak sekmenin malzemesinden: Reçeteler
  kobalt + altın, Laboratuvar arduvaz + gümüş, Market bordo + altın, Bahçe yeşil + altın,
  Profil ceviz + altın, Diğer ve Kaynaklar mürekkep laciverti + bakır. Para göstergesi camın
  üstünde yarı saydam, kenarı varak (`CoinPill(onGlass:)`). Yeni sekme kendi `TabSign`'ını alır.
- Öğrenme ekranları (Laboratuvar, alet penceresi) sade; kutlama (yıldız animasyonu) yalnız teslimde.
- Durum yalnız renkle anlatılmaz: seçimde onay işareti, sayaçta ikon + metin.
- Seçici düğmeler (Tuğrul, 2026-10-27): kobalt hap seçime hızlı (180 ms) ve doğrusal kayar, yazı
  rengi de aynı sürede geçer (`PillTabs`, `widgets/market_widgets.dart`). Yeni seçici düğme
  eklenince `PillTabs` kullanılır ya da aynı geçiş verilir. "Hareketi azalt" açıksa hap atlar.
- Pencereler alttan gelmez, yerinden büyür (Tuğrul, 2026-10-27, "A"): dokunulan şeyin yerinden
  büyüyüp ortada kâğıt olarak açılır, arka kararır ama görünür, arkaya dokununca küçülüp yerine
  döner (`openGrowing`, `widgets/grow_panel.dart`). Reçete penceresi koçan delikli reçete kâğıdı;
  "Al"a basınca kâğıt tezgâha iner. Alet, termometre, acele ve teslim pencereleri de böyle.
  `showModalBottomSheet` ve `showDialog` kullanma. Bu projede `dart format` çalıştırma: depo
  biçimlenmemiş, dokunulmayan dosyaları da değiştirir.
- Bütün reçete kartları aynı düzende (Tuğrul, 2026-10-27, "hidrofil merhem tasarımı"): sağ üstte
  "Reçete" düğmesi, ortada adım kutuları, en altta kartın tek aksiyonu. Kart yalnız tezgâhta,
  alınmış reçetede çizilir. Madde listesi kartta değil, pencerede. "Reçete"
  penceresinin "Hazırlık" bölümü adımları ikon ve `›` okuyla gösterir; ok şeridi yalnız orada.
  Adım kutusu beyaz, ikon açık gri dairede (`AppColors.iconWell`; cam ikonlar beyazda kayboluyordu).
- Aletler (Tuğrul, 2026-10-27): alet seçme ekranı yok; duvardan "Al" reçeteyi kabul eder. Aletler
  markette (`stations`); laboratuvarda adım kartlarının "neyle yapılır" satırında görünür.
  Sahip olunan = ücretsiz kademe ya da satın alınan (`JobStore.ownsTool`).
- **KURAL: Marketin istasyonları laboratuvarın adımlarıdır** (Tuğrul, 2026-10-29, "ŞART"): her
  adımın aynı adlı, aynı sıradaki istasyonu var; ilk kart ücretsiz basit alet, sonraki satın
  alınan daha iyi alet. Yükseltme yalnız o adımın süresini kısaltır (`ShopItem.faster`), başka
  etki (paralel yuva, kalite) yok. Ezme: Porselen havan › Wedgwood havan (%30); Levigasyon:
  Merhem taşı ve spatül › Merhem değirmeni (%50); Geometrik seyreltme: › Unguator (%30);
  Eritme: › Termostatlı su banyosu (%25); Çözme: Beher ve baget › Isıtıcılı manyetik
  karıştırıcı; Emülsifikasyon: Porselen kapsül › El homojenizatörü; Soğutma: › Su ceketli kap;
  Elekten geçirme: Elek › Titreşimli elek; Karıştırma: › Pervaneli karıştırıcı; Şişirme: ›
  Yüksek devirli karıştırıcı; Hacme tamamlama: Mezür › Şişe üstü dispenser; Kapsül doldurma:
  Kapsül doldurma aleti › Yarı otomatik kapsül makinesi (bunlar %30). Yeni 8 aletin ikonu
  çizilmedi (market genel ikon gösteriyor). Yeni adım eklenince istasyonu da eklenir
  (`test/steps_test.dart` denetler). Spatüller grubu çıktı; çelik spatül uyarısı adımda.
  Kart "yükseltme yolu" (Tuğrul, 2026-10-29, "E"; alternatifler
  https://claude.ai/artifact/MbXw222ewKvyqcM54UAm57): her istasyon tek kart, başta adımın
  büyük ikonu ve adı, altında aletler bir yolun durakları (elde: yeşil halka ve yeşil çizgi,
  altında "Bedava" ya da "Elinde"; sıradaki: kesik kobalt halka, altında "%30 daha hızlı"),
  en altta "1800 ile al" ya da "Elinde" (`StationSection`). Süre ("4 dk 30 sn sürer"),
  sağ üstte yüzde çipi ve "… para daha gerek" yazısı yok; para yetmezse düğme yalnız kapalı.
- Adımlar gerçek teknikler (Tuğrul, 2026-10-28, "asıl önemlileri koy"): kontrol, etiket ve
  ambalaj adım değil, laboratuvarda ambalaj aleti durmaz (markette Ambalaj grubu 2026-10-29'da
  çıktı). Merhem: Ezme › Levigasyon › Geometrik seyreltme (salisilik asit); Levigasyon ›
  Geometrik seyreltme (çinko oksit). Krem: Eritme (su banyosu, termometre oyunu) › Çözme (su
  banyosu) › Emülsifikasyon (porselen kapsül) › Soğutma (porselen kapsül, buzsuz, karıştırarak).
  Adım = eczacının madde üzerinde eliyle, aletle ya da yöntemle yaptığı işlem (ezme, maserasyon,
  eritme, çözme, soğutma); malzeme ("su fazı") adım olmaz (Tuğrul, 2026-10-28).
  Ezme ve levigasyon havanda ya da merhem taşında spatülle; seyreltme spatülle ya da havanda
  (`PrescriptionStep.orWith`); salisilik asitte çelik spatül hiçbir adımda yok. Kaynak: Fırat Üni.
  merhem beceri kılavuzu, Ankara Üni. föyleri, USP, PTCB. Alet inceleme sayfası (20 alet, kaynaklı):
  https://claude.ai/artifact/RSKXpt9XPG4epnxApKCk7h Kurallar ASHP bülteninden
  (salisilik asit çelikle tepkir) adımın `notWith`'inde; parşömen çıktı.
  Kaynak listesi: C:\YZ\knowledge\concepts\majistral-alet-ve-makineler.md.
- **KURAL: Reçetedeki her adım = laboratuvardaki bir kart** (Tuğrul, 2026-10-28). Reçetede
  "Maserasyon" yazıyorsa laboratuvarda "Maserasyon" kartı olur. Kartlar alet değil adımdır
  (Ezme, Levigasyon, Geometrik seyreltme, Eritme…); kart adımın ikonunu ve altında neyle
  yapıldığını gösterir ("Merhem taşı ve spatül ya da porselen havan"). `labTools()` kartları
  reçetelerdeki adım adlarından türetir; yeni adımlı reçete eklenince kart kendiliğinden gelir,
  `test/steps_test.dart` denetler. Alet kuralları (salisilik asitte çelik spatül) adımın `notWith`'inde
  kalır, seçim değil, adım başlatılırken uyarı ikonuyla düz cümle ("Plastik spatül kullan.").
  Cam havan uyarısı kalktı (Tuğrul, 2026-10-30): oyuncu alet seçmiyor, uyarıyla yapacağı bir şey yoktu.
  Adımın market yükseltmesi alınınca kartın "neyle yapılır" yazısı o aletin adı olur.
- Laboratuvar (Tuğrul, 2026-10-27): her adımı oyuncu başlatır. Adım kartına basınca kabul edilmiş
  reçeteler açılır (`widgets/tool_sheet.dart`); o adımı şimdi başlatabilenler kobalt vurgulu,
  başlatamayanların altında nedeni (`JobStore.whyNot`: "bu adım daha sonra", "bu reçetede bu
  adım yok", "bu adım bitti", dolu). Bir kart aynı anda tek reçetede çalışır; farklı kartlar
  aynı anda farklı reçetelerde. Adım bitince reçete sıradakini bekler ("seni bekliyor"), kendi
  kendine ilerlemez.
- Oyuncu adımı (Tuğrul, 2026-10-27): `interactive: true` adımda önce oyun, sonra süre (kremde
  eritme: termometreyi 70–75°'de tut, `widgets/heating_sheet.dart`); süre oyun bitince başlar.
- Tartım yok (Tuğrul, 2026-10-27): tartım adımı, terazi istasyonu ve markette terazi kaldırıldı;
  iş ezme, levigasyon ya da eritmeyle başlar. Reçete miktarları kartta yazılı kalır. Formüller ve
  kaynakları `lib/data/orders.dart` başında. Kayıt anahtarları `prep_jobs_v3` ve `wall_v1`; kimliksiz eski
  kayıtlar (v1, v2) okunmaz.
- Acele et (Tuğrul, 2026-10-26): her basış çalışan adımın kalan süresini yarıya, kaliteyi de
  yarıya indirir, yıldız yukarı yuvarlanır (3 → 2 → 1, en düşük 1). Günde 5 hak (`JobStore.rush`); vitrindeki boğaz fanusu ilk 1-3 acelede kaliteyi korur.
  Adım çalışmıyorsa (reçete oyuncuyu bekliyor) basılamaz. Reklam henüz bağlı değil, onay penceresi yerini tutuyor.
- Kimyasal seçimi yok (Tuğrul, 2026-10-26): maddeler reçeteden gelir. Adım sırası da sorulmaz
  (Tuğrul, 2026-10-27): adımlar sabit sırayla yapılır.
  Her adımın kendi ikonu var (`stepIcons`, `ikon_adim_<ad>.png`); yeni adım adı
  eklenirse ikonu da çizilir (`test/steps_test.dart` denetler).
- Reçete durum renkleri (2026-10-27): `OrderStatus` (seni bekliyor amber, hazır yeşil, hazırlanıyor
  mor, yeni kobalt); renkler `AppColors` içinde, yazı tonları açık zeminde ≥5,1:1 ölçüldü. Reçeteler
  sekmesi bu sırayla dizilir; kartın başındaki çip ve süren işin göstergeleri durumun rengini taşır; kartta yan şerit yok (Tuğrul, 2026-10-27).
  Oyuncuyu bekleyen kartta çip ve "Sıra sende: … aletine bas" cümlesi yok; bekleyen adım amber kutuda, altta yalnız "Laboratuvara git" (Tuğrul, 2026-10-28).
  Birincil düğme her zaman kobalt.
- Duvar ve tezgâh (Tuğrul, 2026-10-27): duvarda gelen reçeteler, tezgâhta elindekiler. Duvarda
  henüz alınmamış reçetelerin küçük fişleri (hekim, ad, süre; hepsi aynı boyda, düz, kobalt
  çerçeveli); dokununca reçete penceresi açılır, altta "Al". Alınan reçete duvardan kalkar,
  tezgâha iner ve öne gelir. Duvar sınırı (Tuğrul, 2026-10-27; ekonomi 2. turuyla 2026-10-29): duvarda en fazla 4 reçete
  birikir (`JobStore.wallSize`, çay fanusuyla `wallLimit`), boş yerler silik çerçeve; yenisi her
  60 dakikada gelir (`arrivalEvery`, yer tutucu; 10 dk'da duvar hep doluydu), sayaç geldiği anda yeniden başlar. Duvar doluyken sayaç
  dolsa da gelmez; reçete alınca süre çoktan dolmuşsa yenisi hemen gelir, sayaç o andan
  başlar. Uygulama kapalıyken de gelir. Reçeteler sırayla döner, aynı reçete yeniden gelebilir
  (her gelişin kimliği `IncomingOrder.id`, iş de bu kimlikle tutulur). Elde tutma sınırı yok,
  reçete kaybolmaz; ilk açılışta duvar dolu. Tezgâhta kartlar yan
  yana, sağa sola kaydırılır (`PageView`, yanındaki kartın kenarı görünür), raf kenarına iki
  parça kâğıt bantla asılı, düz (eğiklik Tuğrul isteğiyle kalktı, `PaperTape`); durum kartın
  başında çipte. Tezgâh boşken bantlı küçük not. Kartı tezgâhın altına uzatıp düğmeyi alta
  sabitlemek denendi, Tuğrul geri aldırdı (`CounterTop`, `orders_screen.dart`). Laboratuvar ve Market de tezgâhta:
  başlık (ve Market sekmeleri) duvarda, liste tezgâhın içinde kayar. Laboratuvarın tezgâhı ayrı
  bir oda gibi koyu gri arduvaz (`LabBench`, `AppColors.labBench`; Tuğrul 2026-10-27, "G1").
  Market'te üstte bordo-beyaz çizgili tente, altında kum tezgâh (`MarketStall`; Tuğrul
  2026-10-27, "T1"); tezgâhta doğrudan duran yazı `ink` rengindedir, `inkMuted` kumda soluk kalır.
- Süren iş kartı (Tuğrul, 2026-10-27): madde listesi kartta görünmez; sağ üstte
  "Reçete" düğmesi pencere açar (miktar, her maddenin marketteki görevi, ne işe yarar `purpose`,
  neyde kullanılır `usedFor`; kaynakları `lib/data/orders.dart` başında). Yerine adım şeridi gelir (biten onaylı, süren mor, oyuncuyu bekleyen amber, sıradaki silik) ve
  büyük "… sonra hazır" sayacı. Acele düğmesinin üstüne bedel satırı ya da şimşek ikonları konmaz.
  Hekim adı yalnız unvan ve ilk ad ("Dr. Deniz").
- Reçete kartı koçan biçiminde (Tuğrul, 2026-10-27): üst kenar yarım daire delikli, alt köşeler
  yuvarlak (`PrescriptionStubBorder`).
- Alt çubuk (Tuğrul, 2026-10-28): soldan sağa Reçeteler (reçete koçanı), Laboratuvar (çubuktan
  taşan büyük daire, porselen havan; `HomeScreen.lab` = 1, `GameTabBar.big`), Market (tenteli
  dükkân), Bahçe (sulama kabı; 2026-10-29), Profil (eczacı önlüğü), Diğer (çekmece dolabı;
  içinde Kaynaklar). Altı sekmede dar telefonda ad kesilmez, yalnız sığmadığında küçülür
  (`FittedBox`).
- Bahçe (Tuğrul, 2026-10-29): eczanenin arka bahçesi; başlık duvarda, altında badanalı tahta
  çit ve soluk zeytin yeşili çimen (`GardenGround`), ceviz çerçeveli yükseltilmiş toprak
  parseller (`GardenBed`, `widgets/garden_widgets.dart`): 3 açık, 3 kilitli (çimende kesik
  çerçeve + kilit + kâğıt etiket). Mekanik kodda (2026-10-29, `models/garden.dart`, kayıt
  `garden_v1`). **Tohum, çiçek, fanus** (Tuğrul, 2026-10-29, "her teslimde zar atılır",
  "Yüzdeler tür başına olsun"): teslimlerin %50'si bir tohum getirir (teslim penceresinde
  yazar); türü kademe ağırlığıyla, tür başına seçilir (her sık 60, her orta 27,5, her nadir
  12,5; gruplar ~%47/%43/%10, tek bir orta bitki bir nadirin iki katı sık). Tohumlar birikir.
  Boş parsele dokununca tohum seçilip ekilir; bitki gerçek zamanda büyür (sık 2 sa, orta 6 sa,
  nadir 12 sa; "oyun süresi" diye yazar), olgunlaşınca bozulmaz; olgun parsele dokununca
  hasat: kurutulmuş çiçek (`garden.flowers`). **Çiçek matematiği** (Tuğrul, 2026-10-30,
  "Evet, uygula"): hasat sıradan 1, orta 2, nadir 3 çiçek verir (`DriedPlant.harvestYield`);
  fanus o bitkiden sıradan 3, orta 4, nadir 5 çiçek ister (`DriedPlant.fanusCost`,
  `Garden.canShow`). Düzenli oyuncu (günde 6 teslim) ilk fanusu ~2, Papatya'yı ~8, Mürver'i
  ~23, bütün vitrini ~45 günde açar (eskiden 8, 13, 63, 97); az oynayan ~4, 12, 38, 76.
  Ekim penceresi "… sonra olgunlaşır, 3 çiçek verir" yazar. Vitrine ilk konuşta bedel kadar
  çiçek harcanır, fanus kalıcıdır
  (`garden.grown`; raftan kaldırıp geri koymak çiçek harcamaz). **Oyuncu çiçeğini markette
  satar** (Tuğrul, 2026-10-29, "malum çiçekleri satıyoruz orada"): "Çiçekler" sekmesinde her
  bitki için "Sıradan çiçek", fanusunun etkisi, "Elinde 3 tane var" (yoksa "Elinde hiç yok")
  ve "Sat" (bir tane, `JobStore.sellFlower`); fiyat yazmaz. Satış fiyatı yer tutucu
  (`flowerSellPrices` 10/15/25; bir tohumun parası 10/30/75, teslim başına ortalama ~13 para). Dükkândan çiçek alma kalktı.
  Kademe adları oyunda "Sıradan", "Sıradışı", "Nadir" (Tuğrul, 2026-10-30); bu dosyada "sık"
  sıradan, "orta" sıradışı demektir. Gübre, nadir tohum garantisi
  ve tohum satın alma kalktı (eski kayıttaki o alanlar okunmaz). Bahçenin üstündeki kâğıtta
  tohum ve çiçekler "2 Papatya" diye yazar. `unlockAll` vitrini açmaz; bahçeden önce rafa
  konmuş fanus açık sayılır; seçicide bitkiler sıradan, orta, nadir diye dizilir,
  kademe içinde açıklar üstte; kilitliler soluk, etkisi yazılı, sağda çiçek sayacı ("1/4")
  ve kilit. Duvar
  ve acele sınırı vitrine göre (`JobStore.wallLimit`, `protectedRushesLeft`), cilt fanusu
  teslim emeğini artırır.
  Parsel 4-6 parayla açılır (800/1600/3200). Kurutma askısı henüz yok. Vitrindeki fanus küçük oyun etkisi verir, aynı gruptan iki fanus
  toplanmaz, en güçlüsü sayılır: çaylar duvar (Papatya +1, Ihlamur/Rezene +1, Mürver +2;
  ekonomi 2. turu, "önerilerle": +3 az oynayanın teslimini %34 artırıyordu), boğaz günde
  1/2/3 acelenin kaliteyi düşürmemesi (Adaçayı, Kekik/Hatmi, Gelincik; acele hakkı artırmak
  para kaybettirdiği için değersizdi), cilt teslim emeği (Aynısefa
  %5, Lavanta/Defne %10, Kantaron %15), ferahlatıcı teslimin tohum şansı (Nane %10,
  Biberiye/Okaliptüs %20, Ekinezya %30 artırır, yani %50 yerine %55, %60, %65 olur; Tuğrul,
  2026-10-30, "okey A": bahçe hızı boşa gidiyordu, darboğaz parsel değil tohum; bahçe hızı kalktı). Etki ekranda etiketsiz, düz
  cümleyle yazar ("Duvarda 1 reçete daha birikir", "Günün ilk acelesi kaliteyi düşürmez",
  "Teslimde emek parası %10 artar", "Teslimlerin tohum getirme ihtimali %20 artar"); sahte farmakoloji kurulmaz.
  Market sekmeleri dört (Hızlandırma, İstasyonlar, Kimyasallar, Çiçekler); `PillTabs` yazısı
  yalnız sığmadığında küçülür (`test/market_screen_test.dart`, 360 dp).
  Formüller sekmesi kaldırıldı (ekranı git geçmişinde); formül verisi duruyor
  (`GameTabBar`). Seçim her yerde aynı: adı kobalt yazı + altında kısa kobalt çizgi (`SelectionMark`); alt çubukta çizgi sekmeden sekmeye kayar, yolda uzayıp yerinde kısalır (`_SlidingMark`, Tuğrul 2026-10-27); daire seçimle renk değiştirmez. İkonlar `uretici.html` "Sekmeler" grubunda.
- Market hammaddeleri (2026-10-26): `chemicalGroups`, rol gruplarında; liste ve kaynakları
  beyinde (`knowledge/concepts/majistral-hammaddeler.md`). Reçeteye yeni madde girerse markete de
  eklenir; her maddenin ikonu olur (`test/market_items_test.dart` ikisini de denetler).
  İkonlar `tools/ikon_blok/uretici.html`'de; görünüşte benzer kardeş maddeler (setostearil/stearil,
  iki paraben, hazır baz kavanozları) aynı kapta çizilir, kapak rengiyle ayrılır.
- **İkon tarzı: renkli bilimsel çizim** (Tuğrul, 2026-10-29, "27"; oyuncak blok küçük boyda
  okunmuyordu). Eski farmakope levhası gibi: açık renk boya (`BOYA` .3), mürekkep laciverti
  kontur (`CIZGI` 2.2), ışık sol üstten, gövdelerin sağ alt yarısında çapraz tarama; çizgi
  (`line`) parçaları mürekkep rengi, hacim ve renk geçişi yok. Tarz sayfasındaki çizgi 1,5'ti,
  40 pikselde kaybolmasın diye kalınlaştırıldı. Seçim sayfası (40 tarz):
  https://claude.ai/artifact/K3XFvUP2j2Ws7Kypt5x7HT. Üretici `tools/ikon_blok/uretici.html`
  (`svgIkon`), PNG'ler `py -3 tools/ikon_blok/export.py` ile; geometri değişmedi.
- Kimyasal sekmesi (Tuğrul, 2026-10-29): madde, onu isteyen ilk reçete duvara gelince açılır;
  o güne dek soluk, renksiz ikonlu ve kilitli durur, adı yazmaz ("Kilitli madde"), alınmaz ("Bu maddeyi isteyen ilk reçete
  gelince açılır."). Açılanlar kayıtta (`wall_v1`, `seen`; `JobStore.chemicalUnlocked`); eski
  kayıtta o güne dek gelmiş reçetelerden türetilir. Grupta açıklar üstte, kilitliler altta.
  Rafta gram değil paket adedi yazar ("Sahip olunan: 3 adet", açılmış paket bir sayılır;
  `JobStore.packsOf`); paket gramı da yazmaz. Grup başlığı ortada, eski eczane rafı etiketi
  gibi: çift çizgili beyaz kâğıt, üstünde bant, altında "8 maddeden 5 açık"
  (`ChemicalGroupHeader`). Açıklamalar sade: ne olduğu ve ne işe yaradığı, bir iki kısa
  cümle; teknik terim yok ya da yanında anlamı (reçete penceresi de `chemicalRole` ile okur).
  Satırda düğme "Al"; basınca hemen almaz, satırın yerinden pencere büyür: `PillTabs` ile
  1-5-10-20-100 paket, toplam fiyat, kasadaki para, "N paket al" (para yetmezse kapalı ve
  "Paran yetmiyor"), "Vazgeç" (`openPackBuy`, `JobStore.buyPacks`; Tuğrul, 2026-10-29).
  Paket fiyatı satırın alt yazısında ("Paketi 30 para · Sahip olunan: 3 adet").
- **500 reçete, 39 madde** (Tuğrul, 2026-10-28, "30-40 civarı madde, her madde en az 10
  reçetede, 500 civarı reçete"): markette 39 madde, hepsi en az 10 reçetede; reçetede geçmeyen
  madde markette durmaz (benzil benzoat, kafur, LCD, rezorsin, PEG 400/3350, setil alkol, stearik
  asit, GMS, Tween, Span çıktı). 40 maddeyle kitaptan en çok ~70 formül tamamen yapılabiliyor;
  bu yüzden 68 temel reçete (elle yazılmış 6 + kitaptan 62, `order_book.dart`) farklı miktarla
  7-10 hâl olarak geliyordu; bu 2026-10-29'da kalktı (aşağıda "Miktar bilgi").
  Her reçetenin tek kimliği `PrescriptionOrder.key` (adı); iş, duvar ve teslim kaydı
  bununla tutulur (`order` alanı; eski kayıtta yoksa ad). Oyuna giren kitap formüllerinden
  raf ömrü olmayan 60'ına USP <795>'in genel süresi yazıldı (sulu koruyucusuz 14 gün buzdolabı,
  sulu koruyuculu 35 gün, susuz 180 gün; sulu krem ve setomakrogol krem koruyuculu, izopropanol
  ≥%40 koruyucu sayıldı). Dışarıda: polihexanid jelleri (enjeksiyonluk su), %70 izopropil alkol,
  plasebo kapsülü, nötralleştirme ve süzme adımlı formüller (laboratuvarda kartları yok).
  Şablonlar scratchpad'deki betikle üretildi, artık elle düzenlenir.
- **62 madde, 112 farklı majistral** (Tuğrul, 2026-10-29, "farklı majistral sayımız çok az",
  "Madde + yeni formül"): markete 23 madde eklendi (etanol, hidrojen peroksit, lidokain,
  benzokain, mikonazol, klotrimazol, potasyum sorbat, HPC, bentonit, kalamin, kâfur, krotamiton,
  laktik/benzoik/buzlu asetik/askorbik asit, kalsiyum karbonat, allantoin, kolesterol, sarı
  balmumu, noniyonik hidrofil krem, basit merhem, emülsiye edici merhem); kitapta duran 34 formül
  bunlarla oyuna girdi. Kitaba eldeki maddelerle yapılabilen 11 yeni formül yazıldı (İspanya ve
  Brezilya ulusal formülerleri, WHO el antiseptikleri, IARC kolposkopi, BAD özel listesi); 10'u
  oyunda (benzoik asit çözeltisi eczane stok çözeltisi, yalnız kitapta). "Etkin maddeler" markette üçe
  bölündü (deri, antiseptik ve uyuşturucu, ağızdan alınanlar). Bir formülün miktarı ikinci
  bağımsız kaynakta görülmediyse girmez: NRF 11.2/11.3/11.4/11.60 çalkalama losyonları ve pudra
  ile klotrimazollü üre patı ve çinko merhemi yalnız Altmeyer'de görüldüğü için bekliyor.
- **Miktar bilgi, mekanik değil** (Tuğrul, 2026-10-29, "100 gramda hangi maddeden kaç g var onu
  yaz ama oyunun bir mekaniği olmasın"): "Formül 100 g için; sen 30 g hazırla" ve farklı
  miktarlı hâller kalktı. Her formül tek reçete (112 reçete; "her formül tek reçete"), duvar
  sırayla döndürür. Gram ve mL'li formül hep 100 g ya da 100 mL için yazılır (kitapta 50 g ya da
  1000 g olsa da çevrilir); kapsül ve paket toz kendi sayısıyla (30 kapsül), kapsül numarası
  bilgi satırında ("3 numara kapsül", `PrescriptionOrder.note`). 0,1 g altı mg yazılır. Raftaki
  stok bu 100 g'lık miktar kadar düşer ("Evet, 100 g üzerinden"); paket boyları eski medyan
  gramajla seçilmişti, yeniden ayarlanmadı. Her madde en az bir reçetede geçer (eski "en az 10
  reçetede" kuralı hâllerle sayılıyordu). Eski kayıttaki "· 2" hâl kimlikleri okunmaz.
- Formül kitabı (Tuğrul, 2026-10-28, /goal): 6 kategori farmasötik şekle göre (USP <1151>, Ph. Eur.
  şekil monografları): merhem ve patlar, kremler, jeller, çözeltiler, süspansiyonlar, tozlar ve
  kapsüller; her birinde 50, toplam 300 (`lib/data/formulary/`). Her formül üç soruyu cevaplar: ne
  işe yarar (`use`), hangi maddeler, nasıl yapılır (adımlar `formulaStepNames` içinden, her adımın
  ikonu var). Her formül en az iki kaynağa dayanır (`refs` → `data/references.dart`); yalnız
  farmakope, devlet kurumu, ders kitabı, makale, üniversite kaynağı; blog ve ticari site yok; metin
  kendi sözlerimizle, alıntı yok. Dışarıda: kırmızı/yeşil/turuncu/mor reçeteli ilaçlar, hormon,
  kortikosteroid, retinoid, NIOSH tehlikeli ilaçlar, antiaritmikler, klorokin türevleri, triklosan,
  kurşun/cıva/borik asit/kloroform, sistemik antibiyotik. Sınırda kalan da dışarıda (Tuğrul,
  2026-10-28, "hepsini çıkar"): melatonin, ritim ilacı sayılan beta bloker ve kalsiyum kanal
  blokerleri (propranolol, metoprolol, verapamil, diltiazem), ağızdan antifungal (terbinafin). İçerik taslak: alt ajanlar formüllerin
  bir kısmını bellekten yazdı (özellikle kapsül dolgu miktarları ve bazı bazlar); yayından önce
  öğretim üyesi onayı şart. Raf ömrü `Formula.shelfLife` (kaynağın verdiği; kapsülde USP <795>
  180 gün). 2026-10-28'de 28 kapsül ve 33 tabletten süspansiyon kaynakla tek tek kontrol edildi;
  NIOSH 2024 listesindeki ilaç (ör. spironolakton) kitaba girmez. Kontrol kaydı beyinde
  `knowledge/concepts/majistral-formul-dogrulama.md`.
- Laboratuvarın yeni adımları (2026-10-28): formül kitabında en sık geçen ve laboratuvarda olmayan
  adımlar eklendi: Hacme tamamlama (146), Karıştırma (96), Elekten geçirme (78), Şişirme (53),
  Kapsül doldurma (28, temel teknik diye). Aletler: Beher ve baget, Mezür, Elek, Kapsül doldurma
  aleti (`Cam eşya`, `Toz aletleri`). Yeni reçeteler: çinko oksitli nişasta pudrası, HEC jeli,
  folik asit kapsülü; markete hidroksietilselüloz, laktoz, folik asit eklendi. Bir adım formüllerin
  %10'undan fazlasında geçiyorsa laboratuvarda yapılabilmeli (`test/formulary_test.dart`).
- Profil (Tuğrul, 2026-10-28, "Diploma + ustalık + koleksiyon"): duvarda ceviz çerçeveli eczacılık
  diploması (ad, eczane adı, kalemle değişir; avatar halkası ve unvan teslim sayısıyla yükselir:
  Stajyer eczacı 0, Eczacı 10, Uzman eczacı 30, Mesul müdür 60; eşikler yer tutucu). Altta
  `PillTabs`: Ustalık ve Koleksiyon. Düzeltmeler (Tuğrul, 2026-10-28, "önce düzeltmeler"):
  ustalık yıldızla ölçülmez (yıldızı yalnız acele düşürüyor), kaç kez yapıldığıyla kademelenir
  (Başladın 1, Bronz 5, Gümüş 15, Altın 40; yer tutucu); yalnız denenen teknikler listelenir,
  kalanlar tek cümle. Koleksiyon yalnız oyunda hazırlanabilen formülleri sayar; oyunda reçetesi
  olmayan kategori "0/50" değil "Yakında". Varsayılan ad yok ("Adını yaz"); unvan yalnız
  diplomada; ortalama yıldız gösterilmez. Hiç teslim yoksa "İlk reçeteni bekliyoruz" + "Reçetelere
  git". Hepsi teslim kaydından
  (`JobStore.deliveries`, anahtar `deliveries_v1`; adlar `profile_v1`). Her oyun reçetesinin formül
  kitabındaki karşılığı `PrescriptionOrder.formula`. Liderlik tablosu ve satılık çerçeve yok.
  Sonraya: reçete defteri, seri (onarma haklı), kazanılan çizimli avatar çerçeveleri.
- Profil eklemeleri (Tuğrul, 2026-10-28): reçete defteri (son 3 teslim, tamamı güne göre gruplu);
  ustalıkta madalya halkası (`MasteryMedal`: Başladın gri, Bronz, Gümüş, Altın; dört çentik,
  renkler `AppColors.medal*`); Bronz, Gümüş ya da Altın'a çıkınca teslimde üstte koyu
  kırmızı-beyaz açılan kapsül kutucuğu ("Ezme · Bronz / 5 kez hazırladın", `achievement_toast.dart`;
  Başladın kutucuk çıkarmaz). Vitrin rafında ilaç durmaz ("ilaç koymak çok iyi değil"): fanusta
  kurutulmuş tıbbi bitki, 16 tane (`data/dried_plants.dart`, ikonlar uretici.html "Vitrin";
  `glass:1` parça yan yüzsüz, yarı saydam); nasıl kazanılacakları sonra kararlaştırılacak.
- Şimdilik her şey açık (Tuğrul, 2026-10-28, "unlocked bir şey olmasın"): `unlockAll`
  (`data/lab_tools.dart`): market aletleri elde, koleksiyon tam, vitrine her fanus konur.
  Kazanma ve satın alma kuralları gelince false yapılır; testler iki duruma göre yazıldı.
- **Hasta soruyor** (Tuğrul, 2026-10-30, "hasta soruyor mantıklı"; "reçetelerin normal sistemini
  değiştirmeyeceğin"): reçete, adımlar ve teslim aynı kalır; bilgi teslimden sonra sınanır. Teslim
  penceresi kapanınca hasta gelir (`askPatient`, `widgets/patient_sheet.dart`), reçete kapalıyken
  3 şıktan birini seçersin. Günde en çok 3 soru (`dailyPatientQuestions`). Doğruda o teslimin
  parasının %10'u bahşiş (`patientTipPercent`, Tuğrul, 2026-10-30), yanlışta ceza yok, doğrusu gösterilir, hasta 1, 3 ve 7 gün sonra
  yeniden gelir ("… yeniden geldi"; `PatientBook`, kayıt `patient_v1`); ilk seferde bilinen soru
  dönmez. Soru türleri `models/patient_question.dart`, yalnız ikisi (Tuğrul, 2026-10-30, saklama
  sorusu kalktı): ilacın endikasyonu (`orderUses` + `useAnswers`, `data/patient_uses.dart`; yeni
  tıbbi bilgi yok, `usedFor`'dan kısaltıldı) ve içindeki maddenin işlevi (`chemicalRole`). Yanlış
  şık bu ilaç için doğru olamaz; önce aynı aileden gelir (deri, ağız ve kulak, ağızdan alınan).
  Yeni reçete eklenince `orderUses`'a da yazılır (`test/patient_test.dart` denetler). Kuşkulu
  6 reçete (`unverifiedOrders`) hoca bakana kadar soru olmaz. Testler akışı
  `patientQuestionsEnabled = false` ile sınar.
- Mini oyunlar (Tuğrul, 2026-10-28): her laboratuvar adımında süre başlamadan önce o tekniğin
  hareketi birkaç saniye oynanır, gerçek yapılıştan türetildi (`widgets/mini_games.dart`,
  `miniGameFor`): ezmede kristal kırıp havanda dairesel sürtme, levigasyonda damla damla sıvı
  + spatül, seyreltmede eşit miktar, çözme/karıştırma/emülsifikasyonda uygun hızda daire,
  soğutmada ritim, elekte sallama, şişirmede yüzeye serpme (aynı yere yığma topak yapar),
  hacimde menisküsün alt kenarı, kapsülde tozu yayıp bastırma. Eritme kendi termometre oyunu.
  Hata kaliteyi düşürür, oyun hep biter; kalite şimdilik yıldızı etkilemez (karar açık).
  Görseller yer tutucu çizim. Testler adım akışını `miniGamesEnabled = false` ile sınar.
- Avatarlar (Tuğrul, 2026-10-28): hayvan eczacılar bırakıldı ("hayvanlar olmadı"); avatar önlüklü
  genç eczacı (kız ve erkek), kâğıt kesik tarzında (her parça ayrı kâğıt, altında yumuşak gölge).
  Yüz canlı ve karizmatik olur ("gözler ve ağız hiç canlı durmuyor"): badem göz, renkli iris,
  kalın üst kirpik çizgisi, şekilli dolu kaş, dişli ya da yan gülüş; nokta göz ve tek çizgi ağız
  yok. Oyuncak blok tarzında çizilmez. Taslaklar: scratchpad `eczaci/kagit.html` (seçim bekliyor).
- Testler gerçek fontu `test/test_fonts.dart` ile yükler; taşma testleri böyle gerçeği yansıtır.
- Süren işler `shared_preferences` ile telefona kaydedilir; saat şimdilik cihaz saati
  (`JobStore.now`). Sunucu saati gelene kadar saat hilesi mümkün; kapanmamış bir açık.
- **Ekonomi kodda** (Tuğrul, 2026-10-29, "Evet, önerilerle"; `data/economy.dart`, kayıt
  `economy_v1`, hesap beyinde `knowledge/concepts/majistral-ekonomi.md` 2. tur). Tek para.
  Teslim = malzeme bedeli (hep tam) + adım başına 11 emek × yıldız (%100/%70/%40); günün ilk 3
  teslimi emek ×2; cilt fanusu emeğe %5-15. Kimyasal paketle alınır (`packs`, 61 madde), gramla
  harcanır (`gramsFor`: yüzde, ad, not satırı, kapsül 0,2 g laktoz); "Al" anında raftan düşer,
  eksik paket kasadan alınır, kasa yetmezse ecza deposu veresiye verir, borç teslimden kesilir
  (oyuncu hiç takılmaz; 1★ teslim bile malzemesini öder, test denetler). Başta her maddeden bir
  paket + 100 para. Distile su bedava. Aletler satın alınır, her biri kendi adımını kısaltır
  (`stepDuration`; liste yukarıda "Marketin istasyonları"). Cam havan ve tüp doldurma aleti
  marketten çıktı (hiçbir adımı değiştirmiyordu).
  Giderler 14 800 (aletler 9 200 + parsel 5 600); emek 11 bu toplamdan çözüldü. 2026-10-29'da
  8 yeni alet eklendi (5 900), aletler 15 100, giderler 20 700 oldu; emek yeniden ayarlanmadı. Para göstergesi
  Market ve Bahçe başlığında (`CoinPill`), teslim penceresinde döküm. Reklam ve bildirim henüz
  yok; acele düğmesi onay penceresiyle çalışıyor.
- Eski deneme (Temmuz 2026, tek dosya) git geçmişinde: ilk commit `0bd231c`. 2026-10-25'te market
  düzeni, istasyon kademeleri, reçete kartı, termometre ve görseller oradan seçilerek taşındı.
  Taşınmayan görseller (`Capsule`, `Kalıp_ikon`, `Maserasyon_ikon`, `Oyun_tick`, `Carpi`)
  `assets/images/`'ta duruyor.

## Beyne iz bırak
Bu proje Tuğrul'un ikinci beyninin (`C:\YZ`) parçası; proje kartı
`C:\YZ\500-Projects 🏰\Majistral.md`. Biten iş fiş olarak yazılır, fişin ilk satırı `[Majistral]`
ile başlar. Açık iş `C:\YZ\tasks\`'a `project: "Majistral"` ile girer.
