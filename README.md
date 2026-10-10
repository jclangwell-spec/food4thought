# Food for Thought

A social app for restaurants, the way Letterboxd is for films: log the places you eat, rate them out of 5, review them, pin favourite dishes and follow friends.

The full spec is in [`BRIEF.md`](BRIEF.md). Current progress and decisions are in [`CLAUDE.md`](CLAUDE.md).

## Trying the app

Every change pushed to GitHub is checked and, once Firebase is connected, published to the app's web link automatically. Open the link in Safari on your iPhone. To make it feel like an app, tap the Share button, then **Add to Home Screen**.

You can see each publish under the repo's **Actions** tab on GitHub. A green tick means it worked.

## Running it yourself (developers)

Needs Flutter 3.47.7 (stable).

```sh
flutter pub get
flutter run -d chrome     # run in a browser
flutter test              # run the tests
flutter analyze           # check for code problems
flutter build web --no-web-resources-cdn   # build the web version into build/web
```

## How the code is organised

- `lib/theme/` colours (the "Ember" palette) and fonts (Barlow, Barlow Condensed)
- `lib/shell/` the bottom tabs and the + button
- `lib/features/` one folder per screen: home, search, profile, review
- `lib/widgets/` pieces shared between screens
- `assets/` Josh's exported data and the bundled fonts
