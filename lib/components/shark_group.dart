import 'dart:math';
import 'package:flutter/material.dart';
import 'shark.dart';

class SharkGroup extends StatelessWidget {
  const SharkGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Random random = Random();

    return Stack(
      children: [
        Shark(startY: 1.65, speed: 0.001 + random.nextDouble() * 0.004), // ✅ 속도 variation 추가
        Shark(startY: 1.20, speed: 0.001 + random.nextDouble() * 0.004),
        Shark(startY: 1.05, speed: 0.001 + random.nextDouble() * 0.004),
      ],
    );
  }
}
