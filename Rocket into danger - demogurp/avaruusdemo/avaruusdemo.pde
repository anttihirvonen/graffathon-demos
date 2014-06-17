import toxi.geom.*;
import toxi.geom.mesh2d.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.util.datatypes.*;
import toxi.processing.*;


// Minim is needed for the music playback.
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

PImage credit_image;
PImage bg;
int credit_x = 100; 
int credit_x2 = -100; 
float credit_counter = 0;
float kulma = 0;
int imagecounter = 0;
String[] texts = {
  "thank.png",
  "musicaut.png",
  "info.png",
};
boolean initiate = true;

ArrayList <BreakCircle> circles = new ArrayList <BreakCircle> ();
VerletPhysics2D physics;
ToxiclibsSupport gfx;
FloatRange sade;
Vec2D origin, mouse;

int maxCircles = 1; // maximum amount of circles on the screen
int numPoints = 70;  // number of voronoi points / segments
int minSpeed = 2;    // minimum speed of a voronoi segment
int maxSpeed = 20;   // maximum speed of a voronoi segment
boolean display_sphere = false;


PShape moon; // PShape to hold the geometry, textures, texture coordinates etc.
PShape earth;
PShape icyearth;
int subdivisionLevel = 6; // number of times the icosahedron will be subdivided
float moonZoom = 500; // scale factor aka moonZoom
boolean useShader = true; // boolean to toggle shader of regular view
boolean phase1 = true;
boolean phase2 = false;
boolean phase3 = false;
int phase1end = 0;

PVector moonRotation = new PVector(); // vector to store the moonRotation
PVector moonVelocity = new PVector(); // vector to store the change in moonRotation
float moonRotationSpeed = 0.02; // the moonRotation speed
PImage space;
int opacity = 0;
boolean changeTexture = false;
boolean op = true;
boolean opback = false;
int start = 0;
int op2 = 0;

PShader shader; // GLSL shader that can be applied to lighted textured geometry
int leveys, korkeus = 0;
String windsound = "wind.mp3";
String shatter = "shatter.mp3";
String music = "cosmoride.mp3";
String endmusic = "endmusic.mp3";
String cursound = "";
boolean lol = false;
PFont ff;
PImage ww;
ArrayList positions = new ArrayList();

// Needed for audio
Minim minim;
AudioPlayer song;
BeatDetect beat;
FFT fft;


//------------------PART II -------------------

int x,y,radius;

// textures lookup tables
PGraphics[] tunnelEffects;
PImage[] tunnelTectures;
int[][][] distanceTables;
int[][][] angleTables;
int[][][] shadeTables;


// One texture objects
int[][] distanceTable;
int[][] angleTable;
int[][] shadeTable;
PImage textureImg;
PGraphics tunnelEffect;
int twidth, theight;

int startTime;
int effectStatus;
int tunnelTextureIndex;
int shootTimer1;
int shootTimer2;

ArrayList<Ball> balls;
PImage fireballTexture;
PImage fireballTextureBlur;

int effectResolutionX = 600;
int effectResolutionY = 450;
int effectStartTime = 0;

void loadTexture(String name, int i) {
    tunnelTectures[i] = loadImage(name);
    tunnelEffects[i] = createGraphics(effectResolutionX, effectResolutionY);
    twidth = tunnelEffects[i].width;
    theight = tunnelEffects[i].height;

    float ratio = 32.0;
    int shade = 0;

    // center (w,h)
    distanceTables[i] = new int[2*twidth+1][2*theight+1];
    angleTables[i] = new int[2*twidth+1][2*theight+1];
// shadeTables[i] = new int[2*twidth+1][2*theight+1];
    for (int x = 0; x < twidth*2; x++) {
        for (int y = 0; y < theight*2; y++) {
            int depth = int(ratio * tunnelTectures[i].height / sqrt(float((x - twidth) * (x - twidth) + (y - theight) * (y - theight))));
            int angle = int(0.5 * tunnelTectures[i].width * atan2(float(y - theight), float(x - twidth)) / PI) ;
            distanceTables[i][x][y] = depth;
            angleTables[i][x][y] = angle;
            // shadeTables[i][x][y] = int(sqrt(float((x - twidth) * (x - twidth) + (y - theight) * (y - theight))));
        }
    }
}

