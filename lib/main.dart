import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => showPopUp());
  }

  TextEditingController _player1 = TextEditingController();
  TextEditingController _player2 = TextEditingController();
  String player1Name = "Player1";
  String player2Name = "Player2";
  bool isTurnOne = true;
  List<int> player1Cells = [];
  List<int> player2Cells = [];
  List<TicTac> players = List.generate(9, (index) => TicTac(false));

  List<List<int>> winningCombinations = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6],
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8],
    [2, 4, 6],
  ];

  void showPopUp() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter the Players Name'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _player1,
                decoration: InputDecoration(
                  label: Text("First Player"),
                ),
              ),
              TextField(
                controller: _player2,
                decoration: InputDecoration(
                  label: Text("Second Player"),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  player1Name =
                      _player1.text.isNotEmpty ? _player1.text : "Player1";
                  player2Name =
                      _player2.text.isNotEmpty ? _player2.text : "Player2";
                });
                Navigator.of(context).pop();
              },
              child: const Text('Start Game'),
            ),
          ],
        );
      },
    );
  }

  void checkForWinner() {
    for (var combination in winningCombinations) {
      if (combination.every((index) => player1Cells.contains(index))) {
        showWinnerDialog(player1Name);
        return;
      } else if (combination.every((index) => player2Cells.contains(index))) {
        showWinnerDialog(player2Name);
        return;
      }
    }

    if (player1Cells.length + player2Cells.length == 9) {
      showWinnerDialog("No one");
    }
  }

  void showWinnerDialog(String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('$winner wins!'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  resetGame();
                });
                Navigator.of(context).pop();
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    player1Cells.clear();
    player2Cells.clear();
    players = List.generate(9, (index) => TicTac(false));
    isTurnOne = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1c1f7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    player1Name,
                    style: TextStyle(
                        color: Color(0xff842f8f),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Vs",
                    style: TextStyle(
                        color: Color(0xff842f8f),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    player2Name,
                    style: TextStyle(
                        color: Color(0xff842f8f),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Player Turn: ${isTurnOne ? player1Name : player2Name}",
                    style: TextStyle(
                        color: Color(0xff842f8f),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: 9,
                padding: EdgeInsets.only(top: 50),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (!players[index].isClicked) {
                          players[index].isClicked = true;
                          if (isTurnOne) {
                            player1Cells.add(index);
                            isTurnOne = false;
                          } else {
                            player2Cells.add(index);
                            isTurnOne = true;
                          }
                        }
                      });
                      checkForWinner();
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff842f8f),
                      ),
                      child: Icon(
                        player1Cells.contains(index)
                            ? Icons.circle
                            : player2Cells.contains(index)
                                ? Icons.rectangle_outlined
                                : null,
                        color: Colors.white,
                        size: 48.0,
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                height: 67,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff9c17ad),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      resetGame();
                    });
                  },
                  child: Text(
                    "Reset",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff9c17ad),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class TicTac {
  bool isClicked;
  TicTac(this.isClicked);
}
