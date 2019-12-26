import '../models/animation.dart';
import '../models/frame.dart';

import 'package:rxdart/rxdart.dart';

class AnimationService {

  List<Animation> animations = [];

  Animation currentAnimation = null;
  Frame currentFrame         = null;

  BehaviorSubject<int> _state = BehaviorSubject<int>.seeded(-1);
  Stream<int> get stateObservable => _state.stream;

  AnimationService() {
    this.loadData();
    this.initDefaultValues();
  }

  void loadData() {}

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
  }

  void selectFrame(Frame frame) {
    this.currentFrame = frame;

    this.change();
  }

  void change() {
    _state.add(1);
  }

  int getCurrentFrameIndex() {
    for (var i = 0; i < this.currentAnimation.frames.length; i++) {
      if (this.currentAnimation.frames[i] == this.currentFrame) {
        return i;
      }
    }
  }

  Frame getPreviousFrame() {
    var index = this.getCurrentFrameIndex();

    if (index > 0) {
      return this.currentAnimation.frames[index - 1];
    } else {
      return null;
    }
  }

}

final servAnimation = AnimationService();