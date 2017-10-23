const char* SimpleFragmentShader = STRINGIFY(

varying highp vec2 textureCoordinate;
uniform sampler2D inputImageTexture;

void main(void)
{
    gl_FragColor = texture2D(inputImageTexture, textureCoordinate);
}
);
