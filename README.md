# Huzur Zikirmatik (Dhikr & Tasbeeh)

Google Play Store ve Apple App Store standartlarına tam uyumlu, modern, zarif ve zengin özellikli Flutter Zikirmatik uygulaması.

---

## 🌟 Öne Çıkan Özellikler

1. **Ergonomik ve Modern Sayaç Tasarımı:**
   - Şık, parlayan dairesel ilerleme halkası (Progress Ring).
   - Tek elle rahat kullanım için optimize edilmiş devasa dokunma alanı.
   - **Tam Ekran Dokunma Modu:** Ekrana bakmanıza gerek kalmadan ekrandaki herhangi bir noktaya dokunarak zikir çekebilme imkânı.
   - Geri alma (-1) ve sıfırlama onay koruması.

2. **Hissiyat & Gerçekçi Geri Bildirim:**
   - **Haptik Titreşim:** Kapalı / Hafif / Orta / Güçlü seviye seçenekleri.
   - **Dönüm Noktası Titreşimi:** 33, 99 ve hedefe ulaşıldığında özel çift titreşim uyarısı.
   - **Ses Efekti:** Gerçekçi mekanik tık geri bildirimi (Açılıp kapatılabilir).

3. **Zengin Zikir Kütüphanesi:**
   - **Namaz Tesbihatı:** Sübhanallah, Elhamdülillah, Allahu Ekber.
   - **Günün Zikirleri:** Lâ ilâhe illallâh, Estağfirullah, Salavat-ı Şerife, vb.
   - **Esmâ-ül Hüsnâ:** Anlamları ve özel ebced/hedef sayılarıyla seçkin isimler.
   - **Özel Zikir Ekleme:** Kendi zikrinizi, Arapçasını, hedefini ve notunuzu ekleyip yönetebilme.

4. **Kişiselleştirilebilir Temalar:**
   - **Zümrüt Yeşili (Emerald):** Göz yormayan asil İslami yeşil ve altın detaylar.
   - **Gece Mavisi (Midnight):** OLED ekranlar ve gece kullanımı için derin koyu tema.
   - **Kraliyet Altını (Gold):** Sıcak amber ve altın tonları.
   - **Minimal Taş (Stone):** Sade ve modern antrasit/arduvaz stili.

5. **İstatistik & Devamlılık Takibi:**
   - Ömür boyu toplam çekilen zikir sayısı.
   - Bugün çekilen toplam zikirler.
   - Son 7 günün görsel aktivite çubuk grafiği (Streak).
   - En çok çekilen zikirlerin sıralaması.

6. **Mağaza Uyumluluğu & Güvenlik:**
   - %100 Çevrimdışı (Offline-first) çalışma.
   - Sıfır veri toplama: Tüm veriler yerel hafızada (`SharedPreferences`) şifresiz ve güvenle saklanır.
   - Yerleşik Gizlilik Politikası (Store onayı için zorunlu).

---

## 📱 Google Play Store İçin Yayınlama (Android)

### 1. Release Keystore Oluşturma
Terminalde (PowerShell) şu komutu çalıştırarak imza anahtarınızı oluşturun:
```powershell
keytool -genkey -v -keystore C:\Users\Yusuf\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. `android/key.properties` Dosyasını Tanımlama
`android/key.properties` dosyası oluşturup içine ekleyin:
```properties
storePassword=belirlediginiz_sifre
keyPassword=belirlediginiz_sifre
keyAlias=upload
storeFile=C:/Users/Yusuf/upload-keystore.jks
```

### 3. Google Play App Bundle (.aab) Üretme
```powershell
flutter build appbundle --release
```
Oluşan dosya: `build/app/outputs/bundle/release/app-release.aab` dosyasını Google Play Console'a doğrudan yükleyebilirsiniz.

---

## 🍏 Apple App Store İçin Yayınlama (iOS)

Mac üzerinde veya bulut derleme araçlarında (Codemagic, GitHub Actions):
```bash
flutter build ipa --release
```
Oluşan `.ipa` dosyasını Xcode / Transporter ile App Store Connect'e gönderebilirsiniz.

---

## 🚀 Yerel Olarak Çalıştırma

```powershell
# Web ortamında çalıştırma
flutter run -d chrome

# Android cihazınız veya emülatör bağlıyken
flutter run -d android
```
