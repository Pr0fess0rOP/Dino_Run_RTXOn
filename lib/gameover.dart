import 'package:dino_run/game.dart';
import 'package:flutter/material.dart';

class GameOver extends StatelessWidget {
  static const id = 'GameOver';
  final Dgame gameRef;
  const GameOver(this.gameRef, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            const Text(
              "Game Over Noobie! Replay?",
              style: TextStyle(color: Colors.black),
            ),
            TextButton.icon(
              label: const Text(""),
              onPressed: (){
                //function to restart the game
                reset();
                gameRef.playGame();
              }, 
              icon: const Icon(Icons.refresh),
            ),
        ],
      )
    );
  }

  void reset(){
    

  }
}