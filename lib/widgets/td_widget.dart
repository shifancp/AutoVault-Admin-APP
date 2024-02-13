import 'package:flutter/material.dart';

class TestDriveCard extends StatefulWidget {
  const TestDriveCard(
      {super.key,
      required this.productImg,
      required this.productName,
      required this.productDesc,
      required this.userEmail,
      required this.userName,
      required this.userPhone,
      required this.ftn});
  final String productImg,
      productName,
      productDesc,
      userEmail,
      userName,
      userPhone;
  final Function ftn;
  @override
  State<TestDriveCard> createState() => _TestDriveCardState();
}

class _TestDriveCardState extends State<TestDriveCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                widget.productImg,
                height: 80,
                fit: BoxFit.fill,
              )),
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.productName,
                ),
                Text(
                  widget.productDesc,
                ),
                Text(
                  'Customer Name: ${widget.userName}',
                ),
                Text(
                  'Customer Email: ${widget.userEmail}',
                ),
                Text(
                  'Customer Phone: ${widget.userPhone}',
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () async {
                widget.ftn();
              },
              icon: const Icon(Icons.done))
        ],
      ),
    );
  }
}
