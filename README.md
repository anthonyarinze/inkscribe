# InkScribe - Your Book App

InkScribe is a Flutter-based mobile application that allows users to explore, search for, and bookmark their favorite books. It integrates with Google Books API to provide book details, covers, and author information. Users can sign in to the app to save their bookmarks and preferences across devices.

<p align="center">
  <img src="app_demo.gif" alt="App Demo" width="300" />
</p>

## Features

- Search for books using keywords
- Explore book details including cover image, title, and author
- Bookmark books for easy access later
- Sign in or sign up to sync bookmarks across devices
- User-friendly interface and smooth animations
- ...

## Screenshots

![Screenshot 1](screenshots/screenshot1.png)
![Screenshot 2](screenshots/screenshot2.png)
![Screenshot 3](screenshots/screenshot3.png)

## Installation

1. Clone the repository: `git clone https://github.com/anthonyarinze/InkScribe.git`
2. Navigate to the project directory: `cd InkScribe`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## Dependencies

- `flutter`
- `dio` for making API requests
- `firebase_auth` for authentication
- `riverpod` for state management
- `google_fonts` for using custom fonts
- ...

## Getting Started

1. Make sure you have Flutter installed on your machine.
2. Clone this repository.
3. Set up your Firebase project and configure Firebase Authentication.
4. Create a `lib/config.dart` file and provide your API keys and Firebase configurations:

```dart
class Config {
  static const String googleBooksApiKey = 'YOUR_GOOGLE_BOOKS_API_KEY';
  static const String firebaseApiKey = 'YOUR_FIREBASE_API_KEY';
  static const String firebaseProjectId = 'YOUR_FIREBASE_PROJECT_ID';
  static const String firebaseMessagingSenderId = 'YOUR_FIREBASE_MESSAGING_SENDER_ID';
  // ...
}
```
