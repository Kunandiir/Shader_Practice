#version 410 core

uniform vec2 resolution;
uniform float time;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;
// time
// resolution
// theColor




float Circle(vec2 uv, vec2 p, float r, float blur) 
{
    
    float d = length(uv-p);
    float c = smoothstep(r, r-blur, d);
    
    return c;

}

float Face(vec2 uv, vec2 p, float size)
{

    uv -= p; // cords
    uv /= size; // scaling
    
    
    
    float c = Circle(uv, vec2(0.), .4, .01);
    
    c -= Circle(uv, vec2(-.13, .2), .05, .01);
    c -= Circle(uv, vec2(.13, .2), .05, .01);
    
    float mouth = Circle(uv, vec2(0., .05), .3, .02);
    mouth -= Circle(uv, vec2(0., .1), .3, .02);
    
    c -= mouth;
    
    
    return c;
 }






void main()
{
    vec2 uv = fragCoord.xy / resolution.xy;
     
    uv -= .5;
    uv.x *= resolution.x / resolution.y;
    
    
    vec3 col = vec3(0.);
    
    float c = Face(uv, vec2(0., 0.), 1.);
    
    col = vec3(.1, 0., .5)*c;
    
    
    
    theColor = vec4(col, 1.0);
}
