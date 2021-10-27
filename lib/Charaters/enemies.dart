import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import '../game.dart';

//enumeration of three enemies
enum EnemyType {Pig, Bat, Rino}

//constructor for sprite data of enemies
class ImageData{
  final imagePath;
  final to;
  final from;
  final srcSize;
  
  ImageData(
      {@required this.imagePath,
      @required this.to,
      @required this.from,
      @required this.srcSize}
  );
}

//constructor for details of enemies
class EnemyData {

  final ImageData? runImageData;
  final enemySpeed;
  final enemyDamage;
  final canFly;

  EnemyData(

      {@required this.runImageData,
      @required this.enemyDamage,
      @required this.enemySpeed,
      @required this.canFly});
}

//main class of this dart file
class Enemies extends SpriteAnimationComponent with Hitbox, Collidable, HasGameRef<Dgame>{
  
  late SpriteAnimation runAnimation;//stores run animation

  late EnemyData enemyData; //constructor enemyData
  late double enemySpeed; //constructor enemySpeed
  late double enemyDamage; //constructor enemyDamage

  late Vector2 hitBox; //a hitbox vector???

  //mapping enemyType and EnemyData contructor
  static Map<EnemyType, EnemyData> enemyDetails = {

    //for pig
    EnemyType.Pig: EnemyData(
        runImageData: ImageData(
            imagePath: 'enemy/AngryPig/Walk (36x30).png',
            to: 16,
            from: 1,
            srcSize: Vector2(36, 30)),
        enemyDamage: 0.051,
        enemySpeed: 200.0,
        canFly: false),
    
    //for bat
    EnemyType.Bat: EnemyData(
        runImageData: ImageData(
            imagePath: 'enemy/Bat/Flying (46x30).png',
            to: 7,
            from: 1,
            srcSize: Vector2(46, 30)),
        enemyDamage: 0.051,
        enemySpeed: 200.0,
        canFly: true),

    //for rino
    EnemyType.Rino: EnemyData(
        runImageData: ImageData(
            imagePath: 'enemy/Rino/Run (52x34).png',
            to: 6,
            from: 1,
            srcSize: Vector2(52, 34)),
        enemyDamage: 0.051,
        enemySpeed: 200.0,
        canFly: false),
  };

  //constructor for this very class
  Enemies(EnemyType enemyType) {
    enemyData = enemyDetails[enemyType]!;
    enemySpeed = enemyData.enemySpeed;
    enemyDamage = enemyData.enemyDamage;
  }

  //
  @override
  Future<void>? onLoad() async{
    
    final runImage = await Flame.images.load(enemyData.runImageData!.imagePath);

    debugMode = true; //uncomment this to display hit boxes

    anchor = Anchor.bottomRight; //sets default (0,0) to bottom right for this file

    //create and store animation of enemy running
    runAnimation =
        SpriteSheet(image: runImage, srcSize: enemyData.runImageData!.srcSize)
            .createAnimation(
              row: 0,
              stepTime: 0.1,
              from: enemyData.runImageData!.from,
              to: enemyData.runImageData!.to
            );
    
    animation = runAnimation; //default starting the game by enemy's run animation

    addHitbox(HitboxPolygon([
      Vector2(-0.6, 0.6),
      Vector2(0.6, 0.6),
      Vector2(0.6, -0.6),
      Vector2(-0.6, -0.6),
    ])); //adding hit box for character of using rectangle method  
    
    await setSize();

    return super.onLoad();
  }

  //activating spawner from game.dart
  @override
  void onMount() {
    super.onMount();
    //gameRef.spawner.start();
  } 

  Future<void> setSize() async{
    var scale = (gameRef.canvasSize.x/10)/enemyData.runImageData!.srcSize.x; //preparing scale to resize enemies generally

    height = (enemyData.runImageData!.srcSize.y)*scale;//scalling height
    width = (enemyData.runImageData!.srcSize.x)*scale;//scaling width

    x = 1000; y = gameRef.canvasSize.x/2.6;//start position of walking enemies

    if(enemyData.canFly){
      y = y - 110;//starting position of flying enemies
    }
  }

  //anything in this function will update 60 times per second
  @override
  void update(double dt) {
    super.update(dt);

    //changing position of enemy wrt speed (Moving the Enemy)
    x = x - enemySpeed*dt;
    
    //if enemy goes out of screen
    if(x < (-width)){
      gameRef.remove(this);//remove that instance so that ram remains free
    }
  }
}
