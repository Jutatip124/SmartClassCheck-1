# SmartClassCheck-1

Smart Class Check-in and Learning Reflection App for course 1305216 (Mobile Application Development).

This repository contains:
- Flutter mobile app source code
- Product Requirement Document (PRD)
- Firebase Hosting site files for deployment

## Repository Structure

```text
.
├── Midterm_Labtest_13-Mar-2026.md
├── PRD_SmartCheckClass.md
├── README.md
├── smart_class_app/
│   ├── README.md
│   ├── pubspec.yaml
│   └── lib/
└── smart_class_firebase/
	├── firebase.json
	└── public/
```

## Features (MVP)

- Class check-in with GPS + timestamp
- QR code scan for in-class verification
- Pre-class reflection (previous topic, expected topic, mood)
- Finish class flow with QR + GPS capture
- Post-class reflection (what learned, class feedback)
- Local persistence using SQLite

## Technology Stack

- Flutter (Dart)
- sqflite
- geolocator
- mobile_scanner
- Firebase Hosting (deployment)

## Quick Start

### 1. Run the Flutter app

```bash
cd smart_class_app
flutter pub get
flutter run
```

Optional (web):

```bash
cd smart_class_app
flutter run -d chrome
```

### 2. Deploy hosting site

```bash
cd smart_class_firebase
firebase login
firebase deploy --only hosting
```

## Project Documents

- PRD: `PRD_SmartCheckClass.md`
- Exam Brief: `Midterm_Labtest_13-Mar-2026.md`
- App-level setup and details: `smart_class_app/README.md`

## Notes

- This is an academic project prototype.
- Data is stored locally for MVP scope.
- Replace placeholder Firebase project settings with your own configuration before deployment.