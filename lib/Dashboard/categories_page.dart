import 'package:e_commerce_app/login_ui/auth.dart';
import 'package:e_commerce_app/login_ui/login_screen.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final Auth _auth = Auth(); // Your authentication service

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
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
    );
  }
}
