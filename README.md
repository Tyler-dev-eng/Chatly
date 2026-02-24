## Chatly

Chatly is a simple real‑time chat app built with Flutter and Firebase.  
It supports email/password authentication, one‑to‑one messaging, and a global light/dark theme toggle.

### Features

- **Authentication**: Email/password login and registration using Firebase Auth.
- **Real‑time chat**: Per‑user conversations backed by Cloud Firestore.
- **Theming**: App‑wide light/dark mode controlled via a settings page and Riverpod.
- **Multi‑platform**: Standard Flutter project structure for iOS, Android, Web, and desktop.

### Requirements

- **Flutter**: See your local Flutter install (`flutter --version`)  
- **Dart**: Bundled with Flutter  
- **Firebase project**: With Firestore and Authentication enabled

### Setup

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase**
   - Create a Firebase project.
   - Enable **Email/Password** authentication.
   - Add iOS, Android, Web (and other) apps as needed.
   - Download the generated config files and make sure they match the ones referenced in `firebase_options.dart`.

3. **Run the app**
   ```bash
   flutter run
   ```

### Project structure (high level)

- `lib/main.dart` – App entry point, Firebase init, and Riverpod root.
- `lib/pages/` – Screens such as login, register, home, and chat.
- `lib/components/` – Reusable widgets (e.g. text fields, settings page).
- `lib/providers/` – Riverpod providers, including theme management.
- `lib/themes/` – Light and dark `ThemeData` definitions.

### Notes

- Update Firebase configuration if you change the Firebase project.
- When adding new pages or features, keep shared UI in `components` and state in `providers` for consistency.
