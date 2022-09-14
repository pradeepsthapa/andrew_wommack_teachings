import 'package:andrew_wommack/data/constants.dart';
import 'package:andrew_wommack/data/custom_media_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

class BookmarksState extends StateNotifier<List<CustomMediaItem>>{
  BookmarksState() : super([]);

  final _box = GetStorage();


  Future<void> getBookmarks ()async{
    final List data = await _box.read(Constants.bookmarks);
    final bookmarks = data.map((e) => CustomMediaItem.fromMap(e)).toList();
    state = bookmarks;
  }

  Future<void> addBookmark({required CustomMediaItem customMediaItem})async{
    state = [...state,customMediaItem];
    await saveBookmark(verses: state);
  }

  saveBookmark({required List<CustomMediaItem> verses}){
    final  mappedData = verses.map((e) => e.toMap()).toList();
    _box.write(Constants.bookmarks, mappedData);
  }

  Future<void> removeBookmark({required CustomMediaItem customMediaItem})async{
    state = [...state]..removeWhere((element) => element==customMediaItem);
    await saveBookmark(verses: state);
  }
}