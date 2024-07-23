import 'package:e_commerce_app/Add_To_Cart_Screen/add_to_cart_screen.dart';
import 'package:e_commerce_app/Models/ProductsModel.dart';
import 'package:e_commerce_app/Provider/add_to_cart.dart';
import 'package:e_commerce_app/app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductsModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final myprovider = Provider.of<AddToCart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: TextStyle(fontSize: size.height * 0.025),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: size.width * 0.02),
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_bag_outlined,
                      color: Colors.black, size: size.height * 0.035),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CartPage()));
                  },
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
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
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'product-image-${product.id}',
                child: Center(
                  child: Image.network(
                    product.image!,
                    fit: BoxFit.contain,
                    height: size.height * 0.34,
                    width: size.width * 0.8,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: size.height * 0.04,
                      ),
                      Text(
                          ' ${product.rating?.rate?.toStringAsFixed(1) ?? '0.0'}',
                          style: TextStyle(fontSize: size.height * 0.03)),
                      Padding(
                        padding: EdgeInsets.only(left: size.width * 0.02),
                        child: Card(
                          color: Colors.grey[300],
                          child: Padding(
                            padding: EdgeInsets.all(size.height * 0.004),
                            child: Text(
                                'Reviews: ${product.rating?.count?.toString() ?? '0'}',
                                style: TextStyle(fontSize: size.height * 0.02)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: size.width * 0.02),
                    child: Row(
                      children: [
                        Text('\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                            style: TextStyle(
                                fontSize: size.height * 0.03,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.title!,
                      style: TextStyle(
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.bold)),
                  // Add Liked Button
                  IconButton(
                    onPressed: () {
                      if (myprovider.isLiked(product.id!.toInt())) {
                        myprovider.removeProduct(product.id!.toInt());
                      } else {
                        myprovider.addProduct(product.id!.toInt());
                      }
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: myprovider.isLiked(product.id!.toInt())
                          ? Colors.red
                          : Colors.grey,
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                "Description:",
                style: TextStyle(color: Colors.grey[700]),
              ),
              SizedBox(height: size.height * 0.01),
              Text(product.description!,
                  style: TextStyle(fontSize: size.height * 0.018)),
              SizedBox(height: size.height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${product.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: TextStyle(
                          fontSize: size.height * 0.03,
                          fontWeight: FontWeight.bold)),
                  InkWell(
                    onTap: () {
                      myprovider.addToCart(product, context);
                    },
                    child: Container(
                      height: size.height * 0.055,
                      width: size.width * 0.50,
                      decoration: BoxDecoration(
                        color: AppColors.buttonColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: size.width * 0.02),
                            child: const Icon(Icons.shopping_bag,
                                color: Colors.white),
                          ),
                          Center(
                            child: Text(
                              'Add To Cart',
                              style: TextStyle(
                                  fontSize: size.height * 0.02,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
