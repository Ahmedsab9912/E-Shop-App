import 'package:e_commerce_app/Dashboard/bottom_navigation.dart';
import 'package:e_commerce_app/app_theme/app_theme.dart';
import 'package:e_commerce_app/login_ui/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController user_email = TextEditingController();
  TextEditingController user_pass = TextEditingController();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();

  bool _isObscure = true; // Initially obscure the password
  bool _isLoading = false; // Track loading state
  final Auth _auth = Auth();
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add GlobalKey for Scaffold

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey, // Associate scaffoldKey with Scaffold
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.only(top: size.height * 0.15),
                child: Image(
                  height: size.height * 0.25,
                  width: size.width * 0.4,
                  image: const AssetImage('assets/images/E-Shop.png'),
                ),
              ),
            ),
            Container(
              height: size.height * 0.07,
              width: size.width * 0.85,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey.shade200,
              ),
              child: Center(
                child: TextFormField(
                  controller: user_email,
                  focusNode: focusEmail,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(focusPassword);
                  },
                  keyboardType: TextInputType.text,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Email',
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black54,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white12),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Container(
                height: size.height * 0.07,
                width: size.width * 0.85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey.shade200,
                ),
                child: Center(
                  child: TextFormField(
                    controller: user_pass,
                    focusNode: focusPassword,
                    obscureText: _isObscure,
                    keyboardType: TextInputType.visiblePassword,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password',
                      prefixIcon: const Icon(
                        Icons.lock,
                        color: Colors.black54,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: _isLoading
                  ? null
                  : () async {
                      setState(() {
                        _isLoading = true; // Start loading
                      });
                      try {
                        await _auth.logInWithEmailAndPassword(
                          email: user_email.text.trim(),
                          password: user_pass.text.trim(),
                        );
                        _showSnackbar("Login successful",
                            Colors.green); // Show success message
                        // Navigate to Dashboard screen after successful sign-in
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const BottomNavigation(), // Replace with your Dashboard screen
                          ),
                        );
                      } catch (e) {
                        print("Failed to Log in: $e");
                        _showSnackbar("Wrong Email Password Please Check!",
                            Colors.red); // Show error message
                      } finally {
                        setState(() {
                          _isLoading = false; // Stop loading
                        });
                      }
                    },
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: size.height * 0.06,
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.buttonColor,
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    "Don't have an account?",
                    style: TextStyle(color: Colors.grey, fontSize: 20),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40, left: 10),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.yellow[700], fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for snackbar
  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
