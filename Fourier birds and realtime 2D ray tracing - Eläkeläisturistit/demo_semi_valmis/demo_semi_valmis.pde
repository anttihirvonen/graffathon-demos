


/*

Add utf bunny:


                                                 ...... .. ...  ...  ........ ..
               .     .  . . .. . ..    ..  ...   ...............................
                        . .~:.   ...   .  . ..   ...............................
                        .MMMMM~.................................................
 .                     ,MMM=MMDMMM..............................................
                      .MMM . MMMMM..............................................
                     .MMM ..=M..MM?.............................................
 .     .    ........ MMM... M ..NM~.............................................
...... .    ........MMM?...M+...MM .............................................
...................IMMN ..::...MMM..............................................
................  =MMM ...D ..8MM ..............................................
 ..... .   .=MMMMMMMM,...7 ..,MM:...............................................
........  MMMMMMMMZ, ....... MMM................................................
.. ... .$MMMZ ..............MMM.................................................
...... 8MMM................7MM:.................................................
      8MMM    :M.      ....MMM..................................................
    .MMM7    . MM...   ....MMM..................................................
    .MMM      :   .    ....MMM:.................................................
    MMM.     ..D.. .  . ...+MMM. ...............................................
    MMN     .     .    .....:MMMMM?.............................................
    MMM..  .................  OMMMMMMMMM?.......................................
 .  :MMM    ..        .............+NMMMMMMMM7  ................................
 .  .MMMM.   .. ....   ................  7MMMMMMMN:.............................
 .    :NMMM8$Z=         ......................$MMMMMN: .........................
...      :MMMMM. . .    ........................ :MMMMM,........................
...         8MMM   .  . ............................=MMMM,......................
 .           MMM:  .    ..............................+NMM+ ....................
...    .     MMM~.......................................$MMN....................
            .MMM        .................................:MMM ..................
...    .    .MMM.......................................... MMM~ ................
 .          ~MM=        ....................................MMM ................
...         NMM  . .    .................................... MMM................
 ..    .    MMM .............................................,MMN...............
            MMM.        ....... ..............................?MMI..............
 .     .   .MMM    .   ..... MM ...............................MMM..............
..          MMM   .     .....MZ........$O......................8MM:.............
            MMM.        ....,M:....... M$.......................MMM ............
            .MM? .. ........=M,.......=M:.......................MMM.............
             MMM.       ....8M........8M........................ZMM=............
       .     NMM:... .. ....MO........MM........................,MMM............
       .     =MMM...  .....OM ........$M........................ MMM............
       .     .MMM...  .....MMM= ...... MZ........................ZMM............
       ..   ..IMM .......,MMMMMMN .....OM ........................MMM...........
            .. MM7..  ...MMM:.7MMMMZ ...MM: ......................,MM$..........
             . MMM.    ..MM=..... MMMMMD7ZMMMN................... MMM$..........
             . MM7..  ..MMM..........?MMMMMM ....................MMMM...........
       .    . MMM..    :MM=..........,MMMI.....................DMMMM............
 .           DMMM. .  .8MN..........NMMZ ................... ,MMMM..............
            =MMN ..   ?MM ........ MMM=....... .===========MMMMM:...............
       .   :MMM  .   .MMO.........+MM:. ... NMMMMMMMMMMMMMMMMM:.................
           7MMMD:. =MMMD..........~MMMMMMMMMMMMN:...............................
 .          $MMMMMMMMM~.............7MMMMM7,....................................
               .~??~. . ........................................................
   . ... .......................................................................
 .          .... ...  ..........................................................
       .        .  .    ........................................................
...    .     .  .     ..........................................................
...    .                ........................................................

*/






import moonlander.library.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
 
//int CANVAS_WIDTH = 990;
//int CANVAS_HEIGHT = 540;
 
int CANVAS_WIDTH = 1920;
int CANVAS_HEIGHT = 1080;

int SONG_SKIP_MILLISECONDS = 2000;
// Don't change this – needed for resolution independent rendering
float ASPECT_RATIO = (float)CANVAS_WIDTH/CANVAS_HEIGHT;
// Needed for audio
Minim minim;
AudioPlayer song;
Moonlander moonlander;
/*
* Sets up audio playing: call this last in setup()
* so that the song doesn't start to play too early.
*
* By default, playback doesn't start automatically –
* you must press spacebar to start it.
*/
/*
void setupAudio() {
  minim = new Minim(this);
  song = minim.loadFile("../Passive_Cyclone.mp3");
  // Uncomment this if you want the demo to start instantly
  song.play();
}
*/

