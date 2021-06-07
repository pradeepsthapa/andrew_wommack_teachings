import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_storage/get_storage.dart';

class MainTheme extends ChangeNotifier{

  MainTheme(){
    loadInitial();
  }

  final _box = GetStorage();
  bool _isDark = false;
  int _colorIndex = 0;
  Brightness get platformBrightness => SchedulerBinding.instance!.window.platformBrightness;

  List<dynamic> _swatchColors = [Colors.teal,Colors.red, Colors.blue,Colors.pink];
  List<Color> get swatchColors => [Colors.teal,Colors.red, Colors.blue,Colors.pink];


  void loadInitial(){
    _box.writeIfNull('darkMode', false);
    _box.writeIfNull('colorIndex', 0);
    _isDark = _box.read('darkMode');
    _colorIndex = _box.read('colorIndex');
    notifyListeners();
  }

  ThemeMode toggleThemeMode(bool isDark){
    if(isDark) return ThemeMode.dark;
    else return ThemeMode.dark;
  }

  void toggleDarkMode(){
    _isDark =! isDark;
    _box.write('darkMode', _isDark);
    notifyListeners();
  }


  void changeColor({@required colorIndex}){
    _colorIndex = colorIndex;
    _box.write('colorIndex', _colorIndex);
    notifyListeners();
  }

  bool get isDark => _isDark;
  int get currentColor => _colorIndex;
  MaterialColor get swatchColor => _swatchColors[currentColor] as MaterialColor;

}