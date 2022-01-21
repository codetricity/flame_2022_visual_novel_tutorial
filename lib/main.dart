import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasTappables {
  SpriteComponent girl = SpriteComponent();
  SpriteComponent boy = SpriteComponent();
  SpriteComponent background = SpriteComponent();
  SpriteComponent background2 = SpriteComponent();
  DialogButton dialogButton = DialogButton();
  final Vector2 buttonSize = Vector2(50.0, 50.0);

  final double characterSize = 200.0;
  bool turnAway = false;
  int dialogLevel = 0;
  int sceneLevel = 1;

  TextPaint dialogTextPaint = TextPaint(style: const TextStyle(fontSize: 36));

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final screenWidth = size[0];
    final screenHeight = size[1];
    const textBoxHeight = 100;

    // setup background2
    background2
      ..sprite = await loadSprite('castle.jpg')
      ..size = Vector2(size[0], size[1] - 100);
    // load background
    add(background
      ..sprite = await loadSprite('background.png')
      ..size = Vector2(size[0], size[1] - 100));
    // load girl
    girl
      ..sprite = await loadSprite('girl.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..anchor = Anchor.topCenter;
    add(girl);

    boy
      ..sprite = await loadSprite('boy.png')
      ..size = Vector2(characterSize, characterSize)
      ..y = screenHeight - characterSize - textBoxHeight
      ..x = screenWidth - characterSize
      ..anchor = Anchor.topCenter
      ..flipHorizontally();

    add(boy);

    dialogButton
      ..sprite = await loadSprite('next_button.png')
      ..size = buttonSize
      ..position =
          Vector2(size[0] - buttonSize[0] - 10, size[1] - buttonSize[1] - 10);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (girl.x < size[0] / 2 - 100) {
      girl.x += 30 * dt;
      if (girl.x > 50 && dialogLevel == 0) {
        dialogLevel = 1;
      }
      if (girl.x > 150 && dialogLevel == 1) {
        dialogLevel = 2;
      }
    } else if (turnAway == false && sceneLevel == 1) {
      print('turn away');
      boy.flipHorizontally();
      turnAway = true;
      if (dialogLevel == 2) {
        dialogLevel = 3;
      }
    }

    if (boy.x > size[0] / 2 - 50 && sceneLevel == 1) {
      boy.x -= 30 * dt;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    switch (dialogLevel) {
      case 1:
        dialogTextPaint.render(
            canvas,
            'Keiko: Ken, don\'t'
            ' go... You\'ll die',
            Vector2(10, size[1] - 100.0));
        break;
      case 2:
        dialogTextPaint.render(canvas, 'Ken: I must fight for our village.',
            Vector2(10, size[1] - 100.0));
        break;
      case 3:
        dialogTextPaint.render(canvas, 'Keiko: What about the baby?',
            Vector2(10, size[1] - 100.0));
        add(dialogButton);
        break;
    }
    switch (dialogButton.scene2Level) {
      case 1:
        sceneLevel = 2;
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPaint.render(canvas, 'Ken: Child?  I did not know',
            Vector2(10, size[1] - 100.0));
        if (turnAway) {
          boy.flipHorizontally();
          boy.x = boy.x + 150;
          turnAway = false;
          // change scene
          remove(background);
          remove(boy);
          remove(girl);
          add(background2);
          add(boy);
          add(girl);
        }
        break;
      case 2:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPaint.render(canvas, 'Keiko: Our child.  Our future.',
            Vector2(10, size[1] - 100.0));
        break;
      case 3:
        canvas.drawRect(Rect.fromLTWH(0, size[1] - 100, size[0] - 60, 100),
            Paint()..color = Colors.black);
        dialogTextPaint.render(canvas, 'Ken: My future will be through you.',
            Vector2(10, size[1] - 100.0));
        break;
    }
  }
}

class DialogButton extends SpriteComponent with Tappable {
  int scene2Level = 0;
  @override
  bool onTapDown(TapDownInfo event) {
    try {
      print('we will move to the next screen');
      scene2Level++;
      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
