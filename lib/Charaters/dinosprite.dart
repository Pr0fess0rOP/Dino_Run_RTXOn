import 'package:dino_run/Charaters/enemies.dart';
import 'package:dino_run/game.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';

class Dino extends SpriteAnimationComponent with HasGameRef<Dgame>, Hitbox, Collidable{

  late SpriteAnimation idleAnimation; //stores idle animation
  late SpriteAnimation jumpAnimation; //stores jump animation
  late SpriteAnimation runAnimation; //stores run animation
  late SpriteAnimation hitAnimation; //stores hit animation

  double gravity = 1000; //just a variable used to describe gravity
  double speedY = 0; //speed of sprite in vertical direction
  double yMax = 0; //max possible vertical distance so that our character dont fall below the ground level

  bool isHurting = false; //boolean variable checking if my character is currently hurting or not
  late Timer hurtTimer; //variable used for defining how much time with the dino hurt

  @override
  Future<void>? onLoad() async{
    final tardImage = await Flame.images.load('DinoSprites - tard.png'); //imports and stores the png format of the sprite sheet
    final tardSprite = SpriteSheet(image: tardImage, srcSize: Vector2(24,24)); //converts and stores the sprite format of the png

    idleAnimation = tardSprite.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 3); //creating and storing idle animation
    
    runAnimation = tardSprite.createAnimation(row: 0, stepTime: 0.1, from: 4, to: 10); //creating and storing run animation

    jumpAnimation = tardSprite.createAnimation(row: 0, stepTime: 0.1, from: 12, to: 14); //creating and storing jump animation

    hitAnimation = tardSprite.createAnimation(row: 0, stepTime: 0.1, from: 15,to: 17); //creating and storing hit animation

    animation = runAnimation; //default starting the game by character's run animation

    debugMode = true; //uncomment this to display hit boxes

    // adding hit box for character of using polygon method 
    addHitbox(HitboxPolygon([
      Vector2(-0.6, 0.6),
      Vector2(0.6, 0.6),
      Vector2(0.6, -0.6),
      Vector2(-0.6, -0.6),
    ]));

    //setting how much time will my character is hurting i.e how much time will the hit() work.
    hurtTimer  = Timer(
      0.8,//0.8 seconds chosen because thats amount of time our enemy and character hit box are in contact when collided
      callback: (){
        isHurting = false;//setting isHurting flase after 0.8 seconds of calling hurtTimer
        run();//calling run() after 0.8 seconds of calling hurtTimer
      }
    );

    //calling setSize to set character size
    await setSize();

    return super.onLoad();
  }

  //what happens when hit boxes touch / overlap
  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    
    //if both hitboxes are collidable then
    if(other is Enemies){
      //and if our character is not hurting then
      if(!isHurting){
        //we call hit() => changes animation to hitAnimation, decreases a life and sets isHurting true
        hit();
        //and start hurtTimer that after 0.8 seconds will do callback() => changes animation to runAnimation and sets isHurting false
        hurtTimer.start();
      }
    }
    super.onCollision(intersectionPoints, other);
  }
  
  //checking whether character is touching our ground level i.e yMax or not
  bool isOnGround(){
    return (y >= yMax);
  }

  //instantaneously changes vertical speed of character if it is touching ground
  void jump(){
    if(isOnGround()){
      speedY = -550;
    }
  }

  //when two hitboxes collide we call hit() following things happen
  void hit(){
    animation = hitAnimation; //converting animation to hitAnimation
    isHurting = true; //convert isHurting to true as hitboxes collide
    gameRef.life.value -= 1; //decreasing a life on each hit
  }

  //default running animation function where all default animation and isHurting are re initialized
  void run(){
    animation = runAnimation;
    isHurting = false;
  }

  //setting size of character wrt to screen size
  Future<void> setSize() async{

    height = gameRef.canvasSize.x/10;
    width = gameRef.canvasSize.x/10;

    x = 150; y = gameRef.canvasSize.y/1.6; //setting position of character on screen
    
    yMax = y;//fixing a ground level
  }

  //anything in this function will update 60 times per second
  @override
  void update(double dt) {
    super.update(dt);

    //this will be seen in effect(but is always being applied) after we tap screen and call jump()
    speedY = speedY + gravity*dt; //applying gravtiy always
    y = y + speedY*dt;   //updating the distance along wrt speed (Moving the character)

    //if character is on ground level then we revert speedY back to 0 and set y to yMax
    if (isOnGround()){
      y = yMax;
      speedY = 0;
    }

    //updates hurt timer
    hurtTimer.update(dt);
  }

}
