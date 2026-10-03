# Garajo — Privacy Policy

> **Draft — have it reviewed by a lawyer before publishing.** Replace every `[bracketed]` item. Publish at a public URL (e.g. `https://garajo.app/privacy`) and link it from both store listings and the app's Settings.

**Effective date:** [date]
**Developer:** [legal name], [address] — contact: [email]

Garajo helps you look after your bikes, scooters and cars: fuel, service, expenses, documents and reminders. This policy explains what data the app handles, why, and the choices you have.

## 1. What we collect and why

| Data | When | Why |
|---|---|---|
| **Account** — name and email from Google Sign-In, or an anonymous ID if you continue without signing in | When you sign in | To back up your data and restore it on a new phone |
| **Vehicle details** — registration number, make, model, type, colour, odometer, engine and chassis numbers, registration, insurance and PUC dates | When you add or edit a vehicle | To show your vehicle, calculate service needs and remind you before dates expire |
| **Records** — fuel logs, service records, expenses, budgets, document titles and expiry dates | When you add them | To track spending and maintenance |
| **Document photos** (e.g. insurance policy, PUC certificate) | Only if you attach one while signed in with Google | Backed up so they're available on your other phones |
| **RC photos** | Only when you scan your RC | Read **on your phone** to fill in vehicle details. Sent to Google's Gemini AI **only if you turn on "Read with Gemini AI"** — see section 3 |
| **Crash reports** — stack traces, device model, OS version | When the app crashes | To find and fix bugs |
| **Usage events** — e.g. "an RC scan finished", "a vehicle was added (type: car)", "a budget was set", number of reminders scheduled | While you use the app | To understand which features work. **No registration numbers, names, places or amounts are included** |
| **Device identifiers** — Firebase installation ID, notification token | Automatically | To deliver notifications and attribute crash reports |

We do **not** collect your location, contacts, SMS messages or browsing history. The "Check on VAHAN by SMS" button opens your SMS app with a pre-filled message; we never read your messages.

## 2. Where your data is stored

- **On your phone**, in the app's private storage.
- **In the cloud**, in Google Firebase (Cloud Firestore and Cloud Storage), [region], when you are signed in. Each account's data can only be read and written by that account.

## 3. RC scanning with Gemini AI

The "Read with Gemini AI" switch is **off by default**. When you turn it on and scan your RC, the RC photos are sent through Google Firebase to Google's Gemini model to read the vehicle details. We ask Gemini only for vehicle fields (registration number, make, model, dates, engine and chassis numbers) — never the owner's name or address — but the photo itself shows whatever is printed on the card.

[Keep only the sentence that matches your setup:]
- [Paid tier / Vertex AI:] Google processes these photos only to return the result and does not use them to train its models.
- [Free tier:] Under Google's terms for its free tier, Google may use submitted content to improve its products, and human reviewers may see it.

With the switch off, RC photos never leave your phone.

## 4. Sharing

We don't sell your data and don't show ads. We share data only with **Google** (Firebase, Crashlytics, Analytics, Gemini) acting as our service provider to run the features above, and with authorities when the law requires it.

## 5. How long we keep data

- Cloud data is kept until you delete it or delete your account.
- Crash reports and analytics are kept for [90 days / Google's default retention].
- Data on your phone stays until you delete it in the app, clear the app's data, or uninstall.

## 6. Your choices and rights

- **Edit or delete** any vehicle, record or document in the app.
- **Delete your account**: Settings → Delete account. This permanently deletes your account and everything stored for it in the cloud — vehicles, records and document photos. You can also ask us by email at [email] or via [web form URL].
- **Reminders**: turn them off per vehicle in Settings, or block notifications in your phone's settings.
- **Gemini**: keep "Read with Gemini AI" off to keep RC photos on your phone.
- Depending on where you live (e.g. India's DPDP Act 2023, the EU/UK GDPR), you may have rights to access, correct, erase and port your data and to withdraw consent. Write to us at [email].

**Grievance officer (India):** [name], [email] — we respond within [30] days.

## 7. Children

Garajo is not intended for anyone under 18. We don't knowingly collect data from children.

## 8. Security

Data travels encrypted (TLS). Cloud access is limited to your own account by Firebase security rules, and Firebase App Check lets only the genuine app reach our backend. No method is perfectly secure, but we work to protect your data.

## 9. Changes

We'll update this page and the effective date when this policy changes, and tell you in the app if the change is significant.

## 10. Contact

[legal name] — [email] — [address]
