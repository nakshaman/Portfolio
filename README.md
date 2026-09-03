# Aman Kumar — Flutter Portfolio Website

A single-page animated portfolio built in Flutter (targets **web**, but runs on
mobile/desktop too). Dark theme, gradient accents, scroll-reveal animations,
an animated hero, timeline experience section, and hover-animated project
cards.

## Run it

```bash
flutter pub get
flutter run -d chrome          # dev preview in Chrome
flutter build web              # production build -> build/web
```


## Before you publish — fill this in

Everything now points at `github.com/nakshaman` (GitHub, and the 4 project
repos: `instagram`, `HiveChat`, `Favorite-Places`, `WeatherApp`). One thing
is still a placeholder in `lib/data/data.dart` — your LinkedIn URL:

```dart
static const String linkedinUrl = "https://linkedin.com/in/YOUR_USERNAME";
```

`Favorite-Places` and `WeatherApp` don't have READMEs on GitHub yet, so I
wrote short, honest one-line descriptions based on the repo names — edit
`PortfolioData.miniProjects` in `lib/data/data.dart` if you want to say more
about what each one does.

## The hero illustration (Lottie) — using YOUR chosen animation

You shared two great options on LottieFiles:
- "Free student with laptop Animation" — `lottiefiles.com/free-animation/student-with-laptop-EnL94F5d8E`
- "Free Programming Animation" — `lottiefiles.com/free-animation/programming-jbSmNWIUy1`

I couldn't download either automatically (the sandbox that built this has no
access to lottiefiles.com), so here's the 2-minute setup to use your exact
pick:

1. Open either link above → click **Download** → choose **Lottie JSON**.
2. Rename the downloaded file to `coding.json` and place it in
   `assets/animations/coding.json` (the folder already exists).
3. In `pubspec.yaml`, uncomment these two lines:
   ```yaml
   assets:
     - assets/animations/coding.json
   ```
4. Run `flutter pub get` again.

That's it — `lib/widgets/hero_section.dart` already checks for this file
first and uses it automatically. Until you add it, the hero uses a public
network animation as a placeholder, and if that's ever unreachable it falls
back to a small built-in illustration — so the site never looks broken
either way.

## Design

Redesigned to match an awwwards-style layout: a floating pill nav bar and a
big rounded "hero card" (illustration → name → rotating role → summary →
buttons → scroll-cue pill), all centered, with ambient glow blobs clipped to
the card's rounded corners. Fully responsive — the card, nav, illustration
size, and font sizes all scale across mobile/tablet/desktop breakpoints
(`Responsive` in `lib/theme/app_theme.dart`).

## Fixing "Connection failed (Operation not permitted)" font errors

If you run this as a **native macOS desktop app** (`flutter run -d macos`), you
may see console errors like:

```
google_fonts was unable to load font ... Connection failed (OS Error: Operation not permitted)
```

This is harmless — the app just falls back to a system font — but to fix it
properly, macOS desktop apps are sandboxed from making network calls unless
you explicitly allow it. Add this to **both**
`macos/Runner/DebugProfile.entitlements` and `macos/Runner/Release.entitlements`:

```xml
<key>com.apple.security.network.client</key>
<true/>
```

This isn't needed for `flutter run -d chrome`, iOS, Android, or the deployed
web build — only for running as a macOS desktop app.

## Project structure

```
lib/
  main.dart                  # app entry point
  theme/app_theme.dart        # colors, gradients, text styles, breakpoints
  data/data.dart              # ALL your content — edit this to update the site
  screens/home_screen.dart    # assembles sections + smooth scroll-to nav
  widgets/
    nav_bar.dart               # top nav, animated underline, mobile menu
    hero_section.dart          # animated gradient hero, rotating role text
    about_section.dart         # education, highlights, stat cards
    skills_section.dart        # staggered animated skill chips
    experience_section.dart    # animated vertical timeline
    projects_section.dart      # hover-animated project cards
    certifications_section.dart
    contact_section.dart       # mailto / tel buttons
    footer.dart
    animated_section.dart      # reusable "fade + slide up on scroll" wrapper
    section_header.dart
```

## Customizing

- **Colors/gradient**: `lib/theme/app_theme.dart` → `AppColors`.
- **Content** (name, summary, skills, experience, projects, certifications):
  `lib/data/data.dart` only — no need to touch any widget file.
- **Add a project photo**: swap the icon `Container` in
  `_ProjectCard` (`projects_section.dart`) for an `Image.asset(...)`.
- **Animation speed/style**: every entrance animation goes through
  `AnimatedSection` (`widgets/animated_section.dart`) — tweak the
  `fadeIn`/`slideY` durations and curves there to change it site-wide.

## Notes

- Built with `flutter_animate` for entrance/hover animations and
  `visibility_detector` to trigger animations as sections scroll into view.
- Fully responsive: mobile (<700px), tablet, and desktop layouts via
  `Responsive` helpers in `app_theme.dart`.
- This project wasn't compiled in the sandbox that generated it (no Flutter
  SDK there), so run `flutter pub get` first and let me know if you hit any
  errors — happy to fix them.
