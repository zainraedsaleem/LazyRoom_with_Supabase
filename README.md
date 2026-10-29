# 🏠 LazyRoom

**LazyRoom** is a Flutter-based mobile marketplace built for students living in university dormitories. It connects **customers** (students), **suppliers** (in-dorm sellers), and an **admin** in a single app, letting students order everyday products without leaving their room, suppliers manage their own storefront, and admins oversee the whole ecosystem — including a built-in wallet/balance system for payments. The backend is powered by **Supabase**.

---

## 📖 Overview

Living in a university dorm often means limited access to nearby shops. **LazyRoom** solves this by turning the dorm itself into a marketplace: students browse products listed by in-dorm suppliers, add them to a cart, and place orders — all paid for through an in-app balance rather than cash. Suppliers accept or reject incoming orders, and the admin manages accounts, resolves balances, and keeps the platform running smoothly.

The app is built with a clean, role-based architecture, so each type of user gets a dedicated home screen and workflow tailored to their needs. All data, authentication, and business logic are handled by **Supabase** (PostgreSQL database + Auth), replacing the previous custom REST API backend.

---

## ✨ Key Features

### 🔐 Multi-Role Authentication
- Single login screen with automatic routing to the correct home screen based on the user's role: **Customer**, **Supplier**, or **Admin**.
- Authentication powered by **Supabase Auth**, with automatic session persistence so users stay logged in between app launches.
- Dedicated registration flow for new customers, capturing dorm-specific details such as **building** and **room number** for accurate order delivery.

### 🛍️ Customer Experience
- Browse all available products, filterable by category.
- Add items to a cart and review them before checkout.
- Confirm and place orders directly from an in-app wallet balance.
- Track order history and order status (pending, accepted, completed, cancelled).
- View and manage a personal profile.

### 📦 Supplier Tools
- A dedicated supplier dashboard to manage a personal product catalog: add, edit, and delete products (name, description, price, category, and stock).
- Manage incoming orders: **accept** or **reject** customer orders in real time.
- View a personal profile and account balance.

### 🛠️ Admin Control Panel
- Full visibility over all **customer** and **supplier** accounts.
- Create and delete user accounts.
- Ban and unban users to moderate the platform.
- **Deposit** funds into a customer's wallet or **withdraw** funds from a supplier's balance, keeping the in-app economy balanced.

### 💰 Wallet / Balance System
- Every account carries a live balance stored in the Supabase database, used to pay for and receive orders instead of handling cash on delivery.
- Balance can be refreshed on demand and is updated automatically as orders are placed, accepted, or settled by the admin.

### 🔒 Secure Backend with Supabase
- **PostgreSQL** database managing users, products, orders, and balances.
- **Supabase Auth** for secure sign-up, login, and session handling.
- **Row Level Security (RLS)** policies to ensure each role can only access the data it is allowed to.

### 🎨 Polished UI/UX
- Custom light and dark themes that automatically follow the system setting.
- Reusable, purpose-built widgets (product cards, dialogs, list views) for a consistent look across all three roles.

---

## 🧰 Tech Stack

| Layer                | Technology                                   |
|-----------------------|-----------------------------------------------|
| Framework              | [Flutter](https://flutter.dev)                |
| Language               | Dart                                           |
| State Management       | [Provider](https://pub.dev/packages/provider) |
| Backend & Database     | [Supabase](https://supabase.com) (PostgreSQL) |
| Authentication         | Supabase Auth                                  |
| Supabase Client        | [`supabase_flutter`](https://pub.dev/packages/supabase_flutter) |
| Local Persistence      | `shared_preferences` (session & balance cache)|
| Architecture           | Role-based MVC-style structure (Models, Views, Services, Providers, Controllers) |

---

## 👥 User Roles

| Role         | Capabilities                                                                 |
|--------------|-------------------------------------------------------------------------------|
| **Customer** | Register, browse products, manage cart, place orders, track order history     |
| **Supplier** | Manage product catalog, accept/reject orders, view balance                    |
| **Admin**    | Manage all accounts, ban/unban users, deposit/withdraw balances               |

---

## ⚙️ Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- A [Supabase](https://supabase.com) project

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/<your-username>/lazyroom.git
   cd lazyroom
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   Create a Supabase project, set up the database tables (users, products, orders, etc.) with their RLS policies, then add your project credentials when initializing Supabase in `main.dart`:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```
   > ⚠️ Never commit your `service_role` key. Only the public `anon` key should be used in the app.

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📸 Screenshots

### Onboarding & Authentication

<table>
  <tr>
    <td align="center"><img src="screenshots/splash_screen.png" width="220"/><br/><sub>Splash Screen</sub></td>
    <td align="center"><img src="screenshots/login_screen.png" width="220"/><br/><sub>Login</sub></td>
    <td align="center"><img src="screenshots/rigester_screen.png" width="220"/><br/><sub>Registration</sub></td>
  </tr>
</table>

### Customer Experience

<table>
  <tr>
    <td align="center"><img src="screenshots/browse_products_screen.png" width="220"/><br/><sub>Browse Products</sub></td>
    <td align="center"><img src="screenshots/cart_dialog.png" width="220"/><br/><sub>Cart</sub></td>
    <td align="center"><img src="screenshots/confirm_prushase_screen.png" width="220"/><br/><sub>Purchase Confirmation</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/customer_orders_screen.png" width="220"/><br/><sub>My Orders</sub></td>
    <td align="center"><img src="screenshots/profile_screen.png" width="220"/><br/><sub>Profile</sub></td>
    <td></td>
  </tr>
</table>

### Supplier Dashboard

<table>
  <tr>
    <td align="center"><img src="screenshots/add_product_screen.png" width="220"/><br/><sub>Add Product</sub></td>
    <td align="center"><img src="screenshots/supplier_orders_screen.png" width="220"/><br/><sub>Manage Orders</sub></td>
  </tr>
</table>

### Admin Panel

<table>
  <tr>
    <td align="center"><img src="screenshots/add_acount_screen.png" width="220"/><br/><sub>Create Account</sub></td>
    <td align="center"><img src="screenshots/customer_accounts_screen.png" width="220"/><br/><sub>Customer Accounts</sub></td>
    <td align="center"><img src="screenshots/supplier_accounts_screen.png" width="220"/><br/><sub>Supplier Accounts</sub></td>
  </tr>
</table>

> ⚠️ **Note:** Double-check that each screenshot `src` path exactly matches the real file name (including extension) in your `screenshots/` folder before pushing to GitHub.

---

## 📂 Project Structure

```
lib/
├── controllers/          # App-level controllers (e.g., auth controller)
├── models/               # Data models (User, Product, Order, Account, etc.)
├── providers/            # Provider-based state management
├── services/             # Supabase integration layer (auth, products, orders, admin, storage)
├── theme/                # Light/Dark app theming
├── views/
│   ├── admin_views/      # Admin-only screens (accounts, profile)
│   ├── customer_views/   # Customer-only screens (home, orders, profile)
│   └── supplier_views/   # Supplier-only screens (products, orders, profile)
├── widgets/
│   ├── dialogs/          # Reusable dialogs (cart, add/edit product, ban, deposit, etc.)
│   └── listes_view/      # Reusable list views for products, orders, and accounts
└── main.dart             # App entry point (Supabase initialization)
```

---

## 🤝 Contributing

Contributions, issue reports, and feature suggestions are welcome. Feel free to open an issue or submit a pull request.

---

## 📄 License

This project currently has no license specified. Add a `LICENSE` file if you'd like to open-source it under a specific license (e.g., MIT).

---

## 👤 Author

Developed by **Zain** — Independent Flutter Developer.
