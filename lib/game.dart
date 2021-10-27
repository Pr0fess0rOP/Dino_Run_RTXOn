import 'dart:math';
import 'package:dino_run/Charaters/dinosprite.dart';
import 'package:dino_run/Charaters/enemies.dart';
import 'package:dino_run/hud.dart';
import 'package:dino_run/pause.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//this class calls the game features and contains the logic
class Dgame extends FlameGame with TapDetector, HasCollidables{
  
  late ParallaxComponent parallaxComponent;//store background images

  late Dino dino;//stores my main character sprite animation as object

  //late Timer spawner;//variable used in spawning enemy in a loop

  late ValueNotifier<int> life = ValueNotifier(3);//variable used to store number of lives left

  late TextComponent scoreText;//used to display score
  late int score;//used to store score

  //onLoad function in flame == runApp function in flutter 
  @override
  Future<void>? onLoad() async{
    
    //initiating and loading parallax components
    parallaxComponent = await loadParallaxComponent([
      ParallaxImageData('background/_11_background.png'),
      ParallaxImageData('background/_10_distant_clouds.png'),
      ParallaxImageData('background/_09_distant_clouds1.png'),
      ParallaxImageData('background/_08_clouds.png'),
      ParallaxImageData('background/_07_huge_clouds.png'),
      ParallaxImageData('background/_06_hill2.png'),
      ParallaxImageData('background/_05_hill1.png'),
      ParallaxImageData('background/_04_bushes.png'),
      ParallaxImageData('background/_03_distant_trees.png'),
      ParallaxImageData('background/_02_trees and bushes.png'),
      ParallaxImageData('background/_01_ground.png'),
    ],
    baseVelocity: Vector2(60, 0),//adding motion to parallax images
    velocityMultiplierDelta: Vector2(1.1, 0) //randomizing motion for different layers of parallax
    );
    add(parallaxComponent);//adding the object parallaxComponent on screen

    //saving animation of dino sprite in dino object coming from Dino class constructor
    dino = Dino();
    add(dino);//adding the object dino on screen

    //setting time for spawn of enemy on screen by calling enemySpawn() in a time based infinte loop
    /*spawner = Timer(
      2,
      callback: (){
        enemySpawn();//calling this function after 2 seconds of calling spawners
      }, 
      repeat: true
    );*/
    
    //add(Enemies(EnemyType.Pig));//initializing first enemy so that loop starts

    //initializing score
    score = 0;
    scoreText = TextComponent(score.toString(), 
    textRenderer: TextPaint(
      config: const TextPaintConfig(
        fontSize: 20,
        fontFamily: 'Audiowide-Regular',
        color: Colors.black54,
      )
    ),
    position: Vector2(100,10));//saving int score to string scoreText TextComponent
    scoreText.x = canvasSize.x/2 +10;
    scoreText.size = Vector2(25,20);
    add(scoreText);//adding score on screen

    return super.onLoad();
  }

  //calling jump function from dinosprite.dart whenever we touch the screen
  @override
  void onTapDown(TapDownInfo info) {
    dino.jump();
    super.onTapDown(info);
  }

  //function to spawn enemy on screen
  /*void enemySpawn(){
    var random = Random().nextInt(3);//choose
    var enemyType = EnemyType.values.elementAt(random);
    var enemy = Enemies(enemyType);
    add(enemy);
  }*/

  //Pause Game Function
  void pauseGame(){
    //overlays.remove(Hud.id);
    pauseEngine();
    overlays.add(Pause.id);
  }
  
  //Resume Game Function
  void playGame(){
    //overlays.add(Hud.id);
    resumeEngine();
    overlays.remove(Pause.id);
  }

  void reset(){
    score = 0;
    life.value == 3;
    dino.run(); 
  }

  @override
  void lifecycleStateChange(AppLifecycleState state){
    switch(state){
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        pauseGame();
        break;
      case AppLifecycleState.paused:
        pauseGame();
        break;
      case AppLifecycleState.detached:
        pauseGame();
        break;  
    }
  }

  //helps in setting size
  Future<void> setSize() async{
    
  }

  //anything in this function will update 60 times per second
  @override
  void update(double dt) {
    super.update(dt);

    score = score + (70*dt).toInt(); //updating score as the time passes
    scoreText.text = score.toString();//storing score to TextComponenet variable for displaying

    //when you lose all lives game stops
    if(life.value == -1){
      pauseEngine();
    }
    /*spawner.update(dt);*/
    
  }
}