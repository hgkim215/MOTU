import 'package:flutter/material.dart';
import '../../service/bookmark_service.dart';

class BookmarkProvider extends ChangeNotifier {
  final BookmarkService _bookmarkService = BookmarkService();
  List<Map<String, dynamic>> _bookmarks = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  BookmarkProvider() {
    fetchBookmarks();
  }

  Future<void> fetchBookmarks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _bookmarks = await _bookmarkService.getBookmarks();
    } catch (e) {
      _error = '오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 중복 XX, 상태 관리 담당
  Future<void> deleteBookmark(String bookmarkId) async {
    try {
      var bookmark = _bookmarks.firstWhere((bookmark) => bookmark['id'] == bookmarkId);
      await _bookmarkService.deleteBookmark(bookmark['term']);
      _bookmarks.removeWhere((bookmark) => bookmark['id'] == bookmarkId);
      notifyListeners();
    } catch (e) {
      _error = '삭제 중 오류가 발생했습니다.';
      notifyListeners();
    }
  }
}
