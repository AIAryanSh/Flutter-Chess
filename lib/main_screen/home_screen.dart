//import "package:bishop/bishop.dart";
import "dart:math";

import "package:bishop/bishop.dart" as bishop;
import "package:flutter/material.dart";
import "package:flutter/painting.dart";
import "package:flutter/widgets.dart";
import "package:square_bishop/square_bishop.dart";
import "package:squares/squares.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late bishop.Game game;
  late SquaresState state;
  int player = Squares.white;
  bool aiThinking = false;
  bool flipBoard = false;

  @override
  void initState() {
    _resetGame(false);
    super.initState();
  }

  void _resetGame([bool ss = true]) {
    game = bishop.Game(variant: bishop.Variant.standard());
    state = game.squaresState(player);
    if (ss) setState(() {});
  }

  void _flipBoard() => setState(() => flipBoard = !flipBoard);

  void _onMove(Move move) async {
    bool result = game.makeSquaresMove(move);
    if (result) {
      setState(() => state = game.squaresState(player));
    }
    if (state.state == PlayState.theirTurn && !aiThinking) {
      setState(() => aiThinking = true);
      await Future.delayed(
          Duration(milliseconds: Random().nextInt(4750) + 250));
      game.makeRandomMove();
      setState(() {
        aiThinking = false;
        state = game.squaresState(player);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 90, 129, 148),
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          'CHESS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          ),
        actions: [],
        backgroundColor: Color.fromARGB(255, 36, 68, 84),
        elevation: 10,
        shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
        ),
        ),),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: BoardController(
                state: flipBoard ? state.board.flipped() : state.board,
                playState: state.state,
                pieceSet: PieceSet.merida(),
                theme: BoardTheme.blueGrey,
                moves: state.moves,
                onMove: _onMove,
                onPremove: _onMove,
                markerTheme: MarkerTheme(
                  empty: MarkerTheme.dot,
                  piece: MarkerTheme.corners(),
                ),
                promotionBehaviour: PromotionBehaviour.autoPremove,
              ),
            ),
            SizedBox(height: 32,),
            
            OutlinedButton(
              onPressed: _resetGame,
              child: Text(
                'New Game',
                style: TextStyle(
                  color: Colors.white
                ),
                ),
                style: ButtonStyle(
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                    (Set<MaterialState> states) {
                      return BorderSide(color: Colors.white); // Change border color here
                    },
                  ),
                ),
              ),
            
            
            IconButton(
              onPressed: _flipBoard,
              icon: const Icon(Icons.rotate_left, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}