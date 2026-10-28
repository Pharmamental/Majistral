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
├── models/            shop_item (ShopItem, Station), prescription, prep_job, formula (formül kitabı)
├── data/              stations, lab_tools (laboratuvardaki aletler), market_items, orders
│                      (taslak içerik, doğrulanmadı), references (kaynaklar), formulary +
│                      formulary/<kategori>.dart (300 formül, 6 × 50)
├── logic/             job_store (kabul edilen reçeteler, adım başlatma, acele, telefona kayıt,
│                      JobScope ile ekranlara verilir)
├── screens/           home (alt çubuklu kabuk), orders (Reçeteler), lab (Laboratuvar), market,
│                      profile (Profil), more (Diğer), references (Kaynaklar, Diğer'in içinde)
└── widgets/           chunky_button (3B düğme), game_tab_bar (alt çubuk), back_pill, prescription_card,
                       job_status, tool_sheet (alet → reçete), heating_sheet, result_view,
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
  Havanlar ve spatüller farklı işlerin aletleri (`Station.upgradePath = false`); kademeli
  gruplarda (merhem taşı → Unguator → merhem değirmeni, su banyosu) yalnız sahip olunan en
  yükseği yazar. Satın alma yokken sahip olunan = ücretsiz kademe (`isOwned`).
- Adımlar gerçek teknikler (Tuğrul, 2026-10-28, "asıl önemlileri koy"): kontrol, etiket ve
  ambalaj adım değil, laboratuvarda ambalaj aleti durmaz (markette Ambalaj grubu şimdilik
  etkisiz). Merhem: Ezme › Levigasyon › Geometrik seyreltme (salisilik asit); Levigasyon ›
  Geometrik seyreltme (çinko oksit). Krem: Eritme (su banyosu, termometre oyunu) › Çözme (su
  banyosu) › Emülsifikasyon (porselen kapsül) › Soğutma (porselen kapsül, buzsuz, karıştırarak).
  Adım = eczacının madde üzerinde eliyle, aletle ya da yöntemle yaptığı işlem (ezme, maserasyon,
  eritme, çözme, soğutma); malzeme ("su fazı") adım olmaz (Tuğrul, 2026-10-28).
  Ezme ve levigasyon havanda ya da merhem taşında spatülle; seyreltme spatülle ya da havanda
  (`PrescriptionStep.orWith`); salisilik asitte çelik spatül hiçbir adımda yok. Kaynak: Fırat Üni.
  merhem beceri kılavuzu, Ankara Üni. föyleri, USP, PTCB. Alet inceleme sayfası (20 alet, kaynaklı):
  https://claude.ai/artifact/RSKXpt9XPG4epnxApKCk7h Kurallar ASHP bülteninden
  (salisilik asit çelikle tepkir, cam havan toz ezmez) adımın `notWith`'inde; parşömen çıktı.
  Kaynak listesi: C:\YZ\knowledge\concepts\majistral-alet-ve-makineler.md.
- **KURAL: Reçetedeki her adım = laboratuvardaki bir kart** (Tuğrul, 2026-10-28). Reçetede
  "Maserasyon" yazıyorsa laboratuvarda "Maserasyon" kartı olur. Kartlar alet değil adımdır
  (Ezme, Levigasyon, Geometrik seyreltme, Eritme…); kart adımın ikonunu ve altında neyle
  yapıldığını gösterir ("Merhem taşı ve spatül · Porselen havan"). `labTools()` kartları
  reçetelerdeki adım adlarından türetir; yeni adımlı reçete eklenince kart kendiliğinden gelir,
  `test/steps_test.dart` denetler. Alet kuralları (salisilik asitte çelik spatül, cam havan toz
  ezmez) adımın `notWith`'inde kalır, seçim değil, adım başlatılırken "Dikkat:" uyarısı.
  Market yükseltmeleri (Unguator, termostatlı banyo) kartın "neyle yapılır" yazısını değiştirir.
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
  yarıya indirir, yıldız yukarı yuvarlanır (3 → 2 → 1, en düşük 1). Günde 5 hak (`JobStore.rush`).
  Adım çalışmıyorsa (reçete oyuncuyu bekliyor) basılamaz. Reklam henüz bağlı değil, onay penceresi yerini tutuyor.
- Kimyasal seçimi yok (Tuğrul, 2026-10-26): maddeler reçeteden gelir. Adım sırası da sorulmaz
  (Tuğrul, 2026-10-27): adımlar sabit sırayla yapılır.
  Her adımın kendi oyuncak blok ikonu var (`stepIcons`, `ikon_adim_<ad>.png`); yeni adım adı
  eklenirse ikonu da çizilir (`test/steps_test.dart` denetler).
- Reçete durum renkleri (2026-10-27): `OrderStatus` (seni bekliyor amber, hazır yeşil, hazırlanıyor
  mor, yeni kobalt); renkler `AppColors` içinde, yazı tonları açık zeminde ≥5,1:1 ölçüldü. Reçeteler
  sekmesi bu sırayla dizilir; kartın başındaki çip ve süren işin göstergeleri durumun rengini taşır; kartta yan şerit yok (Tuğrul, 2026-10-27).
  Oyuncuyu bekleyen kartta çip ve "Sıra sende: … aletine bas" cümlesi yok; bekleyen adım amber kutuda, altta yalnız "Laboratuvara git" (Tuğrul, 2026-10-28).
  Birincil düğme her zaman kobalt.
- Duvar ve tezgâh (Tuğrul, 2026-10-27): duvarda gelen reçeteler, tezgâhta elindekiler. Duvarda
  henüz alınmamış reçetelerin küçük fişleri (hekim, ad, süre; hepsi aynı boyda, düz, kobalt
  çerçeveli); dokununca reçete penceresi açılır, altta "Al". Alınan reçete duvardan kalkar,
  tezgâha iner ve öne gelir. Duvar sınırı (Tuğrul, 2026-10-27): duvarda en fazla 3 reçete
  birikir (`JobStore.wallSize`), boş yerler silik çerçeve; yenisi her 10 dakikada gelir
  (`arrivalEvery`, yer tutucu), sayaç geldiği anda yeniden başlar. Duvar doluyken sayaç
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
  dükkân), Profil (eczacı önlüğü), Diğer (çekmece dolabı; içinde Kaynaklar).
  Formüller sekmesi kaldırıldı (ekranı git geçmişinde); formül verisi duruyor
  (`GameTabBar`). Seçim her yerde aynı: adı kobalt yazı + altında kısa kobalt çizgi (`SelectionMark`); alt çubukta çizgi sekmeden sekmeye kayar, yolda uzayıp yerinde kısalır (`_SlidingMark`, Tuğrul 2026-10-27); daire seçimle renk değiştirmez. İkonlar `uretici.html` "Sekmeler" grubunda.
