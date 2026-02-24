# Flutter Medical Store App

A simple Flutter + Dart medical store demo app.

## Features
- Search medicines by name/category
- Add/remove medicines to cart
- Stock-aware cart handling
- Total price calculation and checkout action

## I just want the APK file
Use GitHub Actions to build and download APK without setting up Flutter locally.

1. Push this repo/branch to GitHub.
2. Open **Actions** tab in your GitHub repo.
3. Run workflow: **Build Flutter APK** (or push changes in `flutter_medical_store/`).
4. Wait for the workflow to finish.
5. Open the workflow run and download artifact: `medical-store-release-apk`.
6. Extract it and use `app-release.apk`.

Workflow file: `.github/workflows/build-flutter-apk.yml`.

## Run locally (optional)
1. Install Flutter SDK: https://docs.flutter.dev/get-started/install
2. Verify setup:
   ```bash
   flutter doctor
   ```
3. Move to project folder:
   ```bash
   cd flutter_medical_store
   ```
4. Fetch dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run
   ```

### Build release APK locally
```bash
flutter build apk --release
```

APK output path:
`build/app/outputs/flutter-apk/app-release.apk`
