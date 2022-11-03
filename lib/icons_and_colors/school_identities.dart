// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
import 'custom_icons_icons.dart';

class SchoolColors{
  static const int f = 255;

  static const Color UCVTS = Color.fromARGB(255, 30, 46, 186);
  static const Color Allied = Color.fromARGB(f, 121, 41, 46);
  static const Color AIT = Color.fromARGB(f, 248, 184, 16);
  static const Color APA = Color.fromARGB(f, 175, 179, 172);
  static const Color Magnet = Color.fromARGB(f, 149, 195, 222);
  static const Color UCTech = Color.fromARGB(f, 255, 211, 110);

  static Color getSchoolColor (String school){
    switch(school){
      case "UCVTS" : return UCVTS;
      case "Allied" : return Allied;
      case "AIT" : return AIT;
      case "APA" : return APA;
      case "Magnet" : return Magnet;
      case "UCTech" : return UCTech;
      default: return UCVTS;
    }
  }
}

class SchoolLogos{
  static const IconData UCVTS = CustomIcons.ucvts;
  static const IconData Allied = Icons.healing;
  static const IconData AIT = CustomIcons.ait;
  static const IconData APA = CustomIcons.theaterMasks;
  static const IconData Magnet = Icons.settings;
  static const IconData UCTech = Icons.school;

  static IconData getSchoolLogo (String school){
    switch(school){
      case "UCVTS" : return UCVTS;
      case "Allied" : return Allied;
      case "AIT" : return AIT;
      case "APA" : return APA;
      case "Magnet" : return Magnet;
      case "UCTech" : return UCTech;
      default: return UCVTS;
    }
  }
}