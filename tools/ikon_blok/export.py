"""uretici.html'deki her ikonu şeffaf PNG olarak çıkarır (Edge headless).

Kullanım: py -3 export.py [çıktı klasörü] [boy]
Varsayılan: C:/Game/assets/images/ikon, 288 px. Dosya adı: ikon_<dosya>.png
Pharmamental'ın ikon-blok/export.py betiğinden uyarlandı.
"""
import pathlib
import re
import subprocess
import sys

EDGE = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
burasi = pathlib.Path(__file__).resolve().parent
sayfa = burasi / "uretici.html"
cikti = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else burasi.parent.parent / "assets" / "images" / "ikon")
boy = int(sys.argv[2]) if len(sys.argv) > 2 else 288
cikti.mkdir(parents=True, exist_ok=True)

ortak = [EDGE, "--headless=new", "--disable-gpu", "--hide-scrollbars", "--virtual-time-budget=3000"]
adlar = re.findall(r"dosya:'([^']+)'", sayfa.read_text(encoding="utf-8"))
for sira, ad in enumerate(adlar):
    adres = f"{sayfa.as_uri()}?tek&px={boy}#{sira}"
    hedef = cikti / f"ikon_{ad}.png"
    subprocess.run(ortak + ["--default-background-color=00000000",
                            f"--window-size={boy},{boy}", f"--screenshot={hedef}", adres],
                   capture_output=True)
    print(hedef.name)
