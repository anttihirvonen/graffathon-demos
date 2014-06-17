class pLintu 
{
  float x1;
  float y1;
  float z1;
  float x2;
  float y2;
  float z2;
  color c = color(0,0,0);
  int speed = 1;
  int fly = 0;
  float degree = 1.5;
  
  
  pLintu(float beginX, float beginY,float beginZ,float endX,float endY,float endZ) 
  {
    x1 = beginX;
    y1 = beginY;
    z1 = beginZ;
    x2 = endX;
    y2 = endY;
    z2 = endZ;
    
  }
  
  void move(int value) 
  {
        
    x1 += (x1-x2)/30*value;
    y1 += (y1-y2)/30*value;

    x2 += (x1-x2)/30*value;
    y2 += (y1-y2)/30*value;

  }
  
  void moveP(float valueX,float valueY)
  {
    if (x1-x2 < 0)
    {
      x1 -= valueX;
      x2 -= valueX;
    }
    if (x1-x2 > 0)
    {
      x1 += valueX;
      x2 += valueX;
    }
    if (y1-y2 < 0)
    {
      y1 -= valueY;
      y2 -= valueY;
    }
    if (y1-y2 > 0)
    {
      y1 += valueY;
      y2 += valueY;
    }
    
    if(y1 < -900 && y2 < -900)
    {
       x1 = random(-1000,1000);
       x2 = x1; 
       y1 += 1800;
       y2 += 1800;
    }
    
    
  }
    void moveP2(float valueX,float valueY)
  {
    if (x1-x2 < 0)
    {
      x1 -= valueX;
      x2 -= valueX;
    }
    if (x1-x2 > 0)
    {
      x1 += valueX;
      x2 += valueX;
    }
    if (y1-y2 < 0)
    {
      y1 -= valueY;
      y2 -= valueY;
    }
    if (y1-y2 > 0)
    {
      y1 += valueY;
      y2 += valueY;
    }
    
    if(y1 < -900 && y2 < -900)
    {
       x1 = random(-1000,1000);
       x2 = x1; 
       y1 += 1800;
       y2 += 1800;
    }
    
    
  }
  void setPosition(float beginX,float beginY,float beginZ, float endX,float endY,float endZ)
  {
    x1 = beginX;
    y1 = beginY;
    z1 = beginZ;
    x2 = endX;
    y2 = endY;
    z2 = endZ;
  }
  
  void fly()
  {
   
    fly += speed;
    if (fly < -20)
      speed = -speed;
    if (fly > 30)
      speed = -speed;
    degree = radians(fly);
    //vasen siipi
    fill(color(random(100),255,255));
    beginShape();
    vertex(x1+(x2-x1)/3+(y2-y1)/5,y1+(y2-y1)/3-(x2-x1)/5,0);
    vertex(x1+cos(degree)*((x2-x1)/3+(y2-y1)),y1+cos(degree)*((y2-y1)/3-(x2-x1)),sin(degree)*((x2-x1)/3+(y2-y1)));
    vertex((x2+x1+(x2-x1)/3+(y2-y1)/5)/2,(y2+y1+(y2-y1)/3-(x2-x1)/5)/2,0);
    endShape();
   
   //oikea siipi
   beginShape();
   vertex(x1+(x2-x1)/3-(y2-y1)/5,y1+(y2-y1)/3+(x2-x1)/5,0);
   vertex(x1+cos(degree)*((x2-x1)/3-(y2-y1)),y1+cos(degree)*((y2-y1)/3+(x2-x1)),sin(degree)*((x2-x1)/3+(y2-y1)));
   vertex((x2+x1+(x2-x1)/3-(y2-y1)/5)/2,(y2+y1+(y2-y1)/3+(x2-x1)/5)/2,0);
   endShape();
    
  }
  void paper() 
  {
   
    //vartalo
    fill(c);
    beginShape();
    vertex(x1,y1,z1);
    vertex(x1+(x2-x1)/4+(y2-y1)/5,y1+(y2-y1)/3-(x2-x1)/5,0);
    vertex(x2,y2,0);
    vertex(x1+(x2-x1)/4-(y2-y1)/5,y1+(y2-y1)/3+(x2-x1)/5,0);
    vertex(x1,y1,z1);
    
    endShape();
  
  
  }
  
 void changeColor(int value)
 {
   c = color(random(value),255,255);
 }
 boolean getColor()
 {
   if (c == color(0,0,0))
     return false;
   else
     return true;
 }
 float rightX()
 {
   return x1+(x2-x1)/3+(y2-y1)/5;
 }
 float leftX()
 {
   return x1+(x2-x1)/3-(y2-y1)/5;
 }
 float rightY()
 {
   return y1+(y2-y1)/3-(x2-x1)/5;
 }
 float leftY()
 {
   return y1+(y2-y1)/3+(x2-x1)/5;
 }
 float rightZ()
 {
   return 0;
 }
 float leftZ()
 {
   return 0;
 }
 float headX()
 {
   return x1;
 }
 float headY()
 {
   return y1;
 }
 float headZ()
 {
   return z1;
 }
  float tailX()
 {
   return x2;
 }
 float tailY()
 {
   return y2;
 }
 float tailZ()
 {
   return z2;
 }
}
