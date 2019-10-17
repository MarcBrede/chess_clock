import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chess_clock/Screens/second_Screen.dart';
import 'package:chess_clock/GlobalFiles/appState.dart';

//This widget builds the list on the main-screen in which shows the default and the custom games.
class ScrollableGamesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 2 / 2,
          crossAxisSpacing: 0.5,
          mainAxisSpacing: 1,
        ),
        itemCount: appState.getGamesList().length,
        itemBuilder: (ctx, index) {
          return GestureDetector(
            child: Card(
                color: appState.getColorTheme()['background'],
                elevation: 2,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(appState.getGamesList()[index].name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color:
                                          appState.getColorTheme()['accent'])),
                            ),
                          ),
                          if (index > 6)
                            Padding(
                              padding: EdgeInsets.all(4),
                              child: GestureDetector(
                                child: Icon(
                                  Icons.clear,
                                  color: appState.getColorTheme()['accent'],
                                  size: 20,
                                ),
                                onTap: () => appState.deleteGame(index),
                              ),
                            ),
                        ],
                      ),
                      Expanded(
                        child: Card(
                          color: appState.getColorTheme()['white'],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.timer,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    appState
                                        .getGamesList()[index]
                                        .timeWhite
                                        .inMinutes
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.arrow_upward,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    appState
                                        .getGamesList()[index]
                                        .incrementWhite
                                        .inSeconds
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          color: appState.getColorTheme()['black'],
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.timer,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    appState
                                        .getGamesList()[index]
                                        .timeBlack
                                        .inMinutes
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.arrow_upward,
                                      size: 20,
                                    ),
                                  ),
                                  Text(
                                    appState
                                        .getGamesList()[index]
                                        .incrementBlack
                                        .inSeconds
                                        .toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ])),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SecondScreen(
                          game: appState.getGamesList()[index],
                          currentColor: appState.getColorTheme(),
                          shouldVibrate: appState.getVibration(),
                        )),
              );
            },
          );
        },
      );
    });
  }
}
