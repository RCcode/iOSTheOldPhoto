//
//  UIImage+Rotate.h
//  BeautySelfie
//
//  Created by MAXToooNG on 14-5-23.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)
+ (UIImage *)rotate: (UIImage *)image;
- (UIImage *)fixOrientation:(UIImageOrientation)orientation;
- (UIImage*)rotate:(UIImageOrientation)orient;
- (UIImage *)fixOrientation:(UIImageOrientation)orientation andLogoImage:(UIImage *)logo;
- (UIImage*)rotateImageWithRadian:(CGFloat)radian;
@end
