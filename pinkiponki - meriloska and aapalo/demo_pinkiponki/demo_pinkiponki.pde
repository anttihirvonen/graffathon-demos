/*For rocket connection*/
import moonlander.library.*;

/*For minim*/
import ddf.minim.*;

/*For rocket integration*/
Moonlander moonlander;

/*Shaders*/
//Pshader plasma;
//Pshader blur;

/*Resolution*/
int CANVAS_WIDTH = 1920;
int CANVAS_HEIGHT = 1080;


/*Setting things up*/
void setup() {

  moonlander = Moonlander.initWithSoundtrack(this, "auquid.mp3", 128, 4);

  // The P3D parameter enables accelerated 3D rendering.
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P3D);
  rectMode(CENTER);

  /*Load shaders*/
  //plasma = loadShader("plasmaShader.glsl");
  //blur = loadShader("blur.glsl");

  /*Load rocket integration*/
  moonlander.start();
}

/*Cube's coordinates*/
float x = 0;    
float y = 0;

/*Bar coordinates*/
/*Only y, x is constant*/
float yp1 = 0; 
float yp2 = 0;

int vp1 = 10;
int vp2 = 10;
int vx = 8;    
int vy = 8;
int y0 = -275;  
int y1 = 275;
int x0 = -350;  
int x1 = 350;

/*Draw cube*/
void draw_cube( int secs, float speed)
{  
  pushMatrix();

  /*Moving algorithm*/
  if ( (y < y0) || (y > y1) )
    vy = -1*vy;
  if ( (x < x0) || (x > x1) )
    vx = -1*vx;
  x += vx;
  y += vy;
  translate(x, y, 0);

  /*Cube rotation*/
  float rotationCube = (float)moonlander.getValue("Cube_rotation");
  rotate(rotationCube);

  /*Cube Z position for exit*/
  float cubeZ = (float)moonlander.getValue("cubeZ");
  translate(0, 0, cubeZ);

  /*Color*/
  float cubeStroke = (float)moonlander.getValue("cube_Stroke");
  stroke(cubeStroke);
  box(30);
  popMatrix();
}

/*Draw player bars*/
void draw_bar(int secs, int player)
{
  pushMatrix();
  /*Moving algorithm*/
  if (player == 1) 
  {
    if ( vx > 0) {
      if (y > yp1)
        vp1 = abs(vp1);
      if (y < yp1)
        vp1 = abs(vp1)*(-1);

      yp1 += vp1;
    }
    translate(400, yp1);
  }

  if (player == 2) {
    if (vx < 0) {
      if (y > yp2)
        vp2 = abs(vp2);
      if (y < yp2)
        vp2 = abs(vp2)*(-1);

      yp2 += vp2;
    }
    translate(-400, yp2);
  }

  fill(255);

  box(30, 150, 30);
  popMatrix();
}


/*Makes game field with player bars and game cube*/
void draw_field(int x, int y, int z, int secs)
{
  pushMatrix();
  //translate(x*1000, y*600, z*1000);

  float rotationZF = (float)moonlander.getValue("field_rotationZ");
  rotate(rotationZF);

  draw_cube(secs, 0);
  draw_bar(secs, 1);
  draw_bar(secs, 2);

  /*Draws single game ring*/
  //noFill();
  //rect(0, 0, 1000, 600);
  popMatrix();
}

void draw_space(int secs)
{
  double red_bg = moonlander.getValue("red_background");
  double green_bg = moonlander.getValue("green_background");
  double blue_bg = moonlander.getValue("blue_background");

  //Let's draw background
  background((int)red_bg, (int)green_bg, (int)blue_bg);

  //Lets move away from corner
  translate(width/2, height/2, 0);

  draw_field(0, 0, 0, secs);
}

void draw()
{
  moonlander.update();
  //filter(plasma);

  int secs = (int)moonlander.getCurrentTime();

  float sij = (float)moonlander.getValue("cam_dist");
  float rotationX = (float)moonlander.getValue("cam_rotationX");

  float rotationY = (float)moonlander.getValue("cam_rotationY");
  float rotationZ = (float)moonlander.getValue("cam_rotationZ");

  /*Camera*/
  camera(width/2, height/2, sij, width/2, height/2, 0.0, 0.0, 1.0, 0.0);

  rotateX(rotationX);
  rotateY(rotationY);
  rotateZ(rotationZ);

  /*Directional lights*/
  /*Light 1*/
  float dirl1red = (float)moonlander.getValue("dir_light1red");
  float dirl1green = (float)moonlander.getValue("dir_light1green");
  float dirl1blue = (float)moonlander.getValue("dir_light1blue");
  /*Light 2*/
  float dirl2red = (float)moonlander.getValue("dir_light2red");
  float dirl2green = (float)moonlander.getValue("dir_light2green");
  float dirl2blue = (float)moonlander.getValue("dir_light2blue");
  /*Light 3*/
  float dirl3red = (float)moonlander.getValue("dir_light3red");
  float dirl3green = (float)moonlander.getValue("dir_light3green");
  float dirl3blue = (float)moonlander.getValue("dir_light3blue");

  directionalLight(dirl1red, dirl1green, dirl1blue, 0, 1, -1);
  directionalLight(dirl2red, dirl2green, dirl2blue, 1, -1, 1);
  directionalLight(dirl3red, dirl3green, dirl3blue, 1, 1, 0);



  /*Pingpong last*/
  draw_space(secs);



  if ( (secs > 23) && (secs < 30) ) {
    textSize(32);
    fill(0, 102, 153);
    text("kiitti Pauli :3", 10, 60);
    
  }
  else if (secs > 40 && secs < 50) {
    textSize(32);
    text("pinkiponki  ", 10, 30); 
    fill(0, 102, 153);
    text("meriloska && aapalo", 10, 50);
    fill(0, 102, 153, 51);
  }
}

