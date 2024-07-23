import 'package:flutter/material.dart';
import '../Models/ProductsModel.dart';

class AddToCart extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];
  final Set<int> _likedProductIds = {}; // Use a set to store liked product IDs
  List<ProductsModel> _allProducts = []; // Use a private list for products

  List<Map<String, dynamic>> get cartItems => _cartItems;
  Set<int> get likedProductIds => _likedProductIds; // Public getter
  List<ProductsModel> get allProducts => _allProducts; // Public getter

  void setProducts(List<ProductsModel> products) {
    _allProducts = products;
    notifyListeners();
  }

  void addToCart(ProductsModel product, BuildContext context) {
    final index =
        _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (index == -1) {
      _cartItems.add({'product': product, 'quantity': 1});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item added to the cart successfully."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item is already in the cart."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
    notifyListeners();
  }

  void removeFromCart(ProductsModel product, BuildContext context) {
    final index =
        _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (index != -1) {
      _cartItems.removeAt(index);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item removed from the cart."),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void increment(ProductsModel product) {
    final index =
        _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
    }
    notifyListeners();
  }

  void decrement(ProductsModel product) {
    final index =
        _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (index != -1) {
      int currentQuantity = _cartItems[index]['quantity'];
      if (currentQuantity > 1) {
        _cartItems[index]['quantity'] = currentQuantity - 1;
        notifyListeners();
      }
    }
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _cartItems) {
      total += item['product'].price * item['quantity'];
    }
    return total;
  }

  int get count {
    return _cartItems.length;
  }

  bool isLiked(int productId) {
    return _likedProductIds.contains(productId);
  }

  void addProduct(int productId) {
    _likedProductIds.add(productId);
    notifyListeners();
  }

  void removeProduct(int productId) {
    _likedProductIds.remove(productId);
    notifyListeners();
  }
}
