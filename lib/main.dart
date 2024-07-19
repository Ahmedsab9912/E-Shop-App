import 'package:e_commerce_app/login_ui/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Provider/add_to_cart.dart';
import 'app_theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddToCart(),
      child: MaterialApp(
        theme: AppTheme.themeData,
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ) ,
    );
  }
}
