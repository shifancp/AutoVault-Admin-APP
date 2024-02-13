import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_vault_admin_app/widgets/td_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CompletedTestDrives extends StatelessWidget {
  const CompletedTestDrives({super.key});
  static const routeNmae = '/completedtd';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Completed Test Drives'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collectionGroup('completedtestdrives')
              .snapshots(),
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
                return TestDriveCard(
                  productImg: itemData['productImg'],
                  productName: itemData['productName'],
                  productDesc: itemData['productDesc'],
                  userEmail: itemData['userEmail'],
                  userName: itemData['userName'],
                  userPhone: itemData['userPhone'],
                  ftn: () {},
                );
              },
            );
          },
        ));
  }

  Future<void> moveItemToCompletedTestDrives(
      DocumentReference testDriveReference) async {
    try {
      // Get the data from the 'testdrives' document
      DocumentSnapshot testDriveSnapshot = await testDriveReference.get();
      Map<String, dynamic> testDriveData =
          testDriveSnapshot.data() as Map<String, dynamic>;

      // ignore: unnecessary_null_comparison
      if (testDriveData != null) {
        // Get the UID of the user who created the test drive
        String? userUid = testDriveData['userUid'];

        if (userUid != null) {
          // Create a new document in 'completedtestdrives' collection inside 'users'
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userUid)
              .collection('completedtestdrives')
              .add(testDriveData);

          // Delete the document from the 'testdrives' collection
          await testDriveReference.delete();
        } else {}
      } else {}
    } catch (error) {
      Fluttertoast.showToast(msg: '$error');
    }
  }
}
