import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components/animation_component.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

math.Random rng = new math.Random();

void main() async {
  await Flame.init();
  await Flame.images.loadAll(['Dog_running.png', 'cloud.png']);
  final game = MyGame();
  runApp(game.widget);
}

class Palette {
  static const PaletteEntry white = BasicPalette.white;
  static const PaletteEntry black = BasicPalette.black;
  static const PaletteEntry blue = PaletteEntry(Color(0xFF73B8E2));
  static const PaletteEntry whiteAlpha = PaletteEntry(Color(0x88FFFFFF));
}

class Cloud extends SpriteComponent with HasGameRef<MyGame>, Resizable {
  // int alpha;
  double speed;
  Cloud()
      : super.rectangle(rng.nextDouble() * 200 + 50,
            rng.nextDouble() * 200 + 50, 'cloud.png') {
    // 速度、位置、透明度、大きさをrandom
    var rng = new math.Random();
    // this.alpha = rng.nextInt(255);
    // this.x = gameRef.size.width + 250.0;
    // this.x = 0;
    this.x = 1000;
    this.y = rng.nextDouble() * 200;
    // this.y = 0;
    this.speed = rng.nextDouble();
  }

  @override
  void render(Canvas c) {
    // render無いと描画されない
    super.render(c);
  }

  @override
  void update(double t) {
    super.update(t);
    this.x -= this.speed;
    print(this.x);
    if (this.x < -250.0) {
      this.destroy();
      print("destroyed");
    }
  }
}

class Dog extends AnimationComponent with HasGameRef<MyGame> {
  final double fallSpeed = 1.0;
  final double jumpSpeed = 10.0;
  double ySpeed = 0.0;
  static double dogHeight = 48.0;
  static double dogWidth = 72.0;

  Dog()
      : super.sequenced(
          dogWidth,
          dogHeight,
          'Dog_running.png',
          6,
          textureWidth: dogWidth,
          textureHeight: dogHeight,
          stepTime: 0.1,
          loop: true,
        );

  void jump() {
    this.ySpeed = -jumpSpeed;
  }

  @override
  void render(Canvas c) {
    super.render(c);
  }

  @override
  void update(double t) {
    super.update(t);
    this.y = this.y + this.ySpeed;
    this.ySpeed += this.fallSpeed;
    if (this.y > MyGame.initialY) {
      ySpeed = 0;
    }
    // this.angle += 0.1;

    // angle += SPEED * t;
    // angle %= 2 * math.pi;
  }

  @override
  void onMount() {
    // width = height = gameRef.squareSize;
    this.anchor = Anchor.center;
  }
}

class MyGame extends BaseGame with TapDetector {
  static double initialX = 200;
  static double initialY = 200;
  Dog dog = Dog()
    ..x = initialX
    ..y = initialY;
  MyGame() {
    add(dog);
    add(Cloud());
  }
  @override
  void onTapDown(TapDownDetails details) {
    dog.jump();
    print(details);
    super.onTapDown(details);
  }

  @override
  void render(Canvas c) {
    // c.drawRect(
    // Rect.fromLTWH(0, 0, size.width, size.height), Palette.blue.paint);
    // c.drawRect(
    //     Rect.fromLTWH(0, initialY + Dog.dogHeight, size.width, size.height),
    //     Palette.black.paint);
    // c.drawRect(
    //     Rect.fromLTWH(
    //         0, initialY + (Dog.dogHeight / 2), size.width, size.height),
    //     Palette.black.paint);
    super.render(c);
  }

  @override
  void update(double t) {
    super.update(t);
    // var rng = new math.Random();
    if (rng.nextInt(1000) < 20) {
      add(Cloud());
      print("added");
    }
  }
  // @override
  // void onTapUp(details) {
  //   dog.jump();
  // final touchArea = Rect.fromCenter(
  //   center: details.localPosition,
  //   width: 20,
  //   height: 20,
  // );

  // bool handled = false;
  // components.forEach((c) {
  //   if (c is PositionComponent && c.toRect().overlaps(touchArea)) {
  //     handled = true;
  //     markToRemove(c);
  //   }
  // });

  // if (!handled) {
  //   addLater(Square()
  //     ..x = touchArea.left
  //     ..y = touchArea.top);
  // }
  // }
}
