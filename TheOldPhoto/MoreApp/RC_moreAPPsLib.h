//
//  RC_moreAPPsLib.h
//  RC_moreAPPsLib
//
//  Created by wsq-wlq on 14-11-25.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <UIKit/UIKitDefines.h>
#import <UIKit/UIKit.h>

@interface RC_moreAPPsLib : NSObject


+ (id)shareAdManager;

- (void)requestWithMoreappId:(NSInteger)appid;//请求moreAPP数据及广告弹出次数

- (void)setTitleColor:(UIColor *)color;//设置弹出广告标题颜色
- (void)setBackGroundColor:(UIColor *)color;//设置弹出广告背景颜色

- (BOOL)isHaveNewApp;

- (void)showAdsWithController:(UIViewController *)popViewController;

@end

