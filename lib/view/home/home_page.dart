import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../service/home_service.dart';
import '../../service/auth_service.dart';
import '../theme/color_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeService _controller = HomeService();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<AuthService>(
      builder: (context, service, child) {
        return Scaffold(
          backgroundColor: ColorTheme.colorWhite,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 상단 배너 컨테이너
                Container(
                  width: screenWidth,
                  height: screenHeight * 0.32,
                  decoration: BoxDecoration(
                    color: ColorTheme.colorDisabled,
                    image: DecorationImage(
                      image: AssetImage('assets/images/home_banner_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 사용자 이름 표시
                      Positioned(
                        bottom: screenHeight * 0.32 / 3.5,
                        left: 30,
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '안녕하세요 ${service.user.name}님',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 2,),
                              Text(
                                '오늘도 MOTU에서\n투자 공부 함께해요!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 출석체크 버튼
                      Positioned(
                        bottom: 30,
                        left: 30,
                        child: SizedBox(
                          width: 140,
                          height: 32,
                          child: ElevatedButton(
                            onPressed: () => _controller.checkAttendance(context),
                            child: const Text('출석체크 하기'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorTheme.colorPrimary,
                              foregroundColor: ColorTheme.colorWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 로고 이미지
                      Positioned(
                        top: 20,
                        left: 10,
                        child: Image.asset(
                          'assets/images/motu_logo.png',
                          height: 120,
                        ),
                      ),

                      // 알림 아이콘
                      Positioned(
                        top: 50,
                        right: 10,
                        child: IconButton(
                          icon: const Icon(
                            Icons.notifications_none,
                            color: Colors.black,
                          ),
                          onPressed: () {},
                        ),
                      ),

                      // 캐릭터 이미지
                      Positioned(
                        right: 20,
                        bottom: 20,
                        child: Image.asset(
                          'assets/images/character/hi_panda.png',
                          height: 120,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "오늘의 추천 학습",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text("전체보기"),
                            style: TextButton.styleFrom(
                              foregroundColor: ColorTheme.colorFont,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "추천 학습이 표시될 영역입니다.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "학습 진도율",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: screenHeight * 0.2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: _buildProgressContainer("지금까지 공부한 용어")),
                            Expanded(child: _buildProgressContainer("지금까지 풀어본 문제")),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressContainer(String text) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Image.asset(
            text == "지금까지 공부한 용어"
                ? 'assets/images/character/curious_panda.png'
                : 'assets/images/character/study_panda.png',
            height: 60,
          ),
          const SizedBox(height: 10),
          Container(
            height: 30,
            width: 80,
            decoration: BoxDecoration(
              color: ColorTheme.colorPrimary40,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [],
            ),
            child: Center(
              child: Text(
                "00개",
                style: TextStyle(
                  fontSize: 12,
                  color: ColorTheme.colorWhite,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
