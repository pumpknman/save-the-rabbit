import 'package:flutter/material.dart';

class RabbitZone extends StatefulWidget {
  final Function onGameOver; // ✅ 게임 오버 콜백 함수
  final Function(int) onGameStart; // ✅ 게임 시작 시 fallDuration 전달

  const RabbitZone({Key? key, required this.onGameOver, required this.onGameStart})
      : super(key: key);

  @override
  RabbitZoneState createState() => RabbitZoneState();
}

class RabbitZoneState extends State<RabbitZone> with TickerProviderStateMixin {
  late AnimationController _fallController;
  late AnimationController _rotationController;
  late Animation<double> _fallAnimation;
  late Animation<double> _rotationAnimation;

  final double seaLevel = 180; // ✅ 바다에 닿으면 게임 오버 (조정 가능)
  final int fallDuration = 50; // ✅ 내려오는 속도 조절 가능

  @override
  void initState() {
    super.initState();

    // ✅ `setState()`가 Build 이후 실행되도록 보장
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onGameStart(fallDuration); // ✅ 게임 시작 시 fallDuration 전달
    });

    _setupAnimations();
  }

  void _setupAnimations() {
    _fallController = AnimationController(
      vsync: this,
      duration: Duration(seconds: fallDuration),
    );

    _fallAnimation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _fallController, curve: Curves.linear),
    );

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.easeInOut),
    );

    _fallController.addListener(() {
      if (_fallAnimation.value >= seaLevel) {
        widget.onGameOver();
        _fallController.stop();
        _rotationController.stop();
      }
    });

    _fallController.forward();
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
          offset: Offset(0, _fallAnimation.value),
          child: Transform.rotate(
            angle: _rotationAnimation.value,
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
