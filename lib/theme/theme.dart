import 'package:flutter/material.dart';

class AppTheme{
  late Color primaryColor;
  late Color textColor;
  late Color backgroundColor;
  late Color accentColor;
  late Color textLD;
  late Color cardBackground;
  bool isDark;

  AppTheme({required this.isDark}){
    isDark?_setDarkTheme():_setLightTheme();
  }

  void _setDarkTheme(){
    primaryColor = Color(0xff8e6cef);
    textColor = Colors.white;
    backgroundColor = Color(0xff1d182a);
    textLD = Colors.white;
    cardBackground = Color(0xff29243e);
    accentColor = Color(0xff29243e);
  }
  void _setLightTheme(){
    primaryColor = Color(0xff8e6cef);
    textColor = Colors.white;
    backgroundColor = Colors.white;
    textLD = Colors.black;
    cardBackground = Colors.grey.shade200;
    accentColor = Color(0xffffffff);

  }

  Map<String, dynamic> toJson() => {'isDark': isDark};

  factory AppTheme.fromJson(Map<String, dynamic> json) =>
      AppTheme(isDark: json['isDark'] ?? false);
}