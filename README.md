# CT312H: MOBILE PROGRAMMING

## Project Name: Cosmetic Mini-Supermarket Application

Semester 2, Academic year: 2024-2025

**Contributor 1**:  Nguyễn Thị Hoài Thương *(Responsible for User Role functionalities)*

**Contributor 2**: Ngô Thụy Thanh Tâm *(Responsible for Administrator Role functionalities)*

**Class Number**: M01

## 🧾 Overview

The **Cosmetic Supermarket Application** is a cross-platform mobile app developed to streamline operations for a cosmetics supermarket. It supports two key user roles:

### 👤 User Role (Customer)
- 🛍️ **Product Discovery**: Browse and search a wide range of cosmetics, including featured and categorized items.
- 🧺 **Cart Management**: Add, edit, or remove products in the cart with quantity and size selection.
- 📦 **Order Placement**: Place orders from the cart, with total calculation and automatic order creation.
- 🚚 **Real-Time Tracking**: Monitor order progress through various statuses: Confirmed, Completed, or Canceled.
- 👤 **Account Handling**: Register, sign in, and manage personal user profile securely.

### 🛠️ Admin Role (Administrator)
- 📦 **Inventory Control**: Create, update, and remove product listings; manage stock and upload product images.
- 📊 **Order Processing**: View, update, and manage all orders in the system, including changing status and viewing customer details.
- 👥 **User Management**: Monitor users, handle issues, and maintain the integrity of the platform.

## 💡 Features

- Real-time product listings and updates
- Cart and order management system using **SQLite**
- Secure authentication and user management via **PocketBase**
- Order status tracking (Confirmed, Completed, Canceled)
- Admin dashboard for managing inventory and orders

## 📦 Data Structure (Detailed)

### 🗄️ PocketBase Collections

**users**  
- `id`: unique user ID  
- `email`: user email  
- `emailVisibility`: show/hide email  
- `username`: unique username  
- `password`: encrypted password  
- `tokenKey`: used for API authentication  
- `name`: full name or display name  
- `avatar`: profile image  
- `verified`: email verification status  

**products**  
- `id`: product ID  
- `title`: product name  
- `description`: product details  
- `price`: price per item  
- `featuredImage`: main product image  
- `isFavorite`: whether the product is marked as favorite  
- `userId`: ID of the admin who created it  

**orders**  
- `id`: order ID  
- `amount`: total order amount  
- `products`: list of product objects (with quantity)  
- `dateTime`: order timestamp  
- `userId`: ID of the user who placed the order  
- `status`: current status (confirmed, completed, canceled)  

---

### 🗃️ SQLite Local Cart (Offline)

**carts**  
- `id`: local cart item ID  
- `productId`: ID of the product (linked to PocketBase)  
- `title`: product title  
- `price`: price per item  
- `quantity`: quantity selected by user   
- `status`: current state (in_cart)  
- `imageUrl`: local or remote product image  
- `userId`: owner of the cart item  

## ✅ How to Run

```bash
# Clone the repository
git clone https://github.com/AlbusRosie/Cosmetic-Supermarket

# Navigate into the project folder
cd Cosmetic-Supermarket

# Get Flutter dependencies
flutter pub get

# Run the app on emulator or connected device
flutter run
