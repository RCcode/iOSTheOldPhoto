//
//  FC_FogRectangularFilter.m
//  FilterCamera
//
//  Created by fuqingping on 14-11-19.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import "FC_FogRectangularFilter.h"
#import "GPUImageFilter.h"
#import "GPUImageTwoInputFilter.h"
#import "GPUImageGaussianBlurFilter.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
NSString *const kGPUImageFogRectangularFragmentShaderString = SHADER_STRING
(
 precision lowp float;
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform lowp float topFocusLevel;       //清晰范围开始值（范围：0,1）
 uniform lowp float bottomFocusLevel;    //清晰范围结束值（范围：0,1）
 uniform highp float focusFallOffRate;   //模糊边界宽度（范围：0,1）
 uniform highp float angleRate;          //角度（0.0为水平方向;90、－90为垂直方向，大于0时为顺时针方向变化，小于0为逆时针变化，值范围为：－90.0 —— 90.0）
 void main()
 {
     
     vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     float angleRate_temp = angleRate / 3.0 / 2.37;
     float blurIntensity;
     if (angleRate == 0.0){
         blurIntensity= 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, textureCoordinate2.y);  //degrees
         blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, textureCoordinate2.y);
         
     }else if (angleRate > 0.0){
         if (angleRate < 90.0){
             float temp_topFocusLevel = 0.0;
             float temp_bottomFocusLevel = 0.0;
             
             if (angleRate == 45.0){
                 temp_topFocusLevel = -(topFocusLevel - 0.5);
                 temp_bottomFocusLevel = -(bottomFocusLevel - 0.5);
                 blurIntensity= 1.0 - smoothstep(-temp_topFocusLevel - 0.70 + angleRate * 0.0153 + focusFallOffRate,
                                                 -temp_topFocusLevel - 0.70 + angleRate * 0.0153,
                                                 textureCoordinate2.y*radians(angleRate) - textureCoordinate2.x*radians(90.0 - angleRate));
                 
                 blurIntensity += smoothstep(-temp_bottomFocusLevel - 0.70 + angleRate * 0.0153,
                                             -temp_bottomFocusLevel - 0.70 + angleRate * 0.0153 - focusFallOffRate,
                                             textureCoordinate2.y*radians(angleRate) - textureCoordinate2.x*radians(90.0 - angleRate));
             }else if (angleRate > 45.0){
                 temp_topFocusLevel = -(topFocusLevel - 0.5)*1.25;
                 temp_bottomFocusLevel = -(bottomFocusLevel - 0.5)*1.25;
                 blurIntensity= 1.0 - smoothstep(-temp_topFocusLevel + 0.70 - angleRate * 0.0153 + focusFallOffRate,
                                                 -temp_topFocusLevel + 0.70 - angleRate * 0.0153,
                                                 textureCoordinate2.y*radians((90.0-angleRate)*0.80) - textureCoordinate2.x*radians(angleRate*0.80));
                 
                 blurIntensity += smoothstep(-temp_bottomFocusLevel + 0.70 - angleRate * 0.0153,
                                             -temp_bottomFocusLevel + 0.70 - angleRate * 0.0153 - focusFallOffRate,
                                             textureCoordinate2.y*radians((90.0-angleRate)*0.80) - textureCoordinate2.x*radians(angleRate*0.80));
             }else{
                 
                 
                 temp_topFocusLevel = -(topFocusLevel - 0.5)*1.20;
                 temp_bottomFocusLevel = -(bottomFocusLevel - 0.5)*1.20;
                 blurIntensity= 1.0 - smoothstep(-temp_topFocusLevel + 0.70 - angleRate * 0.0153 + focusFallOffRate,
                                                 -temp_topFocusLevel + 0.70 - angleRate * 0.0153,
                                                 textureCoordinate2.y*radians((90.0-angleRate)*0.85) - textureCoordinate2.x*radians(angleRate*0.85));
                 
                 blurIntensity += smoothstep(-temp_bottomFocusLevel + 0.70 - angleRate * 0.0153,
                                             -temp_bottomFocusLevel + 0.70 - angleRate * 0.0153 - focusFallOffRate,
                                             textureCoordinate2.y*radians((90.0-angleRate)*0.85) - textureCoordinate2.x*radians(angleRate*0.85));
             }
             
         }else{
             blurIntensity= 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, textureCoordinate2.x  );
             blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, textureCoordinate2.x);
             
         }
     }else if (angleRate < 0.0){
         if (angleRate > -90.0){
             blurIntensity= 1.0 - smoothstep(topFocusLevel*(1.0+radians(abs(angleRate_temp*angleRate_temp))) - focusFallOffRate * (1.0+radians(abs(angleRate_temp*angleRate_temp))),
                                             topFocusLevel*(1.0+radians(abs(angleRate_temp*angleRate_temp))),
                                             textureCoordinate2.x * (radians(abs(angleRate_temp*angleRate_temp))) + textureCoordinate2.y);  //degrees
             
             blurIntensity += smoothstep(bottomFocusLevel*(1.0+radians(abs(angleRate_temp*angleRate_temp))),
                                         bottomFocusLevel*(1.0+radians(abs(angleRate_temp*angleRate_temp))) + focusFallOffRate * (1.0+radians(abs(angleRate_temp*angleRate_temp))),
                                         textureCoordinate2.x * (radians(abs(angleRate_temp*angleRate_temp))) + textureCoordinate2.y);
         }else{
             blurIntensity= 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, textureCoordinate2.x  );  //degrees
             blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, textureCoordinate2.x);
         }
     }
     
     
     gl_FragColor = mix(sharpImageColor, blurredImageColor, blurIntensity);
 }
 );
