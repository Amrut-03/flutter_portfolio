# Amrut Khochikar — Portfolio

A responsive, single-page Flutter web portfolio for **Amrut Khochikar**, a Flutter Developer and Mobile App Engineer. Built with Flutter for the web, Firebase Hosting, and Cloud Firestore.

## Features

- Dark, animated single-page design (particle background, scroll reveals, hover effects)
- Responsive layout: mobile, tablet, and desktop breakpoints
- Sections: About/Hero, Experience, Skills, Projects, Achievements, Contact
- Contact form saves messages to **Cloud Firestore** (`messages` collection), with an email fallback if the write fails
- Resume download button (navbar + hero)
- Links to GitHub, LinkedIn, phone, and email
- SEO / social-share meta tags

## Tech Stack

- Flutter (Dart) for web
- `google_fonts`, `url_launcher`, `web`
- `firebase_core`, `cloud_firestore`
- Firebase Hosting + Firestore rules

## Getting Started

```bash
flutter pub get
flutter run -d chrome
```

## Building & Deploying

```bash
flutter build web
firebase deploy
```

The Firebase Hosting project is `amrut-portfolio-project`. Before deploying, ensure a `(default)` Firestore database exists in that project and the Firestore rules allow `create` on `/messages/{messageId}`.

## Testing

```bash
flutter test
```

Includes widget tests for hero content, responsive nav, skill bars, and layout-overflow checks across common screen sizes.