import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/src/features/login/service/auth_service.dart';
import 'dart:math';
import 'dart:developer' as dev;

class QuizService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  bool _correct = false;
  String _selectedAnswer = '';
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  final List<Map<String, dynamic>> _incorrectAnswers = [];
  bool _isHintVisible = false; // 힌트 표시 여부

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get answered => _answered;
  bool get correct => _correct;
  String get selectedAnswer => _selectedAnswer;
  List<Map<String, dynamic>> get questions => _questions;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get incorrectAnswers => _incorrectAnswers;
  bool get isHintVisible => _isHintVisible; // 힌트 표시 여부

  Future<Map<String, dynamic>?> getQuizProgress(
      String uid, String quizId) async {
    try {
      final userQuizRef = _firestore
          .collection('user')
          .doc(uid)
          .collection('completedQuiz')
          .doc(quizId);
      final snapshot = await userQuizRef.get();
      // dev.log('Quiz progress: ${snapshot.data()}');
      return snapshot.data();
    } catch (e) {
      print('Error getting quiz progress: $e');
      return null;
    }
  }

  Future<void> loadQuestions(String collectionName) async {
    try {
      final snapshot =
          await _firestore.collection('quiz').doc(collectionName).get();

      List<Map<String, dynamic>> questionsList = [];

      var data = snapshot.data();
      if (data == null) {
        dev.log('No data found for the given collection name.');
      } else {
        data.forEach((key, value) {
          if (key != 'catchphrase') {
            questionsList.add(value as Map<String, dynamic>);
          }
        });

        for (var question in questionsList) {
          List<dynamic> options = question['options'];
          options.shuffle(Random());
        }

        questionsList.shuffle(Random());
      }

      _questions = questionsList;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      dev.log('Error loading questions: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  void submitAnswer(String correctAnswer) {
    _answered = true;
    _correct = _selectedAnswer == correctAnswer;
    if (_correct) {
      _score++;
    } else {
      _incorrectAnswers.add({
        'question': _questions[_currentQuestionIndex]['question'],
        'selectedAnswer': _selectedAnswer,
        'correctAnswer': correctAnswer,
        'options': _questions[_currentQuestionIndex]['options'],
      });
    }
    notifyListeners();
  }

  Future<void> nextQuestion(String uid, String collectionName) async {
    _currentQuestionIndex++;
    _answered = false;
    _correct = false;
    _selectedAnswer = '';
    _isHintVisible = false; // 다음 질문으로 넘어갈 때 힌트 초기화

    if (_currentQuestionIndex >= _questions.length) {
      if (_score / _questions.length >= 0.9) {
        await AuthService().updateUserBalance(uid, 100000, "퀴즈 학습 완료 보상");
      }
      await AuthService()
          .saveQuizCompletion(uid, collectionName, _score, _questions.length);
    }

    notifyListeners();
  }

  void selectAnswer(String answer) {
    _selectedAnswer = answer;
    notifyListeners();
  }

  void toggleHintVisibility() {
    _isHintVisible = !_isHintVisible;
    notifyListeners();
  }
}
