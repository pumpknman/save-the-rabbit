import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter/material.dart';
import 'screens/level_screen.dart';
import 'dart:async';

void main() {
  runApp(const SaveTheRabbitApp());
}

class SaveTheRabbitApp extends StatelessWidget {
  const SaveTheRabbitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save The Rabbit',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LevelScreen(), // 앱 실행 시 바로 LevelScreen 표시
    );
  }
}
