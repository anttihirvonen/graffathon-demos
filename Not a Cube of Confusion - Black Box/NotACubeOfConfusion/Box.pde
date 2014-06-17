class Box
{
  
 void drawCube(float x, float y, float z, float r, float rs, float s, float u, float v, float u2, float v2)
  {
     pushMatrix();
     fill(0);
     translate(0,0,-100);
     rotateX(r);
     rotateY(r);
     rotateZ(r);
     translate(x,y,z);
     rotateX(rs);
     rotateY(rs);
     rotateZ(rs);
     noStroke();
     beginShape(QUADS);
      
      // +Z "front" face
      vertex(-s, -s,  s, u, v);
      vertex( s, -s,  s, u2, v);
      vertex( s,  s,  s, u2, v2);
      vertex(-s,  s,  s, u, v2);
    
      // -Z "back" face
      vertex( s, -s, -s, u, v);
      vertex(-s, -s, -s, u2, v);
      vertex(-s,  s, -s, u2, v2);
      vertex( s,  s, -s, u, v2);
     endShape();
      
     beginShape(QUADS);
      // +Y "bottom" face
      vertex(-s,  s,  s, u, v);
      vertex( s,  s,  s, u2, v);
      vertex( s,  s, -s, u2, v2);
      vertex(-s,  s, -s, u, v2);
    
      // -Y "top" face
      vertex(-s, -s, -s, u, v);
      vertex( s, -s, -s, u2, v);
      vertex( s, -s,  s, u2, v2);
      vertex(-s, -s,  s, u, v2);
     endShape();
    
     beginShape(QUADS);
      // +X "right" face
      vertex( s, -s,  s, u, v);
      vertex( s, -s, -s, u2, v);
      vertex( s,  s, -s, u2, v2);
      vertex( s,  s,  s, u, v2);
    
      // -X "left" face
      vertex(-s, -s, -s, u, v);
      vertex(-s, -s,  s, u2, v);
      vertex(-s,  s,  s, u2, v2);
      vertex(-s,  s, -s, u, v2);
    
     endShape();
     popMatrix();  
  } 
}
