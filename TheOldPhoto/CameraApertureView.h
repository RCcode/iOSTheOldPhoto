//
//  CameraAperture.h
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//
//  系统名称：取景框
//  功能描述：用于高亮显示需要截取

#import "ControlBorder.h"

@class CameraApertureView;


@interface CameraApertureView : UIView

typedef enum{
        CropStyleOriginal,
        CropStyleFree,
        CropStyleSquare, //1:1
        CropStyleSquareness1,//2:3
        CropStyleSquareness2,//3:2
        CropStyleSquareness3,//4:3
        CropStyleSquareness4,//3:4
        CropStyleSquareness5,//16:9
        CropStyleSquareness6//9:16
}CropStyle;

//控制边框
@property (nonatomic,strong) ControlBorder *controlBorder;
@property (nonatomic,assign) CropStyle style;
//@property (nonatomic, strong) CornerView *leftUpBtn;
//@property (nonatomic, strong) CornerView *leftDownBtn;
//@property (nonatomic, strong) CornerView *rightUpBtn;
//@property (nonatomic, strong) CornerView *rightDownBtn;




@property (nonatomic, weak) id<CameraApertureDelegate> delegate;

@end
