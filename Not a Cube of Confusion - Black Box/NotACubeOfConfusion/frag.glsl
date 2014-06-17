#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float cutoff;
uniform sampler2D texture;
uniform float border;

varying vec4 vertColor;
varying vec4 vertTexCoord;


vec4 effect(sampler2D text, vec2 textCoord) {
  vec4 textColor = texture2D(text, textCoord);
  if (textColor.a >= cutoff) {
    return vec4(textColor.x, textColor.y, textColor.z, 1.0) * vertColor;
  }
  else { 
    return vec4(1, 1, 1, 1) * max((border - (cutoff - textColor.a)) / border, 0);
  }
}
  
void main() {
  gl_FragColor = effect(texture, vertTexCoord.st);
}