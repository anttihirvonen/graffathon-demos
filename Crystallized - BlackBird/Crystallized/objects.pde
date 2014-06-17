class SnowFlake{
  float positionX;
  float positionY;
  float positionZ;
  int startTime;
  int endTime;
  int lifeTime;
  float angle;
  int branches;
  int maxDepth;
  float startLength;
  int phase;
  float phaseWeight;
  float scale;
  
  SnowFlake(float pos1, float pos2, float pos3, int _startTime, int _endTime){
    positionX = pos1;
    positionY = pos2;
    positionZ = pos3;
    startTime = _startTime;
    endTime = _endTime;
    angle = ((float)startTime % 623. / 623.)*HALF_PI + PI*0.1;
    branches = startTime % 3 +4;
    maxDepth = startTime % 2 +2;
    startLength = 5;
    lifeTime = endTime - startTime;
    scale = (float)(startTime % 391. / 391.) *0.5 +0.5;
  }
  
  void display(){
    if(time > startTime){
      float diff = (float)(time - startTime)/lifeTime * (maxDepth+1);
      phase = floor(diff);
      phaseWeight = diff - phase;
      
      float displayedLength = startLength;
      if (phase < 1){
        displayedLength *= phaseWeight;
      }

      pushMatrix();
      if (time > phase2Time){
        rotateX(angle*maxDepth*(time-phase2Time)*0.0002);
        rotateY(angle*branches*(time-phase2Time)*0.0002);
      }
      translate(positionX, positionY, positionZ);
      scale(scale, scale, scale);
            
      if(time > endTime){
        rotateZ(angle*(time-endTime)*0.001);
        
      }
      fill(200,210,255);
      stroke(200,210,255);
      ellipse(0,0,1,1);
      drawFlake(displayedLength);
      
      if (time > pulseTime){
        noFill();
        float timer = (float)(time - startTime)*0.001;
        for (float n = 0; n < sin(timer*PI)*2; n+=0.2){
          strokeWeight(1+n*10.);
          stroke(200,210,255, 40);
          ellipse(0,0,1+n*10.,1+n*10.);
          drawFlake(displayedLength);
        }
        strokeWeight(1);
        
      }
      popMatrix();
    }
  }
  
  void drawFlake(float _length){
    pushMatrix();
    for (int i = 0; i < branches; i++){
        line(0,0,0, _length,0,0);
        pushMatrix();
        translate(startLength,0,0);
        drawBranch(0, startLength*0.6);
        popMatrix();
        rotateZ((float)TWO_PI/branches);
      }
    popMatrix();
    
    
  }
  
  
  
  void drawBranch(int dep, float leng){
    
    float displayedLength = leng;
    if (phase == dep +1){
      displayedLength *= phaseWeight;
    }
    if (dep < maxDepth && phase > dep){
      pushMatrix();
      rotateZ(angle);
      for (int k = 0; k < 3; k++){
        line(0,0,0, displayedLength,0,0);
        pushMatrix();
        translate(leng,0,0);
        drawBranch(dep+1, leng*0.6);
        popMatrix();
        rotateZ(-angle);
      
      }
      popMatrix();
    }
    
  }
  
}

class IceTunnel{
  int segmentCount = 1200;
  float angle = PI*0.31;

  IceTunnel(){
  
  }
  
  void display(){
    pushMatrix();
    float alpha = (time - phase5Time)*0.01;
    alpha = constrain(alpha,0,120);
    fill(150,150,200, alpha);
    stroke(220,180,240, alpha);
    strokeWeight(4);
    rotateZ((float)(time - phase5Time)*0.001);
    for (int i = 0; i < segmentCount; i++){
      translate(0,0,-6);
      rotateZ(angle);
      pushMatrix();
      translate(0, 30, 0);
      rotateY(PI*0.2);
      box(10, 2, 2);
      popMatrix();
    
    }
    strokeWeight(1);
    popMatrix();
  }  
  
}

