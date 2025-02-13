import 'package:flutter/material.dart';

class RabbitZone extends StatefulWidget {
  final Function onGameOver; // ✅ 게임 오버 콜백 함수

  const RabbitZone({Key? key, required this.onGameOver}) : super(key: key);

  @override
  RabbitZoneState createState() => RabbitZoneState();
}

class RabbitZoneState extends State<RabbitZone> with TickerProviderStateMixin {
  late AnimationController _fallController;
  late AnimationController _rotationController;
  late Animation<double> _fallAnimation;
  late Animation<double> _rotationAnimation;

  final double seaLevel = 180; // ✅ 바다에 닿으면 게임 오버 (조정 가능)
  int fallDuration = 50; // ✅ 내려오는 속도 조절 가능

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    // ✅ 낙하 애니메이션 설정 (서서히 내려옴)
    _fallController = AnimationController(
      vsync: this,
      duration: Duration(seconds: fallDuration), // ✅ 내려오는 속도 조절 가능
    );

    _fallAnimation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _fallController, curve: Curves.linear),
    );

    // ✅ 회전 애니메이션 (토끼가 부드럽게 회전)
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // ✅ 회전 속도
    )..repeat(reverse: true); // ✅ 회전 애니메이션 반복

    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _fallController.addListener(() {
      if (_fallAnimation.value >= seaLevel) {
        widget.onGameOver(); // ✅ 바다에 닿으면 게임 오버
        _fallController.stop(); // ✅ 애니메이션 정지
        _rotationController.stop(); // ✅ 회전 정지
      }
    });

    _fallController.forward(); // ✅ 애니메이션 시작
  }

  @override
  void dispose() {
    _fallController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fallAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _fallAnimation.value), // ✅ 토끼 위치 반영
          child: Transform.rotate(
            angle: _rotationAnimation.value, // ✅ 회전 효과 적용
            child: Image.asset(
              'lib/assets/images/rabbit.png',
              width: 50,
            ),
          ),
        );
      },
    );
  }
}