// Säde-luokka, p = lähtöpiste, d = suuntavektori
class Ray {
  PVector p;
  PVector d;
  float intensity;
  
  Ray( PVector origin, PVector dir ){
    p = origin;
    d = dir;
    d.normalize();  // varmistutaan, että suuntavektori on 1:n pituinen
    intensity = 1.0;  
  }

  void draw_to_inf(){
    stroke( 255*(1-intensity) );
    line( p.x, p.y, p.x + 1e4*d.x, p.y + 1e4*d.y );
  }

}

// Luokka vaikka vesipisaralle, p = paikkavektori, r = säde

class Circle {
  PVector p;
  float r;
  
  Circle( PVector origin, float radius ){
    p = origin;
    r = radius;  
    }

  // Piirretään näytölle
  void draw(){
    ellipse( p.x, p.y, 2*r, 2*r );
  
  }
}

// ratkaisee säteen ja pisaran törmäyskohdan, palauttaa < 0 jos törmäystä ei tapahdu
float get_intersection( Ray ray, Circle obj ){
PVector f = new PVector( ray.p.x, ray.p.y );
  float a, b, c, D, t0, t1;

  f.sub( obj.p );  
  a = ray.d.dot( ray.d );
  b = 2 * f.dot( ray.d );
  c = f.dot( f ) - obj.r*obj.r;
  D = b*b - 4*a*c;
  if( D < 0 ){ // menee ohi
      return -1;
  }
  
  D = sqrt( D );
  
  t0 = (-b - D ) / ( 2 * a );
  t1 = (-b + D ) / ( 2 * a );
  
  if( (t0 < t1) && (t0 > 1e-3 ) ){ return t0; }
  else {
    return t1;
    }
  }

// http://en.wikipedia.org/wiki/Rodrigues'_rotation_formula
// angle = kulma radiaaneina
PVector rotate_vector( PVector vec, float angle ){

  // pyöritetään xy-tasossa
  PVector k = new PVector( 0,0, 1 );
  
  PVector v0 = (new PVector(vec.x, vec.y) );
  v0.mult( cos( angle ) );
  
  PVector v1 = k.cross(vec);
  v1.mult( sin(angle) );
  
  PVector v2 = (new PVector( k.x, k.y, k.z ) );
  v2.mult( (1-cos(angle)) * k.dot(vec) );

  v0.add( v1 );
  v0.add( v2 );

  return v0;   
  
}






// Laskee ja piirtää taittuvan säteen (läpi pisaran)
boolean trace_and_draw( Ray ray, Circle obj ){
  
  float t;
  
  t = get_intersection( ray, obj );
  
  // Ei osunut ollenkaan
  if( t < 0 ){
    return false;
  }
  else {
    
    // Törmäyskohta, collision point
    PVector cp = new PVector( ray.p.x+t*ray.d.x, ray.p.y+t*ray.d.y );
    
    // piirretään viiva törmäyskohtaan
    stroke( 255*(1-ray.intensity) );
    line( ray.p.x, ray.p.y, cp.x, cp.y );
    ray.intensity *= 0.65;
    
    // pinnan normaali törmäyskohdassa
    PVector normal = new PVector( cp.x, cp.y );
    normal.sub( obj.p );
    normal.normalize();
    
    // http://en.wikipedia.org/wiki/Snell_law
    // etumerkit iteroitu oikein, i think
    float theta1 = PVector.angleBetween( (new PVector(-ray.d.x, -ray.d.y) ), normal );
    float theta2 = asin( 1.0/1.33 * sin( -theta1 ) );
  
    
    if( rotate_vector(ray.d, PI/2).dot( normal ) < 0 ){ theta2 = -theta2; }
    
    // lasketaan taittuneen säteen uusi suunta
    PVector new_dir = rotate_vector( ray.d, theta2/2 );
    
    // lasketaan vika törmäys
    Ray ref_ray = new Ray( cp, new_dir );
    ref_ray.intensity = ray.intensity;
    
    float new_t = get_intersection( ref_ray, obj );
    
    // piirretään pisaran sisällä menevä säde
    stroke( 255*(1-ray.intensity));
    line( cp.x, cp.y, cp.x + new_dir.x*new_t, cp.y + new_dir.y*new_t );
    
    // lasketaan uuden törmäyskohdan paikkavektori
    cp = new PVector( ref_ray.p.x+new_t*ref_ray.d.x, ref_ray.p.y+new_t*ref_ray.d.y );
  
  // lasketaan pinnan normaali törmäyskohdassa
    normal = new PVector( cp.x, cp.y );
    normal.sub( obj.p );
    normal.normalize();
    
    // se viimeinen taittuminen
    theta1 = PVector.angleBetween( (new PVector(-ray.d.x, -ray.d.y) ), normal );
    theta2 = asin( 1.33/1.0 * sin( theta1 ) );
    
    if( rotate_vector(ray.d, PI/2).dot( normal ) < 0 ){ theta2 = -theta2; }
    
    
    // taittuneen säteen suuntavektori
    new_dir = rotate_vector( ref_ray.d, theta2/2 );
    
    ray.intensity *= 0.65;
    ray.d.set(new_dir.x, new_dir.y);
    ray.p.set(cp.x + new_dir.x*0.005, cp.y + new_dir.y*0.005);
    
    }
  return true;
}

