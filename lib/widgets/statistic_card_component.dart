import 'package:flutter/material.dart';

enum FontSizeOption { small, medium, large }

class StatisticCard extends StatelessWidget {
  final Gradient gradient;
  final String title;
  final String value;
  final FontSizeOption fontSizeOption;

  const StatisticCard({
    super.key,
    required this.gradient,
    required this.title,
    required this.value,
    required this.fontSizeOption,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSizeOption == FontSizeOption.small
                    ? 16
                    : fontSizeOption == FontSizeOption.medium
                        ? 18
                        : 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSizeOption == FontSizeOption.small
                    ? 22
                    : fontSizeOption == FontSizeOption.medium
                        ? 24
                        : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
