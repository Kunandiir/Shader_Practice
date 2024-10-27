#version 410 core

uniform vec2 resolution;
uniform float time;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;
// time
// resolution
// theColor



float DistLine(vec3 ro, vec3 rd, vec3 p) {
    return length(cross(p-ro, rd))/length(rd);
}


void main()
{
    vec2 uv = fragCoord.xy / resolution.xy; // 0 <> 1
     
    uv -= .5; 
    uv.x *= resolution.x / resolution.y;
    
    vec3 ro = vec3(0., 0., -2.);
    vec3 rd = vec3(uv,x, uv.y, 0.)-ro;
   
    vec3 p = vec3(0., 0., 3.);
    float d = DistLine(ro, rd, p); 
    
    
    
    theColor = vec4(d);
}
