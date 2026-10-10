# Food for Thought — working notes

Read `BRIEF.md` first; it is the spec. This file records conventions and decisions that change or extend it.

## Current phase
Phase 1 (accounts + your profile). Step 1 of 7: style samples — waiting for Josh to pick one.

## Decisions (override BRIEF.md where they differ)
- **Josh tests in Safari on his iPhone via a web link**, not the iOS Simulator. His Mac (MacBook Air 2017, macOS High Sierra) can't run current Flutter/Xcode and he is not updating it. All development happens in Claude Code cloud sessions (Flutter is installed by `.claude/hooks/session-start.sh`).
- **Target: iPhone.** Build Flutter web now; native iOS later (needs a newer Mac or cloud macOS CI, plus a $99/yr Apple Developer account — ask Josh first).
- **Sign-in: Google only in phase 1.** Sign in with Apple waits for the native iOS app.
- **Stay on Firebase's free Spark plan for phase 1.** No Cloud Functions, no Storage. Restaurant averages/counts are updated from the app in a Firestore transaction, guarded by security rules. Move to Blaze (with a £1 budget alert, Josh's OK first) in phase 2 for "Popular this week".
- **No profile photo in phase 1.** No pre-uploaded photo of Josh; show an initials avatar. Later, users upload their own photo when creating their account.
- **Wishlist is kept** as a core feature: users save restaurants they want to visit from Search or the Restaurant page. Phase 1: the Profile "Wishlist" row and list, plus "Add to wishlist" on the Restaurant page.

## Phase 1 steps
1. Style samples (2–3 palette + type + plate tile options) — Josh picks.
2. App shell: tabs + "+" button in the chosen style, auto-deploy to a web link via GitHub Actions.
3. Google sign-in, profile created on first sign-in.
4. Idempotent import of `food-for-thought-data.json` (fixed IDs from `e01`/`w01`), plus wipeable demo users.
5. Profile tab: header, favourites + edit, reviews dropdown with sort/filter, following/followers counts, wishlist row.
6. Restaurant page + write/edit review + add restaurant with duplicate warning + add to wishlist.
7. Security rules, offline, accessibility pass.

## Working with Josh
Josh isn't a developer. Plain English, small testable steps, ask before anything costs money or can't be undone. Secrets never go through chat — they go into GitHub repo secrets.
