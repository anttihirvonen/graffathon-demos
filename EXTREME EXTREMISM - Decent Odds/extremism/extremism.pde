import moonlander.library.*;
import ddf.minim.*;

Moonlander moonlander;

Boxez boxez = new Boxez();
Tesla t = new Tesla(); 

void setup() {
  size(1920, 1080, P3D);
  moonlander = Moonlander.initWithSoundtrack(this, "data/ruuvvailu_8.mp3", 128, 8);
  blendMode(ADD);
  t.setup();
  boxez.setup();
  moonlander.start();
}

void draw() {
  moonlander.update();
  int sceneIndex = moonlander.getIntValue("scene");
  
  boolean transitioned = false;
  
  if (sceneIndex == 0) {
    t.draw();
  } else if (sceneIndex == 1) {
    if (!transitioned) {
      transitioned = true;
      resetMatrix();
      boolean caught = false;
      while (!caught) {
        try {
          popMatrix();
        } catch (Exception ex) {
          caught = true;
        }
      }
      
      camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    }
     
    boxez.draw();
  } else if (sceneIndex == 2) {
    boxez.filterOnly();
  } else {
    exit();
  }
}

class Boxez {
  double lastFrame = 0;
  float rate = 40.0f;
  PShader horizBlurShader;
  PShader vertBlurShader;
  PShader rays;
  
  public void setup() {
    randomSeed(0x1337);
      horizBlurShader = loadShader("blur_frag.glsl");
    horizBlurShader.set("pixelSize", 1.0f / width, 0.0f);
    vertBlurShader = loadShader("blur_frag.glsl");
    vertBlurShader.set("pixelSize", 1.0f / width, 0.0f);
    rays = loadShader("rays.glsl");
    rays.set("decay", 0.8f);
    rays.set("density", 0.2f);
    rays.set("weight", 0.2f);
    rays.set("exposure", 0.5f);
    rays.set("light", 0.5f, 0.5f);
    lastFrame = moonlander.getCurrentTime();
  }
  
  class Box { 
    float rX;
    float rY;
    float rZ;
    
    boolean render = true;
    
    static final float thickness = 30.0f;
    static final float length = 60.0f;
    static final float scaleRate = 8.0f;
    
    float scale = 2.0f;
    
    Box() {
      /*rX = radians(random(0.0f, 90.0f) < 45.0f ? 0.0f : 90.0f);
      rY = radians(random(0.0f, 90.0f) < 45.0f ? 0.0f : 90.0f);
      rZ = radians(random(0.0f, 90.0f) < 45.0f ? 0.0f : 90.0f);*/
      
      rX = radians(random(0.0f, 50.0f));
      rY = radians(random(0.0f, 50.0f));
      rZ = radians(random(0.0f, 50.0f));
    }
    
    public void disable() {
      render = false;
    }
    
    public void transform() {
      translate(0.0f, length * 0.75f * scale, 0.0f);
      
      rotateX(rX);
      rotateY(rY);
      rotateZ(rZ);
    }
    
    private void render(float deltaTime) {
      if (scale > 1.0f) {
        scale -= scaleRate * (deltaTime / 1000.0f);
      }
      scale = max(scale, 1.0f);
      
      transform();
      /*translate(0.0f, length * 0.75f * scale, 0.0f);
      
      rotateX(rX);
      rotateY(rY);
      rotateZ(rZ);*/
      
      if (render)
        box(thickness * scale, length * scale, thickness * scale);
    }
  }
  
  ArrayList<Box> boxes = new ArrayList<Box>();
  float boxSpawnTime = 100.0f;
  float boxAccumulator = 100.0f;
  int maxBoxes = 20;
  int disableIndex = 0;
  boolean added = false;
  
  public void createBox() {
    if (boxes.size() + 1 > maxBoxes) {
      boxes.get(disableIndex).disable();
      disableIndex++;
    }
  
    added = true;
    boxes.add(new Box());
  }
  
  public void transformBoxes() {
    for (Box b : boxes) {
      b.transform();
      printCamera();
    }
  }
  
  PVector curCamPos = new PVector();
  PVector nextCamPos = new PVector();
  PVector oldCamPos = new PVector();
  float camSpeed = 0.1f;
  
  public void renderBoxes(float deltaTime) {
    pushMatrix();
    for (Box b : boxes) {
      b.render(deltaTime);
    }
    popMatrix();
  }
  
  float cx = 0;
  float cy = 0;
  float cz = 0;
  float ex = 0;
  float ey = 0;
  float ez = 0;
  int br = 0;
  int bg = 0;
  int bb = 0;
  
  public void draw() {
    cx = (float)moonlander.getValue("camX");
    cy = (float)moonlander.getValue("camY");
    cz = (float)moonlander.getValue("camZ");
    ex = (float)moonlander.getValue("eyeX");
    ey = (float)moonlander.getValue("eyeY");
    ez = (float)moonlander.getValue("eyeZ");
    br = moonlander.getIntValue("br");
    bg = moonlander.getIntValue("bg");
    bb = moonlander.getIntValue("bb");
    
    float deltaTime = 0.0f;
    float curFrame = (float)moonlander.getCurrentTime();
    deltaTime = (float)(curFrame - lastFrame) * 1000;
    lastFrame = curFrame;
    
    deltaTime = max(0.0f, deltaTime);
    deltaTime = min(deltaTime, 16.0f);
    boxAccumulator += deltaTime;
    if (boxAccumulator >= boxSpawnTime) {
      createBox();
      boxAccumulator -= boxSpawnTime;
    }
    
    fill(br, bg, bb, 0x10 );
    strokeWeight(4);
    lights();
    pointLight(255, 0, 0, 0, 0, 0);
    //translate(width / 2, height / 2, 0);
    camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
    filterOnly();
    camera(ex, ey, ez, cx, cy, cz, 0.0, 1.0, 0.0);
    blendMode(ADD);
    renderBoxes(deltaTime);
  }
  
