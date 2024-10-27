
import numpy

import glfw 
from OpenGL.GL import *



def compileShader(shaderType, shader):
    id = glCreateShader(shaderType)
    glShaderSource(id, shader)
    glCompileShader(id)

    
    result = glGetShaderiv(id, GL_COMPILE_STATUS)
    if not result:
        print(glGetShaderInfoLog(id))

    return id

def createShader(vertex, fragment):

    vs = compileShader(GL_VERTEX_SHADER, vertex)
    fs = compileShader(GL_FRAGMENT_SHADER, fragment)

    program = glCreateProgram()
    glAttachShader(program, vs)
    glAttachShader(program, fs)
    glLinkProgram(program)
    glValidateProgram(program)

    glDeleteShader(vs)
    glDeleteShader(fs)

    
    result = glGetProgramiv(program, GL_LINK_STATUS)
    if not result:
        print(glGetProgramInfoLog(program))

    return program




def main():

    if not glfw.init():
        return
    
    window = glfw.create_window(1280, 720, "Hello world!", None, None)

    if not window:
        glfw.terminate()
        return
    

    glfw.make_context_current(window)

    vetecies = [
        -1.0, -1.0,
        1.0, -1.0,
        1.0, 1.0,

        1.0, 1.0,
        -1.0, 1.0,
        -1.0, -1.0,
    ]

    converted_vetecies = numpy.array(vetecies, dtype=numpy.float32)
    
    VAO = glGenVertexArrays(1)
    glBindVertexArray(VAO)


    VBO = glGenBuffers(1)    
    glBindBuffer(GL_ARRAY_BUFFER, VBO)
    glBufferData(GL_ARRAY_BUFFER, converted_vetecies, GL_STATIC_DRAW)


    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * 4, None)
    glEnableVertexAttribArray(0)

    vertex = open("square/vertex.shader").read()
    fragment = open("square/fragment.shader").read()

    shader = createShader(vertex, fragment)

    glUseProgram(shader)

    glUniform2f(glGetUniformLocation(shader, "resolution"), 1280, 720)
    while not glfw.window_should_close(window):

        glUniform1f(glGetUniformLocation(shader, "time"), glfw.get_time())
        glDrawArrays(GL_TRIANGLES, 0, 6)

        glfw.swap_buffers(window)

        glfw.poll_events()

    glfw.terminate()



if __name__ == "__main__":
    main()