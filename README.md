# E-Commerce App (E-Shop) 

## Overview

The **E-Commerce App** is a fully-featured Flutter application designed to deliver a seamless
online shopping experience. With an intuitive interface and robust functionality, users can browse
products, manage their shopping cart, and complete purchases effortlessly. This project demonstrates
best practices in Flutter development and state management.

## Key Features
- **Firebase Authentication:** Added Log In and Sign Up through Firebase Auth . 
- **Product Browsing:** Easily browse a diverse range of products, complete with detailed descriptions, images, and prices.
- **Product Details:** View comprehensive details for each product, including ratings, review counts, and pricing information.
- **Shopping Cart:** Add items to your cart, adjust quantities with + and - buttons, and remove items as needed.
- **Real-Time Updates:** Instant feedback with Snack bar notifications for actions like adding or removing items from the cart.
- **Responsive Design:** Optimized for various devices, ensuring a smooth experience across different screen sizes.
- **Checkout Functionality:** Proceed to checkout with a summary of your cart's total cost, ready for purchase.

## Getting Started

Follow these steps to get started with the E-Commerce App:

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/yourusername/e_commerce_app.git

2. **Navigate to the Project Directory:**
   ```bash
    cd e_commerce_app
   
3. **Navigate to the Project Directory:**
   ```bash
    flutter pub get
4. **Run the Application:**
  `bash 
    flutter run


## Project Structure

- **lib/
 * main.dart: The entry point of the application.
 * models/: Contains data models like ProductsModel for representing product data.
 * provider/: Includes state management solutions such as AddToCart for handling cart operations.
 * screens/: Contains various screens such as the product listings and cart page.
 * widgets/: Custom widgets used throughout the application for a modular design.

## Dependencies

* flutter: The core framework for building the application.
* provider: For state management and handling cart operations.
* http: For making network requests to fetch product data.

