# KOTOBA Logo  

# KOTOBA: Japanese Learning Platform  
Platform Pembelajaran Bahasa Jepang Interaktif Berbasis Mobile

Flutter • Dart • MongoDB • GetX • YouTube API

About • Key Features • Screenshots • Tech Stack • Getting Started

---

# About The Project

KOTOBA adalah aplikasi pembelajaran bahasa Jepang berbasis mobile yang dirancang untuk membantu pengguna mempelajari kosakata, huruf Jepang, serta percakapan sehari-hari secara interaktif dan menyenangkan.

Aplikasi ini menggabungkan konsep gamifikasi, kuis interaktif, video pembelajaran, deteksi objek berbasis AI, latihan menulis huruf Jepang, dan voice recognition untuk meningkatkan pengalaman belajar pengguna secara modern dan efektif.

KOTOBA juga menyediakan sistem progress pembelajaran dan integrasi REST API untuk sinkronisasi data secara realtime.

---

# Key Features

## 📷 Detection Object
Kamera realtime untuk mendeteksi objek di sekitar pengguna dengan menampilkan huruf Jepang, romaji, dan terjemahan bahasa Indonesia dari objek yang terdeteksi.

## 📚 Nihongo Basics
Materi pembelajaran dasar bahasa Jepang yang berisi huruf hiragana, katakana, dan kosakata sehari-hari.

## ✍️ Writing Canvas
Canvas interaktif untuk belajar menulis huruf Jepang berdasarkan urutan garis (*stroke order*) serta mendeteksi tingkat akurasi tulisan pengguna.

## 🎤 Voice Recognition
Fitur latihan pelafalan bahasa Jepang dengan sistem pendeteksi akurasi pengucapan pengguna berdasarkan contoh suara yang tersedia.

## 🧩 Gamified Quiz System
Kuis interaktif seperti tebak kata, puzzle, writing canvas, dan voice recognition untuk menguji pemahaman pengguna.

## 🎥 YouTube Learning Integration
Integrasi video pembelajaran bahasa Jepang langsung dari YouTube API.

## ⭐ XP & Progress Tracking
Sistem poin XP dan progress belajar untuk meningkatkan motivasi pengguna.

## 🔐 Secure Authentication
Sistem login dan registrasi aman menggunakan JWT Authentication.

## 🌐 REST API Integration
Backend API terintegrasi untuk sinkronisasi data aplikasi.

## 📱 Responsive Mobile Experience
UI modern dan responsif untuk pengalaman belajar yang nyaman.

---

# App Previews

| Welcome | Login | Register | Home Dashboard |
|---|---|---|---|
| *(Screenshot)* | *(Screenshot)* | *(Screenshot)* | *(Screenshot)* |
| Welcome screen | User authentication | User registration | Daily progress & XP |

| Kamera | Belajar | Nihongo Basics | Writing Canvas |
|---|---|---|---|
| *(Screenshot)* | *(Screenshot)* | *(Screenshot)* | *(Screenshot)* |
| Object detection | Learning materials | Hiragana & Katakana | Japanese writing practice |

| Voice Recognition | Puzzle Quiz | User Profile | Edit Profile |
|---|---|---|---|
| *(Screenshot)* | *(Screenshot)* | *(Screenshot)* | *(Screenshot)* |
| Pronunciation training | Interactive Japanese quiz | User information | Update user profile |

| Quiz Result | About Application |
|---|---|
| *(Screenshot)* | *(Screenshot)* |
| Score & performance | Application information |

---

# 🛠️ Tech Stack & Architecture

Aplikasi ini dibangun menggunakan pendekatan modular dan scalable architecture untuk mempermudah pengembangan dan maintenance.

---

## Frontend Mobile

- Flutter (Dart)
- GetX State Management
- REST API Integration

---

## Backend

- Express.js
- MongoDB
- JWT Authentication
- RESTful API

---

## External Services

- YouTube Data API v3

---

## Architecture Pattern

- Clean Architecture
- Feature-First Structure
- MVVM Pattern

---

# Folder Structure Overview

## Mobile App Structure

```plaintext
lib/
├── app/
│   ├── data/
│   │   └── theme/
│   │       ├── app_color.dart
│   │       └── app_theme.dart
│   │
│   ├── modules/
│   │   ├── camera/
│   │   ├── canvas/
│   │   ├── home/
│   │   ├── learn/
│   │   ├── login/
│   │   ├── main/
│   │   ├── nihongo/
│   │   ├── profile/
│   │   ├── quiz/
│   │   ├── register/
│   │   ├── speech/
│   │   ├── welcome/
│   │   └── writing/
│   │
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   │
│   └── widget/
│       ├── app_header.dart
│       ├── app_snackbar.dart
│       ├── bottom_navbar.dart
│       ├── drawing_painter.dart
│       └── kana_card.dart
│
└── main.dart

assets/
├── fonts/
└── image/
```

---

## Backend Structure

```plaintext
server/
├── controllers/
├── middleware/
├── models/
├── routes/
├── services/
├── config/
├── utils/
└── server.js
```

---

# Getting Started

## Clone Repository

```bash
git clone https://github.com/Interactive-Japanese-Learning-App/kotoba-frontend-mobile.git
```

---

# Mobile Setup

## Install Dependencies

```bash
flutter pub get
```

## Run Application

```bash
flutter run
```

---

# Backend Setup

## Install Dependencies

```bash
npm install
```

## Copy Environment File

```bash
cp .env.example .env
```

## Start Server

```bash
npm run dev
```

---

# Environment Variables

```env
# Application
PORT=

# Database
MONGODB_URI=

# Authentication
JWT_SECRET=

# YouTube API
YOUTUBE_API_KEY=
```

---

# API Features

## Authentication
- Login
- Register
- Logout

---

## Learning Materials
- Get Materials
- Create Material
- Update Material
- Delete Material

---

## Quiz System
- Get Quiz
- Submit Quiz Result
- XP Calculation

---

## Video Learning
- Fetch YouTube Videos
- Video Categories

---

# Team

- Ranifa Fitriyana
- Team Members

---

# License

This project is licensed under the MIT License.
