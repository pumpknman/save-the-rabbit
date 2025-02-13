import 'package:flutter/material.dart';

class ProblemDisplay extends StatelessWidget {
  final String hanja;

  const ProblemDisplay({Key? key, required this.hanja}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0.5), // 문제 위치 조정 가능
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xffC3FF68),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          hanja,
          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }
}
