#define PROCESSING_COLOR_SHADER

uniform mat4 transform;

attribute vec4 vertex;
attribute vec4 color;

void main() {
  gl_Position = transform * vertex;
}