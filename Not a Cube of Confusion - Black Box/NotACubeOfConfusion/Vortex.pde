
class Ring {
 float time = 0;
 float radius = 0;
 float offset = 0;

  Ring(float time, float radius, float offset) {
      this.time = time;
     this.radius = radius;
     this.offset = offset;
  } 
}

class Vortex {
  TexturedSphere finaleSphere;
  ArrayList<TexturedSphere> spheres;
  ArrayList<Ring> rings;
  float cameraZ = 0;
  PGraphics bg;
  boolean finale = false;
  
  void init() {
    bg = createGraphics(width, height);
    TexturedSphereInfo.init(18);
      
    createSphereGeometry(TexturedSphereInfo.sphereRadius, TexturedSphereInfo.res);  
    spheres = new ArrayList<TexturedSphere>();
    rings = new ArrayList<Ring>();
    
    sphereShader.set("border", 0.2);
  }
  
  void createSphere(float time) {
    float z = -cameraZ - 2000;
    float ringRadius = rings.size() > 0 ? rings.get(rings.size() - 1).radius : 1;
    float x = width / 2 + ringRadius * 3.0 * random(-1, 1);
    float y = height / 2 + ringRadius * 3.0 * random(-1, 1);
    spheres.add(new TexturedSphere(x, y, z, random(800, 1200), random(0.002, 0.006), 0.0005, time, 1.0)); 
  }
  
  float createTime = 0;
  void draw(float time) {
    resetShader();
    cameraZ = time * time * 0.00005;
  
    pushMatrix();
    
    drawBackground(time);
    
    popMatrix();
    
    if (time > 2500.0 && time < 9000.0) {
      while (!finale && time - createTime > 300.0) {
        createSphere(time);
        createTime += 300.0;
      }
    }
    else {
      createTime = 2500.0; 
    }
    
    pushMatrix();
    
    translate(0, 0, cameraZ);
    
    for (int i = spheres.size() - 1; i >= 0; --i) {
      TexturedSphere sphere = spheres.get(i);
      sphere.cutoff = (sphere.cutoffStartZ - abs(-cameraZ - sphere.z)) / sphere.cutoffStartZ + 0.17;
      sphere.draw(time);
      if (sphere.cutoff >= 1.0) {
        spheres.remove(i);
      }
    } 
    
    handleFinale(time);
    
    popMatrix();
  }
  
  float finaleSphereCutoffStart = 0;
  void handleFinale(float time) {
    if (time > 10000.0 && !finale) {
      finale = true; 
      finaleSphere = new TexturedSphere(width / 2, height / 2, 0, 0, 0.001, 0.0012, time, 100.0); 
    }
    if (finaleSphere != null) {
      if (finaleSphere.scale > 0.99) {
        sphereShader.set("border", 80.0);
        finaleSphere.cutoff = (time - finaleSphereCutoffStart) * (time - finaleSphereCutoffStart) * (finaleSphere.cutoff > 1.0 ? 0.0000001 : 0.00000002) + 0.1;
      }
      else {
       finaleSphereCutoffStart = time; 
      }
      finaleSphere.z = -cameraZ - 20;
      finaleSphere.draw(time);
    }
  }
  
  int ringCounter = 0;
  float ringGap = 10.0;
  float offset = 0;
  float offsetChange = PI / 30;
  void drawBackground(float time) {
    if (!finale && (rings.size() == 0 || rings.get(rings.size() - 1).radius > ringGap)) {
      rings.add(new Ring(time * 0.9f, 0.0, offset));
      offset += offsetChange;
    }
    
    bg.beginDraw();
    bg.background(0);
    bg.noStroke();
    bg.translate(width / 2, height / 2);
    for (int i = rings.size() - 1; i >= 0; --i) {
      float t = (time - rings.get(i).time);
      rings.get(i).radius = t * t * 0.0002;
      drawRing(rings.get(i)); 
      if (rings.get(i).radius > max(width, height) * 2) {
         rings.remove(i); 
      }
    }
    bg.endDraw(); 
    
    background(bg);
  }
  
  void drawForeground() {
    if (finaleSphere != null) {
      float a = (finaleSphere.cutoff - 0.17) * 500;
      fill(255, a);
      rect(0, 0, width, height);
      fill(255);
    }
  }
  
  void drawRing(Ring ring) {
    float angle = PI * 2.0 / 12;
    for ( int i = 0; i < 12; ++i) {
      bg.pushMatrix();
      bg.rotate(angle * i - ring.offset);
      bg.translate(0, ring.radius);
      bg.ellipse(0, 0, 3, 3);
      bg.popMatrix();
    }
  }
}
