# SkillBantuin Mobile

SkillBantuin Mobile adalah aplikasi Flutter untuk platform marketplace jasa kecil antara client dan freelancer. Client dapat membuat permintaan bantuan, freelancer dapat mengirim penawaran, client memilih freelancer, pembayaran diproses lewat Midtrans, freelancer mengirim hasil pekerjaan, lalu client memberi review.

Aplikasi ini terhubung ke backend Laravel API yang menangani autentikasi, data project, kategori, penawaran, chat, profil, pembayaran, upload hasil, dan review.

## Fitur Utama

### Client

- Register dan login sebagai client.
- Membuat permintaan bantuan berdasarkan kategori dari API Laravel.
- Melihat daftar project milik client.
- Melihat detail project dan daftar penawaran freelancer.
- Menerima atau menolak penawaran freelancer.
- Melakukan pembayaran melalui alur Midtrans.
- Chat dengan freelancer pada project terkait.
- Melihat hasil pekerjaan yang dikirim freelancer.
- Memberikan review dan rating.
- Mengedit profil client sesuai data backend.

### Freelancer

- Register dan login sebagai freelancer.
- Melihat daftar tugas yang masih tersedia.
- Mencari tugas berdasarkan judul dan kategori.
- Melihat detail tugas.
- Mengirim penawaran harga dan estimasi pengerjaan.
- Melihat pekerjaan dari penawaran yang diterima client.
- Chat dengan client pada project terkait.
- Mengupload file hasil pekerjaan asli dari perangkat.
- Melihat pendapatan berdasarkan penawaran yang diterima.
- Mengedit profil freelancer sesuai data backend.

### Fitur AI untuk Demo

Aplikasi memiliki fitur voice recognition pada chat:

- User menekan tombol microphone pada halaman chat.
- Suara dikenali oleh device.
- Hasil pengenalan suara otomatis masuk ke input pesan.
- User dapat mengedit teks sebelum mengirim chat.

Fitur ini menggunakan package `speech_to_text`.

## Alur Aplikasi

1. Client membuat bantuan.
2. Project tersimpan di Laravel dengan status `open`.
3. Freelancer melihat project tersebut di Aktivitas Tugas atau Cari Tugas.
4. Freelancer mengirim penawaran.
5. Client melihat daftar penawaran.
6. Client menerima salah satu penawaran.
7. Project tidak tampil lagi di daftar tugas freelancer karena sudah tidak tersedia.
8. Client melakukan pembayaran.
9. Freelancer mengerjakan dan mengupload hasil.
10. Client melihat hasil, lalu memberi review dan rating.

## Teknologi

- Flutter
- Dart
- Provider untuk state management
- Laravel API sebagai backend
- Laravel Sanctum untuk auth token
- Midtrans untuk pembayaran
- Oracle Database pada backend Laravel
- `http` untuk request API
- `shared_preferences` untuk session lokal
- `file_picker` untuk upload file hasil pekerjaan
- `speech_to_text` untuk voice recognition chat

## Struktur Folder Penting

```text
lib/
  config/
    app_config.dart
  models/
    app_user.dart
    category_model.dart
    chat_message_model.dart
    offer_model.dart
    project_model.dart
    task_models.dart
  providers/
    auth_provider.dart
    project_provider.dart
    freelancer_provider.dart
  screens/
    client/
    freelancer/
    shared/
  services/
    api_service.dart
    auth_service.dart
    marketplace_service.dart
    session_service.dart
  widgets/
  utils/
```

## Kebutuhan Sistem

- Flutter SDK
- Dart SDK
- Android Studio atau Xcode
- Device fisik atau simulator/emulator
- Backend Laravel SkillBantuin sudah berjalan
- Database backend sudah dimigrate
- Koneksi jaringan yang sama antara HP dan laptop jika memakai device fisik

## Package yang Digunakan

```yaml
cupertino_icons
http
shared_preferences
provider
file_picker
speech_to_text
flutter_lints
```

Install dependency:

```bash
flutter pub get
```

## Konfigurasi Base URL API

Base URL diatur pada:

```text
lib/config/app_config.dart
```

Default development:

```dart
http://localhost:8000/api
```

Untuk menjalankan dengan base URL tertentu, gunakan `--dart-define`:

### Simulator iOS

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api
```

### Android Emulator

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
```

### HP Fisik / Wireless

Gunakan IP laptop pada jaringan yang sama:

```bash
flutter run --dart-define=API_BASE_URL=http://IP_LAPTOP:8000/api
```

Contoh:

```bash
flutter run --dart-define=API_BASE_URL=http://10.253.129.179:8000/api
```

## Menjalankan Aplikasi

1. Jalankan backend Laravel terlebih dahulu.
2. Pastikan API bisa diakses dari device.
3. Install dependency Flutter.
4. Jalankan aplikasi dengan base URL yang sesuai.

```bash
cd mobile-SkillBantuin
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:8000/api
```

Untuk HP fisik, ganti `localhost` dengan IP laptop.

## Endpoint API yang Dipakai

Beberapa endpoint Laravel yang digunakan mobile:

- `POST /register`
- `POST /login`
- `POST /logout`
- `GET /profile`
- `PUT /profile`
- `GET /categories`
- `GET /projects`
- `POST /projects`
- `GET /my-projects`
- `POST /projects/{id}/apply`
- `GET /projects/{id}/offers`
- `PUT /offers/{id}/accept`
- `PUT /offers/{id}/reject`
- `GET /my-offers`
- `GET /chats/{projectId}`
- `POST /chats/{projectId}`
- `POST /projects/{id}/pay`
- `GET /transactions/{orderId}/status`
- `POST /projects/{id}/submit-result`
- `GET /projects/{id}/result-file`
- `POST /projects/{id}/review`

## Permission

### Android

Permission microphone untuk voice recognition ada di:

```text
android/app/src/main/AndroidManifest.xml
```

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

### iOS

Permission microphone dan speech recognition ada di:

```text
ios/Runner/Info.plist
```

```xml
<key>NSMicrophoneUsageDescription</key>
<string>SkillBantuin memakai mikrofon untuk mengubah suara menjadi teks chat.</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>SkillBantuin memakai pengenalan suara untuk membantu menulis pesan chat.</string>
```

## Catatan Demo

Untuk demo fitur voice recognition, lebih disarankan memakai HP fisik karena microphone dan speech recognition lebih stabil dibanding simulator.

Script singkat demo:

> Fitur kecerdasan buatan pada aplikasi ini adalah voice recognition di chat. Pengguna dapat berbicara melalui microphone, lalu sistem mengenali suara dan mengubahnya menjadi teks pesan yang bisa dikirim antara client dan freelancer.

## Status Pengembangan

Fitur utama MVP sudah terhubung ke Laravel API:

- Auth
- Buat project
- List project
- Penawaran
- Accept/reject offer
- Chat
- Midtrans payment flow
- Upload hasil pekerjaan
- Review dan rating
- Profil client/freelancer
- Pendapatan freelancer berdasarkan offer diterima
- Voice recognition pada chat

Beberapa fitur yang masih dapat dikembangkan:

- Push notification realtime
- Websocket untuk chat realtime
- Riwayat pencairan dana freelancer
- Upload lampiran saat client membuat project
- Statistik dashboard yang lebih detail
- Callback Midtrans untuk environment production
