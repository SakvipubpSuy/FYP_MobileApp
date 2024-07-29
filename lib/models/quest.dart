class AnswerModel {
  final int answer_id;
  final String answer;
  final bool isCorrect;

  AnswerModel({
    required this.answer_id,
    required this.answer,
    required this.isCorrect,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      answer_id: json['answer_id'],
      answer: json['answer'],
      isCorrect: json['is_correct'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'answer_id': answer_id,
      'answer': answer,
      'is_correct': isCorrect ? 1 : 0,
    };
  }
}

class QuestionModel {
  final int question_id;
  final String question;
  final List<AnswerModel> answers;

  QuestionModel({
    required this.question_id,
    required this.question,
    required this.answers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    var list = json['answers'] as List;
    List<AnswerModel> answersList =
        list.map((i) => AnswerModel.fromJson(i)).toList();

    return QuestionModel(
      question_id: json['question_id'],
      question: json['question'],
      answers: answersList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': question_id,
      'question': question,
      'answers': answers.map((answer) => answer.toJson()).toList(),
    };
  }
}
