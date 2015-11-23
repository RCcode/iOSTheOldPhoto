//
//  ScreenshotBorder.h
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//
//  系统名称：截图界面
//  功能描述：

#import "CameraApertureView.h"

#define DefaultBorderSizeDiff 50
typedef enum{
    CameraCropStyleOriginal,
    CameraCropStyleFree,
    CameraCropStyleSquare, //1:1
    CameraCropStyleSquareness1,//2:3
    CameraCropStyleSquareness2,//3:2
    CameraCropStyleSquareness3,//4:3
    CameraCropStyleSquareness4,//3:4
    CameraCropStyleSquareness5,//16:9
    CameraCropStyleSquareness6,//9:16
} CameraCropStyle;
@interface ScreenshotBorderView : UIView

//源iamge图像
@property (nonatomic, strong) UIImage *srcImage;

//透明截图框初始大小，默认size比原图小DefaultBorderSizeDiff
@property (nonatomic, assign) CGRect borderRect;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) EAGLContext *eagleContext;
@property (nonatomic, strong) CIContext *ciContext;


/**
 *  指定srcImage，快速创建一个截图界面【推荐使用】
 *
 *  @param srcImage 被截图的image对象
 *
 *  @return 返回一个快速创建的ScreenshotBorder对象
 */
+ (instancetype)screenshotBorderWithSrcImage:(UIImage *)srcImage;

- (void)resetSrcImage:(UIImage *)srcImage;

/**
 *  截图，根据当前截图界面中透明截图框的frame，从srcImage中截取一部分返回
 *
 *  @return 返回截取出的subImage
 */
- (UIImage *)subImage;

- (CGRect)subRect;

- (void)hiddenBorderView;

- (void)showBorderView;

- (void)setCameraCropStyle:(CameraCropStyle)style;

- (void)setSubViewBorder;

@end
