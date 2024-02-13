import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:auto_vault_admin_app/main.dart';
import 'package:auto_vault_admin_app/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String routeName = '/login';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        if (!context.mounted) return;
        Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(SAVE_KEY, true);
        // Navigate to the next screen or perform other actions after successful login.
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
      // Handle errors here (e.g., display a message to the user).
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Icon(
              Icons.login,
              size: 100,
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                  label: Text('Enter Email ID'), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  label: Text('Enter Password'), border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            button('LogIn', Colors.pink, () {
              _signInWithEmailAndPassword();
            }),
          ],
        ),
      )),
    );
  }
}

Widget button(String text, Color color, Function ftn) {
  return SizedBox(
    // height: 50,
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Material(
          color: color,
          borderRadius: BorderRadius.circular(15),
          elevation: 10,
          child: InkWell(
              onTap: () {
                ftn();
              },
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 20),
                  ))),
        ),
      ),
    ),
  );
}
