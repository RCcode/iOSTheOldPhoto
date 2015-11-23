//
//  BM_FilterGridFilter1.m
//  BestMe
//
//  Created by MAXToooNG on 15/5/15.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "BM_FilterGridFilter1.h"

NSString *const kBMFilterGrid1ShaderString = SHADER_STRING
(
 varying highp vec2 textureCoordinate;
 varying highp vec2 textureCoordinate2;
 
 uniform sampler2D inputImageTexture;
 uniform sampler2D inputImageTexture2;
 
 void main()
 {
     lowp vec4 base = texture2D(inputImageTexture, textureCoordinate);
     lowp vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);
    
     mediump float r;
     if (textureCoordinate.x > 0.5) {
         r = base.r;
     } else {
         r = overlay.r;
     }
     
     mediump float g;
     if (textureCoordinate.x > 0.5) {
         g = base.g;
     } else {
         g = overlay.g;
     }
     
     mediump float b;
     if (textureCoordinate.x > 0.5) {
         b = base.b;
     } else {
         b = overlay.b;
     }
     
     mediump float a;
     if (textureCoordinate.x > 0.5) {
         a = base.a;
     } else {
         a = overlay.a;
     }

     gl_FragColor = vec4(r, g, b, a);
 }
 );

@implementation BM_FilterGridFilter1

- (id)init;
{
    if (!(self = [super initWithFragmentShaderFromString:kBMFilterGrid1ShaderString]))
    {
        return nil;
    }
    
    return self;
}

@end
