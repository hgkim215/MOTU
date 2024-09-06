import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motu/provider/navigation_provider.dart';
import 'package:motu/text_utils.dart';
import 'package:motu/view/main_page.dart';
import 'package:motu/view/terminology/widget/terminology_category_card_builder.dart';
import 'package:motu/view/theme/color_theme.dart';
import 'terminology_card.dart';
import 'bookmark.dart';
import 'terminology_search.dart';

class TermMain extends StatelessWidget {
  final String uid;

  const TermMain({super.key, required this.uid});

  Future<bool> checkCompletionStatus(String uid, String docId) async {
    final firestore = FirebaseFirestore.instance;
    final userQuizRef = firestore
        .collection('user')
        .doc(uid)
        .collection('completedTerminology')
        .doc(docId);
    final snapshot = await userQuizRef.get();
    if (snapshot.exists) {
      return snapshot.data()?['completed'] ?? false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.colorNeutral,
      appBar: AppBar(
        backgroundColor: ColorTheme.colorWhite,
        title: const Text('용어학습'),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.left_chevron),
          onPressed: () {
            NavigationService().setSelectedIndex(1);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const MainPage(),
              ),
                  (route) => false, // 모든 기존 경로를 제거
            );
          },
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: TermSearchDelegate(uid: uid),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('terminology')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var documents = snapshot.data!.docs;

                List<Widget> completedCategories = [];
                List<Widget> incompleteCategories = [];
                List<Widget> newCategories = [];

                return FutureBuilder<List<bool>>(
                  future: Future.wait(documents.map((doc) => checkCompletionStatus(uid, doc.id)).toList()),
                  builder: (context, completionSnapshots) {
                    if (completionSnapshots.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    for (var i = 0; i < documents.length; i++) {
                      var doc = documents[i];
                      var data = doc.data() as Map<String, dynamic>;
                      var isCompleted = completionSnapshots.data?[i] ?? false;

                      var categoryCard = buildCategoryCard(
                        context,
                        data['title'],
                        preventWordBreak(data['catchphrase']),
                        Colors.white,
                        TermCard(
                            title: data['title'],
                            documentName: doc.id,
                            uid: uid),
                        isCompleted,
                      );

                      if (isCompleted) {
                        completedCategories.add(categoryCard);
                      } else {
                        incompleteCategories.add(categoryCard);
                      }
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.6 / 2,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: incompleteCategories + completedCategories,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
