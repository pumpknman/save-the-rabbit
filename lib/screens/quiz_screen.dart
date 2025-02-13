import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../components/problem_display.dart';
import '../components/rabbit_zone.dart';
import '../components/answer_options.dart';
import '../components/shark_group.dart';
import '../components/background.dart';
import '../components/game_over_screen.dart';

class QuizScreen extends StatefulWidget {
  final String level;

  const QuizScreen({Key? key, required this.level}) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  String _currentHanja = "";
  String _currentMeaning = "";
  List<String> _answerChoices = [];
  bool isGameOver = false; // ✅ 게임 오버 상태 확인

  final GlobalKey<RabbitZoneState> rabbitKey = GlobalKey<RabbitZoneState>(); // ✅ RabbitZone 상태 변경을 위한 key

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      String data = await rootBundle.loadString('lib/assets/data/${widget.level}');
      List<dynamic> jsonResult = json.decode(data);

      setState(() {
        _questions = jsonResult;
        _loadNextQuestion();
      });
    } catch (e) {
      print("❌ JSON 로드 실패: $e");
    }
  }

  void _loadNextQuestion() {
    if (_currentIndex < _questions.length) {
      var question = _questions[_currentIndex];
      _currentHanja = question["hanja"];
      _currentMeaning = question["meaning"];
      _generateAnswerChoices(question["meaning"]);
      _currentIndex++;
    } else {
      setState(() {
        _currentHanja = "끝!";
        _currentMeaning = "모든 문제 완료";
        _answerChoices = [];
      });
    }
  }

  void _generateAnswerChoices(String correctAnswer) {
    List<String> choices = [correctAnswer];

    while (choices.length < 4) {
      var randomQuestion = _questions[Random().nextInt(_questions.length)];
      if (!choices.contains(randomQuestion["meaning"])) {
        choices.add(randomQuestion["meaning"]);
      }
    }

    choices.shuffle();
    setState(() {
      _answerChoices = choices;
    });
  }

  void _checkAnswer(String selected) {
    if (isGameOver) return; // ✅ 게임 오버 상태면 정답 체크 중단

    bool isCorrect = selected == _currentMeaning;

    // ✅ Rabbit 위치 변경 (정답: 위로 계속 올라감, 오답: 아래로 내려감)
    if (isCorrect) {
      for (int i = 0; i < 3; i++) {
        Future.delayed(Duration(milliseconds: 100 * i), () {
          rabbitKey.currentState?.updateRabbitPosition(true);
        });
      }
    } else {
      rabbitKey.currentState?.updateRabbitPosition(false);
    }

    if (isCorrect) {
      print("✅ 정답!");
    } else {
      print("❌ 오답!");
    }

    _loadNextQuestion();
  }

  // ✅ 게임 오버 시 실행
  void _gameOver() {
    setState(() {
      isGameOver = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ✅ 하늘 배경
          const Background(),

          Column(
            children: [
              // ✅ 문제 영역
              Expanded(
                flex: 4,
                child: ProblemDisplay(hanja: _currentHanja),
              ),

              // ✅ 토끼 + 원형 판 (애니메이션 적용)
              Expanded(
                flex: 3,
                child: RabbitZone(
                  key: rabbitKey,
                  onGameOver: _gameOver, // ✅ 게임 오버 시 실행
                ),
              ),

              // ✅ 바다 + 상어 (보기 박스 바로 위에 위치)
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF1693A5), Color(0xFF08383F)], // 바다 그라디언트 적용
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    const Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: SharkGroup(),
                    ),
                  ],
                ),
              ),

              // ✅ 보기 영역 (바다 바로 아래)
              Expanded(
                flex: 3,
                child: Container(
                  color: const Color(0xFF00CDAC),
                  child: Center(
                    child: AnswerOptions(
                      choices: _answerChoices,
                      correctAnswer: _currentMeaning, // ✅ 정답 전달
                      onAnswerSelected: _checkAnswer,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ✅ 게임 오버 화면 추가
          if (isGameOver)
            GameOverScreen(
              onRetry: () {}, // ✅ 빈 함수 전달하여 오류 방지
            ),
        ],
      ),
    );
  }
}
