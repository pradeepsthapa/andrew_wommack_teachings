import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class GlobalFontModel extends Equatable{
  final String? fontName;
  final TextTheme textTheme;
  final String fontFamily;
  const GlobalFontModel({this.fontName, required this.textTheme, required this.fontFamily});

  @override
  List<Object?> get props => [fontName,textTheme,fontFamily];

}