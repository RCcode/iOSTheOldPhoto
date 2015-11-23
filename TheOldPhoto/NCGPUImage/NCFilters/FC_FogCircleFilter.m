//
//  FC_FogCircleFilter.m
//  FilterCamera
//
//  Created by fuqingping on 14-11-20.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import "FC_FogCircleFilter.h"

#import "GPUImageFilter.h"
#import "GPUImageTwoInputFilter.h"
#import "GPUImageGaussianBlurFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageFogCircleFragmentShaderString = SHADER_STRING
(
 precision lowp float;
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float excludeCircleRadius; //半径，值范围(0.0--1.0)
 uniform vec2 excludeCirclePoint;   //圆心点(x,y)(值范围,x:屏幕宽度范围内/屏幕宽度范围内; y:屏幕高度范围内/屏幕高度范围内)
 uniform float excludeBlurSize;     //模糊边界宽度
 uniform float aspectRatio;         
 
 void main()
 {
     //雾－圆
     lowp vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);

     highp vec2 textureCoordinateToUse = vec2(textureCoordinate2.x, (textureCoordinate2.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
     highp float distanceFromCenter = distance(excludeCirclePoint, textureCoordinateToUse);

     gl_FragColor = mix(sharpImageColor, blurredImageColor, smoothstep(excludeCircleRadius - excludeBlurSize, excludeCircleRadius, distanceFromCenter));
 }
 );
#else
NSString *const kGPUImageFogCircleFragmentShaderString = SHADER_STRING
(
 precision lowp float;
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform float excludeCircleRadius; //半径，值范围(0.0--1.0)
 uniform vec2 excludeCirclePoint;   //圆心点(x,y)(值范围,x:屏幕宽度范围内/屏幕宽度范围内; y:屏幕高度范围内/屏幕高度范围内)
 uniform float excludeBlurSize;     //模糊边界宽度
 uniform float aspectRatio;         //圆类型 1:圆；其他值：椭圆

 
 void main()
 {
     //雾－圆
     lowp vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     highp vec2 textureCoordinateToUse = vec2(textureCoordinate2.x, (textureCoordinate2.y * aspectRatio + 0.5 - 0.5 * aspectRatio));
     highp float distanceFromCenter = distance(excludeCirclePoint, textureCoordinateToUse);
     
     gl_FragColor = mix(sharpImageColor, blurredImageColor, smoothstep(excludeCircleRadius - excludeBlurSize, excludeCircleRadius, distanceFromCenter)); }
 );
#endif

@implementation FC_FogCircleFilter

@synthesize excludeCirclePoint = _excludeCirclePoint, excludeCircleRadius = _excludeCircleRadius, excludeBlurSize = _excludeBlurSize;
@synthesize blurRadiusInPixels = _blurRadiusInPixels;
@synthesize aspectRatio = _aspectRatio;

- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    hasOverriddenAspectRatio = NO;
    
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [blurFilter setBlurRadiusInPixels:4.0];
    [self addFilter:blurFilter];

    fogCircleFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kGPUImageFogCircleFragmentShaderString];
    [self addFilter:fogCircleFilter];

    [blurFilter addTarget:fogCircleFilter atTextureLocation:1];

    self.initialFilters = [NSArray arrayWithObjects:blurFilter, fogCircleFilter, nil];
    self.terminalFilter = fogCircleFilter;
    
    self.blurRadiusInPixels = 5.0;
    
    self.excludeCircleRadius = 60.0/320.0;
    self.excludeCirclePoint = CGPointMake(0.5f, 0.5f);
//    self.excludeBlurSize = 30.0/320.0;
    [self setExcludeBlurSize:0.3];
     [self setAspectRatio:1.0];
    return self;
}

- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
{
    CGSize oldInputSize = inputTextureSize;
    [super setInputSize:newSize atIndex:textureIndex];
    inputTextureSize = newSize;
    
    if ( (!CGSizeEqualToSize(oldInputSize, inputTextureSize)) && (!hasOverriddenAspectRatio) && (!CGSizeEqualToSize(newSize, CGSizeZero)) )
    {
        _aspectRatio = (inputTextureSize.width / inputTextureSize.height);
        [fogCircleFilter setFloat:_aspectRatio forUniformName:@"aspectRatio"];
    }
}

#pragma mark -
#pragma mark Accessors

- (void)setBlurRadiusInPixels:(CGFloat)newValue;
{
    blurFilter.blurRadiusInPixels = newValue;
}

- (CGFloat)blurRadiusInPixels;
{
    return blurFilter.blurRadiusInPixels;
}

- (void)setExcludeCirclePoint:(CGPoint)newValue;
{
    _excludeCirclePoint = newValue;
    [fogCircleFilter setPoint:newValue forUniformName:@"excludeCirclePoint"];
}

- (void)setExcludeCircleRadius:(CGFloat)newValue;
{
    _excludeCircleRadius = newValue;
    [fogCircleFilter setFloat:newValue forUniformName:@"excludeCircleRadius"];
}

- (void)setExcludeBlurSize:(CGFloat)newValue;
{
    _excludeBlurSize = newValue;
    [fogCircleFilter setFloat:newValue forUniformName:@"excludeBlurSize"];
}

- (void)setAspectRatio:(CGFloat)newValue;
{
    hasOverriddenAspectRatio = YES;
    _aspectRatio = newValue;
    [fogCircleFilter setFloat:_aspectRatio forUniformName:@"aspectRatio"];
}

@end
