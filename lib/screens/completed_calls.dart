import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedCalls extends StatelessWidget {
  const CompletedCalls({super.key});
  static const routeName = '/completedcalls';
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Back Requests'),
      ),
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('completedCall')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Some Error Occured'),
                  );
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
                      return ListTile(
                        leading: IconButton(
                            onPressed: () async {
                              _makePhoneCall(itemData['mobile']);
                            },
                            icon: const Icon(Icons.call)),
                        title: Text('Customer Name: ${itemData['name']}'),
                        subtitle:
                            Text('Customer Mobile: ${itemData['mobile']}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.done),
                          onPressed: () {},
                        ),
                      );
                    });
              })),
    );
  }
}