- Market hammaddeleri (2026-10-26): `chemicalGroups`, 6 rol grubunda 31 madde; liste ve kaynakları
  beyinde (`knowledge/concepts/majistral-hammaddeler.md`). Reçeteye yeni madde girerse markete de
  eklenir; her maddenin oyuncak blok ikonu olur (`test/market_items_test.dart` ikisini de denetler).
  İkonlar `tools/ikon_blok/uretici.html`'de; görünüşte benzer kardeş maddeler (Tween/Span, setil/
  stearil, iki paraben) aynı kapta çizilir, kapak rengiyle ayrılır.
- Formül kitabı (Tuğrul, 2026-10-28, /goal): 6 kategori farmasötik şekle göre (USP <1151>, Ph. Eur.
  şekil monografları): merhem ve patlar, kremler, jeller, çözeltiler, süspansiyonlar, tozlar ve
  kapsüller; her birinde 50, toplam 300 (`lib/data/formulary/`). Her formül üç soruyu cevaplar: ne
  işe yarar (`use`), hangi maddeler, nasıl yapılır (adımlar `formulaStepNames` içinden, her adımın
  ikonu var). Her formül en az iki kaynağa dayanır (`refs` → `data/references.dart`); yalnız
  farmakope, devlet kurumu, ders kitabı, makale, üniversite kaynağı; blog ve ticari site yok; metin
  kendi sözlerimizle, alıntı yok. Dışarıda: kırmızı/yeşil/turuncu/mor reçeteli ilaçlar, hormon,
  kortikosteroid, retinoid, NIOSH tehlikeli ilaçlar, antiaritmikler, klorokin türevleri, triklosan,
  kurşun/cıva/borik asit/kloroform, sistemik antibiyotik. İçerik taslak: alt ajanlar formüllerin
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
- Avatarlar (Tuğrul, 2026-10-28): önlüklü hayvan eczacılar. Oyuncak blok tarzında çizilmez
  ("oyuncak blok gibi çizme"). Dörtte üç açıdan (45° yandan), kalın koyu kontur, düz renk + uzak
  yanda tek ton gölge; aşırı sade de değil ("bu kadar da basit çizme"): tüy dokusu, kaş, renkli
  göz, önlükte cep ve yaka kartı gibi ayrıntılar olur. Yüz sevimli kalır, kaşlar V çatmaz.
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
