import 'package:flutter/material.dart';

class RabbitZone extends StatefulWidget {
  final Function onGameOver; // ✅ 게임 오버 콜백 함수

  const RabbitZone({Key? key, required this.onGameOver}) : super(key: key);

  @override
  RabbitZoneState createState() => RabbitZoneState();
}

class RabbitZoneState extends State<RabbitZone> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double rabbitOffset = 0; // ✅ 토끼가 위/아래로 움직이는 값
  final double seaLevel = 180; // ✅ 바다에 닿으면 게임 오버 (조정 가능)
  final double maxHeight = -100; // ✅ 토끼가 올라갈 수 있는 최대 높이 (더 높이 올라가도록 수정)

  // ✅ 토끼가 내려오는 속도 (초 단위) → 여기서 조절 가능
  int fallDuration = 50; // 기본값: 10초

  @override
  void initState() {
    super.initState();

    _setupAnimation();
  }

  void _setupAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: fallDuration), // ✅ 내려오는 속도 조절 가능
    );

    _animation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller.addListener(() {
      if (_animation.value + rabbitOffset >= seaLevel) {
        widget.onGameOver(); // ✅ 바다에 닿으면 게임 오버
        _controller.stop(); // ✅ 애니메이션 정지
      }
    });

    _controller.forward(); // ✅ 애니메이션 시작
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ✅ 정답 체크에 따라 위치 변경 (반복 적용 가능)
  void updateRabbitPosition(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        rabbitOffset = (rabbitOffset - 10).clamp(maxHeight, double.infinity); // ✅ 계속 위로 올라감
      } else {
        rabbitOffset += 3; // ✅ 틀리면 더 빨리 내려감
      }
    });

    // ✅ 지속적으로 호출되도록 함
    if (!isCorrect) return;
    Future.delayed(const Duration(milliseconds: 100), () {
      updateRabbitPosition(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value + rabbitOffset), // ✅ 토끼 위치 반영
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('lib/assets/images/rabbit.png', width: 50),
              Container(
                width: 100,
                height: 10,
                decoration: BoxDecoration(
                  color: const Color(0xffD9D9D9),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Container(
                width: 10,
                height: 166,
                color: const Color(0xffD9D9D9),
              ),
            ],
          ),
        );
      },
    );
  }
}
