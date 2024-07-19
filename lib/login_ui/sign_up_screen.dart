import 'package:flutter/material.dart';
import '../app_theme/app_theme.dart';
import 'auth.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController user_email = TextEditingController();
  TextEditingController user_pass = TextEditingController();
  FocusNode focusEmail = FocusNode();
  FocusNode focusPassword = FocusNode();
  bool _isObscure = true; // Initially obscure the password

  // Sign up logic
  final Auth _auth = Auth(); // Initialize your Auth class
  bool _isSigningUp = false; // Track sign-up state
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String passwordStrength = "";

  // Email validation logic
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    // Enhanced email validation regex
    String pattern = r'^[^@]+@[^@]+\.[^@]+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Password validation logic
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  void _updatePasswordStrength(String password) {
    if (password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password)) {
      setState(() {
        passwordStrength = "Strong";
      });
    } else if (password.length >= 8) {
      setState(() {
        passwordStrength = "Medium";
      });
    } else {
      setState(() {
        passwordStrength = "Weak";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey, // Associate scaffoldKey with Scaffold
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center, // Center text vertically
                    focusNode: focusEmail,
                    validator: _validateEmail,
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
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
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
                      keyboardType: TextInputType.visiblePassword,
                      textAlignVertical: TextAlignVertical.center, // Center text vertically
                      focusNode: focusPassword,
                      obscureText: _isObscure,
                      onChanged: (value) {
                        _updatePasswordStrength(value);
                      },
                      validator: _validatePassword,
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
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (passwordStrength.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Password Strength: $passwordStrength',
                    style: TextStyle(
                      color: passwordStrength == "Strong"
                          ? Colors.green
                          : passwordStrength == "Medium"
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ),
                ),
              InkWell(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isSigningUp = true;
                    });
                    try {
                      await _auth.createUserWithEmailAndPassword(
                        email: user_email.text.trim(),
                        password: user_pass.text.trim(),
                      );
                      _showSnackbar("Sign up successful", Colors.green);
                      // Navigate to another screen after successful sign-up
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => const LoginScreen(),
                        ),
                      );
                    } catch (e) {
                      // Handle error (e.g., show error message)
                      print("Failed to create user: $e");
                      _showSnackbar("Failed to create user. Please check Email/Password", Colors.red);
                    } finally {
                      setState(() {
                        _isSigningUp = false;
                      });
                    }
                  } else {
                    // Show validation errors in UI
                    _showSnackbar("Please fix errors in the form", Colors.red);
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
                    child: _isSigningUp
                        ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Center(
                      child: Text(
                        "Sign Up",
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
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 20),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20, left: 10),
                        child: Text(
                          "Log In",
                          style: TextStyle(color: AppColors.buttonColor, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
