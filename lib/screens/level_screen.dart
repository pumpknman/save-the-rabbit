import 'package:flutter/material.dart';
import '../components/level_button.dart';
import '../components/background.dart';
import '../components/shark_group.dart';
import 'quiz_screen.dart';  // ✅ quiz_screen.dart 임포트

class LevelScreen extends StatelessWidget {
  const LevelScreen({Key? key}) : super(key: key);

  // ✅ 급수 데이터 리스트
  final List<String> levels = const [
    "8급", "7급", "7급II", "6급", "6급II", 
    "5급", "5급II", "4급", "4급II", "3급", 
    "3급II", "2급", "1급", "특급", "특급II"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Background(),

          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: const SharkGroup(),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Save The\nRabbit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "NeoDunggeunmo",
                    fontSize: 58,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff005764),
                    height: 1,
                  ),
                ),
              ),

              // ✅ 버튼 동적 생성
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: levels.length,
                  itemBuilder: (context, index) {
                    return LevelButton(
                      text: levels[index], // ✅ 버튼 텍스트 설정
                      onPressed: () {
                        String jsonFile = _getJsonFilename(levels[index]); // JSON 파일명 변환
                        print('${levels[index]} selected -> 파일: $jsonFile');

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuizScreen(level: jsonFile)),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ✅ 급수 이름을 JSON 파일명으로 변환하는 함수
  String _getJsonFilename(String level) {
    if (level == "특급") return "teuk.json";
    if (level == "특급II") return "teuk_2.json";
    
    // "7급II" → "lvl7_2.json" 변환
    if (level.contains("II")) {
      return "lvl${level.replaceAll("급II", "_2")}.json";
    }

    // "8급" → "lvl8.json" 변환
    return "lvl${level.replaceAll("급", "")}.json";
  }
}
