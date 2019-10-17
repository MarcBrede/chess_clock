library constants;

import './game.dart';
import 'package:flutter/material.dart';

const String APP_BAR_TITLE = "Chess Clock";
const List<Game> SELECTABLE_GAMES = [
  Game(
      name: 'Bullet I',
      timeWhite: Duration(minutes: 1),
      timeBlack: Duration(minutes: 1),
      incrementWhite: Duration(seconds: 0),
      incrementBlack: Duration(seconds: 0)),
  Game(
      name: 'Bullet II',
      timeWhite: Duration(minutes: 2),
      timeBlack: Duration(minutes: 2),
      incrementWhite: Duration(seconds: 1),
      incrementBlack: Duration(seconds: 1)),
  Game(
      name: 'Blitz I',
      timeWhite: Duration(minutes: 3),
      timeBlack: Duration(minutes: 3),
      incrementWhite: Duration(seconds: 2),
      incrementBlack: Duration(seconds: 2)),
  Game(
      name: 'Blitz II',
      timeWhite: Duration(minutes: 5),
      timeBlack: Duration(minutes: 5),
      incrementWhite: Duration(seconds: 0),
      incrementBlack: Duration(seconds: 0)),
  Game(
      name: 'Blitz III',
      timeWhite: Duration(minutes: 5),
      timeBlack: Duration(minutes: 5),
      incrementWhite: Duration(seconds: 3),
      incrementBlack: Duration(seconds: 3)),
  Game(
      name: 'Rapid',
      timeWhite: Duration(minutes: 10),
      timeBlack: Duration(minutes: 10),
      incrementWhite: Duration(seconds: 0),
      incrementBlack: Duration(seconds: 0)),
  Game(
      name: 'Classical',
      timeWhite: Duration(minutes: 15),
      timeBlack: Duration(minutes: 15),
      incrementWhite: Duration(seconds: 15),
      incrementBlack: Duration(seconds: 15)),
];

const colorsModern = {
  'black': Colors.blueGrey,
  'white': Colors.white,
  'accent': Colors.pink,
  'background': Color.fromRGBO(
    245,
    245,
    245,
    0.8,
  ),
};
const colorsClassic = {
  'black': // Color.fromRGBO(148, 114, 77, 1),
      Colors.brown,
  'white': Color.fromRGBO(255, 232, 186, 1),
  'accent': Colors.black,
  'background': Color.fromRGBO(
    245,
    245,
    245,
    0.8,
  ),
};
