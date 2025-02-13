import 'package:flutter/material.dart';
import 'answer_button.dart';

class AnswerOptions extends StatefulWidget {
  final List<String> choices;
  final String correctAnswer; // ✅ 정답 추가
  final Function(String) onAnswerSelected;

  const AnswerOptions({Key? key, required this.choices, required this.correctAnswer, required this.onAnswerSelected})
      : super(key: key);

  @override
  _AnswerOptionsState createState() => _AnswerOptionsState();
}

class _AnswerOptionsState extends State<AnswerOptions> {
  String selectedAnswer = ""; // ✅ 선택한 정답 저장

  void _handleAnswer(String answer) {
    setState(() {
      selectedAnswer = answer;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          selectedAnswer = ""; // ✅ 다음 문제로 넘어가면 초기화
        });
      }
      widget.onAnswerSelected(answer);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double buttonWidth = (screenWidth - 50) / 2; // ✅ 버튼 너비 고정 (15px 여백 고려)
    double buttonHeight = (screenHeight * 0.15).clamp(50, 90); // ✅ 버튼 높이 고정

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10), // ✅ 여백 조정
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAnswerButton(widget.choices[0], buttonWidth, buttonHeight),
              _buildAnswerButton(widget.choices[1], buttonWidth, buttonHeight),
            ],
          ),
          const SizedBox(height: 15), // ✅ 버튼 간 간격 추가
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAnswerButton(widget.choices[2], buttonWidth, buttonHeight),
              _buildAnswerButton(widget.choices[3], buttonWidth, buttonHeight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(String text, double width, double height) {
    return SizedBox(
      width: width, // ✅ 버튼 크기 고정
      height: height, // ✅ 버튼 크기 고정
      child: AnswerButton(
        text: text,
        width: width,
        height: height,
        isSelected: selectedAnswer == text, // ✅ 선택된 버튼 확인
        isCorrect: text == widget.correctAnswer, // ✅ 정답 여부 확인
        onPressed: () => _handleAnswer(text),
      ),
    );
  }
}
