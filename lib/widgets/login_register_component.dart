import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;
  final Color color;
  final Color? textColor;

  const CustomCard({
    super.key,
    required this.buttonText,
    required this.onTap,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Center(
              child: Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
