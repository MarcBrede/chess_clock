import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './game.dart';
import 'constants.dart' as Constants;

//This file manages all the global properties: the gamelist, vibration and the theme.
//Everytime a property gets updated notifyListeners gets called and the necessary Widgets get rebuild.
class AppState extends ChangeNotifier {
  SharedPreferences _prefs;
  Map<String, Color> _colorTheme;
  List<Game> _gamesList = [];
  bool _vibration;

//------------------------------- Theme --------------------------------
  void setColorTheme(bool isModern) async {
    _prefs = await SharedPreferences.getInstance();
    if (isModern) {
      _colorTheme = Constants.colorsModern;
      _prefs.setBool('isModern', true);
    } else {
      _colorTheme = Constants.colorsClassic;
      _prefs.setBool('isModern', false);
      _colorTheme = Constants.colorsClassic;
    }
    notifyListeners();
  }

  Map<String, Color> getColorTheme() {
    if (_colorTheme == null) {
      _initColorTheme();
      return Constants.colorsModern;
    }
    return _colorTheme;
  }

  void _initColorTheme() async {
    _prefs = await SharedPreferences.getInstance();
    bool isModern = _prefs.getBool('isModern');
    if (isModern == null) {
      _colorTheme = Constants.colorsModern;
    } else {
      if (isModern) {
        _colorTheme = Constants.colorsModern;
      } else {
        _colorTheme = Constants.colorsClassic;
      }
    }
    notifyListeners();
  }

//------------------------------- Gamelist --------------------------------
  void addGame(String name, Duration timeWhite, Duration timeBlack,
      Duration incrementWhite, Duration incrementBlack) {
    Game newGame = Game(
        name: name,
        timeWhite: timeWhite,
        timeBlack: timeBlack,
        incrementWhite: incrementWhite,
        incrementBlack: incrementBlack);
    _gamesList.add(newGame);
    _safeGames();
    notifyListeners();
  }

  void _safeGames() async {
    List<String> newGamesList = [];
    _gamesList.forEach((g) {
      newGamesList.add(_getStringRep(g));
    });
    _prefs = await SharedPreferences.getInstance();
    _prefs.setStringList('gamesList', newGamesList);
  }

  String _getStringRep(Game game) {
    return '${game.name}§${game.timeWhite.inMilliseconds}§${game.timeBlack.inMilliseconds}§${game.incrementWhite.inMilliseconds}§${game.incrementBlack.inMilliseconds}';
  }

  List<Game> getGamesList() {
    if (_gamesList.length == 0) {
      _initGamesList();
    }
    return _gamesList;
  }

  void _initGamesList() async {
    _prefs = await SharedPreferences.getInstance();
    List<String> gamesStringList = _prefs.getStringList('gamesList');
    if (gamesStringList == null) {
      Constants.SELECTABLE_GAMES.forEach((g) {
        _gamesList.add(g);
      });
    } else {
      gamesStringList.forEach((gS) {
        _gamesList.add(_makeGame(gS));
      });
    }
    notifyListeners();
  }

  Game _makeGame(String gameString) {
    List<String> gameList = gameString.split('§');
    return Game(
        name: gameList[0],
        timeWhite: Duration(milliseconds: int.parse(gameList[1])),
        timeBlack: Duration(milliseconds: int.parse(gameList[2])),
        incrementWhite: Duration(milliseconds: int.parse(gameList[3])),
        incrementBlack: Duration(milliseconds: int.parse(gameList[4])));
  }

  void deleteGame(index) {
    if (index < 7) return;
    _gamesList.removeAt(index);
    _safeGames();
    notifyListeners();
  }

//------------------------------- Vibration --------------------------------
  bool getVibration() {
    if (_vibration == null) {
      _initVibration();
    }
    return _vibration;
  }

  void _initVibration() async {
    _prefs = await SharedPreferences.getInstance();
    _vibration = _prefs.getBool('vibration');
    if (_vibration == null) {
      setVibration(false);
    }
  }

  void setVibration(shouldVibrate) async {
    _vibration = shouldVibrate;
    _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('vibration', _vibration);
  }
}
