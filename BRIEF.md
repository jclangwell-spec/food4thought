# Food for Thought — build brief (v2)

A social app for restaurants, the way Letterboxd is for films. People log the places they eat, rate them out of 5, review them, pin favourite dishes and follow friends. The home screen shows what's popular across everyone using the app this week.

The owner is Josh Langwell, who isn't a developer. He'll test every step on his phone and give feedback. Please explain choices in plain English, keep each step small enough to try out, and ask before anything costs money or can't be undone.

> v2 replaces the earlier single-user design. The app now has **Home, Search and Profile** tabs. It's multi-user from the start, because "popular this week" needs other people's reviews. Josh's own history moves into a reviews list on his profile.

---

## 1. Tech choices

- **Flutter**, so one codebase builds for iOS and Android. iPhone comes first.
- **Firebase from day one:** Auth (Sign in with Apple + Google), Firestore for data, Storage for photos and Cloud Functions for the weekly popularity counts. Start on the free tier and tell Josh before anything could cost money.
- Keep the data layer behind repository interfaces so screens don't talk to Firebase directly.
- Use `google_fonts` for type, and `flutter_animate` or the built-in implicit animations for motion. Keep other dependencies minimal and well maintained.
- Write a `README.md` with run instructions Josh can follow, and a `CLAUDE.md` holding the conventions and current phase.

## 2. Phases

Finish each phase, with it running on Josh's phone, before starting the next.

| Phase | Scope |
|---|---|
| **1. Accounts + your profile** | Sign in. The restaurant catalogue. Writing a review. The Profile tab without the cuisine diagram: name, photo, 4 favourites, the reviews dropdown with sort and filter, and Following/Followers counts. Importing Josh's data. |
| **2. Discovery + social** | The Search tab with all filters. The Home tab with "Popular this week". Following/following lists and other people's profiles. |
| **3. Personality** | The cuisine Venn diagram. Agrumi-style motion and polish. Review photos. |
| **4. Later** | Restaurant autocomplete from a places service (see §8). A map. Lists. Year in review. Wishlist sharing. |

## 3. Navigation

There's a bottom tab bar with three tabs: **Home · Search · Profile**. A round **+** button floats above the bar (or sits centred in it) to write a review from anywhere.

## 4. Screens

### 4.1 Home — Popular this week
- The header is the app name, "Food for Thought", set in the display face.
- **Popular this week** is a grid of restaurant "plates" (see §6), 3 across, ranked by the **number of reviews written in the last 7 days by all users**. Break ties first by the average rating that week, then by the total number of reviews ever.
- Show the top 12 to 24. Each tile has a small badge with that week's review count, e.g. "14 this week".
- If there's too little activity (fewer than 6 restaurants reviewed this week), widen the window to 30 days and change the heading to "Popular this month". If that's still empty, show "Most reviewed of all time" so Home is never blank.
- Tapping a tile opens the **Restaurant page** (§4.4).
- Optional extra rows below the grid, to add only if they're cheap: "New from friends" (latest reviews by people you follow) and "Just opened" (sorted by open date).
- Compute popularity with a scheduled Cloud Function, for example hourly, that writes a `popularThisWeek` document. Don't count reviews in the app.

### 4.2 Search
- A search box that matches restaurant name, city and area, typo-tolerant where it's easy.
- **Filters**, shown as chips:
  - **Open date:** Newest openings first / Oldest first, plus quick chips "Opened this year" and "Opened in the last 6 months"
  - **Cuisine:** multi-select
  - **Rating:** Highest rated / Lowest rated, using the app-wide average rating
  - **Vibe:** multi-select, from the vibe list in §5
- Show results as a list of rows: plate thumbnail, name, area · city, cuisine, vibe chips, average stars and the number of reviews. Tapping a row opens the Restaurant page.
- When the search is empty, show recent searches and popular cuisines as tappable chips.
- If nothing matches, offer **"Add this restaurant"**, which creates it in the catalogue (§8).

### 4.3 Profile
From top to bottom:
1. **Name and photo:** a large circular photo with the display name under it, plus an optional one-line bio. On someone else's profile there's a **Follow / Following** button here.
2. **Favourites:** four tiles in a row. Each favourite is **a specific dish at a specific restaurant**. The tile shows the dish name large, with the restaurant as the caption and your rating of that restaurant underneath. Tapping one opens the restaurant. You choose and reorder favourites from an edit screen. Empty slots show a dashed outline with "+ Add a favourite".
3. **Cuisine Venn diagram** (phase 3):
   - There's one circle per cuisine the user has reviewed. **Circle area is proportional to the number of reviews in that cuisine.** Scale by area, not radius, so 4 reviews looks twice the size of 2.
   - **Circle colour comes from the user's most common vibe within that cuisine**, using the vibe colours in §5. Use a semi-transparent fill so overlaps blend.
   - **Overlaps:** two circles overlap when the same restaurants are tagged with both cuisines (for example "Japanese" + "Ramen"), and the overlap is sized roughly to the number shared. Cuisines with nothing in common sit next to each other, packed closely like bubbles, with no overlap.
   - Put a label inside each circle large enough to hold it, and in a small legend otherwise. Show at most 12 circles and group the rest as "Other".
   - Tapping a circle opens the reviews dropdown filtered to that cuisine.
   - Below the diagram, add a small vibe colour key.
