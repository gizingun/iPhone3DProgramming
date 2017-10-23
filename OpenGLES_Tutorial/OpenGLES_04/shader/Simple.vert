const char* SimpleVertexShader = STRINGIFY(
attribute vec4 Position;
attribute vec4 InputTextureCoordinate;

uniform mat4 Projection;
uniform mat4 Modelview;
varying vec2 textureCoordinate;

void main(void)
{
    textureCoordinate = InputTextureCoordinate.xy;
    gl_Position = Projection * Modelview * Position;
}
);
