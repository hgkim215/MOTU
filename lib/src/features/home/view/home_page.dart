import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/src/features/learning/term/view/widget/terminology_category_card_builder.dart';
import 'package:motu/src/features/profile/service/profile_service.dart';
import 'package:provider/provider.dart';
import '../../../common/service/navigation_service.dart';
import '../../login/service/auth_service.dart';
import '../../../common/service/text_utils.dart';
import '../../../common/view/widget/chatbot_fab.dart';
import '../../learning/quiz/view/widget/widget/quiz_category_builder.dart';
import '../../learning/term/view/term_card.dart';
import '../../../design/color_theme.dart';
import 'notice_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _getRandomCategoriesAndQuizzes() async {
    // Fetch terminology categories
    final terminologySnapshot =
        await _firestore.collection('terminology').get();
    final terminologyDocuments = terminologySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      data['type'] = 'terminology';
      return data;
    }).toList();

    // Fetch quiz categories
    final quizSnapshot = await _firestore.collection('quiz').get();
    final quizDocuments = quizSnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      data['type'] = 'quiz';
      return data;
    }).toList();

    // 랜덤 선택
    final combinedDocuments = [...terminologyDocuments, ...quizDocuments];
    combinedDocuments.shuffle();

    return combinedDocuments.take(5).toList();
  }

  Future<Map<String, int>> _getCompletedCounts(String uid) async {
    // Fetch completed quiz
    final quizCategoriesSnapshot = await _firestore
        .collection('user')
        .doc(uid)
        .collection('completedQuiz')
        .get();

    int totalQuizScore = 0;
    for (var doc in quizCategoriesSnapshot.docs) {
      final data = doc.data();
      // log('Quiz Data: $data');
      if (data['completed'] == true) {
        totalQuizScore += (data['score'] as int?) ?? 0;
      }
    }

    // Fetch completed terminology
    final terminologyCategoriesSnapshot = await _firestore
        .collection('user')
        .doc(uid)
        .collection('completedTerminology')
        .get();

    int totalTerminologyScore = 0;
    for (var doc in terminologyCategoriesSnapshot.docs) {
      final data = doc.data();
      // log('Terminology Data: $data');
      if (data['completed'] == true) {
        totalTerminologyScore += (data['score'] as int?) ?? 0;
      }
    }

    return {
      'totalQuizScore': totalQuizScore,
      'totalTerminologyScore': totalTerminologyScore,
    };
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (context.watch<AuthService>().user == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorTheme.colorWhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              // 상단 배너 컨테이너
              Container(
                width: screenWidth,
                height: screenHeight * 0.3,
                decoration: const BoxDecoration(
                  color: ColorTheme.colorDisabled,
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/home_banner_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // 상단 배너 컨테이너
                    Container(
                      width: screenWidth,
                      height: screenHeight * 0.35,
                      decoration: const BoxDecoration(
                        color: ColorTheme.colorDisabled,
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/home_banner_background.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 상단 로고와 알림 아이콘
                                Padding(
                                  padding: const EdgeInsets.only(top: 36),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // 로고 이미지
                                      Image.asset(
                                        'assets/images/home_logo.png',
                                        height: screenHeight *
                                            0.03, // 화면 크기에 비례하여 크기 설정
                                      ),
                                      // 알림 아이콘
                                      IconButton(
                                        icon: const Icon(
                                          Icons.notifications_none,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NoticePage()),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10), // 로고와 사용자 이름 사이 간격

                                // 사용자 이름 및 문구와 출석체크 버튼
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, top: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 사용자 이름 및 문구
                                      Text(
                                        '안녕하세요 ${context.watch<AuthService>().user?.name}님',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        '오늘도 MOTU에서\n투자 공부 함께해요!',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                          height: 10), // 문구와 버튼 사이 간격

                                      // 출석체크 버튼
                                      SizedBox(
                                        width: screenWidth * 0.4,
                                        height: 32,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              Provider.of<AuthService>(context,
                                                      listen: false)
                                                  .checkAttendance(context),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorTheme.colorPrimary,
                                            foregroundColor:
                                                ColorTheme.colorWhite,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text('출석체크 하기'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 캐릭터 이미지
                          Positioned(
                            right: 20,
                            bottom: 30,
                            child: Image.asset(
                              'assets/images/character/hi_panda.png',
                              height:
                                  screenHeight * 0.15, // 화면 크기에 비례한 캐릭터 크기 설정
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // 오늘의 추천 학습 섹션
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20.0),
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
                          onPressed: () {
                            Provider.of<NavigationService>(context,
                                    listen: false)
                                .goToLearning();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: ColorTheme.colorFont,
                            padding:
                                const EdgeInsets.only(right: 20.0), // 오른쪽 패딩 설정
                          ),
                          child: const Text("전체보기"),
                        ),
                      ],
                    ),
                    // 추천학습 불러오기
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _getRandomCategoriesAndQuizzes(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        final documents = snapshot.data!;
                        return SizedBox(
                          height: 240,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              final data = documents[index];
                              return Row(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.6 / 2,
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 10,
                                        bottom: 10,
                                        right: 8,
                                        left: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: data['type'] == 'terminology'
                                          ? TermCategoryCardBuilder(
                                              context,
                                              data['title'],
                                              preventWordBreak(
                                                  data['catchphrase']),
                                              Colors.white,
                                              TermCard(
                                                title: data['title'],
                                                documentName: data['id'],
                                                uid: Provider.of<AuthService>(
                                                        context,
                                                        listen: false)
                                                    .user!
                                                    .uid,
                                              ),
                                              false,
                                            )
                                          : buildQuizCard(
                                              context: context,
                                              uid: Provider.of<AuthService>(
                                                      context,
                                                      listen: false)
                                                  .user!
                                                  .uid,
                                              quizId: data['id'],
                                              catchphrase:
                                                  data['catchphrase'] ??
                                                      '설명 없음',
                                              score: 0,
                                              totalQuestions: 15,
                                              isCompleted: false,
                                              isNewQuiz: true,
                                            ),
                                    ),
                                  ),
                                  if (index <
                                      documents.length - 1) // 마지막 카드 제외 간격 추가
                                    const SizedBox(width: 4),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // 학습 진도율 섹션
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "학습 진도율",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    FutureBuilder<Map<String, int>>(
                      future: _getCompletedCounts(
                          context.watch<AuthService>().user!.uid),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        final counts = snapshot.data!;
                        return Container(
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
                              Expanded(
                                child: _buildProgressContainer(
                                  "지금까지 공부한 용어",
                                  counts['totalTerminologyScore'] ?? 0,
                                ),
                              ),
                              Expanded(
                                child: _buildProgressContainer(
                                  "지금까지 풀어본 문제",
                                  counts['totalQuizScore'] ?? 0,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: const ChatbotFloatingActionButton(
          heroTag: 'home',
        ),
      ),
    );
  }

  Widget _buildProgressContainer(String text, int count) {
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
            style: const TextStyle(
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
            ),
            child: Center(
              child: Text(
                "$count개",
                style: const TextStyle(
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
