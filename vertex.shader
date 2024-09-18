#version 410 core

layout(location = 0) in vec2 positions;

void main() 
{
    gl_Position = vec4(positions.x, positions.y, 0.0, 1.0);
}