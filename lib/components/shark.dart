import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Shark extends StatefulWidget {
  final double startY;  // ✅ 각 상어의 높이
  final double speed;   // ✅ 개별 속도 추가

  const Shark({Key? key, required this.startY, required this.speed}) : super(key: key);

  @override
  _SharkState createState() => _SharkState();
}

class _SharkState extends State<Shark> {
  late double _sharkX;
  late bool _isMovingRight;
  late Timer _timer;
  final Random _random = Random();
  late double _sharkSize;

  @override
  void initState() {
    super.initState();
    _initializeShark();
    _startMoving();
  }

  void _initializeShark() {
    _isMovingRight = _random.nextBool();
    _sharkX = _isMovingRight ? -1.2 : 1.2;

    // ✅ 위쪽 상어일수록 크기를 줄임
    _sharkSize = 50 - ((widget.startY - 1.05) * 50);
  }

  void _startMoving() {
    _timer = Timer.periodic(const Duration(milliseconds: 8), (timer) {
      setState(() {
        _sharkX += _isMovingRight ? widget.speed : -widget.speed;

        if (_sharkX > 1.2) {
          _isMovingRight = false;
        } else if (_sharkX < -1.2) {
          _isMovingRight = true;
        }

        // ✅ 방향 변경 확률을 낮춰 더 자연스럽게 (0.5% 확률)
        if (_random.nextDouble() < 0.005) {
          _isMovingRight = !_isMovingRight;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(_sharkX, widget.startY),
      child: Image.asset(
        _isMovingRight
            ? 'lib/assets/images/sharks_fin_right.png'
            : 'lib/assets/images/sharks_fin_left.png',
        width: _sharkSize,
        height: _sharkSize,
      ),
    );
  }
}
