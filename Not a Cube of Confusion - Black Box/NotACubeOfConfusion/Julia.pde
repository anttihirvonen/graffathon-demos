class Julia {
  PShader shader;
  PShape shape;
  
 void init() {
  shader =  loadShader("juliafrag.glsl", "juliavert.glsl");
  shape = createShape();
  shape.beginShape(); 
  shape.vertex(0, 0); 
  shape.vertex(width, 0); 
  shape.vertex(width, height); 
  shape.vertex(0, height);
  shape.endShape(CLOSE);
 }
 
 void draw(float time) {
  shader.set("iGlobalTime", time / 1000.0);
  shader.set("iResolution", (float)width, (float)height);
  shader(shader);
  
  shape(shape);
  
  resetShader();
 }
  
}
