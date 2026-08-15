import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:doc/home.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Signup extends StatefulWidget {
  const Signup({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  final Box settings = Hive.box("settings");

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isCreating = false;

  // Convert password into a SHA-256 hash before storing it.
  String hashPassword(String value) {
    return sha256.convert(utf8.encode(value)).toString();
  }

  Future<void> createAccount() async {
    final enteredPassword = password.text.trim();
    final enteredConfirmPassword = confirmPassword.text.trim();

    // Empty fields
    if (enteredPassword.isEmpty || enteredConfirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    // Minimum password length
    if (enteredPassword.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password must be at least 6 characters"),
        ),
      );
      return;
    }

    // Password confirmation
    if (enteredPassword != enteredConfirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Passwords do not match"),
        ),
      );
      return;
    }

    setState(() {
      isCreating = true;
    });

    try {
      final hashedPassword = hashPassword(enteredPassword);

      // Save only the hashed password.
      await settings.put("password", hashedPassword);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Account Created Successfully"),
        ),
      );

      // Clear password fields.
      password.clear();
      confirmPassword.clear();

      // First-time user goes directly to Home.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Home(
            isDark: widget.isDark,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to create account: $e"),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isCreating = false;
        });
      }
    }
  }

  @override
  void dispose() {
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF121212)
          : Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark
            ? const Color(0xFF121212)
            : Colors.white,
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                // Logo
                const Icon(
                  Icons.shield_outlined,
                  color: Colors.cyan,
                  size: 80,
                ),

                const SizedBox(height: 15),

                // Title
                Text(
                  "Welcome to DocVault",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  "Create your vault password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark
                        ? Colors.grey.shade400
                        : Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 40),

                // Password
                TextFormField(
                  controller: password,
                  obscureText: hidePassword,
                  enabled: !isCreating,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(
                      color: Colors.cyan,
                    ),
                    hintText: "Create Password",
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
                      onPressed: isCreating
                          ? null
                          : () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                      icon: Icon(
                        hidePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

                    filled: true,
                    fillColor: isDark
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm Password
                TextFormField(
                  controller: confirmPassword,
                  obscureText: hideConfirmPassword,
                  enabled: !isCreating,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : Colors.black,
                  ),
                  decoration: InputDecoration(
                    labelText: "Confirm Password",
                    labelStyle: const TextStyle(
                      color: Colors.cyan,
                    ),
                    hintText: "Re-enter Password",
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
                      onPressed: isCreating
                          ? null
                          : () {
                              setState(() {
                                hideConfirmPassword =
                                    !hideConfirmPassword;
                              });
                            },
                      icon: Icon(
                        hideConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),

                    filled: true,
                    fillColor: isDark
                        ? Colors.grey.shade900
                        : Colors.grey.shade100,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                      ),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Password information
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password must contain at least 6 characters.",
                    style: TextStyle(
                      color: isDark
                          ? Colors.grey.shade500
                          : Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Create Vault Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      disabledBackgroundColor:
                          Colors.cyan.withValues(alpha: 0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: isCreating
                        ? null
                        : createAccount,
                    child: isCreating
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Create Vault",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  "Your password is stored securely on this device.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDark
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}