import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_admin_app/widgets/product_widget.dart';
import 'package:auto_vault_admin_app/screens/product_related_screens.dart/add_products_screen.dart';
import 'package:auto_vault_admin_app/screens/product_related_screens.dart/edit_product_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  static String routeName = '/products';
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddProductScreen.routeName);
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collectionGroup('items').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // or any loading widget
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text('No items found');
            }

            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot itemSnap = snapshot.data!.docs[index];
                Map<String, dynamic> itemData =
                    itemSnap.data() as Map<String, dynamic>;

                return ProductWidget(
                  title: itemData['title'],
                  subtitle: itemData['description'],
                  imgPath: itemData['productImg'][0],
                  trailing: const Icon(Icons.navigate_next),
                  ftn: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routeName,
                      arguments: {
                        'title': itemData['title'],
                        'description': itemData['description'],
                        'price': itemData['price'],
                        'offerprice': itemData['offerprice'],
                        'odoreading': itemData['odoreading'],
                        'modelyear': itemData['modelyear'],
                        'fueltype': itemData['fueltype'],
                        'category': itemData['category'],
                        'condition': itemData['condition'],
                        'onoffer': itemData['onoffer'],
                        'productImg': itemData['productImg'],
                        'docId': itemSnap.id,
                      },
                    );
                  },
                );
              },
            );
          },
        ));
  }
}
