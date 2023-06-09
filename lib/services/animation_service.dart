import '../models/animation.dart';
import '../models/frame.dart';
import 'database_service.dart';

import 'package:rxdart/rxdart.dart';

import 'dart:async';
import 'dart:convert';

enum Tool { brush, eraser }

class AnimationService {

  List<Animation> animations = [];

  Animation currentAnimation = null;
  Frame currentFrame         = null;
  Tool tool                  = Tool.brush;

  bool playing               = false;

  BehaviorSubject<int> _state = BehaviorSubject<int>.seeded(-1);
  Stream<int> get stateObservable => _state.stream;

  Timer timer;

  AnimationService() {
    this.loadData();
  }

  void loadData() async {
    print("Loading data...");

    var data = await servDatabase.select("animations");

    this.animations = List.generate(data.length, (i) {
      var json = jsonDecode(data[i]['data']);
      var a    = Animation(json['name']);

      a.initWithValues(json);

      return a;
    });

    print("${this.animations.length} animations loaded.");

    this.initDefaultValues();

    this.change();
  }

  void initDefaultValues() {
    // No animation
    if (this.animations.length == 0) {
      this.animations.add(new Animation("Sans titre 1"));
    }

    this.currentAnimation = this.animations.last;

    // No frame
    if (this.currentAnimation.frames.length == 0) {
      this.currentAnimation.frames.add(new Frame());
    }

    this.currentFrame = this.currentAnimation.frames.last;
  }

  void newFrame() {
    this.currentAnimation.frames.add(new Frame());

    this.currentFrame = this.currentAnimation.frames.last;

    this.change();
    this.currentAnimation.save();
  }

  void selectFrame(Frame frame) {
    this.currentFrame = frame;

    this.change();
    this.currentAnimation.save();
  }

  void selectAnimation(Animation animation) {
    this.currentAnimation.save();

    this.currentAnimation = animation;
    this.currentFrame     = animation.frames.last;
  }

  Future<Animation> createAnimation(String name) async {
    var newAnimation = Animation(name);
    newAnimation.frames.add(Frame());

    this.currentAnimation = newAnimation;
    this.currentFrame     = newAnimation.frames.last;

    await newAnimation.save();

    this.animations.add(newAnimation);

    return newAnimation;
  }

  void deleteAnimation(Animation animation) async {
    await animation.delete();

    this.animations.removeWhere((anim) => anim.id == animation.id);

    // No animation
    if (this.animations.length == 0) {
      this.animations.add(new Animation("Sans titre 1"));

      this.currentAnimation = this.animations.last;

      // No frame
      this.currentAnimation.frames.add(new Frame());

      this.currentFrame = this.currentAnimation.frames.last;
    }

    if (this.currentAnimation.id == animation.id) {
      this.currentAnimation = this.animations.last;
      this.currentFrame = this.currentAnimation.frames.last;
    }

    this.change();
  }

  void deleteFrame(Frame frame) async {
    this.currentAnimation.deleteFrame(frame);

    this.currentAnimation.save();

    // No frame
    if (this.currentAnimation.frames.length == 0) {
      this.currentAnimation.frames.add(new Frame());

      this.currentFrame = this.currentAnimation.frames.last;
    }

    if (this.currentFrame == frame) {
      this.currentFrame = this.currentAnimation.frames.last;
    }

    this.change();
  }

  void copyFrame(Frame frame) async {
    var newFrame = new Frame();
    newFrame.initWithValues(this.currentFrame.toMap());

    this.currentAnimation.frames.insert(this.getCurrentFrameIndex() + 1, newFrame);

    this.currentFrame = newFrame;

    this.change();
  }

  void change() {
    _state.add(1);
  }

  int getCurrentFrameIndex() {
    if (this.currentAnimation == null) return null;

    for (var i = 0; i < this.currentAnimation.frames.length; i++) {
      if (this.currentAnimation.frames[i] == this.currentFrame) {
        return i;
      }
    }
  }

  Frame getPreviousFrame() {
    var index = this.getCurrentFrameIndex();

    if (index != null && index > 0) {
      return this.currentAnimation.frames[index - 1];
    } else {
      return null;
    }
  }

  void nextFrame() {
    var newIndex = (this.getCurrentFrameIndex() + 1) % this.currentAnimation.frames.length;

    this.currentFrame = this.currentAnimation.frames[newIndex];

    this.change();
  }

  void play() {
    this.currentAnimation.save();

    var ms = 1 / this.currentAnimation.fps * 1000;

    timer = Timer.periodic(Duration(milliseconds: ms.round()), (Timer t) => nextFrame());
  }

  void stop() {
    timer?.cancel();
  }

  void changeTool(Tool tool) {
    this.tool = tool;

    this.change();
  }

}

final servAnimation = AnimationService();