  public void filterOnly() {
    filter(rays);
    filter(horizBlurShader);
    filter(vertBlurShader);
  }
}

class Tesla {  
  PShape tesla, room;
  PShape decentodds, crank, flamero, cce, title;
  
  int CANVAS_WIDTH = 800;
  int CANVAS_HEIGHT = 600;
  float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;
  
  
  public void setup() {
   tesla = loadShape("tesla.obj");
   room = loadShape("room.obj");
   decentodds = loadShape("decentodds.obj"); // [0]
   crank = loadShape("crank.obj");           // [1] 
   flamero = loadShape("flamero.obj");       // [2]  
   cce = loadShape("cce.obj");               // [3]
   title = loadShape("extreme.obj");         // [4]
  }
  
  float rotation = 0;
  
  public void draw() {
    moonlander.update(); 
    
    background(0);
    resetMatrix();
    int alights = moonlander.getIntValue("ambientlights");
    int dlights = moonlander.getIntValue("directionalLights");
    ambientLight(alights, alights, alights);
    directionalLight(dlights, dlights, dlights, 0, 1, -1);
    
    float fov = (float)moonlander.getValue("fov");
    float cameraZ = (height/2.0) / tan(fov/2.0);
    
    perspective(fov, float(width)/float(height), cameraZ/10.0, cameraZ*10.0);
    float eyeX;
    float eyeZ;
    
    // Enable/disable camera rotation
    int rotate = moonlander.getIntValue("rotate");
    float rotateDist = (float)moonlander.getValue("rotatedistance");
    float rotateSpeed = (float)moonlander.getValue("rotatespeed");
    if(rotate == 1){
      float secs = millis() / rotateSpeed;
      eyeX = cos(radians(secs))*rotateDist;
      eyeZ = sin(radians(secs))*rotateDist;
    rotation++;
    } else {
      eyeX = (float)moonlander.getValue("eyeX");
      eyeZ = (float)moonlander.getValue("eyeZ");
    }
    // Camera controls
    float eyeY = (float)moonlander.getValue("eyeY");
    float cX = (float)moonlander.getValue("centerX");
    float cY = (float)moonlander.getValue("centerY");
    float cZ = (float)moonlander.getValue("centerZ");
      
    camera(eyeX, eyeY, eyeZ, cX, cY, cZ, 0, 1, 0);  
    
    // Texts
    int text = moonlander.getIntValue("enableText");
    int musicby = moonlander.getIntValue("musicby");
    
    int textRotate = moonlander.getIntValue("textRotate");
    int pushText = moonlander.getIntValue("textZ");
    if(text > 0 && text < 6){
      translate(0, 0, pushText);
      
      rotateY(radians(textRotate));
      drawText(text);
      if(musicby == 1) { 
        rotateY(radians(180));
        textSize(24);
        textAlign(CENTER);
        text("music by", 0, -70);
        fill(255);
      }
      
    }
    
    // Lightning intensity
    int volts = moonlander.getIntValue("volts");
    
    int teslaroom = moonlander.getIntValue("enableTesla");
    if(teslaroom == 1) {
      blendMode(BLEND);
      room();
      drawTesla(volts);
    }
    int moreCoils = moonlander.getIntValue("moreCoils");
    float coilMulti = (float)moonlander.getValue("coilMultiplier");
    int coilAmount = moonlander.getIntValue("coilAmount");
    if(moreCoils == 1) {
      for(int i = 1; i < coilAmount; i++){
        pushMatrix();
        rotateY(radians(30*coilMulti*i));
        translate(0, 0, coilMulti*i+200);
        
        drawTesla(volts);
        
        popMatrix();
      }
    }
  }
  
  void drawTesla(int volts) {
    pushMatrix();
    teslacoil();
      
      for (int i = 1; i <= 8; i++){
        lightning(0, volts); 
        rotateX(radians(random(0, 10)));
        rotateY(radians(random(0.0f, 360.0f)));
        rotateZ(radians(random(0, 10)));
      }
      popMatrix();
  }
  
  void drawText(int text) {
    pushMatrix();
    scale(100.0);
    if(text == 1) shape(decentodds);
    if(text == 2) shape(crank);
    if(text == 3) shape(flamero);
    if(text == 4) shape(cce);
    if(text == 5) shape(title);
    popMatrix();
  }
    
  
  void teslacoil() {
    pushMatrix();
    scale(100.0);
    shape(tesla);
    popMatrix();
  }
  
  void room() {
    pushMatrix();
    scale(100.0);
    shape(room);
    popMatrix();
  }
  
  void lightning(float x0, int maxSegments) {
    if(maxSegments <= 4) return;
    
    int segments =  (int)random(4, maxSegments);
    int step = ((width / 4) / segments);
    pushMatrix();
    for (int i = 0; i < segments; i++) {
      
      float x1 = step + random(10, 64);
      
      float blue = random(150, 255);
      fill(blue, blue, 255);
      noStroke();
      box(3, 3, x1);
      
      rotateX(radians(random(-10.0f, 10.0f)));
      rotateY(radians(random(-15.0f, 15.0f)));
      rotateZ(radians(random(-10.0f, 10.0f)));
      
      translate(0, 0, x1-10);
      
      
      x0 = x1;
      
      if(random(0,8) >= 4.0f) {
        lightning(x0, maxSegments / 2);
      }
    }
    popMatrix();
  }
}
