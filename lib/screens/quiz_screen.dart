import 'dart:async'; // ✅ Timer 사용을 위해 추가
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

  int _remainingTime = 10; // ✅ 초기값 (기본값: 10초)
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _timer.cancel(); // ✅ 타이머 정리
    super.dispose();
  }

  // ✅ RabbitZone에서 게임 시작할 때 시간을 받아오는 메서드
  void _onGameStart(int fallDuration) {
    setState(() {
      _remainingTime = fallDuration; // ✅ RabbitZone에서 전달받은 시간으로 설정
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
        _gameOver(); // ✅ 시간이 다 되면 게임 오버
      }
    });
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

  // ✅ level.json → "8급" 형태로 변환
  String _convertLevelFormat(String level) {
    if (level.contains("lvl")) {
      return level.replaceAll(RegExp(r'[^0-9]'), "") + "급";
    } else if (level.contains("teuk")) {
      return "특급";
    }
    return level;
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

              // ✅ 토끼 (애니메이션 적용) → RabbitZone에서 시간 전달
              Expanded(
                flex: 3,
                child: RabbitZone(
                  onGameOver: _gameOver, // ✅ 게임 오버 시 실행
                  onGameStart: _onGameStart, // ✅ 게임 시작 시 fallDuration 전달받음
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

          // ✅ 좌측 상단: 남은 시간 표시 (위치 조정)
          Positioned(
            top: 50, // ✅ 노티바에 가리지 않도록 조정
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "⏳ $_remainingTime 초",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "NeoDunggeunmo",
                ),
              ),
            ),
          ),

          // ✅ 화면 중앙 상단: 급수 표시 (변환된 형식)
          Positioned(
            top: 50, // ✅ 노티바와 겹치지 않도록 위치 조정
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                _convertLevelFormat(widget.level), // ✅ "lvl8.json" → "8급" 변환
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "NeoDunggeunmo",
                ),
              ),
            ),
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
