# SmartClassCheck-1

Student: Jutatip Sriputhon (6631503124)

## Project Description

Smart Class Check-in and Learning Reflection App for course 1305216 (Mobile Application Development).

The app is an MVP prototype that verifies attendance and participation using:
- GPS location capture
- QR code scanning
- Pre-class and post-class reflection forms
- Local storage with SQLite

## Live Deployment

- Firebase Hosting URL: https://smartcheck-6631503124.web.app

## Repository Structure

```text
.
├── Midterm_Labtest_13-Mar-2026.md
├── PRD_SmartCheckClass.md
├── README.md
├── smart_class_app/
│   ├── pubspec.yaml
│   ├── lib/
│   ├── android/
│   ├── ios/
│   └── web/
└── smart_class_firebase/
    ├── firebase.json
    └── public/
```

## Setup Instructions

### Prerequisites

- Flutter SDK
- Firebase CLI
- Chrome browser (for local web run)

Install Firebase CLI:

```bash
npm install -g firebase-tools
```

Install Flutter dependencies:

```bash
cd smart_class_app
flutter pub get
```

## How to Run the App

### Mobile emulator/device

```bash
cd smart_class_app
flutter run
```

### Web on Chrome (local machine with GUI)

```bash
cd smart_class_app
flutter run -d chrome
```

### Web in Codespaces/headless environment

```bash
cd smart_class_app
flutter run -d web-server --web-hostname=0.0.0.0 --web-port=8080
```

Then open forwarded port 8080 in browser.

## Firebase Configuration Notes

### Build Flutter web

```bash
cd smart_class_app
flutter build web --release
```

If wasm dry-run error appears in this environment:

```bash
flutter build web --release --no-wasm-dry-run
```

### Copy build output to Hosting public folder

```bash
rm -rf /workspaces/SmartClassCheck-1/smart_class_firebase/public/*
cp -r /workspaces/SmartClassCheck-1/smart_class_app/build/web/* /workspaces/SmartClassCheck-1/smart_class_firebase/public/
```

### Deploy to Firebase Hosting

```bash
cd /workspaces/SmartClassCheck-1/smart_class_firebase
firebase login
firebase use smartcheck-6631503124
firebase deploy --only hosting
```

## AI Usage Report

AI tools used:
- GitHub Copilot

What AI helped generate:
- Initial Flutter screen scaffolding and project structure
- Example integration patterns for QR scan and local persistence
- README and deployment command templates

What was implemented or modified manually:
- Requirement interpretation and PRD content finalization
- App flow adjustments for check-in and finish-class behavior
- Firebase project selection and deployment execution
- Final verification and README updates for submission criteria

## Project Documents

- PRD: PRD_SmartCheckClass.md
- Exam Brief: Midterm_Labtest_13-Mar-2026.md
- App details: smart_class_app/README.md