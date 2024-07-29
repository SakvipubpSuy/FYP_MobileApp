import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final Color color;
  final String title;
  final String value;

  const StatisticCard({
    super.key,
    required this.color,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle20 = TextStyle(
      color: Colors.white,
      fontSize: 20,
    );
    const textStyle16 = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );
    return Expanded(
      flex: 1,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textStyle20,
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: textStyle16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
