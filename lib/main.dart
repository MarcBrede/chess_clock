import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'package:chess_clock/GlobalFiles/appState.dart';
import 'package:chess_clock/GamesList/scrollable_games_grid.dart';
import 'package:chess_clock/NewGame/new_game.dart';
import 'GlobalFiles/constants.dart' as Constants;
import 'package:chess_clock/Screens/settings_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      builder: (context) => AppState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    return Consumer<AppState>(builder: (context, appState, child) {
      return MaterialApp(
        title: Constants.APP_BAR_TITLE,
        theme: ThemeData(
          primarySwatch: appState.getColorTheme()['black'],
          accentColor: appState.getColorTheme()['accent'],
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                fontFamily: 'Opensans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: TextStyle(color: appState.getColorTheme()['background'])),
        ),
        home: MyHomePage(title: Constants.APP_BAR_TITLE),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.settings,
                color: appState.getColorTheme()['accent'],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SettingsScreen(
                          )),
                );
              },
            )
          ],
          backgroundColor: appState.getColorTheme()['background'],
          title: Text(widget.title,
              style: TextStyle(
                  fontSize: 20, color: appState.getColorTheme()['accent'])),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ScrollableGamesGrid(
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'btn2',
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (_) {
                  return NewGame(
                  );
                });
          },
          label: Text('Add custom game'),
          icon: Icon(Icons.add),
          backgroundColor: appState.getColorTheme()['accent'],
        ),
      );
    });
  }
}
