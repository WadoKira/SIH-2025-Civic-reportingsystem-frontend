# Civic Reporter Frontend

Demonstrates the frontend implementation of the Civic Reporting System developed for Smart India Hackathon 2025.

## Overview

This project is a Flutter-based mobile application that enables citizens to report civic issues, track complaint status, and view nearby problems using map integration.

The application focuses on usability, modular architecture, and scalable state management.

## Features

- Cross-platform Flutter application (Android, iOS, Web)
- Secure authentication system
- Issue reporting with camera and gallery support
- Real-time location tagging
- Interactive map view of complaints
- Provider-based state management
- Light and dark theme support

## Tech Stack

- Flutter
- Dart
- Provider (State Management)
- flutter_map (Maps Integration)
- geolocator & geocoding (Location Services)
- camera & image_picker (Media Capture)
- google_nav_bar (Navigation UI)

## Project Structure

- android/ – Android native configuration
- ios/ – iOS native configuration
- web/ – Web configuration
- lib/
  - providers/ – State management logic
  - screens/ – Application UI screens
  - utils/ – Themes and helper utilities
  - main.dart – Application entry point
- test/ – Unit and widget tests
- pubspec.yaml – Dependencies and project metadata

## Getting Started

This project is a starting point for a Flutter application.

### Clone the Repository

git clone https://github.com/WadoKira/SIH-2025-Civic-reportingsystem-frontend.git  
cd SIH-2025-Civic-reportingsystem-frontend  

### Install Dependencies

flutter pub get

### Run the Application

flutter run

### Run on Web

flutter run -d chrome

## Build

### Build Android APK

flutter build apk

### Build iOS

flutter build ios

### Build Web

flutter build web

## Architecture

The application follows a modular structure:

- UI separated into screens
- Business logic handled via Provider
- Theme configuration centralized
- Location and map services integrated into reporting flow

## Recommended Environment

- Flutter 3.x
- Dart SDK compatible with Flutter
- Android Studio or VS Code
- Android SDK / Xcode

## Contribution

1. Fork the repository
2. Create a new branch
3. Commit your changes
4. Submit a Pull Request

Ensure proper formatting and lint rules are followed.

## Future Improvements

- Offline-first support
- Push notifications
- Complaint analytics dashboard
- Map clustering and heatmap visualization
- Enhanced backend integration
