import 'package:dino_run/game.dart';
import 'package:dino_run/gameover.dart';
import 'package:dino_run/hud.dart';
import 'package:dino_run/pause.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

//Main Run App
void main() async{
  WidgetsFlutterBinding.ensureInitialized();//functions below will be executed in order before game is started
  await Flame.device.fullScreen();//making the game fulllscreen
  await Flame.device.setLandscape();//portrait to lanscape orientation
  runApp(const MyApp());
}

//stateless widget that will be called in main() => runApp()
class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameWidget(//returning game widget provided by flame
      game: Dgame(), 
      overlayBuilderMap: {//making an overlay of flutter container over flame game on screen
        Hud.id : (_,Dgame gameRef ) => Hud(gameRef), //calling Hud class for container
        Pause.id : (_,Dgame gameRef ) => Pause(gameRef),//calling Pause class for container
        GameOver.id : (_,Dgame gameRef ) => GameOver(gameRef),//calling GameOver class for container
      },
      initialActiveOverlays: const [Hud.id], //activating overlay right from start
    )
    ;
  }
}