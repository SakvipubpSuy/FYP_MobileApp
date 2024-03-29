import 'package:flutter/material.dart';

import '../../models/card.dart';

class IndividualCardPage extends StatefulWidget {
  final CardModel individualcard;
  IndividualCardPage({required Key key, required this.individualcard});

  @override
  State<IndividualCardPage> createState() => _IndividualCardPageState();
}

class _IndividualCardPageState extends State<IndividualCardPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
