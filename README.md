# SmartClassCheck-1

## Jutatip Sriputhon  6631503124 ##

## Project Description

Smart Class Check-in and Learning Reflection App for course 1305216 (Mobile Application Development).

This repository contains:
- Flutter mobile app source code
- Product Requirement Document (PRD)
- Firebase Hosting site files for deployment

## Firebase Deployment URL

- Live URL: https://smartcheck-6631503124.web.app

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

## Setup Instructions

### Prerequisites

- Flutter SDK installed
- Firebase CLI installed (`npm install -g firebase-tools`)
- A Firebase project with Hosting enabled

### Install dependencies

```bash
cd smart_class_app
flutter pub get
```

## How to Run the App

### Run on mobile emulator/device

```bash
cd smart_class_app
flutter run
```

### Run on web (Chrome)

```bash
cd smart_class_app
flutter run -d chrome
```

## Firebase Configuration Notes

### Build Flutter web

```bash
cd smart_class_app
flutter build web --release
```

### Copy web build to Hosting public folder

```bash
rm -rf /workspaces/SmartClassCheck-1/smart_class_firebase/public/*
cp -r /workspaces/SmartClassCheck-1/smart_class_app/build/web/* /workspaces/SmartClassCheck-1/smart_class_firebase/public/
```

### Select Firebase project and deploy

```bash
cd smart_class_firebase
firebase login
firebase use <your-project-id>
firebase deploy --only hosting
```

Notes:
- If `flutter build web --release` fails in this environment due to wasm dry-run, use:

```bash
flutter build web --release --no-wasm-dry-run
```

- Confirm active Firebase project before deploy:

```bash
firebase use
firebase projects:list
```

## Project Documents

- PRD: `PRD_SmartCheckClass.md`
- Exam Brief: `Midterm_Labtest_13-Mar-2026.md`
- App-level setup and details: `smart_class_app/README.md`

## AI Usage Report

AI tools used:
- GitHub Copilot

What AI helped generate:
- Initial Flutter screen scaffolding and project structure
    - Suggested starter layouts for Home, Check-in, Finish Class, and History screens
    - Helped produce reusable UI pieces and consistent widget patterns
    - Provided boilerplate for route navigation and basic state flow
- Example integration patterns for QR scan and local persistence
    - Suggested plugin usage flow for camera-based QR scanning
    - Suggested data model patterns for session records (check-in/check-out fields)
    - Suggested SQLite service structure for create/read/update operations
    - Suggested validation patterns for required form fields before saving
- README and deployment command templates
    - Generated initial README structure and section ordering
    - Suggested command sequences for Flutter web build and Firebase Hosting deploy
    - Suggested troubleshooting steps for common CLI/deployment issues

What was implemented or modified manually:
- Requirement interpretation and PRD content finalization
    - Converted incomplete draft requirements into a complete PRD with clear MVP scope
    - Defined practical data fields, user flow details, and success criteria for the prototype
    - Decided what to keep in MVP and what to move to out-of-scope features
- App flow adjustments for check-in and finish-class behavior
    - Aligned screen behavior with exam scenario (before class and after class workflows)
    - Adjusted validation logic and interaction order for QR scan, GPS capture, and form submission
    - Reviewed and corrected runtime/API compatibility issues found during build and run attempts
- Firebase project selection and deployment execution
    - Set active Firebase project and executed real deployment commands
    - Built Flutter web artifacts and copied outputs into Hosting public directory
    - Verified deployment completed successfully from CLI output
- Final verification and README updates for submission criteria
    - Audited README against exam checklist (project description, setup, run, Firebase notes)
    - Added final deployment URL and clearer setup/run instructions
    - Updated wording and structure for easier grading and demonstration

Engineering judgment and responsible AI usage:
- AI was used as an accelerator for scaffolding, reference patterns, and command templates.
- All critical decisions (scope, workflow, data fields, and final behavior) were made manually based on the exam requirements.
- Generated outputs were reviewed, tested, and adjusted before acceptance.
- Final implementation and documentation reflect manual verification and understanding, not blind copy-paste.

## Submission Checklist

- PRD document in Markdown
- Source code in GitHub repository
- Firebase Hosting URL (accessible)
- README with: project description, setup instructions, app run guide, and Firebase configuration notes
- Short AI usage report

## Notes

- This is an academic project prototype.
- Data is stored locally for MVP scope.
- Replace placeholder Firebase project settings with your own configuration before deployment.