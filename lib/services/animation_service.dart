import '../models/animation.dart';
import '../models/frame.dart';

class AnimationService {

  List<Animation> animations = [];

  Animation currentAnimation = null;
  Frame currentFrame         = null;

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
  }

  void selectFrame(Frame frame) {
    this.currentFrame = frame;
  }

}

final servAnimation = AnimationService();