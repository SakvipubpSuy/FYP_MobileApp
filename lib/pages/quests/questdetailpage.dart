import 'package:flutter/material.dart';
import 'package:fyp_mobileapp/models/quest.dart';
import '../../api/card_service.dart';

class QuestionDetailPage extends StatefulWidget {
  final QuestionModel quest;
  final VoidCallback onEnergyUpdated;

  const QuestionDetailPage(
      {required this.quest, required this.onEnergyUpdated, super.key});

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
      final response = await _cardService.submitQuest(widget.quest.question_id,
          widget.quest.answers[_selectedAnswer!].answer_id);
      setState(() {
        _submitMessage = response['message'];
      });

      widget.onEnergyUpdated();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit answer: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quest Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.quest.question,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...widget.quest.answers.asMap().entries.map((entry) {
              int idx = entry.key;
              AnswerModel answer = entry.value;
              return RadioListTile<int>(
                title: Text(answer.answer),
                value: idx,
                groupValue: _selectedAnswer,
                onChanged: (int? value) {
                  setState(() {
                    _selectedAnswer = value;
                  });
                },
              );
            }),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAnswer,
              child: Text('Submit'),
            ),
            if (_submitMessage != null) ...[
              SizedBox(height: 20),
              Text(
                _submitMessage!,
                style: TextStyle(
                  fontSize: 20,
                  color: _submitMessage == 'Correct answer!'
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ],
            if (_submitMessage == 'Correct answer!') ...[
              SizedBox(height: 20),
              Text(
                'You have earned the energy back!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                ),
              )
            ],
            if (_submitMessage == 'Wrong answer!') ...[
              SizedBox(height: 20),
              Text(
                'You have lost the energy!',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
