#define PI 3.141592

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float iGlobalTime;
uniform vec2 iResolution;

void main(void)
{
  int magic = 201;
  float ar = iResolution.x/iResolution.y;
  float zoomspeedi = 0.090;
  float zoomspeedr = zoomspeedi*ar;

  float rmin;
  float imin;
  float imax;
  if (iGlobalTime > 38.0)
  {
    rmin = (-2.2+iGlobalTime*zoomspeedr) + (iGlobalTime-38.0)*zoomspeedr*190.5;
    imin = (-1.2+iGlobalTime*zoomspeedi) + (iGlobalTime-38.0)*zoomspeedi*190.5;
    imax = (1.2-iGlobalTime*zoomspeedi) - (iGlobalTime-38.0)*zoomspeedi*190.5;
  }
  else
  {
    rmin = (-2.2+iGlobalTime*zoomspeedr);
    imin = (-1.2+iGlobalTime*zoomspeedi);
    imax = (1.2-iGlobalTime*zoomspeedi);
  }

  float rmax = iResolution.x*((imax-imin)/iResolution.y)+rmin;

  float cre = -0.7589;
  float cim = -0.0753;
  float x = gl_FragCoord.x-iResolution.x/2.0;
  float y = gl_FragCoord.y-iResolution.y/2.0;
  float fixx = (rmax-rmin)/iResolution.x;
  float fixy = (imin-imax)/iResolution.y;

  float zre = gl_FragCoord.x*fixx + rmin;
  float zim = gl_FragCoord.y*fixy + imax;

  float zretemp = zre;
  zre = zre*cos(iGlobalTime/(PI*0.7)) - zim*sin(iGlobalTime/(PI*1.337));
  zim = zretemp*sin(iGlobalTime/(PI*1.337)) + zim*cos(iGlobalTime/(PI*0.7));
    
  int iter = 0;
  for (int i = 0; i < 201; ++i)
  {
    iter = i;
    float zresq = zre*zre;
    float zimsq = zim*zim;
    
    if (zresq+zimsq > 4.0)
    {
      break;
    }
    
    zim = 2.0*zre*zim+cim;
    zre = zresq-zimsq+cre;
  }
  if (iter >= magic-1)
    gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
  else
    gl_FragColor = vec4(1.0*float(iter)/float(magic-1), 1.0*float(iter)/float(magic-1), 0.0, 1.0);
}