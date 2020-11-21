import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/anchor.dart';
import 'package:flame/gestures.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

void main() async {
  await Flame.init();
  await Flame.images.loadAll(['Dog_running.png']);
  final game = MyGame();
  runApp(game.widget);
}

class Palette {
  static const PaletteEntry white = BasicPalette.white;
  static const PaletteEntry black = BasicPalette.black;
  // static const PaletteEntry red = PaletteEntry(Color(0xFFFF0000));
  // static const PaletteEntry blue = PaletteEntry(Color(0xFF0000FF));
}

class Dog extends SpriteComponent with HasGameRef<MyGame> {
  static const ANIMATION_SPEED = 4; // move sprite

Dog() :
  super.rectangle(72, 48, 'Dog_running.png',)

  @override
  void render(Canvas c) {
    super.render(c);
  }

  @override
  void update(double t) {
    super.update(t);
    angle += SPEED * t;
    angle %= 2 * math.pi;
  }

  @override
  void onMount() {
    width = height = gameRef.squareSize;
    // anchor = Anchor.center;
  }
}

class MyGame extends BaseGame with TapDetector {
  MyGame() {
    add(Square()
      ..x = 100
      ..y = 100);
  }

  @override
  void onTapUp(details) {
    final touchArea = Rect.fromCenter(
      center: details.localPosition,
      width: 20,
      height: 20,
    );

    bool handled = false;
    components.forEach((c) {
      if (c is PositionComponent && c.toRect().overlaps(touchArea)) {
        handled = true;
        markToRemove(c);
      }
    });

    if (!handled) {
      addLater(Square()
        ..x = touchArea.left
        ..y = touchArea.top);
    }
  }
}
