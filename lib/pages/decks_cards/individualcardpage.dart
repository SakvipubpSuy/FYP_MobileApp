import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../../models/card.dart';

class IndividualCardPage extends StatefulWidget {
  final CardModel individualcard;
  final String deckName;
  const IndividualCardPage(
      {super.key, required this.individualcard, required this.deckName});

  @override
  State<IndividualCardPage> createState() => _IndividualCardPageState();
}

class _IndividualCardPageState extends State<IndividualCardPage> {
  late FlipCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    final card = widget.individualcard;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Invididual Card',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF2F2F85),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Center(
          child: FlipCard(
            controller: _controller,
            flipOnTouch: false,
            front: GestureDetector(
              onTap: () => _controller.toggleCard(),
              onPanUpdate: (details) {
                if (details.delta.dx < -10 || details.delta.dx > 10) {
                  _controller.toggleCard();
                }
              },
              child: CardView(
                card: card,
                borderColor: Color(
                    int.parse(card.cardTier.color.replaceFirst('#', '0xff'))),
                isFront: true,
                deckName: widget.deckName,
              ),
            ),
            back: GestureDetector(
              onTap: () => _controller.toggleCard(),
              onPanUpdate: (details) {
                if (details.delta.dx < -10 || details.delta.dx > 10) {
                  _controller.toggleCard();
                }
              },
              child: CardView(
                card: card,
                borderColor: Color(
                    int.parse(card.cardTier.color.replaceFirst('#', '0xff'))),
                isFront: false,
                deckName: widget.deckName,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  final CardModel card;
  final Color borderColor;
  final bool isFront;
  final String deckName;
  const CardView({
    super.key,
    required this.card,
    required this.borderColor,
    required this.isFront,
    required this.deckName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 400,
      child: CustomPaint(
        painter: BorderPainter(borderColor: borderColor),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isFront) ...[
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          deckName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: borderColor,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.bolt, // Use an appropriate icon for energy
                      color: Colors.blueAccent,
                      size: 24,
                    ),
                    Text(
                      '${card.cardTier.cardEnergyRequired}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.blueAccent,
                      ),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                  ],
                ),
                Placeholder(
                  fallbackHeight: 150,
                  fallbackWidth: 150,
                  color: borderColor,
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 10),
                Text(
                  card.cardName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Card Tier: ${card.cardTier.cardTierName}',
                    textAlign: TextAlign.left, // Align text to the left
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'EXP: ${card.cardTier.cardXP}',
                    textAlign: TextAlign.left, // Align text to the left
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Card Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: borderColor,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        card.cardDescription,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  final Color borderColor;

  BorderPainter({required this.borderColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(10, 0)
      ..lineTo(size.width - 10, 0)
      ..quadraticBezierTo(size.width, 0, size.width, 10)
      ..lineTo(size.width, size.height - 10)
      ..quadraticBezierTo(size.width, size.height, size.width - 10, size.height)
      ..lineTo(10, size.height)
      ..quadraticBezierTo(0, size.height, 0, size.height - 10)
      ..lineTo(0, 10)
      ..quadraticBezierTo(0, 0, 10, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
