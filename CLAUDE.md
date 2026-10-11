# Food for Thought — working notes

Read `BRIEF.md` first; it is the spec. This file records conventions and decisions that change or extend it.

## Current phase
Phase 1 (accounts + your profile). Step 3 of 7 done: Google sign-in works on Josh's iPhone. Shell restyled to the Letterboxd layout. Next: step 4, importing Josh's data. Firebase project `food-for-thought-1e4c7` connected; web app deploys to https://food-for-thought-1e4c7.web.app.

## Decisions (override BRIEF.md where they differ)
- **Josh tests in Safari on his iPhone via a web link**, not the iOS Simulator. His Mac (MacBook Air 2017, macOS High Sierra) can't run current Flutter/Xcode and he is not updating it. All development happens in Claude Code cloud sessions (Flutter is installed by `.claude/hooks/session-start.sh`).
- **Target: iPhone.** Build Flutter web now; native iOS later (needs a newer Mac or cloud macOS CI, plus a $99/yr Apple Developer account — ask Josh first).
- **Sign-in: Google only in phase 1.** Sign in with Apple waits for the native iOS app.
- **Stay on Firebase's free Spark plan for phase 1.** No Cloud Functions, no Storage. Restaurant averages/counts are updated from the app in a Firestore transaction, guarded by security rules. Move to Blaze (with a £1 budget alert, Josh's OK first) in phase 2 for "Popular this week".
- **No profile photo in phase 1.** No pre-uploaded photo of Josh; show an initials avatar. Later, users upload their own photo when creating their account.
- **Look: Letterboxd layout, dark slate, Ember orange accent.** History: Josh rejected Agrumi-style pastels, picked a Strava-like "Ember" style (A), then shared Letterboxd screenshots (`docs/inspiration/`) and chose "dark by default like Letterboxd, with our orange accent". This overrides BRIEF.md §6 personality notes (blobs, orbiting plates, sky gradients). Use no Letterboxd or Strava name, logo or exact colours.
  - App runs in dark mode always (`ThemeMode.dark`); the light palette is kept for a later light mode.
  - Dark slate: background `#161A1F`, bars `#0C0F12`, fields/segments `#2B333C`, accent `#E5482A` (`#FF7A5C` for small text). Barlow for text, Barlow Condensed for the wordmark and big numbers. Tokens live in `lib/theme/app_colors.dart`; never hard-code colours in screens.
  - Layout patterns: centred bold titles in a dark top bar; bottom bar with 5 icons: Home, Search, + (write a review, centre), Activity, Profile; Home "Popular this week" as a 3-across grid of square plate tiles; Search = search box + "Browse by" chevron rows; Profile = segmented tabs (Profile · Reviews · Wishlist — no Lists until phase 4), centred avatar and name, FAVOURITES row of 4 tiles, then big count rows with chevrons (Reviews, Wishlist, Following, Followers). Sign out lives in the ··· menu.
  - **Activity tab** (friends' latest reviews) is a placeholder until phase 2.
- **Fonts are bundled** in `assets/fonts/` rather than using the `google_fonts` package, so text renders right offline.
- **Wishlist is kept** as a core feature: users save restaurants they want to visit from Search or the Restaurant page. Phase 1: the Profile "Wishlist" row and list, plus "Add to wishlist" on the Restaurant page.

## Phase 1 steps
1. Style samples (2–3 palette + type + plate tile options) — Josh picks.
2. App shell: tabs + "+" button in the chosen style, auto-deploy to a web link via GitHub Actions.
3. Google sign-in, profile created on first sign-in.
4. Idempotent import of `food-for-thought-data.json` (fixed IDs from `e01`/`w01`), plus wipeable demo users.
5. Profile tab: header, favourites + edit, reviews dropdown with sort/filter, following/followers counts, wishlist row.
6. Restaurant page + write/edit review + add restaurant with duplicate warning + add to wishlist.
7. Security rules, offline, accessibility pass.

## Conventions
- Screens live in `lib/features/<area>/`, shared widgets in `lib/widgets/`. Screens will talk to data only through repository interfaces (from step 3).
- Data access goes through `lib/data/*_repository.dart` interfaces, handed to screens by `AppScope`. Tests use `FakeAuthRepository` (test/support) and `fake_cloud_firestore`.
- Profiles live at `users/{uid}`; each handle is claimed in `handles/{handle}` in the same transaction.
- Before pushing: `dart format lib test`, `flutter analyze` (no issues), `flutter test`. If `firestore.rules` changed, also `cd firestore-tests && npm test` (emulator rules tests; needs Java 21+).
- CI deploys Firestore rules before hosting, using firebase-tools with the same service-account secret. That account (firebase-adminsdk-…) needs two extra IAM roles: "Service Usage Consumer" (else 403 on serviceusage.googleapis.com) and "Firebase Rules Admin" (else 403 on firebaserules.googleapis.com).
- Pushing to `main` or the working branch runs `.github/workflows/deploy-web.yml`: analyze, test, build web, and deploy to Firebase Hosting once the `FIREBASE_SERVICE_ACCOUNT` secret exists. `.firebaserc` holds the project ID.
- This cloud environment's network policy blocks `*.web.app`, so check deploys via the GitHub Actions job log ("Production deploy succeeded"), and check the UI by building locally and screenshotting with Playwright.
- To screenshot the UI locally, build `tool/preview_main.dart` (signed in as Josh, no Firebase): `flutter build web -t tool/preview_main.dart --no-web-resources-cdn -o <dir>`. The real app loads Firebase JS from gstatic, which this sandbox blocks.
- Headless Chromium screenshots need `locale: 'en-GB'` set, or the Flutter web app throws a locale error and renders blank.

## Working with Josh
Josh isn't a developer. Plain English, small testable steps, ask before anything costs money or can't be undone. Secrets never go through chat — they go into GitHub repo secrets.
