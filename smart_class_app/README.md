# Smart Class Check-in & Learning Reflection App

> Course 1305216 — Mobile Application Development | Midterm Lab Exam

A Flutter mobile application that helps universities verify student attendance and capture learning reflections through GPS location, QR code scanning, and structured reflection forms.

---

## 🚀 Live Demo

**Firebase Hosting URL:** `https://YOUR-PROJECT-ID.web.app`

---

## 📱 Screenshots

| Home Screen | Check-In | Finish Class | History |
|:-----------:|:--------:|:------------:|:-------:|
| Status + buttons | GPS + QR + Mood form | Post-class reflection | All sessions |

---

## ✨ Features

- **GPS Location** — captures coordinates at check-in and check-out
- **QR Code Scanning** — scans class QR code via device camera (mobile_scanner)
- **Pre-class Reflection** — previous topic, expected topic, mood rating (1–5)
- **Post-class Reflection** — what was learned, feedback for instructor
- **Local Storage** — all data saved to SQLite via sqflite (works offline)
- **Session History** — expandable list of all past check-in/check-out records

---

## 🛠️ Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Dart) |
| Local DB | SQLite via `sqflite` |
| GPS | `geolocator` |
| QR Scanner | `mobile_scanner` |
| Deployment | Firebase Hosting |

---

## ⚙️ Setup Instructions

### Prerequisites

- Flutter SDK `>=3.0.0` — [install guide](https://docs.flutter.dev/get-started/install)
- Android Studio or Xcode (for mobile)
- Firebase CLI — `npm install -g firebase-tools`

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/smart-class-app.git
cd smart-class-app
```

### 2. Install Flutter dependencies

```bash
flutter pub get
```

### 3. Run on Android/iOS

```bash
# Android
flutter run

# iOS (macOS only)
flutter run -d ios
```

### 4. Run as Flutter Web

```bash
flutter run -d chrome
```

---

## 🔥 Firebase Configuration

### Deploy the landing page

```bash
cd smart_class_firebase
firebase login
firebase init hosting   # select your project
firebase deploy --only hosting
```

### To deploy Flutter Web build to Firebase

```bash
# In the Flutter project root
flutter build web --release

# Copy build output to firebase public folder
cp -r build/web/* ../smart_class_firebase/public/

# Deploy
cd ../smart_class_firebase
firebase deploy --only hosting
```

### Firebase project setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project (e.g. `smart-class-app`)
3. Enable **Hosting** from the left menu
4. Run `firebase init` and select your project ID
5. Set public directory to `public`

---

## 📂 Project Structure

```
lib/
├── main.dart                    # App entry point
├── theme.dart                   # Colors, typography, theme
├── models/
│   └── class_session.dart       # Data model + fromMap/toMap
├── services/
│   ├── database_service.dart    # SQLite CRUD operations
│   └── location_service.dart    # GPS permission + position
├── screens/
│   ├── home_screen.dart         # Main screen with status/buttons
│   ├── checkin_screen.dart      # Check-in flow (GPS+QR+form)
│   ├── finish_class_screen.dart # Finish class flow (QR+GPS+form)
│   ├── history_screen.dart      # Session history list
│   └── qr_scanner_screen.dart  # Camera QR scanning screen
└── widgets/
    └── common_widgets.dart      # Reusable UI components
```

---

## 🤖 AI Usage Report

**Tools used:** Claude (Anthropic)

**AI generated:**
- Initial Flutter project scaffolding and file structure
- UI widget code for screens (HomeScreen, CheckInScreen, FinishClassScreen)
- SQLite database service boilerplate
- Firebase hosting HTML landing page

**Manually implemented / modified:**
- Form validation logic and error handling in check-in/finish flows
- Session state management between screens (active session detection)
- Custom `MoodSelector` widget interaction logic
- `SimpleQRPainter` for demo QR display
- Database schema design and `copyWith` pattern for session updates
- Android manifest permissions configuration
- Firebase deployment workflow

---

## 📋 Deliverables Checklist

- [x] PRD Document (`PRD.md`)
- [x] Flutter source code (this repo)
- [x] Firebase Hosting deployment
- [x] README with setup instructions
- [x] AI Usage Report (above)

---

## 📄 License

Academic project — Course 1305216, Mobile Application Development
