# CORSIT - Club Of Robotics

A modern Flutter mobile application designed for robotics clubs to manage projects, events, and team collaboration.

## Features

### 🏠 Dashboard

- Welcome screen with club statistics
- Quick action buttons for common tasks
- Recent activities feed
- Project and event overview

### 🔧 Projects

- View all robotics projects
- Project status tracking (Planning, In Progress, Completed)
- Team member information
- Project descriptions and details

### 📅 Events

- Browse upcoming robotics events
- Event registration functionality
- Event details and descriptions
- Workshop and competition information

### 👥 Team

- Team member profiles
- Contact information
- Role-based organization
- Direct messaging capabilities

### 👤 Profile

- Personal information management
- CORSIT membership details
- Settings and preferences
- Activity history

## Design Features

- **Modern UI/UX**: Clean, intuitive interface with Material Design 3
- **Responsive Design**: Works seamlessly across different screen sizes
- **Color Scheme**: Professional blue theme representing technology and innovation
- **Navigation**: Bottom navigation bar for easy access to all sections
- **Cards Layout**: Information organized in clean, readable cards

## Technology Stack

- **Framework**: Flutter 3.8+
- **Language**: Dart
- **UI**: Material Design 3
- **State Management**: Built-in Flutter state management
- **Platforms**: Android, iOS, Web (cross-platform)

## Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development, macOS only)

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd corsit_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Building for Production

**Android APK:**

```bash
flutter build apk --release
```

**iOS App:**

```bash
flutter build ios --release
```

**Web:**

```bash
flutter build web
```

## Project Structure

```
lib/
├── main.dart              # Main application entry point
└── (All pages are in main.dart for simplicity)
    ├── DashboardPage      # Home dashboard
    ├── ProjectsPage       # Projects management
    ├── EventsPage         # Events and workshops
    ├── TeamPage          # Team member profiles
    └── ProfilePage       # User profile and settings
```

## Features Overview

### Dashboard

- Welcome card with club branding
- Statistics cards showing active projects, team members, and events
- Quick action buttons for common tasks
- Recent activities timeline

### Projects Management

- List of robotics projects with status indicators
- Project descriptions and team information
- Add new project functionality
- Project categorization and filtering

### Events System

- Upcoming events with dates and times
- Event registration buttons
- Workshop and competition information
- Event categorization by type

### Team Collaboration

- Team member profiles with roles
- Contact information and direct messaging
- Role-based organization (Team Lead, Technical Lead, etc.)
- Team member search and filtering

### User Profile

- Personal information management
- CORSIT membership details
- Settings and preferences
- Activity tracking and history

## Customization

### Colors

The app uses a blue color scheme that can be customized in `main.dart`:

- Primary: `Color(0xFF1976D2)`
- Secondary: `Color(0xFF42A5F5)`

### Content

All content is currently hardcoded in the app. To make it dynamic:

1. Add a backend API
2. Implement state management (Provider, Bloc, or Riverpod)
3. Add data models for projects, events, and team members

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions about the CORSIT app, please contact the development team or create an issue in the repository.

---

**CORSIT - Club Of Robotics**  
_Empowering the future of robotics through innovation and collaboration_
