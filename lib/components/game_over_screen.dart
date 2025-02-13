import 'package:flutter/material.dart';
import '../screens/level_screen.dart'; // ✅ LevelScreen 이동을 위해 추가

class GameOverScreen extends StatelessWidget {
  final VoidCallback onRetry;

  const GameOverScreen({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ 배경 Dim 처리 (까만색 overlay 적용)
        Container(
          color: Colors.black.withOpacity(0.7), // ✅ 70% 투명도 적용
        ),

        // ✅ 중앙 Game Over 메시지 & 버튼
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "GAME OVER",
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "NeoDunggeunmo",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LevelScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "레벨 선택으로 돌아가기",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
