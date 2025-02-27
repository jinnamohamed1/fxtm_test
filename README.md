# FXTM Forex Tracker
- [FXTM Forex Tracker](#fxtm-forex-tracker)
  - [Introduction](#introduction)
  - [Setup Instructions](#setup-instructions)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [API Configuration](#api-configuration)
  - [Architecture Overview](#architecture-overview)
  - [Features](#features)
  - [Data and API Usage](#data-and-api-usage)
  - [State Management](#state-management)
  - [Third-Party Packages](#third-party-packages)
## Introduction
FXTM Forex Tracker is a Flutter-based application that provides real-time Forex trading data. The app fetches price updates and historical trade data using the [Finnhub API](https://finnhub.io/docs/api). Users can browse Forex pairs and view their historical candlestick data using an interactive chart.
## Setup Instructions
### Prerequisites
Ensure you have the following installed:

- Flutter (Latest stable version)
- Dart SDK
- Android Studio/Xcode (for emulator/simulator)
- VS Code (Recommended for Flutter development)
- Register for a free API key from [Finnhub](https://finnhub.io/)

### Installation
1. Clone the repository:
    ```
    git clone https://github.com/jinnamohamed1/fxtm_test.git
    cd fxtm_test
    ```
2. Install dependencies:
    ```
    flutter pub get
    ```
3. Run code generation (for JSON serialization):
    ```
    flutter pub run build_runner build --delete-conflicting-outputs
    ```
4. Configure the environment variables (see API Configuration)
5. Run the app:
    ```
    flutter run
    ```
### API Configuration
1. Register for a free API key at [Finnhub](https://finnhub.io/).
2. Create a .env file in the root directory:
    ```
    API_HOST="https://finnhub.io/api/v1"
    API_KEY=your_api_key_here
    WEBSOCKET_URL="wss://ws.finnhub.io"
    DEFAULT_EXCHANGE="OANDA"
    ```
3. The app will automatically read the API key using `flutter_dotenv`.

## Architecture Overview
The app follows Clean Architecture with separation of concerns:
```
lib/
│── core/                  # Core utilities, theme, navigation, DI
│── features/
│   ├── forex_list/        # Forex List Feature
│   │   ├── data/          # Data Layer (Models, Repositories, Data Sources)
│   │   ├── di/            # Dependency Injection
│   │   ├── domain/        # Business Logic Layer (Use Cases, Entities)
│   │   ├── presentation/  # UI Layer (Widgets, Pages, Bloc)
│   ├── trade_history/     # Trade History Feature
│   │   ├── data/
│   │   ├── di/
│   │   ├── domain/
│   │   ├── presentation/
```
## Features

- View live Forex price updates
- Select a currency pair to view historical candlestick data
- Interactive candlestick chart using `interactive_chart`
- Error handling with retry options

## Data and API Usage

- The app fetches Forex data from the **Finnhub API**:
- Live price updates via WebSockets
- **Historical candlestick** data via REST API
- Uses both **remote** and **local** (JSON file) data sources

## State Management

- The app uses Flutter Bloc for state management:
- `ForexListBloc` for fetching Forex symbols and prices
- `TradeHistoryBloc` for fetching historical data
- Events drive state transitions (Loading, Loaded, Error)

## Third-Party Packages

- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management
- [json_serializable](https://pub.dev/packages/json_serializable) - JSON parsing
- [interactive_chart](https://pub.dev/packages/interactive_chart) - Candlestick charts
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) - Environment variables