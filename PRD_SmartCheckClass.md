# Product Requirement Document (PRD)
## Smart Class Check-in & Learning Reflection App

**Course:** 1305216 Mobile Application Development  
**Version:** 1.0 (MVP)  
**Date:** March 2026  
**Name:** Jutatip Sriputhon
**ID:** 6631503124

---

## 1. Problem Statement

Universities currently rely on manual attendance methods (paper sign-in sheets, verbal roll call) that are easy to fake and provide no insight into student engagement. A student can have a classmate sign in for them, or be physically present but mentally absent.

This app solves two problems at once:
- **Attendance fraud** — GPS location + QR code scanning confirms the student is physically in the classroom
- **Passive attendance** — Learning reflection forms confirm the student actually engaged with the material

Without this system, instructors have no scalable way to verify both *presence* and *participation* in real time.

---

## 2. Target Users

| User | Role | Primary Need |
|------|------|--------------|
| **Students** | Primary user | Check in quickly, reflect on learning |
| **Instructors** | Secondary user | Verify attendance, read student feedback |

**Student profile:** Undergraduate university students who carry smartphones and attend scheduled classes on campus.

---

## 3. Feature List

### Core Features (MVP)

| # | Feature | Priority |
|---|---------|----------|
| F1 | GPS location capture at check-in and check-out | Must Have |
| F2 | QR Code scanning for class session verification | Must Have |
| F3 | Pre-class reflection form (topic recall, expectations, mood) | Must Have |
| F4 | Post-class reflection form (learning summary, feedback) | Must Have |
| F5 | Local data storage (SQLite) for all session records | Must Have |
| F6 | Home screen with current session status | Must Have |

### Out of Scope (Future)
- Instructor dashboard / admin panel
- Push notifications / reminders
- Cloud sync / multi-device support
- Facial recognition or biometric auth

---

## 4. User Flow

### 4.1 Before Class — Check-in Flow

```
[Home Screen]
     |
     ▼
[Tap "Check-in" button]
     |
     ▼
[System auto-captures: GPS coordinates + Timestamp]
     |
     ▼
[Scan QR Code] ← QR displayed by instructor in class
     |
     ▼
[Fill Pre-class Reflection Form]
  - Previous topic covered
  - Expected topic today
  - Mood before class (scale 1–5)
     |
     ▼
[Submit → Data saved to SQLite]
     |
     ▼
[Home Screen shows: "Checked In ✓"]
```

### 4.2 After Class — Finish Class Flow

```
[Home Screen]
     |
     ▼
[Tap "Finish Class" button]
     |
     ▼
[Scan QR Code again] ← confirms student stayed until end
     |
     ▼
[System auto-captures: GPS coordinates + Timestamp]
     |
     ▼
[Fill Post-class Reflection Form]
  - What I learned today (short text)
  - Feedback for instructor/class
     |
     ▼
[Submit → Data saved to SQLite]
     |
     ▼
[Home Screen shows: "Class Completed ✓"]
```

---

## 5. Data Fields

### Check-in Record

| Field | Type | Description |
|-------|------|-------------|
| `session_id` | String (UUID) | Unique ID for each class session |
| `student_id` | String | Student identifier |
| `checkin_timestamp` | DateTime | Time when Check-in button was pressed |
| `checkin_lat` | Double | GPS latitude at check-in |
| `checkin_lng` | Double | GPS longitude at check-in |
| `qr_code_value` | String | Value scanned from class QR code |
| `prev_topic` | String | What was covered in the previous class |
| `expected_topic` | String | What the student expects to learn today |
| `mood_score` | Integer (1–5) | Pre-class mood rating |

### Check-out Record (appended to same session)

| Field | Type | Description |
|-------|------|-------------|
| `checkout_timestamp` | DateTime | Time when Finish Class button was pressed |
| `checkout_lat` | Double | GPS latitude at check-out |
| `checkout_lng` | Double | GPS longitude at check-out |
| `learned_today` | String | Short summary of what was learned |
| `class_feedback` | String | Feedback about the class or instructor |

### Mood Scale Reference

| Score | Label | Emoji |
|-------|-------|-------|
| 1 | Very Negative | 😡 |
| 2 | Negative | 🙁 |
| 3 | Neutral | 😐 |
| 4 | Positive | 🙂 |
| 5 | Very Positive | 😄 |

---

## 6. Tech Stack

| Layer | Technology | Reason |
|-------|-----------|--------|
| **Frontend / Mobile** | Flutter (Dart) | Cross-platform iOS & Android from a single codebase |
| **Local Storage** | SQLite via `sqflite` package | Persistent offline storage, works without internet |
| **GPS** | `geolocator` Flutter package | Reliable device location API |
| **QR Scanning** | `mobile_scanner` Flutter package | Camera-based QR code reading |
| **State Management** | Flutter `setState` / Provider (minimal) | Sufficient for MVP scope |
| **Deployment** | Firebase Hosting | Free tier, easy CLI deployment for Flutter Web build |
| **Version Control** | GitHub | Source code hosting and submission |

### Key Flutter Dependencies (`pubspec.yaml`)

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0          # SQLite local database
  path: ^1.8.3             # File path utilities
  geolocator: ^11.0.0      # GPS location
  mobile_scanner: ^5.0.0   # QR code scanner
  intl: ^0.19.0            # Date/time formatting
```

---

## 7. Minimum Viable Product (MVP) Scope

The MVP will deliver exactly the features needed to satisfy the exam requirements and demonstrate a working system. The focus is on a functional, shippable prototype — not a production-grade application.

**MVP Screens:**
1. **Home Screen** — Shows check-in status, buttons for Check-in and Finish Class
2. **Check-in Screen** — GPS capture, QR scan, pre-class form
3. **Finish Class Screen** — QR scan, GPS capture, post-class form

**Success Criteria:**
- Student can complete a full check-in → check-out cycle
- All data is saved and retrievable from local storage
- App is deployed and accessible via Firebase Hosting URL