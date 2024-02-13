import 'package:flutter/material.dart';
import 'package:auto_vault_admin_app/screens/call_list.dart';
import 'package:auto_vault_admin_app/screens/completed_calls.dart';
import 'package:auto_vault_admin_app/screens/completed_test_drives.dart';
import 'package:auto_vault_admin_app/screens/pending_td.dart';
import 'package:auto_vault_admin_app/screens/login_screen.dart';
import 'package:auto_vault_admin_app/screens/products_screen.dart';
import 'package:auto_vault_admin_app/widgets/category_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String routeName = '/home';
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': 'Products',
        'subtitle': 'Tap here to view products',
        'imgPath': 'assets/images/cars.png',
        'trailing': const Icon(Icons.navigate_next),
        'ftn': () {
          Navigator.of(context).pushNamed(ProductsScreen.routeName);
        }
      },
      {
        'title': 'Pending Test Drives',
        'subtitle': 'Tap here to Pending Test Drives',
        'imgPath': 'assets/images/td.png',
        'trailing': const Icon(Icons.navigate_next),
        'ftn': () {
          Navigator.of(context).pushNamed(PendingTestDrives.routeNmae);
        }
      },
      {
        'title': 'Call back Requests',
        'subtitle': 'Tap here to view Call Requests',
        'imgPath': 'assets/images/phone-2.png',
        'trailing': const Icon(Icons.navigate_next),
        'ftn': () {
          Navigator.of(context).pushNamed(CallList.routeName);
        }
      },
      {
        'title': 'Completed Test Drives',
        'subtitle': 'Tap here to view Completed Test Drives',
        'imgPath': 'assets/images/completedTD.png',
        'trailing': const Icon(Icons.navigate_next),
        'ftn': () {
          Navigator.of(context).pushNamed(CompletedTestDrives.routeNmae);
        }
      },
      {
        'title': 'Completed Calls',
        'subtitle': 'Tap here to completed calls',
        'imgPath': 'assets/images/phone-2.png',
        'trailing': const Icon(Icons.navigate_next),
        'ftn': () {
          Navigator.of(context).pushNamed(CompletedCalls.routeName);
        }
      },
    ];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
                onPressed: () async {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: ListView.builder(
            itemBuilder: ((context, index) {
              return CategoryWidget(
                  title: menuItems[index]['title'],
                  subtitle: menuItems[index]['subtitle'],
                  imgPath: menuItems[index]['imgPath'],
                  trailing: menuItems[index]['trailing'],
                  ftn: menuItems[index]['ftn']);
            }),
            itemCount: 5));
  }
}
