# Purga Mobile App (Flutter)

The **Purga Mobile App** is the mobile interface of the Purga project, built with Flutter. It provides a user-friendly experience for citizens and drivers to interact with the system. Users can manage their profiles, report garbages, view deposits, and more. Drivers can access optimized routes and mark deposits as cleaned.

---

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Screens](#screens)
  - [Login](#login)
  - [Register](#register)
  - [Deposits](#deposits)
  - [Routes](#routes)
  - [Profile](#profile)
  - [Report](#report)
  - [Awareness](#awareness)
- [Contribution](#contribution)
- [License](#license)

---

## Installation

To set up the project locally, follow these steps:

```bash
git clone https://github.com/PurgaDev/Flutter.git
cd Flutter
flutter pub get
flutter run
```

Ensure that you have Flutter installed. If not, follow the [Flutter installation guide](https://docs.flutter.dev/get-started/install) for your operating system.

---

## Usage

Once the application is running, users can log in or register to access features based on their roles:
- **Citizens** can report garbage dumps, view deposits, and access awareness content and profile.
- **Drivers** have additional access to optimized routes and deposit management.

---

## Features

### For All Users:
- **Register**: Create a new account by providing necessary details.
- **Login**: Authenticate to access the app features.
- **Logout**: Securely log out from the app.
- **Deposits**: View available deposits on a map for visual clarity.
- **Report Garbage Dumps**: Submit reports concerning a found garbage dump, giving as input a picture, an a description (The localisation is also recorded).
- **Profile Management**: View personal details.
- **Awareness Content**: Access information and tips on waste management and environmental protection.

### Additional Features for Drivers:
- **Routes**: View optimized routes for waste collection and cleaning.
- **Mark Deposit as Cleaned**: Update the status of a deposit after cleaning.

---

## Screens

### Login
- **Purpose**: Authenticate users.
- **Features**:
  - Secure login with phone number.
  - Error messages for invalid credentials.

### Register
- **Purpose**: Create a new user account.
- **Features**:
  - Input validation for required fields.

### Deposits
- **Purpose**: Display a list of reported deposits, shown on a map for a more intuitive and user-friendly experience.
- **Features**:
  - Available deposits with coordinates.
  - Citizens can view deposits only.

### Routes (Drivers Only)
- **Purpose**: Display optimized routes for drivers.
- **Features**:
  - Visualize routes using Google Maps for consistency with deposits.
  - Filter routes specific to the logged-in driver.

### Profile
- **Purpose**: View user information.
- **Features**:
  - Display user details (e.g. name, and contact info).

### Report
- **Purpose**: Allow users to report garbage dumps.
- **Features**:
  - Form to input details and fournish a picture.
  - Submit data to the backend for review by administrators.

### Awareness
- **Purpose**: Educate users on environmental and waste management topics.
- **Features**:
  - Display articles, tips, or messages.

---

## Contribution

Contributions are welcome! Follow these steps:
1. Fork the repository.
2. Create a branch for your feature: `git checkout -b feature/your-feature-name`.
3. Submit a Push Request after implementing your changes.

---

## License

This project is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for more details.

