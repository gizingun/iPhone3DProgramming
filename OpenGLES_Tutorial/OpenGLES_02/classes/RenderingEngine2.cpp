//
//  RenderingEngine2.cpp
//  HelloArrow
//
//  Created by hyunuk on 2017. 10. 18..
//  Copyright © 2017년 snowcorp. All rights reserved.
//

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>
#include <cmath>
#include <iostream>
#include "IRenderingEngine.hpp"

#define STRINGIFY(A)  #A
#include "../shader/Simple.vert"
#include "../shader/Simple.frag"

static const float RevolutionsPerSecond = 1;

class RenderingEngine2 : public IRenderingEngine {
public:
    RenderingEngine2();
    ~RenderingEngine2();
    void Initialize(int width, int height);
    void Render() const;
    void ApplyProjection(float *projectMat) const;
    void ApplyModel(float *modelMat) const;
//    void UpdateAnimation(float timeStamp);
//    void OnRotate(DeviceOrientation newOrientation);
private:
    float RotationDirection() const;
    GLuint BuildShader(const char* source, GLenum shaderType) const;
    GLuint BuildProgram(const char* vShader, const char* fShader, GLuint *vShaderHandler, GLuint *fShaderHandelr) const;
//    void ApplyOrtho(float maxX, float maxY) const;
//    void ApplyRotation(float degrees) const;
//    float m_desiredAngle;
//    float m_currentAngle;
    GLuint m_simpleProgram;
    GLuint m_framebuffer;
    GLuint m_renderbuffer;
    GLuint m_vertexShader, m_fragmentShader;
};

IRenderingEngine* CreateRenderer2()
{
    return new RenderingEngine2();
}

struct Vertex {
    float Position[3];
    float Color[4];
};


// Define the positions and colors of two triangles.
const Vertex Vertices[] = {
    {{0.2, 0.2, 0.0}, {1.0, 1.0, 1.0, 1.0}},
    {{0.8, 0.2, 0.0}, {1.0, 1.0, 1.0, 1.0}},
    {{0.2, 0.8, 0.0}, {1.0, 1.0, 1.0, 1.0}},
    {{0.8, 0.8, 0.0}, {1.0, 1.0, 1.0, 1.0}},
};
/*
 const Vertex Vertices[] = {
 {0.2, 0.2, 0.0},
 {0.8, 0.2, 0.0},
 {0.2, 0.8, 0.0},
 {0.8, 0.8, 0.0},
 };
 */

RenderingEngine2::RenderingEngine2()
{
    // Create & bind the color buffer so that the caller can allocate its space.
    glGenRenderbuffers(1, &m_renderbuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, m_renderbuffer);
}

RenderingEngine2::~RenderingEngine2()
{
    if (m_renderbuffer) {
        glDeleteBuffers(1, &m_renderbuffer);
        m_renderbuffer = 0;
    }
    if (m_framebuffer) {
        glDeleteBuffers(1, &m_framebuffer);
        m_framebuffer = 0;
    }
    if (m_vertexShader) {
        glDeleteShader(m_vertexShader);
    }
    if (m_fragmentShader) {
        glDeleteShader(m_fragmentShader);
    }
    if (m_simpleProgram) {
        glDeleteProgram(m_simpleProgram);
    }
}

void RenderingEngine2::Initialize(int width, int height)
{
    // Create the framebuffer object and attach the color buffer.
    glGenFramebuffers(1, &m_framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, m_framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER,
                              GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER,
                              m_renderbuffer);
    
    glViewport(0, 0, width, height);
    
    m_simpleProgram = BuildProgram(SimpleVertexShader, SimpleFragmentShader, &m_vertexShader, &m_fragmentShader);
    
    glUseProgram(m_simpleProgram);
    
//    // Initialize the projection matrix.
//    ApplyOrtho(2, 3);
//
//    // Initialize rotation animation state.
////    OnRotate(DeviceOrientationPortrait);
////    m_currentAngle = m_desiredAngle;
}

void RenderingEngine2::ApplyProjection(float *projectionMat) const
{
    GLint projectionUniform = glGetUniformLocation(m_simpleProgram, "Projection");
    glUniformMatrix4fv(projectionUniform, 1, 0, projectionMat);
}

void RenderingEngine2::ApplyModel(float *modelMat) const
{
    GLint modelviewUniform = glGetUniformLocation(m_simpleProgram, "Modelview");
    glUniformMatrix4fv(modelviewUniform, 1, 0, modelMat);
}

void RenderingEngine2::Render() const
{
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    GLint pointSizeUniform = glGetUniformLocation(m_simpleProgram, "PointSize");
    glUniform1f(pointSizeUniform, 5.0);
//    glUniformMatrix4fv(modelviewUniform, 1, 0, modelMat);
    
    GLuint positionSlot = glGetAttribLocation(m_simpleProgram, "Position");
    GLuint colorSlot = glGetAttribLocation(m_simpleProgram, "SourceColor");
    
    glEnableVertexAttribArray(positionSlot);
    glEnableVertexAttribArray(colorSlot);
    
    GLsizei stride = sizeof(Vertex);
    const GLvoid* pCoords = &Vertices[0].Position[0];
    const GLvoid* pColors = &Vertices[0].Color[0];
    
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, stride, pCoords);
    glVertexAttribPointer(colorSlot, 4, GL_FLOAT, GL_FALSE, stride, pColors);
    
    GLsizei vertexCount = sizeof(Vertices) / sizeof(Vertex);
    glDrawArrays(GL_POINTS, 0, vertexCount);
    
    glDisableVertexAttribArray(positionSlot);
    glDisableVertexAttribArray(colorSlot);
}

GLuint RenderingEngine2::BuildShader(const char* source, GLenum shaderType) const
{
    GLuint shaderHandle = glCreateShader(shaderType);
    glShaderSource(shaderHandle, 1, &source, 0);
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        std::cout << messages;
        exit(1);
    }
    
    return shaderHandle;
}

GLuint RenderingEngine2::BuildProgram(const char* vertexShaderSource,
                                      const char* fragmentShaderSource, GLuint *vShaderHandler, GLuint *fShaderHandelr) const
{
    *vShaderHandler = BuildShader(vertexShaderSource, GL_VERTEX_SHADER);
    *fShaderHandelr = BuildShader(fragmentShaderSource, GL_FRAGMENT_SHADER);
    
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, *vShaderHandler);
    glAttachShader(programHandle, *fShaderHandelr);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(programHandle, sizeof(messages), 0, &messages[0]);
        std::cout << messages;
        exit(1);
    }
    
    return programHandle;
}
