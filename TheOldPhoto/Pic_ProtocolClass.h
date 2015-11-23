//
//  Pic_ProtocolClass.h
//  BeautySelfie
//
//  Created by MAXToooNG on 14-5-22.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "PRJ_FilterToolBarView.h"
@class CornerView;
@class ControlBorder;
@class CameraApertureView;

@protocol CameraApertureDelegate <NSObject>

/**
 *  当frame改变时，通知代理对象
 *
 *  @param cameraAperture 透明截图框cameratAperture对象
 */
- (void)cameraApertureFrameChanged:(CameraApertureView *)cameraAperture;

@end

@protocol ControlBorderDelegate <NSObject>
@optional
- (void)controlBorder:(ControlBorder *)controlBorder MoveBeginWithTouch:(UITouch *)touch;
- (void)controlBorder:(ControlBorder *)controlBorder MovedWithTouch:(UITouch *)touch;
- (void)controlBorderMoveEnd:(ControlBorder *)controlBorder;
@end

@protocol CornerDelegate <NSObject>

@optional

/**********************************************************
 函数名称：- (void)corner:(Corner *)corner TouchesMoved:(UITouch *)touch
 函数描述：当touchesMoved事件被触发时此方法会被调用
 输入参数：(Corner *)corner 被触发touchesMoved事件的view
 输入参数：(UITouch *)touch touch事件
 输出参数：N/A
 返回值：N/A
 **********************************************************/
- (void)corner:(CornerView *)corner TouchesMoved:(UITouch *)touch;


/**********************************************************
 函数名称：- (void)corner:(Corner *)corner TouchesBegin:(UITouch *)touch
 函数描述：当TouchesBegin事件被触发时此方法会被调用
 输入参数：(Corner *)corner 被触发touchesMoved事件的view
 输入参数：(UITouch *)touch touch事件
 输出参数：N/A
 返回值：N/A
 **********************************************************/
- (void)corner:(CornerView *)corner TouchesBegin:(UITouch *)touch;


/**********************************************************
 函数名称：- (void)corner:(Corner *)corner TouchesEnd:(UITouch *)touch
 函数描述：当TouchesEnd事件被触发时此方法会被调用
 输入参数：(Corner *)corner 被触发touchesMoved事件的view
 输入参数：(UITouch *)touch touch事件
 输出参数：N/A
 返回值：N/A
 **********************************************************/
- (void)corner:(CornerView *)corner TouchesEnd:(UITouch *)touch;

@end