4. **Reviews:** a collapsible section titled "Reviews (89)". It's collapsed by default and opens with a smooth expand.
   - **Sort:** Newest review first / Highest rated / Lowest rated / Restaurant open date (newest first or oldest first)
   - **Filter:** Cuisine, Vibe
   - These use the same chip components as Search.
   - Each row has a plate thumbnail, restaurant name, your stars, ♥ if loved, a review snippet and the date. Tapping a row opens the full review.
5. **Following · Followers:** large rows with a count and chevron on the right, like Letterboxd. Each opens a list of people with a Follow/Unfollow button.
6. **Wishlist:** keep this as one more row ("Wishlist 34 ›") that opens Josh's saved places. *(It isn't in the v2 spec, but it keeps his 34 saved places. Remove it if Josh prefers.)*

### 4.4 Restaurant page
This screen isn't in the spec but is needed, since Home and Search both lead to restaurants. It has:
- A big plate, the name, area · city, cuisines, vibes and open date
- The app-wide average rating with a small histogram (½ to 5 stars, Letterboxd style)
- The number of reviews
- **Your review** if you've written one, otherwise a **Write a review** button
- **Friends' reviews**, then **Popular reviews**
- **Add to wishlist**

### 4.5 Write / edit a review
- Restaurant: search the catalogue, or add a new one.
- Date visited, defaulting to today.
- **Rating:** five large stars. Tap for a whole star, tap the same star again for a half, and tap a third time to clear.
- **Vibe:** pick 1 to 3 from the vibe list.
- Standout dish, which can be one-tapped into your Favourites.
- Also ordered.
- Review text.
- ☐ Loved it ♥
- Photo (phase 3).

## 5. Vibes

There's one fixed list, used by Search, the review form, the Venn colours and the filters. Each vibe has a colour:

| Vibe | Meaning | Colour |
|---|---|---|
| Date night | Low lights, special | Blood orange `#FF5A36` |
| Lively | Loud, buzzy, groups | Tangerine `#FF9F1C` |
| Casual | Easy, everyday | Lemon `#FFD23F` |
| Cosy | Small, warm, pub-ish | Terracotta `#D9734E` |
| Quick bite | In and out, takeaway, street food | Lime `#9BCB3C` |
| Brunch | Daytime, coffee | Sky `#6EC1F2` |
| Special occasion | Tasting menus, splurges | Grape `#8E6CEF` |
| Outdoor | Terraces, markets, beer gardens | Leaf `#3FA66B` |

On a review, the vibe is the reviewer's choice. On a restaurant, it's the 3 most-chosen vibes across all of that restaurant's reviews.

## 6. Look and feel

There are two references, which play different roles:

- **Letterboxd sets the structure.** Its poster grid, profile layout (avatar, four favourites, ratings histogram, big count rows with chevrons), star ratings, ♥ likes, compact diary rows and calm information density. Copy the *patterns*. Use no Letterboxd name, logo, colours or dot motif.
- **Agrumi (scrolltide.co/templates/agrumi) sets the personality.** That template is a playful, colourful storefront for dog-bowl ceramics: a summer-sky palette, a soft white blob that "blooms" across the screen, and bowls that orbit in windows of sky and stream past one at a time as you scroll. Bring that mood here:
  - **Plates instead of posters.** Each restaurant is a round plate or bowl tile in a square cell, rather than Letterboxd's 2:3 poster. Until there's a photo, generate it: a glossy ceramic-looking circle in a colour taken from a hash of the restaurant name, with the name set around or below it.
  - **Summer-sky backgrounds.** Use soft sky gradients behind hero areas (Home header, Profile header), with gentle white cloud/blob shapes.
  - **Blob transitions.** When opening a restaurant or review, a white blob expands from the tapped plate to fill the screen. Keep it under 400 ms.
  - **Orbiting plates.** On Home, the "Popular this week" plates drift in with a slight stagger and a gentle float as you scroll. Keep this subtle in lists.
  - **Bouncy, tactile controls.** Buttons squash slightly when pressed, stars pop when tapped and the ♥ bursts.
  - Respect the phone's **Reduce Motion** setting, which turns all of this into simple fades.
- **Provisional palette.** Josh will share screenshots of Agrumi to refine this. Until then:
  - Sky `#BFE3FA` → `#EAF6FE` for backgrounds
  - Cloud white `#FFFDF8` for cards
  - Ink navy `#1B2A4A` for text, and `#5B6B85` for secondary text
  - Stars in sunny yellow `#FFC93C` with a navy outline
  - The ♥ in blood orange `#FF5A36`
  - The citrus vibe colours in §5 as accents
  - Also offer a dark "night sky" theme: navy `#121A2E` background, the same accents.