void selectTexture(int i) {
    textureImg = tunnelTectures[i];
    tunnelEffect = tunnelEffects[i];
    distanceTable = distanceTables[i];
    angleTable = angleTables[i];
// shadeTable = shadeTables[i];

    twidth = tunnelEffects[i].width;
    theight = tunnelEffects[i].height;
}


void setUpTunnel() {

    tunnelTectures = new PImage[8];
    tunnelEffects = new PGraphics[8];
    distanceTables = new int[8][][];
    angleTables = new int[8][][];
    shadeTables = new int[8][][];

    /*
    for (int i=5; i<8; i++){
     loadTexture("test"+i+".png", i-5);
    }


    loadTexture("test1.gif", 0);
    loadTexture("tex7.jpg", 1);
    loadTexture("test8.jpg", 2);
    loadTexture("test2.jpg", 3);
    loadTexture("test51.jpg", 4);

    loadTexture("demo3.jpg", 0);
    loadTexture("test38.jpg", 1);
    loadTexture("test33.jpg", 2);
    loadTexture("test34.jpg", 3);
    loadTexture("test37.jpg", 4);
    //loadTexture("demo1.jpg", 5);
     */

    loadTexture("demo3.jpg", 0);
    loadTexture("test51.jpg", 1);
    loadTexture("test23.png", 2);
    loadTexture("test37.jpg", 3);
    loadTexture("test63.jpg", 4);
    loadTexture("test33.jpg", 5);
    loadTexture("test81.jpg", 6);

}


//------------------PART II -------------------

// An array of news headlines
String[] headlines = {
    "Studies show that the best time to code is 4 am." ,
    "Everyone should watch Future Crew's Unreal." ,
    "Is someone even reading these?",
    "HELP. I'm trapped in North Korea!",
};

String[] thanks = {
    "Greetings to DOT!",
    "Greetings to firebug",
    "Greetings to sooda",
    "Greetings to everyone else!",
};

String[] intro = {
    "ROCKET",
    "INTO",
    "DANGER",
    "AWESOME POWAH!",
    "LOLLERO & JONUX",
};

PFont f; // Global font variable
float head_x; // Horizontal location
int index = 0;
float theta;
int rollindex = 0;

int zero = 0;

int intro_x = 0;
int intro_index = 0;
boolean shat_sound = true;
int exittimer = 0;


void setup() {
    size(1280, 720, P3D); // use the P3D OpenGL renderer
    smooth();
    noStroke();
    f = createFont( "Arial" ,16,true);
    // Initialize headline offscreen
    head_x = width;
    ff = loadFont("font.vlw");
    gfx = new ToxiclibsSupport(this);
    physics = new VerletPhysics2D();
    physics.setDrag(0.05f);
    physics.setWorldBounds(new Rect(0, 0, width, height));
    sade = new BiasedFloatRange(30, 100, 30, 0.6f);
    origin = new Vec2D(width/2+4, height/2-200);
    reset();
    moon = createIcosahedron(subdivisionLevel, "moonmap.jpg"); // create the subdivided icosahedron PShape (see custom creation method) and put it in the global moon reference
    earth = createIcosahedron(subdivisionLevel, "world32k.jpg");
    icyearth = createIcosahedron(subdivisionLevel, "icy_planet.jpg");
    space = loadImage("space.jpg");
    space.resize(1280, 720);
    shader = loadShader("shaderFrag.glsl", "shaderVert.glsl"); // load the PShader with a fragment and a vertex shader
    translate(width/2, height+100); // translate to center of the screen
    leveys = width/2;
    korkeus = height+100;
    phase1 = true;
    phase2 = false;
    setupAudio();
    switchSong(windsound);
    setUpTunnel();

    //print("textureImg.width"+textureImg.width);
    //startTime = millis();

    tunnelTextureIndex = 0;
    selectTexture(tunnelTextureIndex);
    effectStatus = tunnelTextureIndex;
    fireballTexture = loadImage("fireball.png");
    fireballTextureBlur = loadImage("fireballblurr.png");
    fireballTextureBlur.resize(fireballTexture.width, fireballTexture.height);

    balls = new ArrayList<Ball>();
    shootTimer2=0;
    shootTimer1=0;

}

