# Restaurant Order Management App

A Flutter application for managing restaurant orders, tables, and menu items. Built using Clean Architecture principles with BLoC (Cubit) pattern and local storage.

## Features

- 🍽️ Table management (add, remove, status update)
- 🛍️ Order processing system
- 📝 Menu items management (pizzas and drinks)
- 💫 Status tracking for orders
- 🔄 Real-time updates
- 💾 Local data persistence

## Architecture

The project follows Clean Architecture principles with the following layers:

```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   └── usecases/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── cubit/
    ├── pages/
    ├── router/
    └── widgets/
```

### Layer Details

- **Core**: Contains common utilities, constants, and base classes
- **Data**: Implements data sources and repositories
- **Domain**: Contains business logic and entities
- **Presentation**: Houses UI components and state management

## Tech Stack

- Flutter: 3.19.3
- Dart: 3.3.1
- Minimum SDK: 3.1.5
- Target Platform: Android, iOS

### Key Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  go_router: ^13.1.0
  sqflite: ^2.3.2
  path: ^1.8.3
  equatable: ^2.0.5
  get_it: ^7.6.7
  dartz: ^0.10.1
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

## Getting Started

### Prerequisites

- Flutter SDK (3.19.3 or higher)
- Dart SDK (3.3.1 or higher)
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/restaurant_test_app.git
```

2. Navigate to project directory:
```bash
cd restaurant_test_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

### Database Setup

The app uses SQLite for local storage. The database will be automatically initialized on first run with sample data including:
- 5-10 menu items (pizzas and drinks)
- Basic table configuration
- Sample order statuses

## State Management

The app uses the BLoC pattern with Cubit for state management:

- `TableCubit`: Manages table states and operations
- `OrderCubit`: Handles order processing and status updates
- `ProductCubit`: Manages menu items

## Navigation

Using `go_router` for navigation with the following routes:

- `/`: Home page with order list
- `/tables`: Table management
- `/order`: Order creation/editing
- `/order/:id`: Order details

## Testing

Run tests using:
```bash
flutter test
```

## Building for Production

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Coding Standards

- Following Flutter's official style guide
- Using `flutter_lints` for code analysis
- Maintaining clean architecture principles
- Implementing error handling with Either type

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

- Clean Architecture principles by Robert C. Martin
- Flutter team for the amazing framework
- BLoC library maintainers

## Contact

Your Name - [@yourusername](https://twitter.com/yourusername)

Project Link: [https://github.com/yourusername/restaurant_test_app](https://github.com/yourusername/restaurant_test_app)