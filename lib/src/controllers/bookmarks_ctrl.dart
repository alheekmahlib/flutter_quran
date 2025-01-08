import 'package:get/get.dart';

import '../models/bookmark.dart';
import '../repository/quran_repository.dart';

class BookmarksCtrl extends GetxController {
  static BookmarksCtrl get instance => Get.isRegistered<BookmarksCtrl>()
      ? Get.find<BookmarksCtrl>()
      : Get.put<BookmarksCtrl>(BookmarksCtrl());

  BookmarksCtrl({QuranRepository? quranRepository})
      : _quranRepository = quranRepository ?? QuranRepository(),
        super();

  final QuranRepository _quranRepository;
  final BookmarkModel searchBookmark =
      BookmarkModel(id: 3, colorCode: 0xFFF7EFE0, name: 'search Bookmark');

  final List<BookmarkModel> _defaultBookmarks = [
    BookmarkModel(id: 0, colorCode: 0xAAFFD354, name: 'العلامة الصفراء'),
    BookmarkModel(id: 1, colorCode: 0xAAF36077, name: 'العلامة الحمراء'),
    BookmarkModel(id: 2, colorCode: 0xAA00CD00, name: 'العلامة الخضراء'),
  ];
  List<BookmarkModel> bookmarks = [];

  void initBookmarks(
      {List<BookmarkModel>? userBookmarks, bool overwrite = false}) {
    if (overwrite) {
      bookmarks = [...(userBookmarks ?? _defaultBookmarks), searchBookmark];
    } else {
      bookmarks = _quranRepository.getBookmarks();
      if (bookmarks.isEmpty) {
        if (userBookmarks != null) {
          bookmarks = [...userBookmarks, searchBookmark];
        } else {
          bookmarks = [..._defaultBookmarks, searchBookmark];
        }
      }
    }
    _quranRepository.saveBookmarks(bookmarks);
    // emit(bookmarks);
    update();
  }

  saveBookmark({
    required int ayahId,
    required int page,
    required int bookmarkId,
    bool saveBookmark = true,
  }) {
    final bookmarkIndex =
        bookmarks.indexWhere((bookmark) => bookmark.id == bookmarkId);
    if (bookmarkIndex != -1) {
      bookmarks[bookmarkIndex].ayahId = ayahId;
      bookmarks[bookmarkIndex].page = page;
      if (saveBookmark) {
        _quranRepository.saveBookmarks(bookmarks);
      }
      bookmarks = [...bookmarks];
      // emit(bookmarks);
      update();
    }
  }

  removeBookmark(int bookmarkId, {bool saveBookmark = true}) {
    final bookmarkIndex =
        bookmarks.indexWhere((bookmark) => bookmark.id == bookmarkId);
    if (bookmarkIndex != -1) {
      bookmarks[bookmarkIndex].ayahId = -1;
      bookmarks[bookmarkIndex].page = -1;
      if (saveBookmark) {
        _quranRepository.saveBookmarks(bookmarks);
      }
      bookmarks = [...bookmarks];
      // emit(bookmarks);
      update();
    }
  }
}