// lasketaan säteen reitti
void do_raytracing( Circle circles[], Ray ray ){
  boolean is_a_hit = true;
  int counter = 0;
  
  // z buffering, jotta säteet osuu lähimpään pisaraan ensin
  int zindex[] = new int[circles.length];
  float dists[] = new float[circles.length];
  
  for( int i = 0 ; i < circles.length ; i += 1 ){
    dists[i] = PVector.dist( ray.p, circles[i].p );
    zindex[i] = i;
  }
  
  // BUBBLE SORT!!!1!, helppo, mutta hidas jos pisaroita on satoja/tuhansa/ns. månta 
  for( int i = 0 ; i < circles.length ; i += 1 ){
    for( int j = i ; j < circles.length ; j += 1 ){
      if( dists[j] < dists[i] ){
        float tmp = dists[i];
        dists[i] = dists[j];
        dists[j] = tmp;
        int ztmp = zindex[i];
        zindex[i] = zindex[j];
        zindex[j] = ztmp;
        }
      }
    }
  
  
 // lasketaan polku  
  while( is_a_hit && counter < 2*circles.length ){
    is_a_hit = false;
    for( int i = 0 ; i < circles.length ; i += 1 ){
      
      if( trace_and_draw( ray, circles[ zindex[i] ] ) ){
        is_a_hit = true;
        
        }
       counter += 1;
      }
    }
  
  stroke( 255*(1-ray.intensity));
  ray.draw_to_inf();
  
  }


class FourierSeries {
  ArrayList<Float> freqs;
  ArrayList<Float> amps;
  
  FourierSeries(){
    freqs = new ArrayList<Float>();
    amps = new ArrayList<Float>();
  }
  
  void add( float a, float f ){
    freqs.add( f );
    amps.add( a );
  }
  
  float eval( float t ){
    float out = 0.0;
    for( int i = 0 ; i < freqs.size() ; ++i ){
      out += amps.get(i)*cos( TWO_PI*t*freqs.get(i) );
      }
    return out;  
  }
  
}

class FourierLintu {
  float x;
  float y;
  float size;
  float tgain;

  float target_x, target_y;
  
  FourierSeries paikka_x;
  FourierSeries paikka_y;
  
  FourierSeries siipi0_x;
  FourierSeries siipi0_y;
  
  FourierSeries siipi1_x;
  FourierSeries siipi1_y;
  
  boolean keep_up;
  float keep_up_t;
  
  FourierLintu( float aX, float aY, float aSize ){
    size = aSize;
    x = aX;
    y = aY;
    tgain = 1.0;    
  
    paikka_x = new FourierSeries();
    paikka_y = new FourierSeries();
    
    siipi0_x = new FourierSeries();
    siipi0_y = new FourierSeries();
    
    siipi1_x = new FourierSeries();
    siipi1_y = new FourierSeries();
    
    target_x = aX;
    target_y = aY;
  
    keep_up = false;
    keep_up_t = 0;  
  }  

