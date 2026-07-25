# 🎵 Reggae Trivia

Reggae Trivia adalah sebuah game kuis Android berbasis Flutter yang menguji pengetahuan pemain tentang lagu-lagu reggae menggunakan YouTube Music API sebagai sumber data eksternal.

---

## Fitur

- 🎮 Trivia lagu reggae
- 🏆 Leaderboard
- 📜 Riwayat Lagu
- 🌐 REST API PHP + MySQL
- 🎵 Integrasi YouTube Music API
- 🎨 Tema Reggae (Rasta)

---

## Teknologi

- Flutter
- Dart
- PHP
- MySQL
- REST API
- Wasmer
- YouTube Music API

---

## Struktur

```
reggaetrivia-app/
│
├── assets/
│   └── images/
│       ├── reggae_header.png
│       └── reggae_logo.png
│
├── lib/
│   ├── models/
│   │   ├── history_model.dart
│   │   ├── leaderboard_model.dart
│   │   ├── player_model.dart
│   │   └── question_model.dart
│   │
│   ├── pages/
│   │   ├── game_page.dart
│   │   ├── history_page.dart
│   │   ├── home_page.dart
│   │   ├── leaderboard_page.dart
│   │   ├── player_page.dart
│   │   ├── result_page.dart
│   │   └── splash_page.dart
│   │
│   ├── services/
│   │   └── api_service.dart
│   │
│   ├── theme/
│   │   └── reggae_colors.dart
│   │
│   └── main.dart
│
├── pubspec.yaml
└── analysis_options.yaml
```

---

## 🚀 Cara Menjalankan

1. **Clone repository**
   ```bash
   git clone https://github.com/Mas7478/reggaetrivia-app.git
   cd reggaetrivia-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Atur URL API backend**

   Buka `lib/services/api_service.dart`, lalu sesuaikan base URL dengan alamat backend yang sudah di-deploy (lihat [Backend API](#-backend-api)):
   ```dart
   const String baseUrl = "https://your-backend-url/api";
   ```

4. **Jalankan aplikasi**
   ```bash
   flutter run
   ```

### Requirement

- Flutter SDK terbaru (stable channel)
- Dart SDK sesuai `pubspec.yaml`
- Emulator/perangkat Android untuk menjalankan aplikasi

---

## 📱 Screenshot

<img width="720" height="1464" alt="Home page" src="https://github.com/user-attachments/assets/ef26c429-eeb8-4c7e-97ab-27cf1293bb90" />


---

## 🔗 Backend API

Aplikasi ini mengonsumsi REST API dari repository berikut:
https://github.com/Mas7478/reggaetrivia

---

## 👤 Author

**Mas7478**
https://github.com/Mas7478

---

## 📄 License

This project is for educational purposes.
