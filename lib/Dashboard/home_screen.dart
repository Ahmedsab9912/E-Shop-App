import 'dart:convert';
import 'package:e_commerce_app/Dashboard/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../APIs/api.dart';
import '../Add_To_Cart_Screen/add_to_cart_screen.dart';
import '../Models/ProductsModel.dart';
import '../Provider/add_to_cart.dart';
import '../login_ui/auth.dart';
import '../login_ui/login_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Auth _auth = Auth(); // Your authentication service

  // Fetch products from API
  late Future<List<ProductsModel>> futureProducts;
  List<ProductsModel> allProducts = [];
  List<ProductsModel> filteredProducts = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    final filtered = allProducts.where((product) {
      final titleLower = product.title!.toLowerCase();
      final queryLower = query.toLowerCase();
      return titleLower.contains(queryLower);
    }).toList();

    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: size.height * 0.01),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
              ),
              height: size.height * 0.07,
              width: size.width * 0.19,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Colors.yellow[700],
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartPage()));
                  },
                  shape: const CircleBorder(),
                  child: const Icon(Icons.shopping_bag_outlined,
                      color: Colors.white),
                ),
              ),
            ),
            Positioned(
              right: size.width * 0.04,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: BoxConstraints(
                  minWidth: size.width * 0.048,
                  minHeight: size.height * 0.026,
                ),
                child: Center(
                  child: Consumer<AddToCart>(
                    builder: (context, cart, child) {
                      return Text(
                        '${cart.count}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Discover Products',
          style: TextStyle(fontSize: size.height * 0.03),
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
                  await _auth.signOut();
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
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.055,
            width: size.width * 0.8,
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _filterProducts,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ProductsModel>>(
              future: futureProducts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products available'));
                } else {
                  if (allProducts.isEmpty) {
                    allProducts = snapshot.data!;
                    filteredProducts = allProducts;
                  }
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(10),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              if (index.isOdd)
                                return const SizedBox(
                                    height: 10); // Add spacing between rows
                              final int itemIndex = index ~/ 2;
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: buildProductItem(context,
                                          filteredProducts[itemIndex * 2])),
                                  const SizedBox(width: 10),
                                  if (itemIndex * 2 + 1 <
                                      filteredProducts.length)
                                    Expanded(
                                        child: buildProductItem(
                                            context,
                                            filteredProducts[
                                                itemIndex * 2 + 1])),
                                ],
                              );
                            },
                            childCount: (filteredProducts.length * 2 + 1) ~/ 2,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

// Fetch products from API
  Future<List<ProductsModel>> fetchProducts() async {
    final response = await http.get(Uri.parse(products));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ProductsModel.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

// Build product item
  Widget buildProductItem(BuildContext context, ProductsModel product) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            //Passing Constructor parameters to show product details
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product-image-${product.id}',
              child: Image.network(
                product.image!,
                fit: BoxFit.contain,
                height: size.height * 0.20,
                width: size.width * 0.45,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Text(
                  _truncateText(product.title!, 3),
                  style: TextStyle(
                      fontSize: size.height * 0.015,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.01),
              child: Center(
                  child: Text('\$${product.price}',
                      style: TextStyle(
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }

// Truncate text
  String _truncateText(String text, int wordLimit) {
    List<String> words = text.split(' ');
    if (words.length <= wordLimit) {
      return text;
    }
    return '${words.sublist(0, wordLimit).join(' ')}...';
  }
}