class Beam{
  color col;
  int steadyTime;
  int enterTime;
  int endTime;
  int growTime;
  int direction;
  float _length;
  
  
  Beam(color _col, int _enter, int _steady, int _end, int _dir){
    col = _col;
    steadyTime = _steady;
    enterTime = _enter;
    endTime = _end;
    direction = _dir;
    growTime = 2000;
  }
  
  
  void display(){
    if (time > enterTime && time < endTime){
      noFill();
      stroke(col);
      _length = 1.;
      if (time < enterTime + growTime){
        _length = (float)(time - enterTime)/growTime;      
      }
      if (time > endTime - 2000){
        _length = (float)(endTime - time)/2000.;    
      }
  
      for (float i = 0; i < 1; i+=0.1){
        strokeWeight(1+i*10.);
        stroke(col, 20);
        drawCurve();
      }
      strokeWeight(1);
      stroke(col);
      drawCurve();
    }

  }
  
  void drawCurve(){
    beginShape();
    float t = (time - steadyTime)*0.001*direction;
    for (int j = 0; j < 4; j++){
    curveVertex(sin((t-0.6*j*direction*_length)*TWO_PI/21)*15+cos((t-0.6*j*direction*_length)*10*TWO_PI/21)*5, 
      cos((t-0.6*j*direction*_length)*TWO_PI/21)*15+sin((t-0.6*j*direction*_length)*10*TWO_PI/21)*5);
    }
    endShape();

  }
}

class Shard{
  float positionX;
  float positionY;
  int startTime;
  int endTime;
  int lifeTime;
  int vanishTime;
  float angle;
  float startLength;
  float phaseWeight;
  int phase;
  float scale;
  int branches;
  float endingWeight;
  
    Shard(float pos1, float pos2, int _startTime, int _endTime){
    positionX = pos1;
    positionY = pos2;
    startTime = _startTime;
    endTime = _endTime;
    vanishTime = endTime +2000;
    angle = ((float)startTime % 623. / 623.)*HALF_PI + PI*0.1;
    branches = startTime % 3 +7;
    startLength = 5;
    lifeTime = 2000;
    scale = (float)(startTime % 391. / 391.) *0.1 +0.2;
  }
  
    void display(){
      if(time > startTime && time < vanishTime){
        float diff = (float)(time - startTime)/lifeTime * (branches+1);
        phase = floor(diff);
        phaseWeight = diff - phase;
        endingWeight = 1.;
        if (time > endTime){
          endingWeight =1.- (float)(time - endTime)/2000.;
        }
        
        float displayedLength = startLength*phaseWeight*endingWeight;
  
        pushMatrix();
        translate(positionX, positionY);
        rotateX(angle*scale*(time-phase2Time)*0.0002);
        rotateY(angle*branches*(time-phase2Time)*0.0002);
        scale(scale);
              
        fill(100,100,155, 150);
        stroke(200+(1.-endingWeight)*55,210-(1.-endingWeight)*200,255-(1.-endingWeight)*200, 200);
        strokeWeight(1);
        for (int i = 0; i < branches; i++){
          pushMatrix();
          rotateY(TWO_PI*(float)i/branches*2.61);
          rotateZ(PI*(0.3+(float)0.3*i));
          translate(0, (1. - endingWeight)*-40., 0);
          if (phase == i){
            drawCrystal((float)displayedLength/(i*0.1+1));
          }
          else if (phase > i){
            drawCrystal((float)startLength*endingWeight/(i*0.1+1));
          }
          popMatrix();
        }
        popMatrix();
      }
    }
  
    void drawCrystal(float _scale){
      pushMatrix();
      scale(_scale);
      beginShape(TRIANGLES);
      for(int j = 0; j < 4; j++){
        vertex(0, 0, 0);
        vertex(sin(j*0.25*TWO_PI), -3, cos(j*0.25*TWO_PI));
        vertex(sin((j+1)*0.25*TWO_PI), -3, cos((j+1)*0.25*TWO_PI));
        
        vertex(0, -6, 0);
        vertex(sin(j*0.25*TWO_PI), -3, cos(j*0.25*TWO_PI));
        vertex(sin((j+1)*0.25*TWO_PI), -3, cos((j+1)*0.25*TWO_PI));
      }
      endShape();
      popMatrix();
      
    }
}

