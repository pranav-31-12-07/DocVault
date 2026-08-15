import 'package:doc/home.dart';
import 'package:doc/login.dart';
import 'package:doc/signup.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox("documents");
  await Hive.openBox("settings");

  final settings = Hive.box("settings");

  final hasPassword = settings.get("password") != null;

  runApp(
    DocVault(
      hasPassword: hasPassword,
    ),
  );
}

class DocVault extends StatelessWidget {
  const DocVault({
    super.key,
    required this.hasPassword,
  });

  final bool hasPassword;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "DocVault",

      home: hasPassword
          ? const Login()
          : const Signup(
              isDark: false,
            ),
    );
  }
}