#else
NSString *const kGPUImageFogRectangularFragmentShaderString = SHADER_STRING
(
 precision lowp float;
 varying vec2 textureCoordinate;
 varying vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 uniform lowp float topFocusLevel;
 uniform lowp float bottomFocusLevel;
 uniform highp float focusFallOffRate;
 uniform highp float angleRate;
 void main()
 {
     vec4 sharpImageColor = texture2D(inputImageTexture, textureCoordinate);
     vec4 blurredImageColor = texture2D(inputImageTexture2, textureCoordinate2);
     
     float angleRate_temp = angleRate / 3.0 / 2.37;
     float blurIntensity;
     if (angleRate == 0.0){
         blurIntensity= 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, textureCoordinate2.y);  //degrees
         blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, textureCoordinate2.y);
         
     }else if (angleRate > 0.0){
         if (angleRate < 90.0){
             float temp_topFocusLevel = 0.0;
             float temp_bottomFocusLevel = 0.0;
             
             if (angleRate == 45.0){
                 temp_topFocusLevel = -(topFocusLevel - 0.5);
                 temp_bottomFocusLevel = -(bottomFocusLevel - 0.5);
                 blurIntensity= 1.0 - smoothstep(-temp_topFocusLevel - 0.70 + angleRate * 0.0153 + focusFallOffRate,
                                                 -temp_topFocusLevel - 0.70 + angleRate * 0.0153,
                                                 textureCoordinate2.y*radians(angleRate) - textureCoordinate2.x*radians(90.0 - angleRate));
                 
                 blurIntensity += smoothstep(-temp_bottomFocusLevel - 0.70 + angleRate * 0.0153,
                                             -temp_bottomFocusLevel - 0.70 + angleRate * 0.0153 - focusFallOffRate,
                                             textureCoordinate2.y*radians(angleRate) - textureCoordinate2.x*radians(90.0 - angleRate));
             }else if (angleRate > 45.0){
                 temp_topFocusLevel = -(topFocusLevel - 0.5)*1.25;
                 temp_bottomFocusLevel = -(bottomFocusLevel - 0.5)*1.25;
                 blurIntensity= 1.0 - smoothstep(-temp_topFocusLevel + 0.70 - angleRate * 0.0153 + focusFallOffRate,
                                                 -temp_topFocusLevel + 0.70 - angleRate * 0.0153,
                                                 textureCoordinate2.y*radians((90.0-angleRate)*0.80) - textureCoordinate2.x*radians(angleRate*0.80));
                 
                 blurIntensity += smoothstep(-temp_bottomFocusLevel + 0.70 - angleRate * 0.0153,
                                             -temp_bottomFocusLevel + 0.70 - angleRate * 0.0153 - focusFallOffRate,
                                             textureCoordinate2.y*radians((90.0-angleRate)*0.80) - textureCoordinate2.x*radians(angleRate*0.80));
             }else{
                 
                 
                 temp_topFocusLevel = -(topFocusLevel - 0.5)*1.20;
                 temp_bottomFocusLevel = -(bottomFocusLevel - 0.5)*1.20;
                 blurIntensity= 1.0 - smoothstep(-temp_topFocusLevel + 0.70 - angleRate * 0.0153 + focusFallOffRate,
                                                 -temp_topFocusLevel + 0.70 - angleRate * 0.0153,
                                                 textureCoordinate2.y*radians((90.0-angleRate)*0.85) - textureCoordinate2.x*radians(angleRate*0.85));
                 
                 blurIntensity += smoothstep(-temp_bottomFocusLevel + 0.70 - angleRate * 0.0153,
                                             -temp_bottomFocusLevel + 0.70 - angleRate * 0.0153 - focusFallOffRate,
                                             textureCoordinate2.y*radians((90.0-angleRate)*0.85) - textureCoordinate2.x*radians(angleRate*0.85));
             }
             
         }else{
             blurIntensity= 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, textureCoordinate2.x  );
             blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, textureCoordinate2.x);
             
         }
     }else if (angleRate < 0.0){
         if (angleRate > -90.0){
             blurIntensity= 1.0 - smoothstep(topFocusLevel*(1.0+radians(abs(angleRate_temp*angleRate_temp))) - focusFallOffRate * (1.0+radians(abs(angleRate_temp*angleRate_temp))),
                                             topFocusLevel*(1.0+radians(abs(angleRate_temp*angleRate_temp))),
                                             textureCoordinate2.x * (radians(abs(angleRate_temp*angleRate_temp))) + textureCoordinate2.y);  //degrees
             
             blurIntensity += smoothstep(bottomFocusLevel*(1.0+radians(abs(angleRate_temp*angleRate_temp))),
                                         bottomFocusLevel*(1.0+radians(abs(angleRate_temp*angleRate_temp))) + focusFallOffRate * (1.0+radians(abs(angleRate_temp*angleRate_temp))),
                                         textureCoordinate2.x * (radians(abs(angleRate_temp*angleRate_temp))) + textureCoordinate2.y);
         }else{
             blurIntensity= 1.0 - smoothstep(topFocusLevel - focusFallOffRate, topFocusLevel, textureCoordinate2.x  );  //degrees
             blurIntensity += smoothstep(bottomFocusLevel, bottomFocusLevel + focusFallOffRate, textureCoordinate2.x);
         }
     }
     
     
     gl_FragColor = mix(sharpImageColor, blurredImageColor, blurIntensity);
 }
 );
