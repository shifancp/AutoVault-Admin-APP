import 'package:flutter/material.dart';

class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.imgPath,
      required this.trailing,
      required this.ftn});
  final String title, subtitle, imgPath;
  final Icon trailing;
  final Function ftn;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ftn();
      },
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Image.asset(
          imgPath,
        ),
        trailing: trailing,
      ),
    );
  }
}
