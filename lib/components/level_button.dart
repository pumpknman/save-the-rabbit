import 'package:flutter/material.dart';

class LevelButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const LevelButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  _LevelButtonState createState() => _LevelButtonState();
}

class _LevelButtonState extends State<LevelButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
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
        children: [
          // ✅ 그림자 효과 (버튼과 동일한 크기)
          if (!isPressed) // ✅ 버튼을 누르면 그림자 제거
            Positioned(
              bottom: 5,
              left: 0,
              right: 0,
              child: Container(
                height: 80, // ✅ 버튼과 동일한 높이
                decoration: BoxDecoration(
                  color: const Color(0xffA4D459), // ✅ 그림자 색상
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

          // ✅ 실제 버튼
          Transform.translate(
            offset: isPressed ? const Offset(0, 3) : Offset.zero,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffC3FF68),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0, // ✅ Flutter 기본 그림자 제거
                shadowColor: Colors.transparent, // ✅ 기본 그림자 완전히 숨김
                minimumSize: const Size(120, 80), // ✅ 버튼 크기 유지
                padding: const EdgeInsets.symmetric(vertical: 12), // ✅ 내부 여백 조정
              ),
              onPressed: widget.onPressed,
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: "NeoDunggeunmo",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
