import 'package:flame/game.dart';
import 'package:flutter/material.dart';

// Device constants
const double kScreenWidth = 1080;
const double kScreenHeight = 900;

// Text styles
final _style = const TextStyle(
    color: Colors.white, fontSize: 20, fontFamily: 'MarioRegular');
final kRegular = TextPaint(style: _style);
final kBiggerText = TextPaint(style: _style.copyWith(fontSize: 32));
