# SkillBantuin

SkillBantuin adalah aplikasi mobile untuk mempertemukan client yang butuh bantuan tugas kecil dengan freelancer yang punya skill sesuai.

## Alur Utama

1. Client membuat permintaan bantuan.
2. Freelancer melihat tugas dan mengirim penawaran.
3. Client memilih freelancer.
4. Client membayar lewat Midtrans.
5. Freelancer mengerjakan dan mengirim hasil.
6. Client memberi review.

## Role

- Client: buat tugas, pilih freelancer, bayar, review hasil.
- Freelancer: cari tugas, kirim penawaran, kerjakan tugas, pantau pendapatan.

## Payment

Payment akan memakai Midtrans Snap.

Untuk saat ini layar pembayaran masih placeholder agar alur aplikasi bisa dicoba. Saat backend siap, tombol "Bayar via Midtrans" diarahkan ke Snap token dari server.

## Setup API Laravel

Secara default aplikasi masih memakai data mock lokal. Untuk mencoba koneksi ke backend Laravel, jalankan aplikasi dengan `dart-define`:

```bash
flutter run --dart-define=USE_LARAVEL_API=true --dart-define=API_BASE_URL=http://10.0.2.2:8000/api
```

Catatan alamat:

- Android emulator: `http://10.0.2.2:8000/api`
- iOS simulator atau web lokal: `http://127.0.0.1:8000/api`
- HP fisik: pakai IP laptop di jaringan yang sama, contoh `http://192.168.1.10:8000/api`

Layer API sudah disiapkan di:

- `lib/config/api_config.dart` untuk `USE_LARAVEL_API`, `API_BASE_URL`, dan timeout.
- `lib/config/api_endpoints.dart` untuk daftar path endpoint.
- `lib/services/api_client.dart` untuk request JSON, bearer token, timeout, dan error Laravel.
- `lib/services/laravel_auth_service.dart` untuk login, register, logout.
- `lib/services/laravel_task_service.dart` untuk task, offer, payment, submit hasil, dan review.

Format respons auth yang didukung:

```json
{
  "data": {
    "user": {
      "id": 1,
      "name": "Nadia Client",
      "email": "client@skillbantuin.demo",
      "username": "clientdemo",
      "phone_number": "081234567890",
      "role": "client"
    },
    "token": "plain-text-token"
  }
}
```

## Status Project

Saat ini aplikasi masih frontend prototype dengan data mock lokal. Fokusnya adalah membuat alur MVP mudah dipahami sebelum disambungkan ke backend dan Midtrans.
