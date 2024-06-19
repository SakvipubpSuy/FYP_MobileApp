import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../models/card.dart';

class IndividualCardPage extends StatefulWidget {
  final CardModel individualcard;
  const IndividualCardPage({super.key, required this.individualcard});

  @override
  State<IndividualCardPage> createState() => _IndividualCardPageState();
}

class _IndividualCardPageState extends State<IndividualCardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Individual Card Page'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Text(
              widget.individualcard.cardName,
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
