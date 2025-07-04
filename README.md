# 🛍️ Shoppy

Shoppy is a Flutter-based e-commerce app that uses Firebase for authentication and Firestore to manage user data like cart, favorites, and orders. It follows clean architecture and uses Cubit for state management.

---

## 📦 Features

- 🔐 User Authentication (Firebase Auth)
- 🛒 Cart Management (with quantity)
- ❤️ Favorites List
- 📦 Order Placement (stored per user in Firestore)
- 🌙 Theme Switching (with Shared Preferences)
- 🧭 Bottom Navigation with 4 screens: Home, Favorites, Cart, Profile
- 📡 Products loaded from an external API

---

## Screenshots

Here’s a glimpse of the Shoppy experience:

<img width="175" alt="1.png" src="screenshots%2F1.png"/><img width="175" alt="2.png" src="screenshots%2F2.png"/><img width="175" alt="3.png" src="screenshots%2F3.png"/><img width="175" alt="4.png" src="screenshots%2F4.png"/><img width="175" alt="5.png" src="screenshots%2F5.png"/><img width="175" alt="6.png" src="screenshots%2F6.png"/>
<img width="175" alt="1.png" src="screenshots%2F7.png"/><img width="175" alt="2.png" src="screenshots%2F8.png"/><img width="175" alt="3.png" src="screenshots%2F9.png"/><img width="175" alt="4.png" src="screenshots%2F10.png"/><img width="175" alt="5.png" src="screenshots%2F11.png"/><img width="175" alt="6.png" src="screenshots%2F12.png"/>


---

## 🧱 Project Structure

```
lib/
├── models/
├── services/
├── theme/
├── view/
│   ├── screens/
│   └── widgets/
├── view_model/
│   └── cubits/
└── main.dart
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK
- Firebase project with Authentication and Firestore enabled

### Setup Instructions

1. Clone the repo:

```bash
git clone https://github.com/KerlosGirgis/Shoppy.git
cd Shoppy
flutter pub get
```

2. Set up Firebase:
   - Add `google-services.json` to `android/app/`
   - Enable Email/Password sign-in in Firebase Authentication
   - Enable Firestore

3. Run the app:

```bash
flutter run
```

---

## 📌 Firestore Structure

Each user document (`users/{uid}`) includes:

- `cart`: List of items with `id` and `quantity`
- `favourites`: List of product IDs
- `orders`: List of order maps with items and timestamp

---

## 🧪 State Management

The app uses `flutter_bloc` and Cubit classes for managing:

- Product list
- Cart
- Favorites
- Theme switching
- Orders

---

## 📄 License

This project is licensed under the MIT License.

---

## 👤 Author

**Kerlos Girgis**  
[GitHub Profile](https://github.com/KerlosGirgis)