class Rose{
  float positionX;
  float positionY;
  float positionZ;
  int startTime;
  int endTime;
  int lifeTime;
  int branches;
  int phase;
  float phaseWeight;
  float scale;
  color col;
  color strokeCol;
  float angleWeight;
  int timer;
  int fallTimer;
  
  Rose(float pos1, float pos2, float pos3, int _startTime, int _endTime){
    positionX = pos1;
    positionY = pos2;
    positionZ = pos3;
    startTime = _startTime;
    endTime = _endTime;
    timer = startTime +8000;
    branches = 27;
    lifeTime = endTime - startTime;
    scale = 1;
    col = color(100,100,200);
    strokeCol = color(200,255,255);
    fallTimer = songEndTime - endTime - 500;
  }
  
  void display(){
    noStroke();
    col = color(100,100,200);
    scale = 1;
    angleWeight = 1;
    if (time < startTime + 6000){
      scale = (float)(time - startTime)/6000.;
    }
    if (time < startTime + 8000){
      angleWeight = (float)(time - startTime)/8000.;
    } else{
      angleWeight = sin((float)(time - timer)*0.001*0.1*PI + HALF_PI)*0.3+0.7;
      col = color(100 + 20*(float)(time - timer)/3000. ,100 - 100*(float)(time - timer)/3000. ,
      200 - 200*(float)(time - timer)/3000. );
      strokeCol = color(200 + 55*(float)(time - timer)/3000. ,255 - 50*(float)(time - timer)/3000. ,
      255 - 30*(float)(time - timer)/3000. );
    }
    phase = 30;
    phaseWeight = 0;
    if (time > endTime){
      float diff = (float)(time - endTime)/fallTimer * (branches+1);
      phase = floor(diff);
      phaseWeight = diff - phase;
      phase = branches - phase;
    }
    
    
    
    fill(col);
    float t = (time - startTime)*0.001;
    pushMatrix();
    scale(2);
    scale(scale);
    rotateX(PI*0.2);
    rotateY(t*0.02*TWO_PI);

    for (int i = 0; i < branches; i++){
      float fallRot = 1.;
      float fallTrans = 0.;
      if ( i == phase){
        fallRot = 1.- phaseWeight;
        fallTrans = -40.*phaseWeight;
      }
      if ( i <= phase)
      {
        pushMatrix();
        rotateY((float)TWO_PI*0.21*i);
        translate(0,-0.5*i + fallTrans, 0.1*i);
        rotateX((float)TWO_PI*0.007*(0.25+ angleWeight*0.75)*i*fallRot);
        scale((float)0.3+(float)(0.07*i));
        drawPetal();
        popMatrix();
      }
    }
    popMatrix();

  
  }
  
  void drawPetal(){
    noStroke();
    beginShape(QUADS);
    vertex(0, 0, 0);
    vertex(-5, 3, 2);
    vertex(0, 3, 3);
    vertex(0, 0, 0);
    
    vertex(-5, 3, 2);
    vertex(-6, 6, 3);
    vertex(0, 6, 4);
    vertex(0, 3, 3);
    
    vertex(-6, 6, 3);
    vertex(-6, 10, 3);
    vertex(0, 10, 4);
    vertex(0, 6, 4);
    
    vertex(-6, 10, 3);
    vertex(-4, 12, 1);
    vertex(0, 12, 2);
    vertex(0, 10, 4);
    
    vertex(0, 0, 0);
    vertex(0, 3, 3);
    vertex(5, 3, 2);
    vertex(0, 0, 0);
    
    vertex(0, 3, 3);
    vertex(0, 6, 4);
    vertex(6, 6, 3);
    vertex(5, 3, 2);
    
    vertex(0, 6, 4);
    vertex(0, 10, 4);
    vertex(6, 10, 3);
    vertex(6, 6, 3);
    
    vertex(0, 10, 4);
    vertex(0, 12, 2);
    vertex(4, 12, 1);
    vertex(6, 10, 3);
    endShape();
    stroke(strokeCol);
    line(-6, 10, 3, -4, 12, 1);
    line(-4, 12, 1, 0, 12, 2);
    line(0, 12, 2, 4, 12, 1);
    line(4, 12, 1, 6, 10, 3);

  }
  
  
}


