import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/quest.dart';
import 'package:fyp_mobileapp/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/card_service.dart';
import 'package:lottie/lottie.dart';

class QuestionDetailPage extends StatefulWidget {
  final QuestionModel quest;
  final VoidCallback onEnergyUpdated;

  const QuestionDetailPage({
    required this.quest,
    required this.onEnergyUpdated,
    super.key,
  });

  @override
  _QuestionDetailPageState createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  final CardService _cardService = CardService();
  int? _selectedAnswer;
  String? _submitMessage;

  void _submitAnswer() async {
    if (_selectedAnswer == null) return;

    try {
      final response = await _cardService.submitQuest(
        widget.quest.question_id,
        widget.quest.answers[_selectedAnswer!].answer_id,
      );

      bool isCorrect = response['message'] == 'Correct answer!';
      onQuestCompleted(widget.quest.question_id, isCorrect);

      setState(() {
        _submitMessage = response['message'];
      });

      widget.onEnergyUpdated();

      _showResultModal(response['message']);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit answer: $e')),
        );
      }
    }
  }

  void onQuestCompleted(int questionId, bool isCorrect) {
    _markQuestAsCompleted(questionId);
  }

  Future<void> _markQuestAsCompleted(int questionId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> completedQuests = prefs.getStringList('completedQuests') ?? [];

    // Add the completed question ID to the list
    completedQuests.add(questionId.toString());
    prefs.setStringList('completedQuests', completedQuests);
  }

  void _showResultModal(String message) {
    String lottieAnimation;
    Color messageColor;

    if (message == 'Correct answer!') {
      lottieAnimation = 'assets/Correctanswer.json';
      messageColor = Colors.green;
    } else {
      lottieAnimation = 'assets/Wronganswer.json';
      messageColor = Colors.red;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Lottie animation with no looping
                Lottie.asset(
                  lottieAnimation,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                  repeat: false,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 18,
                    color: messageColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      Navigator.of(context).pop();
                      _redirectToHome();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.of(context).pop();
        _redirectToHome();
      }
    });
  }

  void _redirectToHome() {
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Dashboard()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.amber),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Quest Details',
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2F2F85),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.quest.question,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ...widget.quest.answers.asMap().entries.map((entry) {
                int idx = entry.key;
                AnswerModel answer = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F2F85),
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: _selectedAnswer == idx
                          ? Colors.amber
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                  child: RadioListTile<int>(
                    title: Text(
                      answer.answer,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: idx,
                    groupValue: _selectedAnswer,
                    activeColor: Colors.amber,
                    onChanged: (int? value) {
                      setState(() {
                        _selectedAnswer = value;
                      });
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2F2F85),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