- **Type:** a chunky, friendly display face for names and headings (try *Bricolage Grotesque*) and a clean rounded sans for text (try *Figtree*). Both are on Google Fonts. Show Josh the options before committing.
- Use big rounded corners (20–28 px) on cards and sheets, and fully round plates, chips and the + button.

**If Josh shares Agrumi screenshots, they override the palette and type guesses above.**

## 7. Data model (Firestore)

```
users/{uid}             { displayName, handle, photoUrl, bio, createdAt,
                          favourites: [ {restaurantId, dish, order} x up to 4 ],
                          followerCount, followingCount, reviewCount }
users/{uid}/following/{otherUid}   { since }
users/{uid}/followers/{otherUid}   { since }
users/{uid}/wishlist/{id}          { restaurantId, note, priority, addedAt }

restaurants/{id}        { name, nameLower, city, area, cuisines: [..],
                          openedOn (date, nullable), topVibes: [..],
                          avgRating, ratingCount, reviewCount,
                          ratingHistogram: {"0.5":n,...,"5":n},
                          createdBy, createdAt, placeId (nullable, phase 4) }

reviews/{id}            { userId, restaurantId, rating (0.5–5, nullable),
                          vibes: [..], standoutDish, alsoOrdered, text,
                          loved, visitedOn (nullable), photoUrl,
                          createdAt, updatedAt,
                          originalScore?, originalRank?, importedFrom? }

stats/popularThisWeek   { windowStart, windowEnd, items: [{restaurantId, count, avg}] }
```

Keep restaurant averages and counts up to date in a Cloud Function that runs when a review is written. Write security rules so that everyone signed in can read, people can only write their own reviews and profile, and anyone signed in can create a restaurant.

## 8. Where restaurants come from

There's no free, complete list of restaurants with **opening dates**, and map services generally don't provide them. So:
- **Phase 1–3:** the catalogue is built by users. It's seeded from Josh's 123 places. "Add this restaurant" lets anyone add one (name, city, area, cuisines, opened on). Flag likely duplicates by matching similar names in the same city.
- **Open date** is entered by people and can be edited. A restaurant with no date sorts last in open-date sorts.
- **Phase 4:** optionally add autocomplete from a places service (Google Places or Foursquare) to fill in name, address and location. These cost money past free limits, so ask Josh first.

## 9. Importing Josh's data

Use the files in `assets/`: `food-for-thought-data.json` and `profile-photo.jpg`. The JSON was exported from the prototype, which had no vibes or open dates.

- **Create Josh's user:** display name "Josh Langwell", handle `josh_langwell`, and the photo from `profile-photo.jpg`.
- **For each `visits[]` item:** find or create a restaurant from `name`, `city`, `area` and `cuisine`, with the cuisine becoming `cuisines: [cuisine]` when it isn't blank. Then create a review by Josh with `rating`, `standoutDish`, `alsoOrdered`, `review → text`, `loved`, `visitedOn = null`, and keep `originalScore`, `originalRank` and `importedFrom`.
  - Map the old `diningStyle` to an initial vibe: Pub → Cosy, Street food → Quick bite, Café → Brunch, Brunch → Brunch, Fine dining → Special occasion, Bar → Lively, Casual → Casual, and leave it blank otherwise. Josh can correct these later.
- **For each `wishlist[]` item:** find or create the restaurant, then add it to Josh's wishlist with `note` and `priority`.
- **`favouriteDishes[]`, in order, become Josh's 4 favourites:** Tonkotsu ramen @ Maki and Ramen · Oxtail orzo @ Oma · Momo combo @ House of Momo · Croissant @ Mahali Bakery.
- Run the import **once only**, as an admin script or a one-off button. It must be safe to run twice without duplicating anything.
- How the ratings were made (already done, so don't recalculate): /10 scores were halved and rounded to half stars, and the Edinburgh ranks #1–#33 were spread from 5★ down to 3★.
- To test Home and Search with more than one user, create **3 to 5 clearly labelled demo users** with a handful of reviews each, in a separate test project or under a `demo` flag that can be wiped. Never mix them into Josh's real data without asking.

## 10. Behaviour rules

- Every delete needs a confirm step inside the sheet. Don't use pop-up alert dialogs.
- Filters match without caring about capitals. Restaurants with no rating, vibe or open date sort last.
- Edits keep fields the form doesn't show, such as `originalScore`.
- Make it work offline where Firestore allows, with reviews written offline syncing later.
- Make it accessible: star ratings get labels such as "3.5 stars", tap targets are at least 44 pt and text contrast meets WCAG AA on both themes.

## 11. How to work with Josh

- Start by reading this brief and the data file. Then propose a short plan for phase 1, including the Firebase setup steps Josh must do himself, and wait for his OK.
- After each screen, run the app in the iOS Simulator and tell Josh what to try.
- Commit to git after each working step, with clear messages. Set up a private GitHub repo if Josh wants backup.
- Explain any setup Josh has to do himself (Xcode, Apple ID signing, the Firebase console) one step at a time.
- Before building the look, show Josh 2 or 3 small style samples (palette + type + one plate tile) and let him pick.