  void move(float dt){
    x = x*(1-dt) + target_x*dt;
    y = y*(1-dt) + target_y*dt;
  }

  void draw( float aT ){
    float t = tgain * aT/1000.0;
    
    pushMatrix();    

  
   /*translate(-50+sin(2*PI*time/2000)+sin(2*PI*time/10000)+90*sin(2*PI*time/10000), -100-sin(2*PI*time/2000));
   fill(50);
   scale(0.5);
   triangle(0, 0, 30, -8*sin(2*PI*time/6000), 15, 40*sin(2*PI*time2/10000));
   fill(255);
   triangle(0, 0, 30, -8*sin(2*PI*time/6000), -15, 50*sin(2*PI*time2/10000));
  */
  
  if( keep_up ){
    if( paikka_x.eval(t) > 0 && paikka_x.eval(t+0.1) < 0 ){ keep_up_t = t; }
  }
  
  translate( x + paikka_x.eval(t), y + paikka_y.eval(t) );
  scale(size);
  
  if( keep_up && paikka_x.eval(t+0.01) > paikka_x.eval(t) ){
    fill(50);
    triangle(0, 0, 30, siipi0_x.eval(keep_up_t), 15, siipi0_y.eval(keep_up_t)); 
    fill(255);
    triangle(0, 0, 30, siipi1_x.eval(keep_up_t), -15, siipi1_y.eval(keep_up_t));  
  }
  else {
    fill(50);
    triangle(0, 0, 30, siipi0_x.eval(t), 15, siipi0_y.eval(t)); 
    fill(255);
    triangle(0, 0, 30, siipi1_x.eval(t), -15, siipi1_y.eval(t));
  }
  popMatrix();
  }

}


 /*
void rolling(int level, int shards) {
  int  time = millis();
   if (level <= 0) {
    return;
   }
   
   pushMatrix();
    
   scale(1);
  
   //float rot = mouseX;
   //rotate(radians(15.0 + rot));
   fill(0);
   triangle(0, 0, 30, -20, 15, 40*sin(2*PI*time/1000));
  
   fill(255);
   triangle(0, 0, 30, -20, -15, 50*sin(2*PI*time/1000));
  
   for (int i=0; i < shards; i++) {
     rotate(radians(360.0 / shards));
     translate(0, 1000);
     lintuja();
   }
  
   popMatrix();
}
*/
FourierLintu lintu1, lintu2, lintu3; 

FourierLintu linnut[];
 
