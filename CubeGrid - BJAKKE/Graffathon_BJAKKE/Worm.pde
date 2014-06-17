import toxi.geom.*;

class Worm{
  
  PApplet applet;
  Vec3D pos;
  PShape shape;
  float startTime = 0;

  Worm(PApplet _applet, float x, float y, float z){
    applet = _applet;
    pos = new Vec3D(x, y, z);    
    
    shape = createShape(PConstants.SPHERE, 5);
    shape.setFill(color(255, 255, 255));
    shape.setStroke(color(0, 255, 255));
    shape.setStrokeWeight(1);
  }
  
  void setStartTime(float seconds){
    if(startTime <1){
      startTime = seconds;
    }
  }
  
  void drawInternal(){
    shape(shape);
  }
  
  void draw(float seconds){
    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    drawInternal();
    
    
    float stepsize = 0.1;    
    for(float t = startTime; t < seconds; t+=stepsize){
       translate(20, 50, 80*sin(t));
       rotateX(t*5);
       rotateY(t*4);
       rotateZ(sin(t)*1);
       drawInternal();      
    }
    
    
    popMatrix();
    
  }
  
  
}
