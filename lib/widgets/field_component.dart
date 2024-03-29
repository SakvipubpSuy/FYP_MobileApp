import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final Color? color;
  final String hintText;
  final double height;

  const CustomField({
    super.key,
    required this.hintText,
    this.height = 40,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Center(
          child: SizedBox(
            height: height,
            child: TextFormField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: color),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
