// Minim is needed for the music playback.
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*; 

// Set to 1920x1080 for demo.
int CANVAS_WIDTH = 960;
int CANVAS_HEIGHT = 540;
float ASPECT_RATIO = (float)CANVAS_WIDTH / (float)CANVAS_HEIGHT;
// You can skip backwards/forwards in your demo by using the 
// arrow keys; this controls how many milliseconds you skip
// with one keypress.
int SONG_SKIP_MILLISECONDS = 2000;
int[] times = {3000, 10000, 20000, 30000, 42000, 50000, 60000, 70000, 80000, 90000};
// Needed for audio
Minim minim;
AudioPlayer song;

void setupAudio(){
  minim = new Minim(this);
  song = minim.loadFile("David_TMX_-_Intro_chiante.mp3");
  //song.play();
}

void setup() {
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D); //P3D, P2D
  frameRate(60);
  setupAudio();
}

void drawCircle(int x, int y, int r, color f, color s){
  fill(f);
  stroke(s);
  ellipse(x, y, r, r);
}

void drawDemo(int time) {
  float t = time * 0.001;
  if(time < times[0]) {
    int x = floor(0.5 * CANVAS_WIDTH);
    int y = floor(0.5 * CANVAS_HEIGHT);
    int r = floor((times[0] - time) * 0.4);
    drawCircle(x, y, r, color(0), color(0));
  }
  if(times[0] < time && time < times[6]){
    int rad = min( min(40, floor((time - times[0]) * 0.005)), floor((times[6] - time) * 0.005));
    float rot = min( CANVAS_HEIGHT / 3, (time - times[0]) * 0.01);
    int x = floor(sin(t) * rot + 0.5 * CANVAS_WIDTH);
    int y = floor(cos(t) * rot + 0.5 * CANVAS_HEIGHT);
    drawCircle(x, y, rad, color(0), color(0));
  }
  if(times[1] < time && time < times[6]){
    int rad = min( min(20, floor((time - times[1]) * 0.002)), floor((times[6] - time) * 0.002));
    float rot = min( CANVAS_HEIGHT / 3, (time - times[0]) * 0.01);
    float off = min(CANVAS_HEIGHT / 6, (time - times[1]) * 0.005);
    int x = floor(sin(t) * rot + sin(t*6) * off + 0.5 * CANVAS_WIDTH);
    int y = floor(cos(t) * rot - cos(t*6) * off + 0.5 * CANVAS_HEIGHT);
    drawCircle(x, y, rad, color(255, 0, 0), color(255, 0, 0));
  }
  if(times[2] < time && time < times[6]){
    int rad = min( min(20, floor((time - times[2]) * 0.002)), floor((times[6] - time) * 0.002));
    float rot = min( CANVAS_HEIGHT / 3, (time - times[0]) * 0.01);
    float off_x = 1.3 * min(CANVAS_HEIGHT / 6, (time - times[2]) * 0.005);
    float off_y = 0.7 * min(CANVAS_HEIGHT / 6, (time - times[2]) * 0.005);
    int x1 = floor(sin(t) * rot + sin(t*6 + PI*0.5) * off_x + 0.5 * CANVAS_WIDTH);
    int y1 = floor(cos(t) * rot - cos(t*6 + PI*0.5) * off_y + 0.5 * CANVAS_HEIGHT);
    int x2 = floor(sin(t) * rot - sin(t*6) * off_y + 0.5 * CANVAS_WIDTH);
    int y2 = floor(cos(t) * rot + cos(t*6) * off_x + 0.5 * CANVAS_HEIGHT);
    drawCircle(x1, y1, rad, color(0, 255, 0), color(0, 255, 0));
    drawCircle(x2, y2, rad, color(0, 0, 255), color(0, 0, 255));
  }
}

