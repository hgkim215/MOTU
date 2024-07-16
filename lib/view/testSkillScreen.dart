import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TestSkillScreen extends StatefulWidget {
  final String collectionName;

  TestSkillScreen({required this.collectionName});

  @override
  _TestSkillScreenState createState() => _TestSkillScreenState();
}

class _TestSkillScreenState extends State<TestSkillScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _correct = false;

  @override
  void initState() {
    super.initState();
    _loadRandomQuestions();
  }

  Future<void> _loadRandomQuestions() async {
    final snapshot = await _firestore.collection(widget.collectionName).get();
    final questions = snapshot.docs;
    questions.shuffle();
    setState(() {
      _questions = questions.take(10).toList();
    });
  }

  void _answerQuestion(String selectedAnswer, String correctAnswer) {
    setState(() {
      _answered = true;
      _correct = selectedAnswer == correctAnswer;
      if (_correct) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQuestionIndex++;
      _answered = false;
      _correct = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          '실력 테스트',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: _questions.isEmpty
          ? Center(child: CircularProgressIndicator())
          : _currentQuestionIndex >= _questions.length
          ? Center(child: Text('테스트 완료! 점수: $_score/${_questions.length}'))
          : Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / _questions.length,
                  minHeight: 10,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '${_currentQuestionIndex + 1} / ${_questions.length}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _questions[_currentQuestionIndex]['question'],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ..._questions[_currentQuestionIndex]['options'].map<Widget>((option) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: _answered
                            ? null
                            : () => _answerQuestion(option, _questions[_currentQuestionIndex]['answer']),
                        child: Text(option),
                      ),
                    );
                  }).toList(),
                  if (_answered)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _nextQuestion,
                        child: Text('다음 질문'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
