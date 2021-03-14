import 'dart:math';
import 'package:flutter/material.dart';
import 'Timer.dart';
import 'game_button.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  final Dependencies dependencies = new Dependencies();
  List<GameButton> buttonsList;
  var gamePlayer;
  var statePlayer = 1;
  var bayrak = 1;
  var buttonText;
  String bestScore = "0";
  var score = 9999999;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    buttonsList = doInit();
    dependencies.stopwatch.start();
  }

  List<GameButton> doInit() {
    //oyundaki gereken değerlere ilk değerleri atar
    buttonText = new List();
    gamePlayer =
        new List(); //bu liste, oyuncunun işlem yaptığı butonların id leri ile dolacaktır
    statePlayer = 1;
    var buttons = <GameButton>[
      new GameButton(id: 1, text: rndm()),
      new GameButton(id: 2, text: rndm()),
      new GameButton(id: 3, text: rndm()),
      new GameButton(id: 4, text: rndm()),
      new GameButton(id: 5, text: rndm()),
      new GameButton(id: 6, text: rndm()),
      new GameButton(id: 7, text: rndm()),
      new GameButton(id: 8, text: rndm()),
      new GameButton(id: 9, text: rndm()),
      new GameButton(id: 10, text: rndm()),
      new GameButton(id: 11, text: rndm()),
      new GameButton(id: 12, text: rndm()),
      new GameButton(id: 13, text: rndm()),
      new GameButton(id: 14, text: rndm()),
      new GameButton(id: 15, text: rndm()),
      new GameButton(id: 16, text: rndm()),
      new GameButton(id: 17, text: rndm()),
      new GameButton(id: 18, text: rndm()),
      new GameButton(id: 19, text: rndm()),
      new GameButton(id: 20, text: rndm()),
      new GameButton(id: 21, text: rndm()),
      new GameButton(id: 22, text: rndm()),
      new GameButton(id: 23, text: rndm()),
      new GameButton(id: 24, text: rndm()),
      new GameButton(id: 25, text: rndm()),
    ];
    return buttons;
  }

  void playGame(GameButton gb) {
    setState(() {
      if (statePlayer <= 25) {
        if (int.parse(gb.text) == statePlayer) {
          //gb.text = gb.id;
          gb.color = Colors.red;
          gamePlayer.add(gb.id);
          statePlayer++;
        }
      }
      if (statePlayer == 26) {
        dependencies.stopwatch.stop();
        if (dependencies.stopwatch.elapsedMilliseconds < score) {
          bestScore = "${dependencies.stopwatch.elapsedMilliseconds}";
          score = dependencies.stopwatch.elapsedMilliseconds;
        }
      }
    });
  }

  String rndm() {
    var r = new Random();
    while (true) {
      var randIndex = r.nextInt(
          26); // 1 den 25 e kadar random dönecek bir fonk var      index=12
      if (randIndex != 0 && !buttonText.contains(randIndex)) {
        buttonText.add(randIndex);
        String a = randIndex.toString();
        return a;
      }
    }
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
      dependencies.stopwatch.reset();
      dependencies.stopwatch.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Schuttle Table"),
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Expanded(
              child: new GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 1.0,
                    mainAxisSpacing: 1.0),
                itemCount: buttonsList.length,
                itemBuilder: (context, i) => new SizedBox(
                  width: 50.0,
                  height: 50.0,
                  child: new RaisedButton(
                    padding: const EdgeInsets.all(8.0),
                    onPressed: () => playGame(buttonsList[i]),
                    child: new Text(
                      buttonsList[i].text,
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: buttonsList[i].color,
                    disabledColor: buttonsList[i].color,
                  ),
                ),
              ),
            ),
            new Expanded(
              flex: 0,
              child: new Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Timers(dependencies: dependencies),
                    Text(
                      "Best Score : $bestScore",
                      style: new TextStyle(color: Colors.black, fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
            new RaisedButton(
              child: new Text(
                "Replay",
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              color: Colors.red,
              disabledColor: Colors.red,
              padding: const EdgeInsets.all(20.0),
              onPressed: resetGame,
            )
          ],
        ));
  }
}
