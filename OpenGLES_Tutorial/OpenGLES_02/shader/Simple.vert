const char* SimpleVertexShader = STRINGIFY(
attribute vec4 Position;
attribute vec4 SourceColor;
varying vec4 DestinationColor;
uniform mat4 Projection;
uniform mat4 Modelview;
uniform float PointSize;

void main(void)
{
    DestinationColor = SourceColor;
    gl_PointSize = PointSize;
    gl_Position = Projection * Modelview * Position;
}
);
