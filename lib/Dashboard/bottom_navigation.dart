import 'package:e_commerce_app/Dashboard/user_page.dart';
import 'package:e_commerce_app/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'categories_page.dart';
import 'home_screen.dart';
import 'liked_page.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectedIndex = 0;

  // List of widgets for each tab
  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    LikedPage(),
    CategoriesPage(),
    UserPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Liked',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: const Color.fromARGB(255, 83, 83, 83),
        unselectedLabelStyle:
            const TextStyle(color: Color.fromARGB(255, 161, 161, 161)),
        selectedItemColor: AppColors.buttonColor,
        backgroundColor: const Color.fromARGB(255, 224, 224, 224),
        onTap: _onItemTapped,
      ),
    );
  }
}
