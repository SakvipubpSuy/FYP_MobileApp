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
        backgroundColor: const Color(0xFF2F2F85),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Color(int.parse(card.cardTier.color.replaceFirst('#', '0xff'))),
              const Color(0xFF2F2F85),
            ],
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
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.5),
                Color(int.parse(card.cardTier.color.replaceFirst('#', '0xff'))),
                Colors.black.withOpacity(0.5),
              ], // Gradient from dark to light
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            borderRadius: BorderRadius.circular(10.0), // Rounded corners
          ),
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
                    Icon(
                      Icons.bolt, // Use an appropriate icon for energy
                      color: borderColor,
                      size: 24,
                    ),
                    Text(
                      '${card.cardTier.cardEnergyRequired}',
                      style: TextStyle(
                        fontSize: 20,
                        color: borderColor,
                      ),
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(
                      5.0), // Padding to create space between image and border
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        borderColor,
                        Colors.white,
                      ], // Gradient from tier color to white
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(
                        10.0), // Rounded corners for the border
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      5.0, // Match this with the container border radius
                    ),
                    child: card.imgUrl != null
                        ? Image.network(
                            card.imgUrl!, // Display the image from the URL
                            height: 150, // Adjust the height as needed
                            width:
                                double.infinity, // Adjust the width as needed
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 150,
                                color: Colors.grey,
                              );
                            }, // Ensures the image covers the area
                          )
                        : const Icon(
                            Icons.image, // Default icon if image is null
                            size: 150,
                            color: Colors.grey, // Color for the default icon
                          ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  card.cardName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[300],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Card Tier: ${card.cardTier.cardTierName}',
                    textAlign: TextAlign.left, // Align text to the left
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'EXP: ${card.cardTier.cardXP}',
                    textAlign: TextAlign.left, // Align text to the left
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
              ] else ...[
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Card Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
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
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[300],
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
      ..shader = LinearGradient(
        colors: [
          borderColor,
          Colors.white
        ], // Gradient from tier color to white
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
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