void lintuja(double aika) {
  int  time = (int)(aika * 1000);
  int time2 = time * (int((-50+sin(2*PI*time/2000)+sin(2*PI*time/10000)+90*sin(2*PI*time/10000))));
  
  
  lintu1.draw( time );
  
  
  /*
   //lintu nro 1
   pushMatrix();
   translate(0,0);
   scale(1);
   fill(60);
   triangle(0, 0, 30, -20, 15, 40*sin(2*PI*time/1000));
  
   fill(255);
   triangle(0, 0, 30, -20, -15, 50*sin(2*PI*time/1000));
   popMatrix();
   */
  /*
  FourierLintu lintu2 = new FourierLintu( 50, 50, 0.8 );
  lintu2.paikka_x.add( 15.0, 0.5 );
  lintu2.paikka_x.add( 60.0, 0.1 );
  lintu2.paikka_x.add( 30.0, 0.1 );  
  
  lintu2.paikka_y.add( 5.0, 0.5 );
   
  lintu2.siipi0_x.add( -20.0, 1.0/6.0 );
  lintu2.siipi0_y.add( 40.0, 1.0 );
  lintu2.siipi0_y.add( 20.0, 0.1 );

  lintu2.siipi1_x.add( -20.0, 1.0/6.0 );
  lintu2.siipi1_y.add( 50.0, 1.0 );
  lintu2.siipi1_y.add( 5.0, 5.0 );
  
  //lintu2.draw( time + 400 ); 
*/   
   //lintu nro 2
   pushMatrix();
   translate(lintu2.x+15*sin(2*PI*time/2000)+60*sin(2*PI*time/10000)+30*sin(2*PI*time/10000), lintu2.y+5*sin(2*PI*time/2000));
   scale(0.8);
   fill(50);
   triangle(0, 0, 30, -20*sin(2*PI*time/6000), 15, 40*sin(2*PI*time/1000)+20*sin(2*PI*time/10000));
  
   fill(230);
   triangle(0, 0, 30, -20*sin(2*PI*time/6000), -15, 50*sin(2*PI*time/1000+20*sin(2*PI*time/10000)));
   popMatrix();
 
  
  lintu3.keep_up = true;  
  lintu3.draw( time*lintu3.paikka_x.eval(time/1000.0)/400.0 + 870 );
  /*
   //lintu nro 3
   pushMatrix();
   scale(0.5);
  
   float distance = -50+sin(2*PI*time/2000)+sin(2*PI*time/10000)+90*sin(2*PI*time/10000);
   distance = distance + 80;
   distance = distance / 10;
  
   translate(-50+sin(2*PI*time/2000)+sin(2*PI*time/10000)+90*sin(2*PI*time/10000), -100-sin(2*PI*time/2000));
   fill(50);
  triangle(0, 0, 30, -8*sin(2*PI*time/6000), 15, 40*sin(2*PI*time2/10000));
   //triangle(0, 0, 30, -8*sin(2*PI*time/6000), 15, (40*sin(2*PI*time/1000*distance)));
  
   fill(255);
   triangle(0, 0, 30, -8*sin(2*PI*time/6000), -15, 50*sin(2*PI*time2/10000));
   //triangle(0, 0, 30, -8*sin(2*PI*time/6000), -15, (50*sin(2*PI*time/1000*distance)));
   popMatrix();
 */

  for( int i = 0 ; i < linnut.length ; ++i ){
    linnut[i].draw(time);
  }     
}

Circle pisarat[];

 
void setup() {
  size(CANVAS_WIDTH, CANVAS_HEIGHT, P2D);
  noStroke();
  frameRate(30);
  fill(255);
  smooth();
  
  
    // Parameters:
    // - PApplet
    // - soundtrack filename (relative to sketch's folder)
    // - beats per minute in the song
    // - how many rows in Rocket correspond to one beat
    
   //moonlander = Moonlander.initWithSoundtrack(this, "../Passive_Cyclone.mp3", 120, 4);
  //sekoo tässä:
  minim = new Minim( this );
  song = minim.loadFile(  "../Passive_Cyclone.mp3", 1024 );
  moonlander = new Moonlander( this, new MinimController( song, 120, 4 ) );
  randomSeed(5);
  
  //  moonlander = Moonlander.initWithSoundtrack(this, "../Passive_Cyclone.mp3", 120, 4);
     
  
    
  //setupAudio();
  //moonlander = Moonlander.initWithSoundtrack(this, "Passive_Cyclone.mp3", 120, 4);
  moonlander.start();
  

  // lintuinit
  lintu1 = new FourierLintu( 0,0, 1.0 );
  lintu1.siipi0_x.add( -20, 0 );
  lintu1.siipi0_y.add( 40, 1.0 );
  lintu1.siipi1_x.add( -20, 0 );
  lintu1.siipi1_y.add( 50, 1.0 );
  
  lintu2 = new FourierLintu( 50, 50, 0.8 );

  lintu3 = new FourierLintu( -50, -50, 0.5 );
  lintu3.paikka_x.add( 1.0, 0.5 );
  lintu3.paikka_x.add( 1.0, 0.1 );
  lintu3.paikka_x.add( 90.0, 0.1 );
  lintu3.paikka_y.add( -1, 0.5 );
  lintu3.siipi0_x.add( -8, 1.0/6.0 );
  lintu3.siipi0_y.add( 40, 0.1*20 );
  lintu3.siipi1_x.add( -8, 1.0/6.0 );
  lintu3.siipi1_y.add( 50, 0.1*20 );
  
  linnut = new FourierLintu[180];
  for( int i = 0 ; i < linnut.length ; ++i ){
    float phi = TWO_PI*random(0,360)*PI/180.0;
    float r = random(300, 1800);
    linnut[i] = new FourierLintu( r*cos( phi ),  r*sin( phi ), random(30,200)/150.0 );
    float randx = random(10,50);
    linnut[i].siipi0_x.add( -randx, 0 );
    linnut[i].siipi0_y.add( random(10,50), 1.0 );
    linnut[i].siipi0_y.add( random(10,50), 0.33 );
    linnut[i].siipi0_y.add( random(10,50), 0.125 );
    linnut[i].siipi1_x.add( -randx, 0 );
    linnut[i].siipi1_y.add( random(10,50), 1.0 );    
    linnut[i].siipi1_y.add( random(10,50), 0.33 );    
    linnut[i].siipi1_y.add( random(10,50), 0.125 );    
    
    linnut[i].paikka_y.add( random(10,100), 0.1 );    
    linnut[i].paikka_y.add( random(10,100), 0.05 );    
    linnut[i].paikka_y.add( random(10,100), 0.025 );    
    
    linnut[i].paikka_x.add( random(10,100), 0.3 );
    linnut[i].paikka_x.add( random(10,100), 0.01 );
    linnut[i].paikka_x.add( random(10,100), 0.005 );
    
    
    linnut[i].tgain = 0.5 + random(0,200)/200.0;
  
    }

  pisarat = new Circle[3];
  pisarat[0] = new Circle( new PVector( 0, -25 ), 10 );
  pisarat[1] = new Circle( new PVector( -50, 25 ), 10 );
  pisarat[2] = new Circle( new PVector( 50, 25 ), 10 );
  
  
}

