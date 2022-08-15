import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget {
  IconData? icon;

  String? imageIcon;
  String title;
  Color? iconColor;
  Function onPressed;
  HomeItem(
      {Key? key,
      this.imageIcon,
      this.iconColor = Colors.grey,
      this.icon,
      required this.title,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon == null
          ? Image.asset(
            imageIcon ?? "",
            width: 20,
            height: 20,
            fit: BoxFit.cover,
            color: iconColor ?? Colors.grey,
          )
          : Icon(
              icon,
              color: iconColor ?? Colors.grey,
            ),
      title: Text(title),
      trailing: IconButton(
        onPressed: () => onPressed(),
        splashRadius: 25,
        icon: const Icon(Icons.keyboard_arrow_right_outlined),
      ),
    );
  }
}
