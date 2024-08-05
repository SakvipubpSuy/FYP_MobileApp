import 'package:flutter/material.dart';

enum FontSizeOption {
  small,
  medium,
}

class StatisticCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final FontSizeOption fontSizeOption; // Accept enum value

  const StatisticCard({
    Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.fontSizeOption, // Accept enum value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Map enum to font size
    double fontSize;
    switch (fontSizeOption) {
      case FontSizeOption.small:
        fontSize = 16.0;
        break;
      case FontSizeOption.medium:
        fontSize = 20.0;
        break;
    }

    final TextStyle textStyle =
        TextStyle(fontSize: fontSize, color: Colors.white);

    return Expanded(
      flex: 1,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textStyle),
              const SizedBox(height: 10),
              Text(value, style: textStyle),
            ],
          ),
        ),
      ),
    );
  }
}
