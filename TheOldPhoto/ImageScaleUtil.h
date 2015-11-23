//
//  ImageScaleUtil.h
//  OpenCVTest
//
//  Created by MAXToooNG on 14-5-15.
//  Copyright (c) 2014年 MAXToooNG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageScaleUtil : NSObject
+ (CGPoint)getThePointWithImage:(CGPoint)p imageSize:(CGSize)size;
+ (CGFloat)getTheScaleForImageSize:(CGSize)size;
@end
