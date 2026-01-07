# FormulaStats

A native iOS application for comparing Formula 1 driver statistics across different seasons and eras. FormulaStats enables F1 enthusiasts to perform detailed statistical comparisons of driver performance using real-time data from the Jolpica F1 REST API.

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)
![Platform](https://img.shields.io/badge/platform-iOS%2018.0+-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Architecture](#architecture)
- [API Integration](#api-integration)
- [Scoring Algorithm](#scoring-algorithm)
- [Technologies](#technologies)
- [Requirements](#requirements)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)

## Overview

FormulaStats is built using Swift and SwiftUI, providing a modern iOS interface for exploring Formula 1 statistics. The app fetches comprehensive racing data including race results, qualifying positions, championship points, and career achievements, allowing users to make fair comparisons between drivers from different eras and regulation periods.

## Features

### Driver Comparison

- **Cross-Era Comparisons**: Compare any two drivers from seasons 2003-2023
- **Comprehensive Statistics**: View wins, points, pole positions, and final championship standings
- **Real-Time Data**: Fetch live data from the Jolpica F1 API
- **FormulaStats Score**: Custom normalized scoring algorithm for fair cross-era comparisons
- **Visual Indicators**: Color-coded comparison showing which driver performed better in each metric

### Statistics Tracked

- Total race wins in the season
- Total championship points
- Final drivers' championship position
- Pole positions (2003 onwards)
- FormulaStats composite performance score

### Game Mode

- Random driver matchup generator
- Compare surprise pairings from different seasons
- Test your F1 knowledge with unpredictable matchups

## Installation

### Prerequisites

- macOS with Xcode 16.0 or later
- iOS 18.0+ device or simulator
- Apple Developer account (for device deployment)

### Clone the Repository

```bash
git clone https://github.com/JakeSeiberg/FormulaStats.git
cd FormulaStats
```

### Open in Xcode

```bash
open FormulaStats.xcodeproj
```

### Build and Run

1. Select your target device or simulator
2. Press `Cmd + R` to build and run the application
3. The app will launch and you can begin comparing drivers

## Usage

### Comparing Drivers

1. **Enter First Driver Details**
   - Input the season year (2003-2023)
   - Tap "Get Drivers" to load available drivers for that season
   - Select a driver from the picker

2. **Enter Second Driver Details**
   - Input the season year for comparison
   - Tap "Get Drivers" to load drivers
   - Select the second driver from the picker

3. **View Comparison**
   - Tap "Get Race Data" to fetch statistics
   - View side-by-side comparison with color-coded results:
     - Green: Better performance
     - Red: Worse performance
     - Yellow: Tied performance

4. **Reset**
   - Tap "Reset" to clear all data and start a new comparison

### Game Mode

1. Navigate to "Play the FormulaStats Game"
2. Tap "Generate Two Drivers"
3. The app will randomly select two drivers and seasons
4. View the comparison and test your F1 knowledge

## Architecture

### Project Structure

```
FormulaStats/
├── FormulaStats.xcodeproj/       # Xcode project files
├── FormulaStats/
│   ├── ContentView.swift         # Main UI with comparison and game screens
│   ├── DriverList.swift          # Driver data models and fetching logic
│   ├── RaceData.swift            # Race statistics API calls (wins, poles)
│   ├── Points.swift              # Championship standings and points data
│   ├── Support.swift             # Helper functions and scoring algorithm
│   ├── FormulaStatsApp.swift    # App entry point
│   └── Assets.xcassets/          # App icons and assets
├── README.md                     # Project documentation
└── LICENSE                       # License file
```

### Key Components

**ContentView.swift**
- Main application interface
- `CompareScreen`: User-driven driver comparison interface
- `GameScreen`: Random driver matchup generator
- State management for driver data and UI updates

**DriverList.swift**
- `DriverList`, `Driver` models for JSON decoding
- `getDriversList()`: Fetches all drivers for a given season
- `getDriverId()`: Retrieves driver ID from name

**RaceData.swift**
- `getDriverWins()`: Fetches total race wins in a season
- `getDriverPoles()`: Fetches pole positions (2003+)
- `getRacesInSeason()`: Calculates total races participated

**Points.swift**
- `DriverStanding` models for championship data
- `getPointsInSeason()`: Retrieves total championship points
- `getFinalPositionInSeason()`: Gets final standings position

**Support.swift**
- `splitName()`: Parses driver names for API queries
- `calcScore()`: Computes normalized FormulaStats performance score

## API Integration

FormulaStats uses the [Jolpica F1 API](https://github.com/jolpica/jolpica-f1), a RESTful API providing comprehensive Formula 1 data.

### Endpoints Used

```
GET https://api.jolpi.ca/ergast/f1/{season}/drivers.json
GET https://api.jolpi.ca/ergast/f1/{season}/drivers/{driverId}/results/1.json
GET https://api.jolpi.ca/ergast/f1/{season}/drivers/{driverId}/qualifying/1.json
GET https://api.jolpi.ca/ergast/f1/{season}/drivers/{driverId}/driverStandings.json
```

### Data Fetching Pattern

All API calls use asynchronous completion handlers:

```swift
func getDriverWins(season: String, driverId: String, completion: @escaping (Int?) -> Void) {
    // Async URLSession data task
    // JSON decoding
    // Completion handler callback
}
```

### Error Handling

- Network error handling with optional return types
- JSON decoding error management
- Graceful fallback for missing data

## Scoring Algorithm

The FormulaStats Score provides a normalized metric for comparing drivers across different eras, accounting for:

- **Wins** (32 points per win): Primary performance indicator
- **Pole Positions** (16 points per pole): Qualifying speed
- **Championship Points** (2 points per point): Overall consistency
- **Final Position** (abs(position - 30) × 2): Championship competitiveness

**Formula:**
```
Score = (wins × 32 + poles × 16 + points × 2 + (30 - position) × 2) / total_races
```

This per-race normalization ensures fair comparison between drivers with different season lengths.

## Technologies

- **Swift 5.0**: Modern, type-safe programming language
- **SwiftUI**: Declarative UI framework for iOS
- **URLSession**: Native networking for API calls
- **Codable**: JSON serialization/deserialization
- **Async/Await Pattern**: Completion handlers for asynchronous operations
- **Xcode 16.0**: Development environment

## Requirements

- iOS 18.0 or later
- Xcode 16.0 or later
- Internet connection for API access
- Swift 5.0

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

### How to Contribute

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines

- Follow Swift style conventions
- Maintain SwiftUI best practices
- Add comments for complex logic
- Test on multiple iOS versions
- Ensure backwards compatibility

## License

This project is licensed under the MIT License.

## Acknowledgments

- **Jolpica F1 API**: [github.com/jolpica/jolpica-f1](https://github.com/jolpica/jolpica-f1) - Comprehensive F1 data API
- **Ergast Developer API**: Original data source for F1 statistics
- **Formula 1**: For the incredible sport and historical data

## Author

**Jacob Seiberg**

- GitHub: [@JakeSeiberg](https://github.com/JakeSeiberg)
- LinkedIn: [Jacob Seiberg](https://www.linkedin.com/in/jacob-seiberg-55ba64335/)
- Portfolio: [pages.uoregon.edu/jseiberg](https://pages.uoregon.edu/jseiberg/index.html)

**Built with passion for Formula 1 and iOS development**
