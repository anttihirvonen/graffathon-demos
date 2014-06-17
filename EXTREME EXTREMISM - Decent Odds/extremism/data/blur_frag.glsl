#version 120

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 pixelSize;

varying vec4 vertColor;
varying vec4 vertTexCoord;

float coeffs1[3] = float[3](0.00038771, 0.01330373, 0.11098164);
float coeffs2[3] = float[3](0.11098164, 0.01330373, 0.00038771);

void main() {
	vec4 color = vec4(0.0, 0.0, 0.0, 1.0);

	for (int i = 0; i < 3; i++) {
		vec2 texcoord = vertTexCoord.st - pixelSize * float(i);
		color += texture2D(texture, texcoord) * coeffs1[i];
	}
  
	color += texture2D(texture, vertTexCoord.st) * 0.22508352;
	
	for (int i = 0; i < 3; i++) {
		vec2 texcoord = vertTexCoord.st + pixelSize * float(i + 5);
		color += texture2D(texture, texcoord) * coeffs2[i];
	}
	
	gl_FragColor = clamp(color * 2.05, vec4(0.0), vec4(1.0));
}