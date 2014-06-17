#version 120

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 light;
uniform float decay;
uniform float density;
uniform float weight;
uniform float exposure;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
	vec2 texcoord = vertTexCoord.st;
	vec4 color = texture2D(texture, texcoord);
	
	float illuminationDecay = 1.0;
	vec2 dir = (texcoord - light) * (1.0 / 16.0) * density;
	
	for (int i = 0; i < 16; i++) {
		texcoord -= dir;
		vec4 sample = texture2D(texture, texcoord);
		sample *= illuminationDecay * weight;
		color += sample;
		illuminationDecay *= decay;
	}
	
	gl_FragColor = color * exposure;
}