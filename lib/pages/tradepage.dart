import 'package:flutter/material.dart';

class TradePage extends StatefulWidget {
  const TradePage({super.key});

  @override
  State<TradePage> createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trade Page'),
      ),
      body: const Center(
        child: Column(
          children: [
            Text('Trade Page 1'),
            Text('Trade Page 2'),
          ],
        ),
      ),
    );
  }
}
