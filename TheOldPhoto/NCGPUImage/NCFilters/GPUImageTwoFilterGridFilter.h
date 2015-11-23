//
//  GPUImageTwoFilterGridFilter.h
//  GPUImage
//
//  Created by MAXToooNG on 15/5/15.
//  Copyright (c) 2015年 Brad Larson. All rights reserved.
//

#import "GPUImageFilter.h"

extern NSString *const kGPUImageTwoFilterGridTextureVertexShaderString;

@interface GPUImageTwoFilterGridFilter : GPUImageFilter
{
    GPUImageFramebuffer *secondInputFramebuffer;
    GLint filterSecondPositionAttribute;
    GLint filterSecondTextureCoordinateAttribute;
    GLint filterInputTextureUniform2;
    GPUImageRotationMode inputRotation2;
    CMTime firstFrameTime, secondFrameTime;
    GLfloat *v1,*v2;
    BOOL hasSetFirstTexture, hasReceivedFirstFrame, hasReceivedSecondFrame, firstFrameWasVideo, secondFrameWasVideo;
    BOOL firstFrameCheckDisabled, secondFrameCheckDisabled;
}

- (void)setv1:(GLfloat *)v;
- (void)setTexture:(GLfloat *)v;


- (void)disableFirstFrameCheck;
- (void)disableSecondFrameCheck;

@end
