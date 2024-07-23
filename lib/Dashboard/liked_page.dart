import 'package:e_commerce_app/Provider/add_to_cart.dart';
import 'package:e_commerce_app/login_ui/auth.dart';
import 'package:e_commerce_app/login_ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikedPage extends StatelessWidget {
  const LikedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Liked Page',
          style: TextStyle(fontSize: size.height * 0.025),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  DrawerHeader(
                    child: Image.asset("assets/images/E-Shop.png"),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.black38),
            ListTile(
              title: const Row(
                children: [
                  Icon(Icons.logout, color: Colors.black),
                  SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                ],
              ),
              onTap: () async {
                try {
                  await Auth().signOut();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Signed out successfully'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const LoginScreen()),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to sign out: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: Consumer<AddToCart>(
        builder: (context, addToCart, child) {
          final likedProductIds = addToCart.likedProductIds;
          final allProducts = addToCart.allProducts;

          final likedProducts = allProducts
              .where((product) => likedProductIds.contains(product.id))
              .toList();

          return likedProducts.isEmpty
              ? Center(child: Text('No liked products'))
              : ListView.builder(
                  itemCount: likedProducts.length,
                  itemBuilder: (context, index) {
                    final product = likedProducts[index];
                    return ListTile(
                      leading: Image.network(product.image!),
                      title: Text(product.title!),
                      subtitle: Text(
                          '\$${product.price?.toStringAsFixed(2) ?? '0.00'}'),
                      onTap: () {
                        // Navigate to the product detail page
                      },
                    );
                  },
                );
        },
      ),
    );
  }
}
