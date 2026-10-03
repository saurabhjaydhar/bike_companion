# Garajo — Store compliance and Firebase setup

Answers to paste into the store forms, and console steps that must be done before release. Based on what the app does as of Phase 4; re-check after any feature that collects new data.

## 1. Before release — must do

| # | Step | Why |
|---|---|---|
| 1 | **Move the Firebase project to the Blaze plan** (paid Gemini tier) | On the free Gemini tier, Google may use submitted content — RC photos showing the owner's name and address — to improve its products, and human reviewers may see it. Paid tiers don't. Alternative: switch to the Vertex AI Gemini API (`FirebaseAI.vertexAI()`), also Blaze. |
| 2 | **Publish the Firestore and Storage rules** below | Each user may only read and write their own data |
| 3 | **App Check**: register the apps (Play Integrity for Android, App Attest for iOS), watch the metrics for a few days, then **enforce** for Firestore, Storage and Firebase AI Logic | Stops others calling Gemini and Firebase on your quota |
| 4 | Register the **debug token** printed in the debug log (Firebase → App Check → Manage debug tokens) | Debug builds keep working once enforcement is on |
| 5 | Publish the **privacy policy** ([privacy-policy.md](privacy-policy.md)) at a public URL | Required by both stores |
| 6 | Publish an **account deletion page** (a web form or instructions + email) | Play requires a way to request deletion outside the app |
| 7 | Set a **Gemini rate limit per user** (Firebase AI Logic → Settings) | Caps cost if something goes wrong |

### Firestore rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Everything a user owns lives under users/{uid}.
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == uid;
    }
  }
}
```

### Storage rules

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Document photos: users/{uid}/documents/{vehicleId}/{docId}.{ext}
    match /users/{uid}/{allPaths=**} {
      allow read, delete: if request.auth != null && request.auth.uid == uid;
      allow create, update: if request.auth != null && request.auth.uid == uid
        && request.resource.size < 10 * 1024 * 1024
        && request.resource.contentType.matches('image/.*');
    }
  }
}
```

## 2. Google Play — Data safety form

**Does the app collect or share user data?** Yes. **Is all data encrypted in transit?** Yes. **Can users request deletion?** Yes (in app: Settings → Delete account; and the deletion page from step 6).

| Data type (Play category) | Collected | Shared | Optional | Purpose |
|---|---|---|---|---|
| Personal info → Name, Email address | Yes (Google Sign-In) | No | Yes (can continue anonymously) | Account management |
| Personal info → User IDs | Yes | No | No | Account management |
| Photos and videos → Photos | Yes (document photos when signed in; RC photos only with Gemini on) | No¹ | Yes | App functionality |
| Files and docs | No | | | |
| App activity → App interactions | Yes (4 events) | No | No | Analytics |
| App info and performance → Crash logs, Diagnostics | Yes | No | No | App functionality (fixing crashes) |
| Device or other IDs | Yes (Firebase installation ID, FCM token) | No | No | Analytics, app functionality |
| Other user-generated content (vehicle data, records) | Yes | No | No | App functionality |
| Location, Contacts, Messages, Financial info, Health | No | | | |

¹ Data sent to Google as a service provider (Firebase, Gemini) is not "sharing" under Play's definitions.

Spending amounts are app content entered by the user, not "financial info" (no payment or bank data).

## 3. App Store — Privacy nutrition labels

**Data Linked to You:** Contact Info (Name, Email — Google Sign-In), Identifiers (User ID), User Content (Photos, Other User Content — vehicle data and records).
**Data Not Linked to You:** Diagnostics (Crash Data, Performance), Usage Data (Product Interaction).
**Tracking:** No. **Third-party advertising:** No.

## 4. Permissions and why

| Permission | Platform | Used for | Store text (already in the app) |
|---|---|---|---|
| Camera | Android, iOS | Scanning the RC, photographing documents | iOS: "Garajo uses the camera to scan your RC and to photograph vehicle documents…" |
| Photos / media | Android, iOS | Choosing an RC or document photo from the gallery | iOS usage strings in Info.plist |
| Notifications (`POST_NOTIFICATIONS`) | Android 13+, iOS | Expiry, service and budget reminders | Asked after the first date is saved, with a reason |
| `RECEIVE_BOOT_COMPLETED` | Android | Restoring scheduled reminders after a restart | — |

Not requested: `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM` — reminders are scheduled inexactly (9 AM ± a few minutes), so the restricted exact-alarm permission isn't needed.

## 5. Content rating and other declarations

- **Content rating questionnaire:** utility app; no violence, gambling, user-to-user communication or location sharing.
- **Target audience:** 18+ (matches the privacy policy).
- **Ads:** none. **In-app purchases:** none.
- **Government apps:** not affiliated with VAHAN/Parivahan — keep the listing wording neutral ("check your RC details by SMS").
