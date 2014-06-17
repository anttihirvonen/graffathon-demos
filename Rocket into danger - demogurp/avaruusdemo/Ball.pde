
class Ball {

  float r;   // radius
  float r_max;
  float x, y; // location
  float speed; // speed
  //float speedy; // speed
  float angle;
    float targetX, targetY;
  
  
    
    
    
  // Constructor
  Ball(float tempR, int x_, int y_, float speed_) {
    r_max = tempR;
    r = r_max;
    x = x_;
    y = y_;
    speed = speed_;
    targetX = 0;
    targetY = 0;
  }

  void move() {
    angle = atan2((targetY-y), (targetX-x));
    //PVector target = new PVector(targetX,targetY);
   // PVector pos = new PVector(x,y);
    // target.sub(pos);
     
    x += speed * cos(angle); // Increment x
    y += speed * sin(angle); // Increment y
    float dist = (targetY-y)*(targetY-y) + (targetX-x)*(targetX-x);
    r = r_max * dist/((width/2)*(width/2));
    if (r>r_max) r = r_max;
   // print(r+"\n");

  }

  void updateTarget(float targetX_, float targetY_)
  {
    targetX = targetX_;
    targetY = targetY_;
   // angle = atan2((targetY-y), (targetX-x));
  }
  
  int finished(){
    if (r < 1) return 1;
    return 0;
  }
  
  // Draw the ball
  void display(PImage texture, PImage texture2) {
    noStroke();
    //fill(200,200,0);
    //ellipse(x, y, r*2, r*2);
   // texture.mask([0,0,0]);
    image(texture,x,y,r*2,r*2); 
    //texture.mask(texture2);
    image(texture2,x,y,r*2,r*2); 
     //image(texture2,x,y,r*2,r*2); 
  }
}

