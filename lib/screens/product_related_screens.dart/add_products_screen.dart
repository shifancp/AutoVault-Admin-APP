import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_vault_admin_app/screens/products_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});
  static String routeName = '/addScreen';
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  bool _isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _offerPriceController = TextEditingController();
  final TextEditingController _odoController = TextEditingController();
  final TextEditingController _modelYearController = TextEditingController();
  final List<XFile> _selectedImages = [];
  List<String> uploadedImageUrls = [];
  String? selectedFuelType;
  String? selectedCategory;
  String? selectedCondition;
  bool _isOffer = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void addProducts() async {
    setState(() {
      _isLoading = true;
    });
    await uploadFunction(_selectedImages);
    final data = {
      'docId': '',
      'productImg': uploadedImageUrls,
      'title': _titleController.text.trim(),
      'description': _descController.text.trim(),
      'category': selectedCategory,
      'onoffer': _isOffer,
      'price': _priceController.text.trim(),
      'offerprice': _offerPriceController.text.trim(),
      'odoreading': _odoController.text.trim(),
      'fueltype': selectedFuelType,
      'modelyear': _modelYearController.text.trim(),
      'condition': selectedCondition,
    };
    try {
      // Get the subcollection based on the selected category
      CollectionReference categoryCollection = _firestore
          .collection('products')
          .doc(selectedCategory)
          .collection('items');

      var docRef = await categoryCollection.add(data);
      String docId = docRef.id;

      // Update the document with the generated docId
      await docRef.update({'docId': docId});
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
    setState(() {
      _isLoading = false;
    });
    if (!context.mounted) return;
    Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: const Text('Add Product'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) {
                          return Image.file(File(_selectedImages[index].path));
                        }),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        _pickImage();
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Add Photos')),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                                label: Text('Enter Product Title'),
                                border: OutlineInputBorder()),
                          ),
                          TextFormField(
                            controller: _descController,
                            decoration: const InputDecoration(
                                label: Text('Enter Product Description'),
                                border: OutlineInputBorder()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: selectedCategory,
                                onChanged: (String? newCategory) {
                                  setState(() {
                                    selectedCategory = newCategory;
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
                                value: _isOffer,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    _isOffer = newValue!;
                                  });
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _priceController,
                            decoration: const InputDecoration(
                                label: Text('Enter Original Price'),
                                border: OutlineInputBorder()),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _offerPriceController,
                            enabled: _isOffer == true,
                            decoration: const InputDecoration(
                                label: Text('Enter offer Price'),
                                border: OutlineInputBorder()),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            controller: _odoController,
                            decoration: const InputDecoration(
                                label: Text('ODO Reading'),
                                border: OutlineInputBorder()),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            maxLength: 4,
                            controller: _modelYearController,
                            decoration: const InputDecoration(
                                label: Text('Model Year'),
                                border: OutlineInputBorder()),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              DropdownButton<String>(
                                value: selectedFuelType,
                                onChanged: (String? newFuelType) {
                                  setState(() {
                                    selectedFuelType = newFuelType;
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
                                value: selectedCondition,
                                onChanged: (String? newCondition) {
                                  setState(() {
                                    selectedCondition = newCondition;
                                  });
                                },
                                items: <String>[
                                  'Mint',
                                  'Good',
                                  'Average'
                                ].map<DropdownMenuItem<String>>((String value) {
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
                            child: button('Add Product+', Colors.pink, () {
                              addProducts();
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
        ),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(),
      ],
    );
  }

  Future<void> _pickImage() async {
    _selectedImages.clear();
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isNotEmpty) {
        _selectedImages.addAll(images);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: '$e');
    }
    setState(() {});
  }

  Future<void> uploadFunction(List<XFile> images) async {
    for (int i = 0; i < images.length; i++) {
      var imageUrl = await uploadImage(images[i]);
      uploadedImageUrls.add(imageUrl.toString());
    }
  }

  Future<String> uploadImage(XFile image) async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child('multiple_images')
        .child(image.name);
    UploadTask uploadTask = reference.putFile(File(image.path));
    await uploadTask.whenComplete(() {});
    String downloadURL = await reference.getDownloadURL();
    return downloadURL;
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
