# SKTI Gundar

<a href="https://www.buymeacoffee.com/IlhamGhaza" target="_blank">
    <img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee">
</a></br>

SKTI Gundar is a Flutter application designed to implement and demonstrate various cryptographic algorithms and techniques. This project aims to educate users about different encryption methods by providing practical implementations within a mobile application.

## Table of Contents

- [SKTI Gundar](#skti-gundar)
  - [Table of Contents](#table-of-contents)
  - [Project Structure](#project-structure)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
  - [Usage](#usage)
  - [Contributing](#contributing)
  - [License](#license)
  - [Acknowledgements](#acknowledgements)
  - [Contact](#contact)

## Project Structure

The project is organized into several directories and files to maintain modularity and clarity:

```
lib/
├── config/
│   └── theme/
│       ├── bloc/
│       │   └── theme_cubit.dart
│       └── theme.dart
├── data/
│   ├── blocking_substitution.dart
│   ├── github_service.dart
│   ├── hill_cipher2.dart
│   ├── hill_cipher3.dart
│   ├── permutation_compaction.dart
│   ├── substitution_compaction.dart
│   └── substitution_permutation.dart
├── presentation/
│   ├── home_page.dart
│   ├── profile_page.dart
├── main_page.dart
└── main.dart    
```

- **lib/config/theme/**: Contains theme-related configurations, including the `theme_cubit.dart` for managing theme states and `theme.dart` for defining theme data.

- **lib/data/**: Houses the implementations of various cryptographic algorithms, each encapsulated in its respective Dart file, facilitating easy maintenance and scalability.

## Getting Started

### Prerequisites

Before running the application, ensure that the following tools are installed on your system:

- Flutter SDK (latest stable version)
- Dart SDK
- An integrated development environment (IDE) such as Android Studio or Visual Studio Code with Flutter extensions

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/IlhamGhaza/skti_gundar.git
   ```

2. **Navigate to the project directory**:

   ```bash
   cd skti_gundar
   ```

3. **Install dependencies**:

   ```bash
   flutter pub get
   ```

4. **Run the application**:

   ```bash
   flutter run
   ```

## Usage

Upon launching the application, users can navigate through different sections, each dedicated to a specific cryptographic algorithm. Interactive interfaces allow users to input data, apply encryption techniques, and observe the results, thereby enhancing their understanding of cryptographic processes.

## Contributing

Contributions to enhance the application's functionality or to introduce new cryptographic algorithms are welcome. To contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Implement your changes and ensure they are well-documented.
4. Submit a pull request with a detailed description of your modifications.

## License

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) <br>
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

- The Flutter team for providing an excellent framework that simplifies cross-platform development.
- Contributors to the open-source cryptography libraries utilized within this project.

## Contact

For further information or inquiries, please contact:

- **Name**: Ilham Ghaza
- **Email**: [email](mailto:cb7ezeur@selenakuyang.anonaddy.com).
Project Repository: [https://github.com/IlhamGhaza/skti_gundar](https://github.com/IlhamGhaza/skti_gundar)
