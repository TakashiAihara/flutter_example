import 'dart:collection';
import 'dart:ui';
import 'dart:core';

import 'package:reflectable/reflectable.dart';
import 'package:flutter/semantics.dart';
import 'package:forge2d/forge2d.dart';
import 'package:flame/gestures.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flame_forge2d/sprite_body_component.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:flame/components/component.dart';
import 'package:flame/components/text_component.dart';
import 'package:flame/text_config.dart';
import 'package:flame/palette.dart';
import 'package:flame/anchor.dart';

import 'boundaries.dart';

class MyReflectable extends Reflectable {
  const MyReflectable() : super(invokingCapability);
}

const myReflectable = MyReflectable();

class Pizza extends SpriteBodyComponent with hasLoadableImage {
  static Image _pizzaImage;
  // super.imagePath = "test";
  final Vector2 _position;
  final bodyType;

  // Pizza(this.imagePath, this.bodyType, this._position, Image image) : super(Sprite(image), Vector2(5, 5));
  Pizza(this.bodyType, this._position, Image image) : super(Sprite(image), Vector2(5, 5));

  @override
  void update(double dt) {
    body.applyForceToCenter(Vector2(30.0, 0.0));
    super.update(dt);
  }

  @override
  Body createBody() {
    final PolygonShape shape = PolygonShape();

    final v1 = Vector2(0, size.y / 2);
    final v2 = Vector2(size.x / 2, -size.y / 2);
    final v3 = Vector2(-size.x / 2, -size.y / 2);
    final vertices = [v1, v2, v3, v2];
    shape.set(vertices, vertices.length);

    final fixtureDef = FixtureDef();
    fixtureDef.setUserData(this); // To be able to determine object in collision
    fixtureDef.shape = shape;
    fixtureDef.restitution = 0.0;
    fixtureDef.density = 0.0;
    fixtureDef.friction = 0.2;

    final bodyDef = BodyDef();
    bodyDef.position = viewport.getScreenToWorld(_position);
    bodyDef.angle = (_position.x + _position.y) / 2 * 3.14;
    // bodyDef.type = BodyType.DYNAMIC;
    bodyDef.type = bodyType;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  String toString() {
    // return "[" + _position.x.toString() + "," + _position.y.toString() + "]";
    return body.linearVelocity.toString();
  }
}

mixin hasLoadableImage {
  // TODO finalにしたい
  static Image image;

  // TODO finalにしたい
  static String imagePath;
}

class Debugger {
  List<Object> list = List<Object>();
  Debugger();
  TextComponent scoreTime =
      TextComponent("test", config: TextConfig(color: BasicPalette.white.color, fontSize: 10))
        ..anchor = Anchor.topLeft;

  void displayDebug(Vector2 camera, Forge2DGame game, Canvas c) {
    scoreTime
      ..x = camera.x
      ..y = camera.y
      ..text = list.join('\n');
    game.renderComponent(c, scoreTime);
  }

  void add(Object o) {
    list.add(o);
  }
}

class SpriteBodySample extends Forge2DGame
    with TapDetector, SecondaryTapDetector, LongPressDetector {
  Image _pizzaImage;
  Pizza player;
  Debugger debug;

  SpriteBodySample(Vector2 viewportSize)
      : super(
          scale: 6.0,
          gravity: Vector2(0, -50.0),
        ) {
    viewport.resize(viewportSize);
    final boundaries = createBoundaries(viewport);

    boundaries.forEach(add);
    // final Vector2 position = Vector2(details.localPosition.dx, details.localPosition.dy);

    print("constructor");

    this.debug = Debugger();
    debug..add(player?.size)..add(camera)..add(viewport.size);
  }

  /// after initialize
  @override
  Future<void> onLoad() async {
    print("onLoad");
    _pizzaImage = await images.load('pizza.png');
    final Vector2 position = Vector2(10, 10);
    player = Pizza(BodyType.DYNAMIC, position, _pizzaImage);
    add(player);
    debug.add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (player != null) {
      print("x:" + viewport.size.x.toString());
      print("y:" + viewport.size.y.toString());
      this.camera.x = -(viewport.size.x / viewport.scale) + player.body.position.x * viewport.scale;
      this.camera.y = -(viewport.size.y / viewport.scale) - player.body.position.y * viewport.scale;
    }
  }

  @override
  void render(Canvas c) {
    debug.displayDebug(camera, this, c);
    super.render(c);
  }

  @override
  void onTapDown(TapDownDetails details) {
    super.onTapDown(details);
  }

  @override
  void onLongPressEnd(LongPressEndDetails details) {
    super.onLongPressEnd(details);
    final Vector2 position = Vector2(details.localPosition.dx, details.localPosition.dy);
    add(Pizza(BodyType.STATIC, position, _pizzaImage));
  }
}