void drawPixel(int time) {
  if(time < times[0]) {fill(125); rect(0, 0, CANVAS_WIDTH, CANVAS_HEIGHT);}
  
  if(times[0] < time && time < times[9]) {
    loadPixels();  
    
    if(times[0] < time && time < times[7]) {
      for(int i = 0; i < CANVAS_HEIGHT; i++) {
        for(int j = 0; j < CANVAS_WIDTH; j++) {
          int index = i * CANVAS_WIDTH + j;
          int c = CANVAS_WIDTH;
          if (j > 1 && i > 1 && i < CANVAS_HEIGHT - 1 && j < CANVAS_WIDTH - 1)
            pixels[index] = (pixels[index-1] + pixels[index] + pixels[index+1] + pixels[index-c] + pixels[index+c]) / 5;
        }
      }
    }
    if(times[4] < time && time < times[8]) {
      for(int i = 0; i < CANVAS_HEIGHT; i++) {
        for(int j = 0; j < CANVAS_WIDTH; j++) {
          int index = i * CANVAS_WIDTH + j;
          int c = CANVAS_WIDTH;
          float weight = 5.0;
          if (j > 0 && i > 0 && i < CANVAS_HEIGHT - 1 && j < CANVAS_WIDTH - 1){
            float red = (red(pixels[index-1]) + red(pixels[index]) * weight + red(pixels[index+1]) + red(pixels[index-c]) + red(pixels[index+c])) / (4.0 + weight);
            float blue = (blue(pixels[index-1]) + blue(pixels[index]) * weight + blue(pixels[index+1]) + blue(pixels[index-c]) + blue(pixels[index+c])) / (4.0 + weight);
            float green = (green(pixels[index-1]) + green(pixels[index]) * weight + green(pixels[index+1]) + green(pixels[index-c]) + green(pixels[index+c])) / (4.0 + weight);
            pixels[index] = color(red, green, blue);
          }
          if (j == 0 && i > 0 && i < CANVAS_HEIGHT - 1){
            float red = (red(pixels[index]) * weight + red(pixels[index+1]) + red(pixels[index-c]) + red(pixels[index+c])) / (3.0 + weight);
            float blue = (blue(pixels[index]) * weight + blue(pixels[index+1]) + blue(pixels[index-c]) + blue(pixels[index+c])) / (3.0 + weight);
            float green = (green(pixels[index]) * weight + green(pixels[index+1]) + green(pixels[index-c]) + green(pixels[index+c])) / (3.0 + weight);
            pixels[index] = color(red, green, blue);
          }
          if (i == 0 && j > 0 && j < CANVAS_WIDTH - 1){
            float red = (red(pixels[index]) * weight + red(pixels[index+1]) + red(pixels[index-1]) + red(pixels[index+c])) / (3.0 + weight);
            float blue = (blue(pixels[index]) * weight + blue(pixels[index+1]) + blue(pixels[index-1]) + blue(pixels[index+c])) / (3.0 + weight);
            float green = (green(pixels[index]) * weight + green(pixels[index+1]) + green(pixels[index-1]) + green(pixels[index+c])) / (3.0 + weight);
            pixels[index] = color(red, green, blue);
          }
          if (j == CANVAS_WIDTH - 1 && i > 0 && i < CANVAS_HEIGHT - 1){
            float red = (red(pixels[index]) * weight + red(pixels[index-1]) + red(pixels[index-c]) + red(pixels[index+c])) / (3.0 + weight);
            float blue = (blue(pixels[index]) * weight + blue(pixels[index-1]) + blue(pixels[index-c]) + blue(pixels[index+c])) / (3.0 + weight);
            float green = (green(pixels[index]) * weight + green(pixels[index-1]) + green(pixels[index-c]) + green(pixels[index+c])) / (3.0 + weight);
            pixels[index] = color(red, green, blue);
          }
          if (i == CANVAS_HEIGHT - 1 && j > 0 && j < CANVAS_WIDTH - 1){
            float red = (red(pixels[index]) * weight + red(pixels[index+1]) + red(pixels[index-1]) + red(pixels[index-c])) / (3.0 + weight);
            float blue = (blue(pixels[index]) * weight + blue(pixels[index+1]) + blue(pixels[index-1]) + blue(pixels[index-c])) / (3.0 + weight);
            float green = (green(pixels[index]) * weight + green(pixels[index+1]) + green(pixels[index-1]) + green(pixels[index-c])) / (3.0 + weight);
            pixels[index] = color(red, green, blue);
          }
        }
      }
    }
    updatePixels();
  }
}

/*
 * Processing's drawing method
 */
void draw() {
  drawPixel(song.position());
  drawDemo(song.position());
}


/* 
 * Simple playback controls 
 * for easier development.
 */
void keyPressed() {
  if (key == CODED) {
    // Left/right arrow keys: seek song
    if (keyCode == LEFT) {
      song.skip(-SONG_SKIP_MILLISECONDS);
    } 
    else if (keyCode == RIGHT) {
      song.skip(SONG_SKIP_MILLISECONDS);
    }
  }
  // Space bar: play/payse
  else if (key == ' ') {
    if (song.isPlaying())
      song.pause();
    else
      song.play();
  }
  // Enter: spit out the current position
  // (for syncing)
  else if (key == ENTER) {
    print(song.position() + ", ");
  }
}
