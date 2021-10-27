import 'package:dino_run/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//this is not a flame file it is a widget flutter file with stateless widget
class Pause extends StatelessWidget {
  static const id = 'Pause';
  final Dgame gameRef;
  const Pause(this.gameRef, {Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,//alignment of row
      children: [
        //when paused textbutton is presesd from Hud.dart
        TextButton.icon(
          label: const Text(""),
          onPressed: (){
          gameRef.reset();
          }, 
          icon: const Icon(Icons.refresh, size: 90,),
        ),
        TextButton.icon(
          label: const Text(""),
          onPressed: (){
            gameRef.playGame();
          }, 
          icon: const Icon(Icons.play_arrow, size: 100,),
        ),
      ],
    )
    ;
  }
}