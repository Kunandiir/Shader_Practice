#version 410 core

uniform vec2 resolution;
uniform float time;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;
// time
// resolution
// theColor


void main() {
  
  theColor = vec4(1.,.7,.4, 1.);
}

