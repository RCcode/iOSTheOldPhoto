//
//  Corner.h
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//
//  系统名称：截图框边角按钮
//  功能描述：用于调整ScreenshotBorder的大小
#import "Pic_ProtocolClass.h"
#import <UIKit/UIKit.h>

@interface CornerView : UIView

//代理
@property (nonatomic, weak) id<CornerDelegate> delegate;

@end
