# Charger App

## Overview
The Charger App is a Flutter-based mobile application designed to monitor the charging status and provide useful information about the battery. The app includes features such as authentication, home screen with a curved navigation bar, and a detailed view of battery usage using gauge charts.

## Table of Contents
1. [Getting Started](#getting-started)
2. [Features](#features)
3. [Dependencies](#dependencies)
4. [Installation](#installation)
5. [Usage](#usage)
6. [Screenshots](#screenshots)
7. [Contributing](#contributing)
8. [License](#license)

## Getting Started
To get started with the Charger App, follow these steps:

1. Ensure you have Flutter installed. If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).
2. Clone the repository.
3. Open the project in your preferred IDE.
4. Run the `main.dart` file to launch the app.

## Features
### Authentication
The app includes authentication features to verify the user's identity and control access to specific sections.

### Home Screen
The home screen displays crucial information about the battery, such as the current charge percentage, estimated time left, and a background image. It also features a curved navigation bar for easy navigation.

### Settings
The settings screen provides options for configuring the app according to the user's preferences.

### Gauge Chart
The gauge chart offers a visual representation of battery usage, displaying the current charge percentage on a radial gauge chart. The chart updates in real-time as the battery charges.

## Dependencies
The Charger App relies on the following dependencies:
- `firebase_auth`: Handles user authentication.
- `firebase_core`: Initializes Firebase.
- `curved_navigation_bar`: Implements the curved navigation bar.
- `firebase_database`: Manages real-time data updates for battery usage.

## Installation
1. Add the required dependencies to your `pubspec.yaml` file.
   ```yaml
   dependencies:
     firebase_auth: ^latest_version
     firebase_core: ^latest_version
     curved_navigation_bar: ^latest_version
     firebase_database: ^latest_version
   ```

2. Run `flutter pub get` in your terminal.

## Usage
The app is structured with several Dart files, each serving a specific purpose:
- `auth_page.dart`: Manages authentication pages.
- `home_page.dart`: Displays the main home screen.
- `settings.dart`: Provides settings options.
- `table_screen.dart`: Navigates to a table screen.
- `stream_value.dart`: Manages real-time data updates.
- `usage_gauge_page.dart`: Displays a detailed gauge chart of battery usage.

Feel free to customize the code to suit your specific requirements.

## Screenshots
![charger2](https://github.com/dunMckenzie/smartcharger/assets/116878303/a760df53-b0b7-4b24-bb34-03081ce5b07f)
![charger1](https://github.com/dunMckenzie/smartcharger/assets/116878303/5067939e-60ec-4c09-a8dc-cd073dcec6c3)
![charger4](https://github.com/dunMckenzie/smartcharger/assets/116878303/bf9e7fa6-795c-46b9-9a89-fb4540e50203)
![charger3](https://github.com/dunMckenzie/smartcharger/assets/116878303/aa094188-0c71-48f6-b1fb-408d470c4c41)


## Contributing
If you wish to contribute to the Charger App, please follow these guidelines:
1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Submit a pull request.

## License
This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute it as per the license terms.
