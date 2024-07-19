
import 'package:flutter/material.dart';
import '../Models/ProductsModel.dart';

class AddToCart extends ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => _cartItems;

  void addToCart(ProductsModel product, BuildContext context) {
    final index = _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (index == -1) {
      _cartItems.add({'product': product, 'quantity': 1});
      // Show a success message when an item is added to the cart
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Item added to the cart successfully."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Show a message when the item is already in the cart
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
    final index = _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (index != -1) {
      _cartItems.removeAt(index);
      // Show a message when the item is removed from the cart
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
    final index = _cartItems.indexWhere((item) => item['product'].id == product.id);
    if (index != -1) {
      _cartItems[index]['quantity'] += 1;
    }
    notifyListeners();
  }

  void decrement(ProductsModel product) {
    final index = _cartItems.indexWhere((item) => item['product'].id == product.id);
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
}
