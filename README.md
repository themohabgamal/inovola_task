# Inovola Expense Tracker
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/themohabgamal/inovola_task)

This repository contains a comprehensive expense tracking application built with Flutter. The app features a clean, modern interface for users to monitor their finances, add new expenses with multi-currency support, and view an interactive dashboard. It is architected following Clean Architecture principles for robustness and scalability.

## ✨ Features

- **Dynamic Dashboard**: Get an at-a-glance view of your total balance, income, and total expenses.
- **Expense Management**: Seamlessly add new expenses with a title, amount, category, date, and an optional receipt image.
- **Multi-Currency Support**: Log expenses in various international currencies. The app fetches real-time exchange rates from `exchangerate-api.com` and displays the converted value in USD for clarity.
- **Interactive Expense List**: View your transaction history with infinite scrolling. Swipe to delete an expense, with a convenient "Undo" option.
- **Advanced Data Filtering**: Filter your expense view by various time periods, including "This Month", "Last 7 Days", "This Quarter", and "This Year".
- **Offline First**: All data is persisted locally using Hive, ensuring the app is fully functional without an internet connection.
- **Engaging UI/UX**: Built with a responsive design, smooth animations using `flutter_animate`, and shimmer loading effects for an enhanced user experience.

## 🛠️ Architecture & Tech Stack

The application is built with a modern, scalable tech stack, emphasizing a separation of concerns and testability.

- **Architecture**: **Clean Architecture** (Data, Domain, Presentation layers)
- **State Management**: **BLoC (Business Logic Component)** for predictable and manageable state.
- **Local Storage**: **Hive** for fast, lightweight, and efficient local database operations.
- **Networking**: **Dio** for handling API requests to the currency conversion service.
- **Dependency Injection**: **GetIt** service locator for decoupling dependencies.
- **Responsive UI**: **Flutter ScreenUtil** to ensure the UI adapts gracefully to different screen sizes.
- **Animations**: **Flutter Animate** for creating fluid and engaging animations.
## 📱 App Visualization
<p align="center">
  <img src="https://github.com/user-attachments/assets/0e9d4690-69e7-48cf-93aa-f9b6159a558d" width="200" />
  <img src="https://github.com/user-attachments/assets/63e08ce8-40ab-4ccd-b4e7-733ba840c23e" width="200" />
  <img src="https://github.com/user-attachments/assets/984b479c-ce90-4cd3-9023-c156a47ea486" width="200" />
      <img src="https://github.com/user-attachments/assets/8e9cd489-3d54-41e4-87fa-e90fd8f417b9" width="200" />
  <img src="https://github.com/user-attachments/assets/cfd208eb-58c7-4bc4-aceb-0a2aa7f18e58" width="200" />
     <img src="https://github.com/user-attachments/assets/49ff9479-a423-43a8-8c57-da79b99b154a" width="200" />
    <img src="https://github.com/user-attachments/assets/5c1e0c1a-0757-406c-8598-ec6a33c31d7f" width="200" />

</p>
## 📱 App Demo  

🎥 **Watch the demo here:**  
[▶️ App Demo Video](https://drive.google.com/file/d/18zqWIZK-8gINazfUPLlzVqZLF9RuRBe4/view?usp=sharing)

---
## 🚀 Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (Version >= 3.27.0)
- An editor like VS Code or Android Studio with the Flutter plugin.

### Installation & Running

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/themohabgamal/inovola_task.git
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd inovola_task
    ```
3.  **Install the dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the application:**
    ```sh
    flutter run
    ```

## 🧪 Testing

The project includes a suite of unit tests covering core business logic, including expense validation, currency calculations, and pagination logic.

To run the tests, execute the following command in your terminal:
```sh
flutter test
