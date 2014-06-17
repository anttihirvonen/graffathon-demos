class BallGrid{
  PApplet applet;
  PShape shape;
  PShape trigger_shape;
  AudioManager audioManager;
  
  int FFT_RANGE_BEGIN = 1;
  int FFT_RANGE_END = 1;
  int FFT_TRIGGER = 20;
  
  int FFT_ROTATE_RANGE_BEGIN = 92;
  int FFT_ROTATE_RANGE_END = 98;
  
  float fade = 0.0;
  
  BallGrid(PApplet _applet, AudioManager _audioManager){
    applet = _applet;  
    audioManager = _audioManager;
    
    shape = createShape(PConstants.BOX, 35);
    shape.setFill(color(200, 0, 255));
    shape.setStroke(color(255, 255, 255));
    shape.setStrokeWeight(1);
    //shape.setStroke(0);

    
    //trigger_shape = createShape(PConstants.SPHERE, 30);
    trigger_shape = createShape(PConstants.SPHERE, 25);
    //trigger_shape.setFill(color(0, 0, 255));
    trigger_shape.setFill(color(200, 0, 255));
    trigger_shape.setStroke(color(255, 255, 255));
    trigger_shape.setStrokeWeight(1);
    //trigger_shape.setStroke(0);
    
  }
  
  void draw(int xlevel, int ylevel, int zlevel, float distance){
    float pwr = audioManager.analyzeRange(FFT_RANGE_BEGIN, FFT_RANGE_END);
   
   
   
    //if(pwr > FFT_TRIGGER){
    //if(audioManager.beatDetector().isHat()){  
    if(pwr > 20){ 
      println("BEAT", pwr, "NOW"); 
      fade = 1;
      
    }else{
      fade *= 0.90;
      println("BEAT", pwr);
    }
    
    /*PShape cen = createShape(PConstants.SPHERE,30 );
    cen.setFill(color(255, 255, 255));
    cen.setStroke(color(255, 255, 255));
    cen.setStrokeWeight(0);
    cen.scale(fade);
    shape(cen);
    */
    
    pushMatrix();
    translate(GRID_DISTANCE/2, GRID_DISTANCE/2, GRID_DISTANCE/2);
    
    //temp shape for drawing
    PShape sh = createShape(shape);
    sh.scale(fade);
    //ambientLight(51, 102, 126);
 
 
    for(int z = -zlevel; z < zlevel; z++){
       for(int y = -ylevel; y < ylevel; y++){
          for(int x = -xlevel; x < xlevel; x++){
             pushMatrix();
             translate(x* distance, y*distance, z*distance);
             //if(fade > 0.1){
               //translate(20,20,20); // displacement
               triggerShape(sh);
             //}else{
             //  triggerShape(shape );
             //}
             popMatrix();              
          }
       } 
    }
    
      popMatrix();
  }
  
  void triggerShape(PShape _shape){
    rotateX(audioManager.currentTimeSeconds()*1.5);
    rotateZ(sin(audioManager.currentTimeSeconds()));
    shape(_shape); 
  }

}
