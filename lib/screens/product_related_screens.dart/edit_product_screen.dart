import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_vault_admin_app/screens/products_screen.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});
  static String routeName = '/editScreen';
  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
//function to get imageUrlsfrom database
  Future<List<String>> getImageUrls() async {
    List<String> urls = [];
    try {
      ListResult result = await FirebaseStorage.instance.ref().listAll();

      for (var item in result.items) {
        String url = await item.getDownloadURL();
        urls.add(url);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final titleController = TextEditingController(text: args['title']);
    final descController = TextEditingController(text: args['description']);
    final priceController = TextEditingController(text: args['price']);
    final offerPriceController =
        TextEditingController(text: args['offerprice']);
    final odoController = TextEditingController(text: args['odoreading']);
    final modelYearController = TextEditingController(text: args['modelyear']);
    final docId = args['docId'];
    final CollectionReference products = FirebaseFirestore.instance
        .collection('products')
        .doc(args['category'])
        .collection('items');
    List<String> uploadedImageUrls = (args['productImg'] as List<dynamic>)
        .map((imageUrl) => imageUrl.toString())
        .toList();
    Future<String> uploadImage(File imageFile) async {
      try {
        TaskSnapshot task = await FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg')
            .putFile(imageFile);

        String imageUrl = await task.ref.getDownloadURL();
        return imageUrl;
      } catch (e) {
        return '';
      }
    }

    Future<List<XFile>?> pickMultipleImages() async {
      final ImagePicker picker = ImagePicker();

      try {
        List<XFile>? images = await picker.pickMultiImage();
        return images;
      } catch (e) {
        return null;
      }
    }

    Future<void> addMorePhotos() async {
      List<XFile>? images = await pickMultipleImages();

      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          try {
            // Upload the image to Firebase Storage
            String imageUrl = await uploadImage(File(image.path));

            // Update the uploadedImageUrls list
            setState(() {
              uploadedImageUrls.add(imageUrl);
            });

            // Update the Firestore document with the new image URL
            await products.doc(docId).update({
              'productImg': FieldValue.arrayUnion([imageUrl]),
            });
          } catch (e) {
            Fluttertoast.showToast(msg: '$e');
          }
        }
        setState(() {});
      }
    }

//function to delete photos fromdbstorage
    Future<void> deleteImage(int index, String docId) async {
      try {
        String url =
            uploadedImageUrls[index]; // Get the URL at the specified index
        await FirebaseStorage.instance.refFromURL(url).delete();

        // Remove the image URL from Firestore
        await products.doc(docId).update({
          'productImg': FieldValue.arrayRemove([url]),
        });
      } catch (e) {
        Fluttertoast.showToast(msg: '$e');
      }
    }

//function to delete docs from db
    Future<void> deleteProduct(String docId, List<String> imageUrls) async {
      try {
        // Delete the product document
        await products.doc(docId).delete();

        // Delete the associated images from Firebase Storage
        for (var url in imageUrls) {
          await FirebaseStorage.instance.refFromURL(url).delete();
        }
      } catch (e) {
        Fluttertoast.showToast(msg: '$e');
      }
    }

//function to update
    Future<void> updateProduct(
      String docId,
      String title,
      String description,
      String price,
      String offerPrice,
      String odoReading,
      String modelYear,
      String category,
      bool onOffer,
      String fuelType,
      String condition,
    ) async {
      try {
        await products.doc(docId).update({
          'title': title,
          'description': description,
          'price': price,
          'offerprice': offerPrice,
          'odoreading': odoReading,
          'modelyear': modelYear,
          'category': category,
          'onoffer': onOffer,
          'fueltype': fuelType,
          'condition': condition,
        });
      } catch (e) {
        Fluttertoast.showToast(msg: '$e');
      }
    }

//widget to show the uploaded images from firebase
    Widget buildImageWidgets(List<String> urls) {
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Adjust the number of columns as needed
        ),
        itemCount: urls.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Image.network(
                urls[index],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      deleteImage(index, docId);
                    }),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: buildImageWidgets(
                uploadedImageUrls,
              )),
              button('Delete Product-', Colors.red, () async {
                // await deleteImage(index, docId);
                await deleteProduct(docId, uploadedImageUrls);
                if (!context.mounted) return;
                Navigator.of(context)
                    .pushReplacementNamed(ProductsScreen.routeName);
              }),
              ElevatedButton.icon(
                  onPressed: () async {
                    addMorePhotos();
                  },
                  icon: const Icon(Icons.add_a_photo),
                  label: const Text('Add More Photos')),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            label: Text('Enter Product Title'),
                            border: OutlineInputBorder()),
                      ),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(
                            label: Text('Enter Product Description'),
                            border: OutlineInputBorder()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<String>(
                            value: args['category'],
                            onChanged: (String? newCategory) {
                              setState(() {
                                args['category'] = newCategory;
                              });
                            },
                            items: <String>[
                              'Hatchback',
                              'Sedan',
                              'SUV',
                              'Crossover',
                              'Coupe',
                              'Convertible',
                              'Sports',
                              'Exotics',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: const Text('Select Category'),
                          ),
                          // SizedBox(
                          //   width: 80,
                          // ),
                          const Text('On Offer?'),
                          Checkbox(
                            value: args['onoffer'],
                            onChanged: (bool? newValue) {
                              setState(() {
                                args['onoffer'] = newValue!;
                              });
                            },
                          ),
                        ],
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: priceController,
                        decoration: const InputDecoration(
                            label: Text('Enter Original Price'),
                            border: OutlineInputBorder()),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: offerPriceController,
                        enabled: args['onoffer'] == true,
                        decoration: const InputDecoration(
                            label: Text('Enter offer Price'),
                            border: OutlineInputBorder()),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: odoController,
                        decoration: const InputDecoration(
                            label: Text('ODO Reading'),
                            border: OutlineInputBorder()),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        controller: modelYearController,
                        decoration: const InputDecoration(
                            label: Text('Model Year'),
                            border: OutlineInputBorder()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<String>(
                            value: args['fueltype'],
                            onChanged: (String? newFuelType) {
                              setState(() {
                                args['fueltype'] = newFuelType;
                              });
                            },
                            items: <String>[
                              'Petrol',
                              'Diesel',
                              'CNG',
                              'Electric'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: const Text('Select Fuel Type'),
                          ),
                          DropdownButton<String>(
                            value: args['condition'],
                            onChanged: (String? newCondition) {
                              setState(() {
                                args['condition'] = newCondition;
                              });
                            },
                            items: <String>['Mint', 'Good', 'Average']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            hint: const Text('Select Condition'),
                          ),
                        ],
                      ),
                      Container(
                        child: button('Update Product+', Colors.pink, () {
                          updateProduct(
                              docId,
                              titleController.text,
                              descController.text,
                              priceController.text,
                              offerPriceController.text,
                              odoController.text,
                              modelYearController.text,
                              args['category'],
                              args['onoffer'],
                              args['fueltype'],
                              args['condition']);
                          Navigator.of(context).pop();
                        }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget button(String text, Color color, Function ftn) {
  return SizedBox(
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
                  padding: const EdgeInsets.all(10.0), child: Text(text))),
        ),
      ),
    ),
  );
}