void setupAudio() {
    minim = new Minim(this);
}

void setupFFT() {
    fft = new FFT(song.bufferSize(), song.sampleRate());
    fft.logAverages(22, 3);
    beat = new BeatDetect();
    beat.setSensitivity(13);
}

void switchSong(String name) {
    if (name != cursound && !lol) {
        song = minim.loadFile(name);
        song.play();
        print("soundi luotu   "+name+"\n");
        cursound = name;
        if (name == shatter) {
            lol = true;
        }
        if (name == music) {
            setupFFT();
            print("FFT luotu\n");
        }
    } else {

    }
}
PImage crImage(String sentence) {
    PGraphics pg = createGraphics(400,20,JAVA2D);
    pg.beginDraw();
    pg.background(255);
    pg.fill(250);
    pg.textAlign(CENTER);
    pg.textFont(ff, 16);
    pg.text(sentence, 0, 0, 400, 20);
    pg.endDraw();
    PImage w = createImage(400,20,RGB);
    copy(pg, 0, 0, 400, 20, 0, 0, 400, 20);
    return w;
}

void scan() {
    positions.clear();
    for(int x = 0; x < ww.width; x++) {
        for(int y = 0; y < ww.height; y++) {
            if(get(x,y) != -65794) {
                positions.add(new PVector(x,y,0));
            }
        }
    }
}

void intro() {
    pushMatrix();
    fill(255, 0, 0);
    textSize(50);
    text("HIHIHII", width/2, height/2);

    popMatrix();
}

void displayRoll() {

    textFont(f, 40);                 // Set the font
    translate(width/2,height/2); // Translate to the center
    rotate(theta);               // Rotate by theta
    textAlign(CENTER) ;
    int roll_w = int( (height/3) / fft.avgSize());
    for(int i = 0; i < thanks.length; i++) {
        text(thanks[i], -200 + i*100, -100 + i*70);
    }

    //text(thanks[index], 0, 0);
    if (theta > 6.1) {
        theta = 0;
        scale(2, 2);
        // index is incremented when the current String has left the screen in order to display a new String.
        //index = (index + 1) % thanks.length;
    }
    // Increase rotation
    theta += 0.05;
}


void displayIntro() {
    pushMatrix();

    textFont(f, 50);
    fill(255, 255, 50);
    rotate(-0.3316);
    for(int i = 0; i < intro_index+1; i++) {
        if (i == intro_index) {
            text(intro[intro_index],intro_x,350+i*40);
        }
        if (i < intro_index) {
            text(intro[intro_index],640,350+i*40);
        }
    }
    intro_x += 15;
    if (intro_x > 640) {
        intro_x = 0;
        // index is incremented when the current String has left the screen in order to display a new String.
        intro_index = (intro_index + 1) % intro.length;

    }
    popMatrix();
}

void displayHeadlines() {
    textFont(f,36);
    textAlign (LEFT);
    //for(int i = 0; i < fft.specSize(); i++)
    //{
    //  fill(fft.getBand(i)*1000);
    //}
    fill(255, 255, 0);

    // A specific String from the array is displayed according to the value of the "index" variable.
    text(headlines[index],head_x,700);

    // Decrement x
    head_x = head_x - 15;

    // If x is less than the negative width, then it is off the screen
    // textWidth() is used to calculate the width of the current String.
    float head_w = textWidth(headlines[index]);
    if (head_x < -head_w) {
        head_x = width;
        // index is incremented when the current String has left the screen in order to display a new String.
        index = (index + 1) % headlines.length;

    }
}

void draw() {
    // UPDATE
    if (phase3) {
      if(initiate){
        setup_credit();
        initiate = false;
        song = minim.loadFile(endmusic);
        song.play();
        exittimer = millis();
      }
      if(millis() - exittimer > 32000){
        exit();
      }
      drawCredit();
    }else{
    if (phase1end > 0 && (millis() - (phase1end + 5000)) > 0 && phase2 == false) {
        phase1 = false;
        phase2 = true;
        zero = millis();
        startTime = zero;
        effectStartTime = millis();
        song = minim.loadFile(music);
        song.play();
        setupFFT();
    }
    if (phase2) {
        fft.forward(song.mix);
        beat.detect(song.mix);
        drawTunnelEffect();
        if(millis() -zero < 13200) {
            displayIntro();
        }
        if(millis() -zero > 13200 && millis() -zero < 42000) {
            displayHeadlines();
        }
        if(millis() -zero > 42000 && millis() -zero < 50000) {
            displayRoll();
        }


    }
    
    
    
    if (phase1) {
        yks_part();
        if(phase1end > 0) {
            op2 += 2;
            fade(op2);
        }
    }
    }


}

