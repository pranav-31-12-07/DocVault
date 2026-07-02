import 'package:doc/home.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final password = TextEditingController();
  final realPassword = "pranav@2007";

  bool isDark = false;
  bool hidePassword = true;

  @override
  void dispose() {
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF121212) : Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF121212) : Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDark = !isDark;
              });
            },
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.cyan,
            ),
          ),
        ],
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30),
            child: Transform.translate(
              offset: const Offset(0, -100),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
              
                  // Logo
                  const Icon(
                    Icons.shield_outlined,
                    color: Colors.cyan,
                    size: 80,
                  ),
              
                  const SizedBox(height: 15),
              
                  Text(
                    "DocVault",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
              
                  const SizedBox(height: 8),
              
                  Text(
                    "Your Personal Document Arsenal",
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
              
                  const SizedBox(height: 40),
              
                  // Password Field
                  TextFormField(
                    controller: password,
                    obscureText: hidePassword,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white
                          : Colors.black,
                    ),
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.cyan
                      ),
                      hintText: "Enter Password",
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.grey.shade400
                            : Colors.grey.shade600,
                      ),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.cyan,
                      ),
              
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                              color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
              
                      filled: true,
                      fillColor: isDark
                          ? Colors.grey.shade900
                          : Colors.grey.shade100,
              
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
              
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.cyan,
                        ),
                      ),
              
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.cyan,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              
                  const SizedBox(height: 25),
              
                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (password.text == realPassword) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Login Successful"),
                            ),
                          );
              
                          Navigator.pushReplacement(
                            context, 
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return Home(isDark: isDark,);
                              },
                            )
                            );
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Login Failed"),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              
                  const SizedBox(height: 35),
              
                  Text(
                    "Your documents stay secure on your device",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade500
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}