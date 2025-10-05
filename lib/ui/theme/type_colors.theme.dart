import 'package:flutter/material.dart';
import 'package:pokedex_app/data/models/type_palette.model.dart';

class TypeColors {
  static const Map<String, TypePalette> palettes = {
    "normal": TypePalette(
      primary: Color(0xFF9FA19F),
      secondary: Color(0xFFBBBCBB),
      accent: Color(0xFF727472),
    ),
    "fire": TypePalette(
      primary: Color(0xFFE62829),
      secondary: Color(0xFFED6666),
      accent: Color(0xFFAD1414),
    ),
    "water": TypePalette(
      primary: Color(0xFF2980EF),
      secondary: Color(0xFF67A4F4),
      accent: Color(0xFF0E59BA),
    ),
    "grass": TypePalette(
      primary: Color(0xFF42A129),
      secondary: Color(0xFF6BD251),
      accent: Color(0xFF2F741E),
    ),
    "electric": TypePalette(
      primary: Color(0xFFFAC000),
      secondary: Color(0xFFFFD445),
      accent: Color(0xFFB38900),
    ),
    "ice": TypePalette(
      primary: Color(0xFF3FD8FF),
      secondary: Color(0xFF75E3FF),
      accent: Color(0xFF00B5E2),
    ),
    "fighting": TypePalette(
      primary: Color(0xFFFF8000),
      secondary: Color(0xFFFFA449),
      accent: Color(0xFFB65B00),
    ),
    "poison": TypePalette(
      primary: Color(0xFF9040CC),
      secondary: Color(0xFFB078DB),
      accent: Color(0xFF682999),
    ),
    "ground": TypePalette(
      primary: Color(0xFF915121),
      secondary: Color(0xFFD37F3E),
      accent: Color(0xFF683A18),
    ),
    "flying": TypePalette(
      primary: Color(0xFF81B9EF),
      secondary: Color(0xFFA5CDF3),
      accent: Color(0xFF2486E3),
    ),
    "psychic": TypePalette(
      primary: Color(0xFFF14179),
      secondary: Color(0xFFF5779F),
      accent: Color(0xFFCB0F4B),
    ),
    "bug": TypePalette(
      primary: Color(0xFF91A119),
      secondary: Color(0xFFB4C71F),
      accent: Color(0xFF667112),
    ),
    "rock": TypePalette(
      primary: Color(0xFFAFA981),
      secondary: Color(0xFFC6C2A6),
      accent: Color(0xFF857F55),
    ),
    "ghost": TypePalette(
      primary: Color(0xFF704170),
      secondary: Color(0xFFA969A9),
      accent: Color(0xFF512F51),
    ),
    "dragon": TypePalette(
      primary: Color(0xFF5061E1),
      secondary: Color(0xFF828EEA),
      accent: Color(0xFF2032BB),
    ),
    "dark": TypePalette(
      primary: Color(0xFF50413F),
      secondary: Color(0xFF7C6561),
      accent: Color(0xFF392E2D),
    ),
    "steel": TypePalette(
      primary: Color(0xFF60A1B8),
      secondary: Color(0xFF83B5C7),
      accent: Color(0xFF3E768A),
    ),
    "fairy": TypePalette(
      primary: Color(0xFFF170F1),
      secondary: Color(0xFFF598F5),
      accent: Color(0xFFE517E5),
    ),
  };

  static TypePalette getPalette(String type) {
    return palettes[type.toLowerCase()] ??
        TypePalette(
          primary: Colors.grey,
          secondary: Colors.grey.shade400,
          accent: Colors.grey.shade700,
        );
  }
}