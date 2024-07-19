import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Models/ProductsModel.dart';
import '../Provider/add_to_cart.dart';
import '../app_theme/app_theme.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<AddToCart>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(fontSize: size.height * 0.025),
        ),
        centerTitle: true,
      ),
      body: cartProvider.count == 0 // Check if the cart is empty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.remove_shopping_cart,
              size: size.height * 0.20,
              color: Colors.red,
            ),
            const Text(
              "Cart is empty",
              style: TextStyle(fontSize: 35),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = cartProvider.cartItems[index];
                  final product = cartItem['product'] as ProductsModel;
                  final quantity = cartItem['quantity'];

                  return Dismissible(
                    key: ValueKey(product.id), // Use a unique key for each item
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      cartProvider.removeFromCart(product, context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Item removed from cart"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.delete, color: Colors.white, size: size.height * 0.04),
                          const SizedBox(width: 10),
                          Text(
                            'Remove',
                            style: TextStyle(color: Colors.white, fontSize: size.height * 0.02),
                          ),
                        ],
                      ),
                    ),
                    child: Card(
                      color: Colors.white,
                      elevation: 3,
                      margin: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          // Network image with placeholder
                          Padding(
                            padding: EdgeInsets.only(bottom: size.height * 0.01, top: size.height * 0.01),
                            child: Image.network(
                              product.image!,
                              fit: BoxFit.contain,
                              height: size.height * 0.13,
                              width: size.width * 0.25,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) {
                                  return child;
                                } else {
                                  return const Center(child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding :EdgeInsets.only(left: size.width * 0.015),
                                  child: Text(
                                    product.title!,
                                    style: TextStyle(
                                        fontSize: size.height * 0.022,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: size.width * 0.01, top: size.height * 0.01),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Card(
                                        color: AppColors.buttonColor,
                                        elevation: 2,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              onPressed: () => cartProvider.decrement(product),
                                              icon: const Icon(Icons.remove,color: Colors.white,),
                                            ),
                                            Text('$quantity',style: TextStyle(color: Colors.white,fontSize: size.height * 0.022),),
                                            IconButton(
                                              onPressed: () => cartProvider.increment(product),
                                              icon: const Icon(Icons.add,color: Colors.white,),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:  EdgeInsets.only(right: size.width * 0.01),
                                        child: Text(
                                          '\$ ${(product.price! * quantity).toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: size.height * 0.028),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.02, left: size.width * 0.02, right: size.width * 0.02).copyWith(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: size.height * 0.03),
                      ),
                      InkWell(
                        onTap: () {
                          // Handle checkout functionality
                        },
                        child: Container(
                          height: size.height * 0.050,
                          width: size.width * 0.40,
                          decoration: BoxDecoration(
                            color: AppColors.buttonColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(right: size.width * 0.02),
                                child: const Icon(Icons.shopping_bag, color: Colors.white),
                              ),
                              Center(
                                child: Text(
                                  'Checkout',
                                  style: TextStyle(fontSize: size.height * 0.02, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
