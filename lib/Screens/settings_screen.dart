import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:launch_review/launch_review.dart';

import 'package:chess_clock/GlobalFiles/appState.dart';

//Settings screen
class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> title = ['Theme', 'Vibration', 'Rate this app'];
  List<String> content = [
    'choose a different theme',
    'customize the haptic feedback',
    'give this app a rating in the Play Store',
  ];

  showThemeDialog(BuildContext context, Function setColorTheme) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Theme'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('modern'),
                onPressed: () {
                  setColorTheme(true);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                  child: Text('classic'),
                  onPressed: () {
                    setColorTheme(false);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  showVibrationDialog(BuildContext context, Function setVibration) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Vibration'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Vibration on'),
                onPressed: () {
                  setVibration(true);
                  Navigator.pop(context);
                },
              ),
              SimpleDialogOption(
                  child: Text('Vibration off'),
                  onPressed: () {
                    setVibration(false);
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  void linkToAppStore() {
    LaunchReview.launch();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appState.getColorTheme()['background'],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: appState.getColorTheme()['black'],
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            title: Text(
              'Settings',
              style: TextStyle(color: appState.getColorTheme()['accent']),
            ),
          ),
          body: Container(
            padding: EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: title.length,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    if (index == 0) {
                      showThemeDialog(context, appState.setColorTheme);
                    }
                    if (index == 1) {
                      showVibrationDialog(context, appState.setVibration);
                    }
                    if (index == 2) {
                      linkToAppStore();
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1,
                                color: appState.getColorTheme()['black']))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(title[index]),
                        Text(
                          content[index],
                          style: TextStyle(
                              color: appState.getColorTheme()['black']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
