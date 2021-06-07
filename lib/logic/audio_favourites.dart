import 'package:andrew_wommack/data/model.dart';
import 'package:andrew_wommack/data/model_data.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';

class AudioFavourites extends ChangeNotifier{

  final _box = GetStorage();

  AudioFavourites(){
    loadInitials();
  }

  void loadInitials(){
    _favList = allList.where((element) => _box.read(element.tUrl!)==true).toList();
    notifyListeners();
  }

  List<TeachingModel> _favList = [];
  List<TeachingModel> get favList => _favList;
  List<TeachingModel> allList = TeachingCategory.allList;

  bool readFavStatus(String url){
    _box.writeIfNull(url, false);
    return _box.read(url);
  }

  void toggleFavourite(String url){
    _box.writeIfNull(url, false);
    bool _isFav = _box.read(url);
    _box.write(url, _isFav =! _isFav);
    _favList = allList.where((element) => _box.read(element.tUrl!)==true).toList();
    notifyListeners();
  }
}