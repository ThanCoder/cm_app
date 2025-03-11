import 'package:flutter/material.dart';

class ImdbIcon extends StatelessWidget {
  String title;
  ImdbIcon({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return SizedBox.shrink();
    }
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 20,
        ),
        Text(
          title.length == 1 ? '$title.0' : title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