void fade(int amount) {
    fill(0, 0, 0, amount);
    rect(-leveys, -korkeus, leveys*5, korkeus*5);
}

void yks_part() {
    if (op) {
        opacity += 2;
    }
    if (opback) {
        opacity -= 1;
        if (opacity < 150) {
            opacity = 150;
        }
    }
    if (opacity > 220) {
        changeTexture = true;
    }
    if (opacity > 250) {
        op = false;
        opback = true;
    }
    background(space); // black background
    perspective(PI/3.0, (float) width/height, 0.1, 1000000); // perspective for close shapes
    pushMatrix();
    phaseOne();
    pushMatrix();
    translate(0, 0, -5);
    if(!changeTexture) {
        shape(icyearth);
    } else {
        if(moonRotation.x > -40) {
            shape(icyearth);
        }
    }
    popMatrix();
    frame.setTitle(" " + int(frameRate) + " " + moonRotation.x + " " + start); // write the fps in the top-left of the window
    if(korkeus < height +600) {
        shape(moon); // display the PShape
    }
    pushMatrix();
    translate(0, 0, 1);
    fadeIn();
    popMatrix();

    popMatrix();
    if (display_sphere && moonRotation.x < -40) {
        pushMatrix();
        translate(0, 0, -1);
        removeAddCircles();
        physics.update();
for (BreakCircle bc : circles) {
            if(millis() - start > 5000 && shat_sound) {
                shat_sound = false;
                switchSong(shatter);
                useShader = false;
                bc.run(true);
            } else {
                bc.run(false);
            }
        }
        popMatrix();
    }
    for(int i = 0; i < positions.size()-1; i++) {
        PVector ps = (PVector) positions.get(i);
        pushMatrix();
        translate(ps.x + 100, ps.y + 100, 0);
        rotateX(-1.5);
        noStroke();
        fill(200);
        box(1, 1, 5);
        popMatrix();
    }
}

void keyPressed() {
}

void removeAddCircles() {
    for (int i=circles.size ()-1; i>=0; i--) {
        // if a circle is invisible, remove it...
        if (circles.get(i).transparency < 200 && !shat_sound) {
            phase1end = millis();
            op2 = 100;
        }
        if (circles.get(i).transparency < 0) {
            circles.remove(i);
            // and add two new circles (if there are less than maxCircles)
            if (circles.size() < maxCircles-1) {
                circles.add(new BreakCircle(origin, sade.pickRandom()));
                circles.add(new BreakCircle(origin, sade.pickRandom()));
            }
        }
    }
}

void reset() {
    // remove all physics elements
for (BreakCircle bc : circles) {
        physics.removeParticle(bc.vp);
        physics.removeBehavior(bc.abh);
    }
    // remove all circles
    circles.clear();
    // add one circle of sade 200 at the origin
    circles.add(new BreakCircle(origin, 110));
}
void drawEllipse() {
    fill(255);
    ellipse(width/2, height-400, 100, 100);
}

void fadeIn() {
    fill(0, 0, 0, opacity);
    rect(-leveys, -korkeus, leveys*5, korkeus*5);
}
void phaseOne() {
    if (phase1) {
        //FIXME: better way to do this!
        if (moonRotation.x < - 10) {
            korkeus += 5;
            if (korkeus >= height + 600) {
                korkeus = height + 600;
                moonVelocity.x = -0.1;
                moonRotation.add(moonVelocity);

            }
        }
        translate(leveys, korkeus); // translate to center of the screen
        scale(moonZoom); // set the scale/moonZoom level

        if (moonRotation.x < -18) {
            //zoomIn();
        }
        // render the PShape with or without the shader
        if (useShader) {
            // set the lightPosition according to the mouse position
            pointLight(255, 255, 255, width/2, -height/2, 10);
            shader(shader);
        } else {
            resetShader();
        }
        if(moonRotation.x > -10){
          moonVelocity.x = -0.04;
        }else{
          moonVelocity.x = -0.1;
        }
        if (moonRotation.x > -22) {
            moonRotation.add(moonVelocity); // add moonRotation moonVelocity to moonRotation
        } else {
            if(!display_sphere) {
                start = millis();
            }
            display_sphere = true;
        }
        rotateX(moonRotation.x*moonRotationSpeed); // moonRotation over the X axis
        rotateY(moonRotation.y*moonRotationSpeed); // moonRotation over the Y axis

    }
}

