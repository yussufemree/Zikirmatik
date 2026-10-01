# 🚀 Zikirmatik & Kıble Bulucu - App Store Deployment Kılavuzu

Bu proje, Apple App Store ve Google Play Store standartlarında hazırlanmış olup **GitHub Actions** ile otomatik derleme ve TestFlight/App Store dağıtımını destekler.

---

## 1. GitHub Deposu Oluşturma ve Projeyi Gönderme

1. [GitHub](https://github.com/new) adresine gidin ve yeni bir **Private** veya **Public** repo oluşturun (Örn: `zikirmatik`).
2. Terminalinizde şu komutları çalıştırarak yerel projeyi GitHub'a bağlayın:

```powershell
# 1. Uzak depoyu bağlayın (kendi kullanıcı adınızı ve repo adınızı yazın):
git remote add origin https://github.com/KULLANICI_ADINIZ/zikirmatik.git

# 2. Ana dala gönderin:
git push -u origin main
```

---

## 2. App Store Connect & GitHub Actions Yapılandırması

Uygulamanın her `main` dala kod atıldığında veya GitHub Actions sekmesinden manuel tetiklendiğinde otomatik olarak derlenip **TestFlight**'a yüklenmesi için GitHub reponuzun **Settings > Secrets and variables > Actions** kısmına şu gizli anahtarları (Secrets) ekleyin:

| Secret Adı | Açıklama |
|---|---|
| `APPLE_CERTIFICATE_BASE64` | Apple Distribution Sertifikanızın (.p12) Base64 formatı |
| `APPLE_CERTIFICATE_PASSWORD` | .p12 sertifikanızı dışa aktarırken belirlediğiniz şifre |
| `PROVISIONING_PROFILE_BASE64` | App Store Provisioning Profile (.mobileprovision) Base64 formatı |
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Anahtar ID (Örn: `2X9R4274KC`) |
| `APP_STORE_CONNECT_API_ISSUER_ID` | App Store Connect Issuer ID (UUID formatında) |
| `APP_STORE_CONNECT_API_KEY_BASE64` | İndirdiğiniz `AuthKey_XXXXX.p8` dosyasının Base64 hali |

### Windows PowerShell'de Dosyaları Base64'e Çevirme:
```powershell
# Sertifika için (.p12):
[Convert]::ToBase64String([IO.File]::ReadAllBytes("Certificates.p12")) | Set-Clipboard

# Profil için (.mobileprovision):
[Convert]::ToBase64String([IO.File]::ReadAllBytes("profile.mobileprovision")) | Set-Clipboard

# API Anahtarı için (.p8):
[Convert]::ToBase64String([IO.File]::ReadAllBytes("AuthKey_XXXXX.p8")) | Set-Clipboard
```
*(Bu komutlar dosyanın Base64 halini doğrudan panonuza kopyalar, GitHub Secrets sayfasına gidip `Ctrl + V` ile yapıştırabilirsiniz).*

---

## 3. GitHub Actions Otomasyon Akışı

`.github/workflows/deploy_appstore.yml` dosyası şunları otomatik olarak yapar:
1. `macos-14` (Apple Silicon M1/M2/M3) yüksek performanslı sunucuda çalışır.
2. Flutter stable ve Java 17 ortamını kurar.
3. Apple sertifikasını geçici macOS Keychain'ine aktarır.
4. `flutter test` ile tüm birim ve arayüz testlerini doğrular.
5. `flutter build ipa --release --export-options-plist=ios/ExportOptions.plist` ile imzalı `.ipa` paketini üretir.
6. `.ipa` dosyasını hem GitHub Artifact olarak 7 gün saklar, hem de `altool` ile **Apple TestFlight / App Store Connect**'e otomatik yükler!
