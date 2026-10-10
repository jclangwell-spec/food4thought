# Food for Thought — working notes

Read `BRIEF.md` first; it is the spec. This file records conventions and decisions that change or extend it.

## Current phase
Phase 1 (accounts + your profile). Step 2 of 7: app shell built. Waiting for Josh to set up Firebase Hosting so it deploys to a web link.

## Decisions (override BRIEF.md where they differ)
- **Josh tests in Safari on his iPhone via a web link**, not the iOS Simulator. His Mac (MacBook Air 2017, macOS High Sierra) can't run current Flutter/Xcode and he is not updating it. All development happens in Claude Code cloud sessions (Flutter is installed by `.claude/hooks/session-start.sh`).
- **Target: iPhone.** Build Flutter web now; native iOS later (needs a newer Mac or cloud macOS CI, plus a $99/yr Apple Developer account — ask Josh first).
- **Sign-in: Google only in phase 1.** Sign in with Apple waits for the native iOS app.
- **Stay on Firebase's free Spark plan for phase 1.** No Cloud Functions, no Storage. Restaurant averages/counts are updated from the app in a Firestore transaction, guarded by security rules. Move to Blaze (with a £1 budget alert, Josh's OK first) in phase 2 for "Popular this week".
- **No profile photo in phase 1.** No pre-uploaded photo of Josh; show an initials avatar. Later, users upload their own photo when creating their account.
- **Look: Strava-like, not Agrumi.** Josh rejected the sky/pastel Agrumi-style samples. Direction is now clean cards, one strong accent colour, bold condensed numbers, reviews shown like activity-feed posts, "Popular this week" as a leaderboard. Use no Strava name, logo or exact colours. This overrides BRIEF.md §6 personality notes (blobs, orbiting plates, sky gradients); Letterboxd structure still applies.
- **Josh picked style A, "Ember"**: page `#F2F3F5`, white cards, ink `#1E1E24`, one blood-orange accent `#E5482A` (darker `#C2381C` for small text so it passes AA). Barlow for text, Barlow Condensed for headings and big numbers. Dark theme follows the phone setting. Tokens live in `lib/theme/app_colors.dart`; never hard-code colours in screens.
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
- Before pushing: `dart format lib test`, `flutter analyze` (no issues), `flutter test`.
- Pushing to `main` or the working branch runs `.github/workflows/deploy-web.yml`: analyze, test, build web, and deploy to Firebase Hosting once the `FIREBASE_SERVICE_ACCOUNT` secret exists. `.firebaserc` holds the project ID.
- Headless Chromium screenshots need `locale: 'en-GB'` set, or the Flutter web app throws a locale error and renders blank.

## Working with Josh
Josh isn't a developer. Plain English, small testable steps, ask before anything costs money or can't be undone. Secrets never go through chat — they go into GitHub repo secrets.
