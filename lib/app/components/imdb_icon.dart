import 'package:flutter/material.dart';

class ImdbIcon extends StatelessWidget {
  String title;
  Color? color;
  ImdbIcon({
    super.key,
    required this.title,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color.fromARGB(184, 15, 15, 15),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 20,
          ),
          Text(
            title.length == 1 ? '$title.0' : title,
            style: TextStyle(
              // color: Colors.white,
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
