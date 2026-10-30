# UMS Flutter Mobile Development - Practical Assignment 01

A professional Flutter login form implementation featuring robust form validation, Yemeni phone number verification, a secure password toggle, and a countdown OTP timer built with clean state management and memory leak prevention.

---

## 🚀 Features & Requirements Implemented

1. **Academic ID / Email Validation**: 
   - Validates standard university emails or 10-digit academic IDs starting with `20`.
2. **Yemeni Phone Number Validation**: 
   - Ensures phone numbers strictly start with `77`, `73`, `71`, or `78` and consist of exactly 9 digits.
3. **Password & Confirm Password Security**: 
   - Secure password visibility toggles (`obscureText`) for both fields and a strict match validator.
4. **OTP Countdown Timer**: 
   - A 60-second interactive countdown timer managed via `Timer.periodic` with proper cancellation and resource disposal.
5. **Memory Leak Prevention**: 
   - Strict resource management using `dispose()` for all controllers and focus nodes.
6. **Async Safety**: 
   - Proper `mounted` checks to prevent UI crashes during asynchronous server simulation gaps.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: Flutter (Dart)
- **State Management**: Stateful Widget (`StatefulWidget`, `GlobalKey<FormState>`)
- **Navigation & Focus**: `FocusNode`, `TextInputAction`
- **Timer Management**: Dart `async` & `Timer.periodic`

---

## ⚙️ Getting Started & Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/mak8924/assignment_1_lab-login_assignment
   ```
2. **Navigate to project directory**:
   ```bash
   cd login_assignment
   ```
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the application**:
   ```bash
   flutter run
   ```