#version 410 core

uniform vec2 resolution;
uniform float time;
vec2 fragCoord = gl_FragCoord.xy;
out vec4 theColor;
// time
// resolution
// theColor


float Band(float t, float start, float end, float blur){
    float step1 = smoothstep(start-blur, start+blur, t);
    float step2 = smoothstep(end+blur, end-blur, t);

    return step1*step2;
}

float Rect(vec2 uv, float left, float right, float bottom, float top, float blur) {
    float band1 = Band(uv.x, left, right, blur);
    float band2 = Band(uv.y, bottom, top, blur);

    return band2*band1;


}


void main()
{
    vec2 uv = fragCoord.xy / resolution.xy;
     
    uv -= .5; 
    uv.x *= resolution.x / resolution.y;
    
    
    vec3 col = vec3(0.);
    
    float m = sin(time*3)*.1;
    float u = cos(time*3)*.1;
    float x = uv.x+u;
    float q = (x-.5)*(x+.5);
    float y = uv.y+m+q;
    
    float mask = 0.;
    //mask = smoothstep(-0.5, 0.5, uv.x);
    //mask = Band(uv.x, -.5, .5, .01);



    mask = Rect(vec2(x, y), -.5, .5, -.3, .3, .01);
    col = vec3(1., 1., 1.)*mask;
    
    
    
    theColor = vec4(col, 1.0);
}
