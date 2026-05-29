# MoodMatch

A Flutter mobile application that provides personalized movie, TV series, and music recommendations based on your current mood.

## Description

MoodMatch helps users discover entertainment content that matches their emotional state. By selecting a mood, users receive curated recommendations for movies, TV shows, and music that align with how they're feeling. The app features a powerful search functionality to explore the entire recommendation database.

## Screenshots

<div align="center">
  <img src="/docs/screenshots/welcome_screen.png" alt="Welcome Screen" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="/docs/screenshots/home_screen.png" alt="Home Screen" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="/docs/screenshots/favourites_screen.png" alt="Favourites Screen" width="250"/>
  &nbsp;&nbsp;&nbsp;
  <img src="/docs/screenshots/browse_screen.png" alt="Browse Screen" width="250"/>
</div>

## Features

- **Mood-Based Recommendations**: Get personalized content suggestions based on your current emotional state
- **Multi-Content Support**: Discover movies, TV series, and music all in one place
- **Smart Search**: Search across all content types with real-time validation and filtering
- **Offline-First**: All recommendation data is bundled with the app for instant access
- **Material Design 3**: Modern, polished UI following the latest Material Design guidelines
- **State Management**: Efficient reactive state management using Riverpod
- **Type-Safe Navigation**: Route management handled by go_router

## Tech Stack

### Core Framework
- **Flutter** (SDK ^3.12.0) - Cross-platform mobile development framework
- **Dart** - Programming language

### State Management
- **flutter_riverpod** (^3.3.1) - Reactive state management and dependency injection

### Navigation
- **go_router** (^17.2.3) - Declarative routing solution for Flutter

### Additional Dependencies
- **cached_network_image** (3.3.1) - Efficient image loading and caching
- **shared_preferences** (2.3.2) - Local key-value storage
- **cupertino_icons** (^1.0.8) - iOS-style icons

### Development Tools
- **flutter_lints** (^6.0.0) - Recommended lints for Flutter projects
- **flutter_test** - Testing framework

## Project Structure

```
lib/
├── constants/
│   └── app_constants.dart         # Application-wide constants and route definitions
├── models/
│   ├── content_item.dart          # ContentItem model and ContentType enum
│   └── mood.dart                  # Mood model
├── providers/
│   └── app_providers.dart         # Riverpod providers and state notifiers
├── repositories/
│   └── recommendation_repository.dart  # Business logic for recommendations and search
├── screens/
│   └── search_screen.dart         # Search screen UI
├── services/
│   └── local_data_service.dart    # JSON data loading service
├── utils/
│   └── search_validator.dart      # Search input validation
└── main.dart                      # Application entry point

assets/
├── data/
│   └── content.json              # Mood and recommendation data
└── images/                       # Image assets (if any)
```

## Getting Started

### Prerequisites

- Flutter SDK (^3.12.0 or higher)
- Dart SDK (comes with Flutter)
- Android Studio / Xcode (for Android/iOS development)
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd moodmatch-mobile-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Verify your Flutter installation**
   ```bash
   flutter doctor
   ```

4. **Run the app**
   
   For development:
   ```bash
   flutter run
   ```
   
   For a specific device:
   ```bash
   flutter devices
   flutter run -d <device-id>
   ```

### Building for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Development

### Running Tests

```bash
flutter test
```

### Code Analysis

Check for any issues in the codebase:
```bash
flutter analyze
```

### Code Formatting

Format all Dart files:
```bash
flutter format .
```

## Architecture

The app follows a layered architecture pattern:

- **Presentation Layer** (`screens/`): UI components and user interactions
- **State Management Layer** (`providers/`): Riverpod providers managing application state
- **Business Logic Layer** (`repositories/`): Domain logic and data transformation
- **Data Layer** (`services/`, `models/`): Data models and data access

### State Management Flow

1. UI widgets consume providers
2. Providers expose state and business logic
3. Repositories handle data operations
4. Services interact with data sources (local JSON)

## Key Components

### Models
- **Mood**: Represents an emotional state with associated recommendations
- **ContentItem**: Represents a movie, TV series, or music recommendation
- **ContentType**: Enum for content types (music, movie, tvSeries)

### Providers
- **moodListProvider**: Manages the list of available moods
- **selectedMoodIdProvider**: Tracks the currently selected mood
- **searchQueryProvider**: Manages search input state
- **searchResultsProvider**: Provides filtered search results
- **moodRecommendationsProvider**: Delivers mood-based recommendations

### Services
- **LocalDataService**: Loads and parses JSON data from assets

### Repositories
- **RecommendationRepository**: Handles mood fetching, content search, and recommendation logic

## Contributing

This project is part of a Mobile Applications course. For contributions:

1. Create a new branch for your feature
2. Follow the existing code style and patterns
3. Ensure all tests pass
4. Run `flutter analyze` to check for issues
5. Submit a pull request with a clear description

## License

This project is created for educational purposes as part of a Mobile Applications course.

## Acknowledgments

- Built with Flutter and the Flutter community's excellent packages
- Material Design 3 for the design system
- Riverpod for elegant state management

## Project Team

- **Ismail Yilmaz** - 5123090
- **Phat Vo** - 2405645
- **Erkin Caliskan** - 5123096
- **Md Abdur Rahim** - 2407096
