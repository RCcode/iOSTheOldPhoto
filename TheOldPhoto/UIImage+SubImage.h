//
//  UIImage+SubImage.h
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//

#import <UIKit/UIKit.h>

//屏幕size
#define kWinSize [UIScreen mainScreen].bounds.size


@interface UIImage (SubImage)


/**
*  获取当前image对象rect区域内的图像
*
*  @param rect 指定需要的区域
*
*  @return 返回截图subIamge
*/
- (UIImage *)subImageWithRect:(CGRect)rect;


/**
 *  指定size，获取新的iamge对象
 *
 *  @param size 指定新的大小
 *
 *  @return 返回指定size大小的image
 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/**
 *按一定比例进行压缩
 */
+ (NSData *)createThumbImage:(UIImage *)image size:(CGSize )thumbSize percent:(float)percent;
- (UIImage *)fixOrientation:(UIImageOrientation)orientation;

@end
