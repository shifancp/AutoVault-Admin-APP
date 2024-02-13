import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_admin_app/firebase_options.dart';
import 'package:auto_vault_admin_app/screens/call_list.dart';
import 'package:auto_vault_admin_app/screens/completed_calls.dart';
import 'package:auto_vault_admin_app/screens/completed_test_drives.dart';
import 'package:auto_vault_admin_app/screens/login_screen.dart';
import 'package:auto_vault_admin_app/screens/pending_td.dart';
import 'package:auto_vault_admin_app/screens/product_related_screens.dart/add_products_screen.dart';
import 'package:auto_vault_admin_app/screens/home_screen.dart';
import 'package:auto_vault_admin_app/screens/product_related_screens.dart/edit_product_screen.dart';
import 'package:auto_vault_admin_app/screens/products_screen.dart';
import 'package:auto_vault_admin_app/screens/splash.dart';

// ignore: constant_identifier_names
const SAVE_KEY = 'isLoggedIn';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.pink),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        ProductsScreen.routeName: (context) => const ProductsScreen(),
        AddProductScreen.routeName: (context) => const AddProductScreen(),
        EditProductScreen.routeName: (context) => const EditProductScreen(),
        PendingTestDrives.routeNmae: (context) => const PendingTestDrives(),
        CompletedTestDrives.routeNmae: (context) => const CompletedTestDrives(),
        CallList.routeName: (context) => const CallList(),
        CompletedCalls.routeName: (context) => const CompletedCalls(),
      },
    );
  }
}
