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
├── logic/             quality (1–3 yıldız hesabı), job_store (süren işler, telefona kayıt,
│                      JobScope ile ekranlara verilir)
├── screens/           home (alt çubuklu kabuk), orders (Reçeteler), preparation (Hazırlama),
│                      lab (Laboratuvar), market
└── widgets/           chunky_button (3B düğme), back_pill (başlıklar), prescription_card,
                       job_status, result_view, market_widgets, thermometer_panel/painter
```

## Arayüz kuralları (2026-10-25, Tasarım Rehberi'nden)
- Renk 60-30-10: krem zemin, beyaz kart, kiremit yalnız birincil aksiyon. Hazır/teslim yeşil.
- Yazı: başlık ve düğme Baloo 2, gövde Rubik; ikisi `assets/fonts/`'ta gömülü (OFL). Değişken
  font olduğu için kalınlık `AppText` ile verilir (`fontVariations`); düz `TextStyle(fontWeight)`
  bazı cihazlarda kalın çizmez. Rubik'te `→` yok; `›` kullan.
- Boşluk 4-8-12-16-20-24-32-40-48, köşe 20, çip tam yuvarlak, dokunma alanı en az 44.
- Birincil aksiyon altta (başparmak bölgesi): kartın en altı ya da ekranın sabit alt çubuğu.
- Öğrenme ekranı (Hazırlama) sade; kutlama (yıldız animasyonu) yalnız teslimde.
- Durum yalnız renkle anlatılmaz: seçimde onay işareti, sayaçta ikon + metin.
- Reçete kartında adım sırası gösterilmez (hazırlamadaki bulmacanın cevabını verir).
- Aletler (2026-10-25): hazırlamada spatül, havan ve çalışma yüzeyi seçilir; kurallar ASHP
  bülteninden (salisilik asit çelik spatülle tepkir; cam havan toz ezmez; parşömen kremde olmaz).
  Kaç alet yanlış olursa olsun alet hatası tek yıldız. Marketteki basamaklar gerçek aletler
  (kefeli → elektronik → analitik terazi; merhem taşı → Unguator → merhem değirmeni); havanlar
  ve spatüller yükseltme değil, farklı işlerin aletleri (`Station.upgradePath = false`).
  Kaynak listesi: C:\YZ\knowledge\concepts\majistral-alet-ve-makineler.md.
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
