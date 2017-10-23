//
//  GLTexture.m
//  OpenGLES
//
//  Created by HyunukKim on 2017. 10. 23..
//  Copyright © 2017년 gizingun. All rights reserved.
//

#import "GLTexture.h"

@implementation GLTexture

+ (id)textureWithImagePath:(NSString *)path
{
    return [[self alloc] initWithImagePath:path];
}

- (id)initWithImagePath:(NSString *)path
{
    self = [super init];
    if (self) {
        _textureID = -1;
        _imageData = NULL;
        _width = -1;
        _height = -1;
        if ([self loadUIImage:path]) {
            [self generateTexture];
        }
    }
    
    return self;
}

#pragma mark - Public methods

- (BOOL)bindTexture
{
    if (_textureID == -1) {
        return NO;
    }
    
    glBindTexture(GL_TEXTURE_2D, _textureID);
    return YES;
}

#pragma mark - Private methods
- (BOOL)loadUIImage:(NSString *)imagePath
{
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (image == nil) {
        return NO;
    }
    
    // Get Image Information
    CGImageRef cgImage = [image CGImage];
    _width = CGImageGetWidth(cgImage);
    _height = CGImageGetHeight(cgImage);
    
    if (_imageData) {
        free(_imageData);
    }
    _imageData = (GLubyte *)calloc(_width * _height * 4, sizeof(GLubyte));
    if (_imageData == NULL) {
        return NO;
    }
    
    // 이미지 그릴 비트맵컨텍스트 생성
    CGContextRef bitmapContext = CGBitmapContextCreate(_imageData, _width, _height, 8, _width * 4, CGImageGetColorSpace(cgImage), kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(bitmapContext,
                       CGRectMake(0, 0, _width, _height),
                       cgImage);
    
    //: 비트맵데이터만 필요하므로 컨텍스트는 메모리 해제한다
    CGContextRelease(bitmapContext);
    return YES;
}

- (BOOL)generateTexture
{
    if(_imageData == NULL)
        return NO;
    
    if(_textureID != -1)
    {
        glDeleteTextures(1, &_textureID);
        _textureID = -1;
    }
    
    //: 텍스춰 구분자를 생성한다
    glGenTextures(1, &_textureID);
    
    //: 텍스춰를 바인딩한다
    glBindTexture(GL_TEXTURE_2D, _textureID);
    
    //: 텍스춰 파라미터를 설정한다
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    //: 텍스춰 구분자와 이미지 데이터를 연결한다
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA,
                 (GLsizei)_width,
                 (GLsizei)_height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 _imageData);
    return YES;
}

- (void)deleteTexture
{
    if (_textureID != -1) {
        glDeleteTextures(1, &_textureID);
        _textureID = -1;
    }
}
@end