void zoomIn() {
    moonZoom += 10;
}

int getZoomSpeed(int timer, float timeDisplacement) {

    return int(textureImg.width * .2 * timeDisplacement + 100);

}

int getSpinSpeed(int timer, float timeDisplacement) {
// if (timer < 10000){
// return int(textureImg.height * .115 * timeDisplacement +300);
// }
    return int(textureImg.height * .15 * timeDisplacement +300);
}
boolean fademusic = false;

float holeRad = 10;
void drawTunnelEffect() {

    int timer = millis()-startTime;

    if (millis()-startTime > 30000 && effectStatus == 0) {
        selectTexture(++tunnelTextureIndex);
        effectStatus = 1;
        effectStartTime = millis();
    } else if (millis()-startTime > 40000 && effectStatus == 1 ) {
        selectTexture(++tunnelTextureIndex);
        effectStatus = 2;
        effectStartTime = millis();

    } else if (millis()-startTime > 60000 && effectStatus == 2 ) {
        selectTexture(++tunnelTextureIndex);
        effectStatus = 3;
        effectStartTime = millis();

    } else if (millis()-startTime > 90000 && effectStatus == 3 ) {
        selectTexture(++tunnelTextureIndex);
        effectStatus = 4;
        effectStartTime = millis();

    } else if (millis()-startTime > 100000 && effectStatus == 4 ) {
        selectTexture(++tunnelTextureIndex);
        effectStatus = 5;
        effectStartTime = millis();

    } else if (millis()-startTime > 120000 && effectStatus == 5 ) {
        selectTexture(++tunnelTextureIndex);
        effectStatus = 6;
        effectStartTime = millis();
    } else if (millis()-startTime > 140000 && effectStatus == 6 ) {
        selectTexture(0);
        effectStatus = 7;
        tunnelTextureIndex = 0;
        effectStartTime = millis();
    } else if (millis()-startTime > 160000 && effectStatus == 7)
    {
        phase2 = false;
        minim.stop();
        phase3= true;
        print("phase 3");
    }


    /*
    if (millis()-shootTimer1 > 800 ){
      balls.add(new Ball(164,50,700,45));
      shootTimer1 = millis();
    }

    if (millis()-shootTimer2 > 500 ){
      balls.add(new Ball(164,750,700,45));
      shootTimer2 = millis();
    }*/

    tunnelEffect.beginDraw();
    tunnelEffect.loadPixels();

    float timeDisplacement = millis() / 1000.0;


    //calculate the shift values out of the time value
    int shiftX = getZoomSpeed(timer, timeDisplacement); //int(textureImg.width * .2 * timeDisplacement+300); // speed of zoom
    int shiftY = getSpinSpeed(timer, timeDisplacement); // int(textureImg.height * .15 * timeDisplacement+300); //speed of spin

    //calculate the look values out of the time value
    //by using sine functions, it'll alternate between looking left/right and up/down
    int shiftLookX = twidth / 2; //+ int(twidth / 4 * sin(timeDisplacement));
    int shiftLookY = theight / 2; //+ int(theight / 4 * sin(timeDisplacement * 0.5));

//if (timer > 6000 ){
    shiftLookX += int(twidth / 4 * sin(timeDisplacement));
    shiftLookY += int(theight / 4 * sin(timeDisplacement * 0.5));


//}







    float tim = (millis()-effectStartTime)/17000.0;
    if (effectStatus > 3) {
        tim= (millis()-effectStartTime)/10000.0;
    }
    if (effectStatus == 6) {
        tim =  (millis()-effectStartTime)/10000.0;
        
        if (millis()-effectStartTime>15000 ) holeRad*=2;
       // if (millis()-effectStartTime > 18000) phase3 = true;
    }
    print(effectStartTime+" " + tim+ " " + effectStatus+"\n");
    
    
if (effectStatus == 6 && millis()-effectStartTime>18000 && !fademusic){
  song.shiftGain(-80, 13, 2000);
  fademusic = true;
}


if (effectStatus >= 6 && millis()-effectStartTime>19900){
          phase2 = false;
        minim.stop();
        phase3= true;
        print("phase 3");
        
  //song.shiftGain(-80, 13, 5000);
 // fademusic = true;
}
    /*
    if (effectStartTime > 17000){
      tim = max(tim - 1.0/((millis()-effectStartTime+0.001)), 0);
    }*/
  if ((effectStatus == 6 && millis()-effectStartTime<13000) || effectStatus!= 6){
      if (effectStatus > 2 && effectStartTime > 2500 && effectStatus != 4 && phase3 == false) {
          for (int i=0; i<5; i++) {
              //  print(" "+int(fft.getBand(int(i))) );
              if (int(fft.getBand(int(i))) > 70) {
                  int r = int(fft.getBand(int(i))) * 2;
                  balls.add(new Ball(r,50,700,45));
              }
          }
  
          for (int i=5; i<10; i++) {
  
              if (int(fft.getBand(int(i))) > 70) {
                  int r = int(fft.getBand(int(i)));
                  balls.add(new Ball(r*2.5,750,700,45));
              }
          }
      }
  }

// print("\n");
    int flashNro = 100;

    if (effectStartTime>20000) {
        flashNro = 10;
    }
    if (effectStartTime>25000) {
        flashNro = 5;
    }
    float ratioXfix = width/float(effectResolutionX);
    float ratioYfix = height/float(effectResolutionY);

    // TODO: FIX this shit
    float centerPosX = 0;
    float centerPosY = 0;
    float min_dist = 999999;

    for (int y = 0; y < theight; y++)  {
        for (int x = 0; x < twidth; x++)      {
            //make sure that x + shiftLookX never goes outside the dimensions of the table

            int texture_x = constrain((distanceTable[x + shiftLookX][y + shiftLookY] + shiftX) % textureImg.width ,0, textureImg.width);
            int texture_y = (angleTable[x + shiftLookX][y + shiftLookY]+ shiftY) % textureImg.height;




            // tunnelEffect.pixels[x+y*twidth] = textureImg.pixels[texture_y * textureImg.width + texture_x];


            //tunnelEffect.pixels[x+y*twidth]  = color(r,g,b); //color(tim*r,g*tim,tim*b);

            // test lookuptables
            // tunnelEffect.pixels[x+y*w] = color( 0,texture_x,texture_y);

            int px = int(twidth/2) - (x+shiftLookX)/2;
            int py = int(theight/2) - (y+shiftLookY)/2;

            float dist2 = px*px+py*py;
            // TODO: FIX this shit
            if (dist2 < min_dist) {
                min_dist = dist2;
                centerPosX = (px+x)*ratioXfix;
                centerPosY = (py+y)*(ratioYfix);
            }

            float r = red(textureImg.pixels[texture_y * textureImg.width + texture_x]);
            float g = green(textureImg.pixels[texture_y * textureImg.width + texture_x]);
            float b = blue(textureImg.pixels[texture_y * textureImg.width + texture_x]);


            // TODO: FIX this shit
            if (dist2 < min_dist) {
                min_dist = dist2;
                centerPosX = (px+x)*ratioXfix;
                centerPosY = (py+y)*(ratioYfix);
            }



            // tunnelEffect.pixels[x+y*twidth]  = textureImg.pixels[texture_y * textureImg.width + texture_x];

            if (effectStatus == 0) { // blue tube

                if (timer < 10000) {
                    if (dist2 < 1000) {
                        tunnelEffect.pixels[x+y*twidth] = color( tim*(dist2/1000)*r/255.0*255, tim*(dist2/1000)*g/255.0*255, tim* (dist2/1000)*b/255.0*255);
                    } else {
                        tunnelEffect.pixels[x+y*twidth] = color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                    }
                } else {
                    float d1 = min(max(fft.getBand( int(dist2/(500.0*800))%5)/20,1),2.5);
                    // float d2 = fft.getBand( int(dist2/(500.0*800))%20)/30;

                    if ((texture_x%flashNro)==0) { /*texture_x < 50 && texture_x > 10 && random(1000)<10*/
                        float m = max((texture_x - 50.0)/40.0, 0.1);

                        tunnelEffect.pixels[x+y*twidth] = color( d1*r/255.0*255, d1*g/255.0*255, d1*b/255.0*255);
                        /*
                                 }else if (texture_x < 250 && texture_x > 200 && random(1000)<100){
                        float m = dist2/(500.0*800);
                        tunnelEffect.pixels[x+y*twidth] = color( m*d2*(dist2/1000)*r/255.0*255, d2*(dist2/1000)*g/255.0*255, d2*(dist2/1000)*b/255.0*255);
                        */
                    } else if (dist2 < 1000) {
                        tunnelEffect.pixels[x+y*twidth] = color( (dist2/1000)*r/255.0*255, (dist2/1000)*g/255.0*255, (dist2/1000)*b/255.0*255);
                    } else {
                        tunnelEffect.pixels[x+y*twidth] = color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                    }


                }

            } else if ( effectStatus == 1) {   // blue strobo tube

                // if (true){
                float d1 = fft.getBand( int(dist2/(500.0*800))%5)/3;
                float d2 = fft.getBand( int(dist2/(500.0*800))%10)/3;
                float d3 = fft.getBand( int(dist2/(500.0*800))%20)/3;
                tunnelEffect.pixels[x+y*twidth] = color( d1*r/255.0*255, d2*g/255.0*255, d3*b/255.0*255);
                /*
                         if (dist2 < 1000){
                  tunnelEffect.pixels[x+y*twidth] = color( tim*(dist2/1000)*r/255.0*255, tim*(dist2/1000)*g/255.0*255, (dist2/1000)*b/255.0*255);
                         }else{
                 tunnelEffect.pixels[x+y*twidth] = color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                         }*/

            } else if ( effectStatus == 2) {  // white nest

                if (timer > 57000) {
                    float d1 = fft.getBand( int(dist2/(500.0*800))%5)/3;
                    float d2 = fft.getBand( int(dist2/(500.0*800))%10)/3;
                    float d3 = fft.getBand( int(dist2/(500.0*800))%20)/3;
                    tunnelEffect.pixels[x+y*twidth] = color( d1*r/255.0*255, d2*g/255.0*255, d3*b/255.0*255);
                } else {

                    if (dist2 < 1000) {
                        tunnelEffect.pixels[x+y*twidth] = color( tim*(dist2/1000)*r/255.0*255, tim*(dist2/1000)*g/255.0*255, tim*(dist2/1000)*b/255.0*255);

                    } else {
                        tunnelEffect.pixels[x+y*twidth] = color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                    }
                }


            } else if ( effectStatus == 3) { // red nest

                if (dist2 < 1000) {
                        tunnelEffect.pixels[x+y*twidth] = color( tim*(dist2/1000)*r/255.0*255, tim*(dist2/1000)*g/255.0*255, tim*(dist2/1000)*b/255.0*255);
                }else if (timer > 87000) {
                    float d1 = fft.getBand( int(dist2/(500.0*800))%5)/3;
                    float d2 = fft.getBand( int(dist2/(500.0*800))%10)/3;
                    float d3 = fft.getBand( int(dist2/(500.0*800))%20)/3;
                    tunnelEffect.pixels[x+y*twidth] = color( d1*r/255.0*255, d2*g/255.0*255, d3*b/255.0*255);
                } else {

                    if (dist2 < 1000) {
                        tunnelEffect.pixels[x+y*twidth] = color( tim*(dist2/1000)*r/255.0*255, tim*(dist2/1000)*g/255.0*255, tim*(dist2/1000)*b/255.0*255);

                    } else {
                        tunnelEffect.pixels[x+y*twidth] = color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                    }
                }


            } else if ( effectStatus == 4) { // gray net
              float rad = 1000;
                if (dist2 < rad) {
                    tunnelEffect.pixels[x+y*twidth] = color( tim*(dist2/rad)*r/255.0*255, tim*(dist2/rad)*g/255.0*255, tim*(dist2/rad)*b/255.0*255);

                } else if (texture_x < 250 && texture_x > 200) {
                    float d1 = fft.getBand( int(dist2/(500.0*800))%5)/100;
                    float m = max((texture_x - 50.0)/40.0, 0.1);
                    tunnelEffect.pixels[x+y*twidth] = color( m*d1*r/255.0*255, m*d1*g/255.0*255, m*d1*b/255.0*255);
                } else {
                    tunnelEffect.pixels[x+y*twidth] = textureImg.pixels[texture_y * textureImg.width + texture_x]; //= color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                }


            } else if ( effectStatus == 5) { // lines
                if (dist2 < 1000) {
                    tunnelEffect.pixels[x+y*twidth] = color( tim*(dist2/1000)*r/255.0*255, tim*(dist2/1000)*g/255.0*255, tim*(dist2/1000)*b/255.0*255);
                } else {
                    tunnelEffect.pixels[x+y*twidth] = textureImg.pixels[texture_y * textureImg.width + texture_x]; //= color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                }
            } else if ( effectStatus == 6) { // blue tube
                float rad = holeRad;
                  
                if (dist2 < rad*rad) {
                  float asd = dist2/(rad*rad);
                    tunnelEffect.pixels[x+y*twidth] = color( tim*(asd)*r/255.0*255, tim*(asd)*g/255.0*255, tim*(asd)*b/255.0*255);
                } else {
                    tunnelEffect.pixels[x+y*twidth] = color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                }

            } else if ( effectStatus == 7) {
                if (dist2 < 1000) {
                    tunnelEffect.pixels[x+y*twidth] = color( tim*(dist2/1000)*r/255.0*255, tim*(dist2/1000)*g/255.0*255, tim*(dist2/1000)*b/255.0*255);
                } else {
                    tunnelEffect.pixels[x+y*twidth] = color( tim*r/255.0*255, tim*g/255.0*255, tim*b/255.0*255);
                }

            }

        }
    }
//  print(ratioYfix+"\n");
    tunnelEffect.updatePixels();
    tunnelEffect.endDraw();

// display the results
    image(tunnelEffect,0,0,width,height);


    // Update ammos
    for (int i = balls.size()-1; i >= 0; i--) {
        Ball ball = balls.get(i);
        ball.updateTarget(centerPosX,centerPosY);
        ball.move();
        ball.display(fireballTexture,fireballTextureBlur);
        if (ball.finished()>0) {
            balls.remove(i);
        }
    }


}


void setup_credit() {
  //size(1280, 720, P3D);
  credit_image = loadImage("thank.png");
  bg = loadImage("galaxy.jpg");
  //noStroke();
  
bg.resize(1800, 1800);
credit_image.resize(640, 480);
}

void rotatee(){
  rotateY(kulma);
  kulma += 0.001;
  if (kulma > 3.3 && imagecounter < 2){
    imagecounter += 1;
    kulma = 0;
    if (imagecounter < texts.length){
      updateImage();
    }
  }
}
void updateImage(){
  credit_image = loadImage(texts[imagecounter]);
}

void drawCredit() {
  background(0);
  pushMatrix();
  translate(width/2, height/2);
  rotate(credit_counter);
  translate(-bg.width/2, -bg.height/2);
  translate(0, 0, -100);
  credit_counter += 0.001;
  image(bg, 0, 0);
  popMatrix();
  pushMatrix();
  translate(width / 2, height / 2);
  translate(0, 0, 200);
  rotatee();
  rotateZ(PI/6);
  int luku = 5;
  for (int i = 0; i < luku; i++){
    pushMatrix();
    rotatee();
    beginShape();
    texture(credit_image);
    vertex(credit_x2-(luku+i)/5, -100, 0, 0, 0);
    vertex(credit_x-(luku+i)/5, -100, 0, 1, 0);
    vertex(credit_x-(luku+i)/5, 100, 200, 1, 1);
    vertex(credit_x2-(luku+i)/5, 100, 200, 0, 1);
    endShape();
    popMatrix();
  }
  popMatrix();
}


