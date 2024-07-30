import 'package:flutter/material.dart';
import 'package:motu/view/word/word_term_quiz.dart';
import 'package:provider/provider.dart';
import '../../service/bookmark_service.dart';
import '../../service/words_card_service.dart';
import '../../widget/words_term_card_builder.dart';

class WordsTermCard extends StatelessWidget {
  final String title;
  const WordsTermCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WordsProvider()..fetchWords(title),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: true,
          actions: [
            Consumer<WordsProvider>(
              builder: (context, wordsProvider, child) {
                return IconButton(
                  icon: Icon(Icons.bookmark),
                  onPressed: () {
                    if (wordsProvider.words.isNotEmpty && wordsProvider.current < wordsProvider.words.length) {
                      BookmarkService().addBookmark(
                        wordsProvider.words[wordsProvider.current]['term'] ?? '',
                        wordsProvider.words[wordsProvider.current]['definition'] ?? '',
                        wordsProvider.words[wordsProvider.current]['example'] ?? '',
                        wordsProvider.words[wordsProvider.current]['category'] ?? '',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('책갈피에 저장되었습니다.')),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<WordsProvider>(
          builder: (context, wordsProvider, child) {
            if (wordsProvider.words.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: wordsProvider.pageController,
                    itemCount: wordsProvider.words.length + 1,
                    onPageChanged: (index) {
                      wordsProvider.setCurrentPage(index);
                    },
                    itemBuilder: (context, index) {
                      if (index == wordsProvider.words.length) {
                        return _buildCompletionPage(context, title);
                      } else {
                        return buildTermCard(
                          context,
                          wordsProvider.words[index]['term'] ?? '',
                          wordsProvider.words[index]['definition'] ?? '',
                          wordsProvider.words[index]['example'] ?? '',
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: wordsProvider.previousPage,
                        color: wordsProvider.current > 0 ? Colors.blue : Colors.grey,
                      ),
                      if (wordsProvider.current < wordsProvider.words.length)
                        Text(
                          "${wordsProvider.current + 1} / ${wordsProvider.words.length}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: wordsProvider.nextPage,
                        color: wordsProvider.current < wordsProvider.words.length ? Colors.blue : Colors.grey,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompletionPage(BuildContext context, String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '학습 완료!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            '축하합니다! 모든 카드를 학습하셨습니다.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TermQuizScreen(
                    collectionName: 'terminology', // 실제 컬렉션 이름을 지정합니다.
                  ),
                ),
              );
            },
            child: Text('퀴즈 풀기'),
          ),
        ],
      ),
    );
  }
}