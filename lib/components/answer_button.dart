import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AnswerButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool isSelected; // ✅ 선택 여부
  final bool isCorrect; // ✅ 정답 여부

  const AnswerButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.width,
    required this.height,
    required this.isSelected,
    required this.isCorrect,
  }) : super(key: key);

  @override
  _AnswerButtonState createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // ✅ 기본 배경색 (선택되지 않은 상태)
    Color buttonColor = const Color(0xffC3FF68);
    Color textColor = Colors.black; // ✅ 기본 검은색 텍스트
    Color shadowColor = const Color(0xffA4D459); // ✅ 그림자 색상

    // ✅ 선택되었을 때 정답/오답에 따라 색상 변경
    if (widget.isSelected) {
      buttonColor = widget.isCorrect ? const Color(0xFF00C176) : const Color(0xFFFF003C);
      textColor = Colors.white; // ✅ 선택되면 흰색 텍스트
    }

    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          isPressed = false;
        });
        widget.onPressed();
      },
      onTapCancel: () {
        setState(() {
          isPressed = false;
        });
      },
      child: Stack(
        clipBehavior: Clip.none, // ✅ 그림자가 정상적으로 표시되도록 처리
        children: [
          // ✅ 그림자 효과 (버튼과 동일한 크기 & 라운드 처리, 눌렀을 때 제거)
          if (!isPressed) // ✅ 버튼을 누르면 그림자 제거
            Positioned(
              top: 10, // ✅ 그림자 위치 조정
              left: 0,
              right: 0,
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: shadowColor, // ✅ 그림자 색상
                  borderRadius: BorderRadius.circular(12), // ✅ 버튼과 동일한 라운드 처리
                ),
              ),
            ),

          // ✅ 실제 버튼
          Positioned(
            top: isPressed ? 8 : 3, // ✅ 눌렀을 때 버튼이 아래로 이동
            left: 0,
            right: 0,
            child: SizedBox(
              width: widget.width, // ✅ 버튼 크기 강제 고정
              height: widget.height, // ✅ 버튼 크기 강제 고정
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // ✅ 선택된 경우 색상 변경
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // ✅ 버튼과 동일한 라운드 처리
                  ),
                  elevation: 0, // ✅ 기본 그림자 제거
                  shadowColor: Colors.transparent, // ✅ 기본 그림자 완전히 숨김
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // ✅ 여백 조정
                ),
                onPressed: widget.onPressed,
                child: AutoSizeText(
                  widget.text,
                  textAlign: TextAlign.center, // ✅ 중앙 정렬
                  maxLines: 2, // ✅ 최대 2줄 (줄바꿈 적용)
                  minFontSize: 14, // ✅ 너무 작아지지 않도록 최소 크기 설정
                  overflow: TextOverflow.ellipsis, // ✅ 너무 길면 말줄임표 적용
                  style: TextStyle(
                    fontFamily: "NeoDunggeunmo",
                    fontSize: 22, // ✅ 글자 크기 조정 (크면 자동 축소됨)
                    fontWeight: FontWeight.bold,
                    color: textColor, // ✅ 선택 여부에 따라 색상 변경
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