#endif

@implementation FC_FogRectangularFilter
@synthesize blurRadiusInPixels;
@synthesize topFocusLevel = _topFocusLevel;
@synthesize bottomFocusLevel = _bottomFocusLevel;
@synthesize focusFallOffRate = _focusFallOffRate;
@synthesize angleRate = _angleRate;



- (id)init;
{
    if (!(self = [super init]))
    {
        return nil;
    }
    
    blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [blurFilter setBlurRadiusInPixels:3.0f];
    [self addFilter:blurFilter];
    
    fogRectangularFilter = [[GPUImageTwoInputFilter alloc] initWithFragmentShaderFromString:kGPUImageFogRectangularFragmentShaderString];
    [self addFilter:fogRectangularFilter];
    
    [blurFilter addTarget:fogRectangularFilter atTextureLocation:1];
    
    self.initialFilters = [NSArray arrayWithObjects:blurFilter, fogRectangularFilter, nil];
    self.terminalFilter = fogRectangularFilter;
    
    self.topFocusLevel = 0.4;
    self.bottomFocusLevel = 0.6;
    self.focusFallOffRate = 0.2;
    self.angleRate = 0.0;
    self.blurRadiusInPixels = 6.0;
    
    return self;
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

- (void)setTopFocusLevel:(CGFloat)newValue;
{
    _topFocusLevel = newValue;
    [fogRectangularFilter setFloat:newValue forUniformName:@"topFocusLevel"];
}

- (void)setBottomFocusLevel:(CGFloat)newValue;
{
    _bottomFocusLevel = newValue;
    [fogRectangularFilter setFloat:newValue forUniformName:@"bottomFocusLevel"];
}

- (void)setFocusFallOffRate:(CGFloat)newValue;
{
    _focusFallOffRate = newValue;
    [fogRectangularFilter setFloat:newValue forUniformName:@"focusFallOffRate"];
}

- (void)setAngleRate:(CGFloat)newValue;
{
    _angleRate = newValue;
    [fogRectangularFilter setFloat:newValue forUniformName:@"angleRate"];
}



@end
