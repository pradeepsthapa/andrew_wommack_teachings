import 'package:andrew_wommack/data/constants.dart';
import 'package:andrew_wommack/logic/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

class StorageProvider extends ChangeNotifier{
  final ChangeNotifierProviderRef _reader;
  StorageProvider(this._reader);

  final _box = GetIt.I.get<GetStorage>();

  bool _isDark = false;
  bool get isDark => _isDark;

  void changeDarkTheme(bool value){
    _box.write(Constants.darkMode, value);
    _isDark = value;
    notifyListeners();

  }

  void saveFontSize(double size){
    _box.write(Constants.fontSize, size);
    _reader.read(fontSizeProvider.state).state = size;
  }

  void saveBackground(int color){
    _box.write(Constants.backgroundColor, color);
    _reader.read(appColorProvider.state).state = color;
  }

  void saveFontStyle(int index){
    _box.write(Constants.fontIndex, index);
    _reader.read(globalFontProvider.state).state = index;
  }


  void initStorage(){
    _box.writeIfNull(Constants.darkMode, false);
    _box.writeIfNull(Constants.fontSize, 18.0);
    _box.writeIfNull(Constants.backgroundColor, 4);
    _box.writeIfNull(Constants.fontIndex, 0);
    _box.writeIfNull(Constants.bookmarks, <Map<String,dynamic>>[]);
    _initialDarkMode();
  }

  void _initialDarkMode(){
    _isDark = _box.read(Constants.darkMode);
    notifyListeners();
  }



  void loadInitials() {
    _reader.read(fontSizeProvider.state).state =  _box.read(Constants.fontSize);
    _reader.read(appColorProvider.state).state =  _box.read(Constants.backgroundColor);
    _reader.read(globalFontProvider.state).state =  _box.read(Constants.fontIndex);
  }
}