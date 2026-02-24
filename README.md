Civic Reporter — Frontend (Flutter)

A mobile frontend application built with Flutter for the Civic Reporting System — developed as part of Smart India Hackathon 2025 (SIH 2025).

This application enables citizens to report civic issues, view nearby problems, and interact with backend services including authentication, issue tracking, maps, and image uploads.

Features

Cross-platform Flutter application (Android, iOS, Web, Desktop)

User authentication and session handling

Issue reporting with camera and gallery support

Maps and real-time location integration

State management using Provider

Material Design UI with light and dark theme support

Project Structure
├── android/             # Android native configuration
├── ios/                 # iOS native configuration
├── lib/                 # Main Dart source code
│   ├── providers/       # State management classes
│   ├── screens/         # Application UI screens
│   ├── utils/           # Themes and utility classes
│   └── main.dart        # Application entry point
├── web/                 # Web configuration
├── test/                # Unit and widget tests
├── pubspec.yaml         # Project dependencies
├── .gitignore           # Git ignore rules
└── README.md            # Documentation
Dependencies

Key packages used in this project:

flutter_map — Interactive map rendering

latlong2 — Geographic coordinate handling

geolocator — Device location access

geocoding — Reverse geolocation

image_picker — Image selection from camera/gallery

camera — Camera integration

google_nav_bar — Bottom navigation bar

provider — State management

intl — Internationalization support

All dependencies are listed in pubspec.yaml.

Architecture
State Management

The project uses Provider for scalable and reactive state management.

MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => IssueProvider()),
  ],
  child: MaterialApp(...)
)
Theme Support

Custom light and dark themes are defined in utils/app_theme.dart.

Modular Screen Design

Screens are organized into separate files for authentication, dashboard, issue reporting, and splash flow.

Map and Location Integration

The application integrates device geolocation and interactive maps to allow accurate civic issue reporting.

Setup and Installation
Clone the Repository
git clone https://github.com/WadoKira/SIH-2025-Civic-reportingsystem-frontend.git
cd SIH-2025-Civic-reportingsystem-frontend
Install Dependencies
flutter pub get
Run the Application

For Android or iOS:

flutter run

For Web:

flutter run -d chrome
Build Release Version

For Android:

flutter build apk

For iOS:

flutter build ios
Recommended Environment

Flutter 3.9 or higher

Compatible Dart SDK

Android Studio or Visual Studio Code

Contribution Guidelines

Fork the repository

Create a new branch

Commit changes with proper descriptions

Submit a pull request

Ensure code formatting and lint rules are followed.

Future Enhancements

Offline-first synchronization

Push notifications for issue status updates

Map clustering and heatmap visualization

Complete backend API integration documentation
