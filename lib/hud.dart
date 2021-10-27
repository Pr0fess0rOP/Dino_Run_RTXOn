import 'package:dino_run/game.dart';
import 'package:flutter/material.dart';

//this is not a flame file it is a widget flutter file with stateful widget
class Hud extends StatefulWidget {
  static const id = 'Hud';
  final Dgame gameRef;
  const Hud(this.gameRef, {Key? key}) : super(key: key);

  @override
  State<Hud> createState() => _HudState();
}

//main class of this file
class _HudState extends State<Hud> {

  var gamePaused = false; //variable to save if game is paused or not

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,//alignment of row
      children: [
        //pause and play iconButtons
        TextButton.icon(
          label: const Text(""),
          onPressed: (){
            if(gamePaused){
              widget.gameRef.playGame();//resumes game
              const Text("Paused", style: TextStyle(fontSize: 50, backgroundColor: Colors.black),);
            }
            else{
              widget.gameRef.pauseGame();//pauses game
            }
            setState(() {
              gamePaused = !gamePaused;
            });
          }, 
          icon: Icon(gamePaused? Icons.play_arrow : Icons.pause)
        ),

        //just a text
        /*const Text(
          "Score: ",
          style: TextStyle(color: Colors.black),
        ),*/

        //the life system thingy ?
        ValueListenableBuilder(valueListenable: widget.gameRef.life, builder: (_, int value, __){

          final health = <Widget>[];

          for(int i = 0; i < 3; i++){
            health.add(Icon( (i < value) ?  Icons.favorite : Icons.favorite_border_outlined, color: Colors.redAccent,));
          }
          
          return Row(
            children: health,
          );
        })
      ],
    );
  }
}