
class WavyThing {
  Boolean bgwhite = false;
  float aspect_ratio = 0;
  float sx1;
  float ex1;
  
  void drawCustomBezier(float time, float bps, int bezier_count, float sx, float sy, float ex, float ey)
  {
    float bez_incrx = abs(sx-ex)/(bezier_count);
    float bez_incry = abs(sy-ey)/(bezier_count);
    
    aspect_ratio = (float)width / height;
    sx1 = -aspect_ratio;
    ex1 = aspect_ratio;
    
    beginShape();
    vertex(sx, sy);
    for (int i = 0; i < bezier_count; ++i)
    {
       float px = sx+i*bez_incrx;
       float py = sy+i*bez_incry;
       bezierVertex(px + 0.5f*bez_incrx, py + 0.5f*bez_incry + sin(((0.001f*time)%bps)*2*PI), px + 0.5f*bez_incrx, py + 0.5f*bez_incry - sin(((0.001f*time)%bps)*2*PI), px+bez_incrx, py+bez_incry);
    }
    endShape(); 
  }
  
  float sy1 = 0.0f;
  float ey1 = 0.0f;
  
  float incr = 0.06f;
  
  float strkwght = 0.04f;
  float bps = (148.0f/60.0f);
  float bps2 = bps*2.0f;
  
  int linecount = 0;
  
  void drawCustomBeziers(float time, float bps, int bezier_count, int line_count)
  {
      for (int i = 0; i < line_count; ++i)
      {
          float ypos = (1.0f/(i+2))*2.0f-1.0f;
          drawCustomBezier(time, bps, 4, -aspect_ratio, 0.5f+ypos, aspect_ratio, 0.5f+ypos);
      }
  }
  
  Boolean changelinecount = true;
  Boolean makeitstoppls = false;
  void draw(float time) {
    pushMatrix();
    clear();
    translate(width/2.0, height/2.0);
    scale(width/2.0/aspect_ratio, -height/2.0);
    
    if (!makeitstoppls)
    {
      if (((time*0.01f) % bps2) < bps)
      {
          background(255);
          stroke(0);
          if (changelinecount && ((time*0.01f) % bps2*2) < bps2)
          {
              changelinecount = false;
              ++linecount;
          }
      }
      else
      {
         background(0);
         stroke(255);
         if (linecount > 11)
           makeitstoppls = true;
         changelinecount = true;
      }
        
      noFill();
      strokeWeight(strkwght);
      drawCustomBeziers(time, bps, 4, max(1, linecount));
    }
    popMatrix();
  }
}
