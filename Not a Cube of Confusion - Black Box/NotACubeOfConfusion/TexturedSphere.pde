
static class TexturedSphereInfo {
  static float sphereRadius = 200;
  static int res = 10;
  
  static float[] cx, cz, sphereX, sphereY, sphereZ;
  static float sinLUT[];
  static float cosLUT[];
  static float SINCOS_PRECISION = 0.5;
  static int SINCOS_LENGTH = int(360.0 / SINCOS_PRECISION);
  
  static void init(int res) {
    TexturedSphereInfo.res = res;
    
    sinLUT = new float[SINCOS_LENGTH];
    cosLUT = new float[SINCOS_LENGTH];
  
    for (int i = 0; i < SINCOS_LENGTH; i++) {
      sinLUT[i] = (float) Math.sin(i * DEG_TO_RAD * SINCOS_PRECISION);
      cosLUT[i] = (float) Math.cos(i * DEG_TO_RAD * SINCOS_PRECISION);
    }
  
    float delta = (float)SINCOS_LENGTH/res;
    float[] cx = new float[res];
    float[] cz = new float[res];
    
    // Calc unit circle in XZ plane
    for (int i = 0; i < res; i++) {
      cx[i] = -cosLUT[(int) (i*delta) % SINCOS_LENGTH];
      cz[i] = sinLUT[(int) (i*delta) % SINCOS_LENGTH];
    }
    
    // Computing vertexlist vertexlist starts at south pole
    int vertCount = res * (res-1) + 2;
    int currVert = 0;
    
    // Re-init arrays to store vertices
    sphereX = new float[vertCount];
    sphereY = new float[vertCount];
    sphereZ = new float[vertCount];
    float angle_step = (SINCOS_LENGTH*0.5f)/res;
    float angle = angle_step;
    
    // Step along Y axis
    for (int i = 1; i < res; i++) {
      float curradius = sinLUT[(int) angle % SINCOS_LENGTH];
      float currY = -cosLUT[(int) angle % SINCOS_LENGTH];
      for (int j = 0; j < res; j++) {
        sphereX[currVert] = cx[j] * curradius;
        sphereY[currVert] = currY;
        sphereZ[currVert++] = cz[j] * curradius;
      }
      angle += angle_step;
    } 
  }
}

PShape sphereShape;
PShader sphereShader;
PImage sphereImage;

void createSphereGeometry(float r, int res) {
    
    sphereShader = loadShader("frag.glsl", "vert.glsl");
    sphereImage = loadImage("sphere.png");  
    textureMode(IMAGE);  
    sphereShape = createShape();
    
    int v1,v11,v2;
    r = (r + 240 ) * 0.33;
    sphereShape.beginShape(TRIANGLE_STRIP);
    sphereShape.noStroke();
    sphereShape.texture(sphereImage);
    float iu=(float)(sphereImage.width-1)/(res);
    float iv=(float)(sphereImage.height-1)/(res);
    float u=0,v=iv;
    for (int i = 0; i < res; i++) {
      sphereShape.vertex(0, -r, 0,u,0);
      sphereShape.vertex(TexturedSphereInfo.sphereX[i]*r, TexturedSphereInfo.sphereY[i]*r, TexturedSphereInfo.sphereZ[i]*r, u, v);
      u+=iu;
    }
    sphereShape.vertex(0, -r, 0,u,0);
    sphereShape.vertex(TexturedSphereInfo.sphereX[0]*r, TexturedSphereInfo.sphereY[0]*r, TexturedSphereInfo.sphereZ[0]*r, u, v);
    sphereShape.endShape();   
    
    // Middle rings
    int voff = 0;
    for(int i = 2; i < res; i++) {
      v1=v11=voff;
      voff += res;
      v2=voff;
      u=0;
      sphereShape.beginShape(TRIANGLE_STRIP);
      sphereShape.noStroke();
      sphereShape.texture(sphereImage);
      for (int j = 0; j < res; j++) {
        sphereShape.vertex(TexturedSphereInfo.sphereX[v1]*r, TexturedSphereInfo.sphereY[v1]*r, TexturedSphereInfo.sphereZ[v1++]*r, u, v);
        sphereShape.vertex(TexturedSphereInfo.sphereX[v2]*r, TexturedSphereInfo.sphereY[v2]*r, TexturedSphereInfo.sphereZ[v2++]*r, u, v+iv);
        u+=iu;
      }
    
      // Close each ring
      v1=v11;
      v2=voff;
      sphereShape.vertex(TexturedSphereInfo.sphereX[v1]*r, TexturedSphereInfo.sphereY[v1]*r, TexturedSphereInfo.sphereZ[v1]*r, u, v);
      sphereShape.vertex(TexturedSphereInfo.sphereX[v2]*r, TexturedSphereInfo.sphereY[v2]*r, TexturedSphereInfo.sphereZ[v2]*r, u, v+iv);
      sphereShape.endShape();
      v+=iv;
    }
    u=0;
    
    // Add the northern cap
    sphereShape.beginShape(TRIANGLE_STRIP);
    
    sphereShape.noStroke();
    sphereShape.texture(sphereImage);
    for (int i = 0; i < res; i++) {
      v2 = voff + i;
      sphereShape.vertex(TexturedSphereInfo.sphereX[v2]*r, TexturedSphereInfo.sphereY[v2]*r, TexturedSphereInfo.sphereZ[v2]*r, u, v);
      sphereShape.vertex(0, r, 0,u,v+iv);    
      u+=iu;
    }
    sphereShape.vertex(TexturedSphereInfo.sphereX[voff]*r, TexturedSphereInfo.sphereY[voff]*r, TexturedSphereInfo.sphereZ[voff]*r, u, v);
    sphereShape.endShape();
  }
  
class TexturedSphere {
  float cutoffStartZ = 0;
  float cutoff = 0.0;
  float x, y, z;
  float rotY;
  float rotYSpeed = 0;
  float scale = 0;
  float time = 0;
  float scaleLimit = 0;
  float scaleSpeed = 0;
  
  void draw(float time) {
    rotY = time * rotYSpeed;
    scale = min(scaleLimit, (time - this.time) * scaleSpeed);
    sphereShader.set("cutoff", cutoff);
    shader(sphereShader); 
   
    float xOffset = abs(x - width / 2) < 1 ? 0 : (time - this.time) * 10.0 / (x - width / 2);
    float yOffset = abs(y - height / 2) < 1 ? 0 : (time - this.time) * 10.0 / (y - height / 2); pushMatrix();
    
    translate(x + xOffset, y + yOffset, z);
    rotateY(rotY);
    scale(scale);
    
    shape(sphereShape);  
    
    popMatrix();
  }
  
  TexturedSphere(float x, float y, float z, float cutoffStartZ, float rotYSpeed, float scaleSpeed, float time, float scaleLimit)
  {
    this.rotYSpeed = rotYSpeed;
    this.x = x; 
    this.y = y;
    this.z = z;
    this.cutoffStartZ = cutoffStartZ;
    this.time = time;
    this.scaleSpeed = scaleSpeed;
    this.scaleLimit = scaleLimit;
  }
}
