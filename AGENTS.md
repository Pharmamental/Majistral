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

## Klasörün durumu (2026-10-25)
Temmuz 2026'dan kalma bir Flutter projesi var (`lib/main.dart`, iki test). Git deposu değil.
Bu eski kodun korunup korunmayacağına henüz karar verilmedi; Tuğrul'a sormadan silinmez.

## Beyne iz bırak
Bu proje Tuğrul'un ikinci beyninin (`C:\YZ`) parçası; proje kartı
`C:\YZ\500-Projects 🏰\Majistral.md`. Biten iş fiş olarak yazılır, fişin ilk satırı `[Majistral]`
ile başlar. Açık iş `C:\YZ\tasks\`'a `project: "Majistral"` ile girer.
