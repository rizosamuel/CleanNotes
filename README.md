# CleanNotes

## Overview

CleanNotes is an iOS application built using Swift and Clean Architecture principles. It allows users to create, edit, and manage their notes efficiently while ensuring a structured and scalable codebase.

## Features

- User authentication (Login/Register)
- Create, edit, and delete notes
- Settings management
- Biometric authentication support (Face ID/Touch ID)
- Organized using Clean Architecture
- Unit tested for robustness

## Installation

### Prerequisites

- macOS with Xcode installed (latest recommended version)
- Swift Package Manager (SPM) dependencies resolved

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/CleanNotes.git
   cd CleanNotes
   ```
2. Open `CleanNotes.xcodeproj` in Xcode.
3. Select the appropriate simulator or device.
4. Build and run the project.

## Project Structure

The project follows Clean Architecture principles and is structured as follows:

```
CleanNotes/
│── Routers/           # Handles navigation
│── ViewModels/        # Business logic & state management
│── Views/             # UI components
│── Models/            # Data models
│── Services/          # External API and storage management
│── Resources/         # Assets and localized strings
```

## Dependencies

- **UIKit** – For building the user interface
- **LocalAuthentication** – For biometric authentication
- **Foundation** – Core iOS utilities
- **Combine (if used)** – Reactive programming

## Testing

To run the unit tests, open **Xcode**, select **CleanNotesTests**, and run the tests using:

```
Cmd + U
```

Tests cover core functionalities including authentication, note management, and UI interactions.

## Contribution

1. Fork the repository.
2. Create a new branch (`feature-branch-name`).
3. Commit your changes.
4. Push your branch and create a pull request.

## License

This project is licensed under the MIT License. Feel free to modify and distribute.

---

Developed with ❤️ by Rijo Samuel&#x20;

# CleanNotes
