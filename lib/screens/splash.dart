import 'package:flutter/material.dart';
import 'package:auto_vault_admin_app/main.dart';
import 'package:auto_vault_admin_app/screens/home_screen.dart';
import 'package:auto_vault_admin_app/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset('assets/images/splash.gif')),
    );
  }

  Future<void> navigate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(SAVE_KEY);
    await Future.delayed(
        const Duration(seconds: 4)); // Show splash screen for 2 seconds
    if (isLoggedIn == null || isLoggedIn == false) {
      if (!context.mounted) return;
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    } else {
      if (!context.mounted) return;
      await Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    }
  }
}
