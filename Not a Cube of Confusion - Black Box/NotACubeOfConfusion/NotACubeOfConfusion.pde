import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer song;

Letters letters;
Vortex vortex;
WavyThing wavy;
Julia julia;
Ripple ripple;

boolean loading = false;
void setup() {
  size(1920, 1080, P3D);
  frameRate(60);

  minim = new Minim(this);
  song = minim.loadFile("NeXuS-NightFlyer.mp3");

  randomSeed(1);

  letters = new Letters();
  letters.init();

  vortex = new Vortex();
  vortex.init();

  wavy = new WavyThing();

  julia = new Julia();
  julia.init();

  initClockEffect();

  ripple = new Ripple();
  ripple.init();
}

boolean songPlaying = false;
void draw() {
  if (!songPlaying) {
    songPlaying = true;
    song.play();
  }

  float time = song.position();
  float clockTime = 13000;
  float wavyTime = clockTime + 6700;
  float lettersTime = wavyTime + 6000 / 0.3;
  float juliaTime = lettersTime + 40000;
  float vortexTime = juliaTime + 18000 / 0.4;
  float rippleTime = vortexTime + 18500;

  if (time < clockTime) {
    drawClockEffect(time);
  } else if (time < wavyTime) {
    wavy.draw(time);
  } else if (time < lettersTime) {
    letters.draw((time - wavyTime) * 0.3);
  } else if (time < juliaTime) {
    julia.draw(time - lettersTime);
  } else if (time < vortexTime) {
    vortex.draw((time - juliaTime) * 0.4);
  } else if (time < rippleTime) {
    ripple.draw((time - vortexTime));
  } else if (time > rippleTime) {
    stopMusic();
    exit();
  }
}

void stopMusic() {
  song.close();
  minim.stop();
}