float flock(float phi ){
  while(phi > PI ){ phi -= PI; }
  if( phi < 0.5 ){ return 0.25; }
  if( phi > 0.5 && phi < 0.75 ){ return 1.0; }
  if( phi > 0.75 ){ return 0.5; }
  return 0.5;
} 
 
void draw() {
  
  //lopetus kamaa:
  int fadeOut = moonlander.getIntValue("fade_out");
    //ja tässä:
  float musicVolume = (float)moonlander.getValue( "music_volume" ); 
  song.setGain( musicVolume );

  
  int time = millis();
  double rocketTime;
  // Reset all transformations.
  resetMatrix();
  translate(CANVAS_WIDTH/2.0, CANVAS_HEIGHT/2.0);
  scale(CANVAS_WIDTH/2.0 / 100.0 , CANVAS_HEIGHT/2.0 / 80.0 );
    moonlander.update();
    double bg_red = moonlander.getValue("background_red");
    int bg_green = moonlander.getIntValue("background_green");
    int bg_blue = moonlander.getIntValue("background_blue");
    int linnut_state = moonlander.getIntValue("linnut_state");
    
    float zoom_value = (float)moonlander.getValue( "zoom_value" );
  
    float flock_size = (float)moonlander.getValue( "flock_size" );
    
    float beats = (float)moonlander.getValue( "beat_sync" );
    
  
    background((int)bg_red, bg_blue, bg_green);
  
 
    textSize(10);
    rocketTime = moonlander.getCurrentTime();
    
   pushMatrix();
   
   /*if( linnut_state == 1 && (frameCount % 4) == 0 ){
     float q = 1 - 0.5*(1+cos(TWO_PI*millis()/1000.0 * 0.05*1.5 ) );
     for(int i = 0 ; i < linnut.length ; ++i ){
       linnut[i].target_x = linnut[i].x*(0.95+q*0.05) + (1100 + 2000*(1-q)*0.05+random(-50,50))*cos(TWO_PI*millis()/1000.0*0.05 + random(-100,100)/100.0*q*0.1 );
       linnut[i].target_y = linnut[i].y*(0.95+q*0.05) + (1100 + 2000*(1-q)*0.05+random(-50,50))*sin(TWO_PI*millis()/1000.0*0.05*1.5 + random(-100,100)/100.0*q*0.1 ); 
     }
   }
   for( int i = 0 ; i < linnut.length ; ++i ){
     float q = 0.5*(1+cos(TWO_PI*millis()/1000.0 * 0.05*0.5 ) )*0;//random(0,100)/100.0;
     
     linnut[i].move(0.02 * random(50,100)/50.0 * (linnut[i].tgain*q + (1-q)));
     }*/
   if( linnut_state == -1 ){ exit(); }  
     
   if( linnut_state == 0 ) {
     noStroke();
     if( beats > 0 ){
     stroke(255);
     strokeWeight(beats*10); 
     }
     
     scale( zoom_value );
     lintuja(rocketTime);
   }
   
   if( linnut_state == 1){
     noStroke();
     if( beats > 0 ){
       strokeWeight(beats*10);
       stroke(255);
     }
     
     scale( zoom_value );
     float mu = (float)rocketTime*0.05;
     if(mu > 1.0 ){mu = ceil(mu)-mu;}
     float mu2 = (1-cos(PI*mu))/2.0;
     float phi = mu2*TWO_PI*2;
     
     /*float x = 3000 * cos(TWO_PI*millis()/1000.0*0.05 );
     float y = 3000 * sin(TWO_PI*millis()/1000.0*0.05*2.0 );
     float s = 1-0.5*(1 + sin(TWO_PI*millis()/1000.0*0.05*2.0/2.0 ) );*/
     float x = 3000 * cos(phi + PI );
     float y = 1000 * sin(phi*2.0  + PI );
     //float s = 1-0.5*(1 + sin(phi*2.0/2.0*2  + PI/2.0 ) - 0.25*sin(phi*2.0/2.0*2  + PI/2.0 +0.1) );
     //float s = flock( phi*2 + PI/2.0);
     
     //println( mu );
     
     
     
     translate(x,y);
     scale( 0.4 + 0.6*flock_size );
     lintuja(rocketTime);
   }

  if( linnut_state == 10 ){
  // pyöritellään pisaroita muodostelmassa
  strokeWeight( 1.0 );
  
  
    for( int i = 0 ; i < pisarat.length ; ++i ){
      PVector new_p = new PVector( pisarat[i].p.x, pisarat[i].p.y );
      new_p.sub((new PVector(0,0) ) );
      new_p = rotate_vector( new_p, 0.01 );
      new_p.add((new PVector(0,0) ) );
      pisarat[i].p = new_p;
    }
  
  stroke((int)(beats/2.0*255));
  for( int i = 0 ; i < pisarat.length ; ++i ){
    pisarat[i].draw();
  }
  strokeWeight( 0.5 );
  // simuloidaan vähän säteitä
  for( int i = 0 ; i < 32 ; ++i ) {
   //Ray sade = new Ray( new PVector( 0, 512.0/33.0 * i + 10 ), new PVector( 1, 0 ) ); 
   Ray sade = new Ray( new PVector(-50,80), new PVector( i/32.0, -1.0 ) );  
   
   
   do_raytracing( pisarat, sade ); 
   
    
   }
 
  
  }

   popMatrix();
  
   //lopetus kamaa:
   fill(0,0,0,fadeOut);
   rect( -200, -200, 400, 400 ); 
    
    
  // TODO: implement some example drawing
  // and time-based sync done in code
  //background(#b7e2dc);
  /*
   if ( time < 5000){
   textSize(0.1);
   fill(0, 102, 153);
  
   text("TESTIIIIII", 0.0, 0.0 );
   }
  
   else{
      fill(#60abc1);
      noStroke();
      ellipse(sin(0.0001*time), 0., 1.0*tan(time*0.001), 1.0);
   }
  
   */
  
   //ellipse(0., sin(0.0001*time), 1.0*tan(time*0.001), 1.0);
  /*
  fill(#79ab99);
  noStroke();
  ellipse(0., sin(0.0001*time), 1.0*tan(time*0.001), 1.0);
  */
  /*
  fill(#e19ba5);
  noStroke();
  rect(0., 0., 100, 100);
  */
  // The following lines draw a full-screen quad.
  // Params for rect: x, y, width, height
  // rect(-ASPECT_RATIO, -1, 2*ASPECT_RATIO, 2);
 
  
  
  
  
}
/*
void keyPressed() {
  if (key == CODED) {
    // Left/right arrow keys: seek song
    if (keyCode == LEFT) {
      song.skip(-SONG_SKIP_MILLISECONDS);
    }
    else if (keyCode == RIGHT) {
      song.skip(SONG_SKIP_MILLISECONDS);
    }
  }
  // Space bar: play/payse
  else if (key == ' ') {
    if (song.isPlaying())
      song.pause();
    else
      song.play();
  }
  // Enter: spit out the current position
  // (for syncing)
  else if (key == ENTER) {
    print(song.position() + ", ");
  }
}
*/
 
