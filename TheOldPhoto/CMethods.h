//
//  CMethods.h
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <stdio.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface CMethods : NSObject
{
    
}

//window 高度
CGFloat windowHeight();

//window 宽度
CGFloat windowWidth();

//statusBar隐藏与否的高
CGFloat heightWithStatusBar();

//view 高度
CGFloat viewHeight(UIViewController *viewController);

//图片路径
UIImage* pngImagePath(NSString *name);
UIImage* jpgImagePath(NSString *name);
NSString* jpgImagePathWithPath(NSString *name);

//数字转化为字符串
NSString* stringForInteger(int value);

//系统语言环境
NSString* currentLanguage();

BOOL iPhone4();
BOOL iPhone5();

BOOL IOS7();
BOOL IOS8();
BOOL iOS9();
//返回随机不重复树
NSMutableArray* randrom(int count,int totalCount);

//十六进制颜色值
UIColor* colorWithHexString(NSString *stringToConvert);
UIColor* colorWithHexStringAndAlpha(NSString *stringToConvert, CGFloat alpha);
UIColor* cornerColorWithHexString(NSString *stringToConvert);
//把字典转化为json串
NSData* toJSONData(id theData);

NSString *LocalizedString(NSString *translation_key, id none);

CGFloat setW(CGFloat width);
CGFloat setH(CGFloat Height);

//CGFloat setHForIcon(CGFloat width);
//CGFloat setWForIcon(CGFloat height);

//NSString* getHeaderData();
//NSDictionary *getCollageConfigDic(NSInteger type);
//NSDictionary *getEurFilterConfig();
//NSArray*getFilterPreviewArray();

MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView);
MBProgressHUD * showMBProgressHUDandButton(NSString *content,BOOL showView, id target, SEL action);
void hideMBProgressHUD();
NSString *doDevicePlatform();
BOOL isChineseS();
BOOL isChinese();
MBProgressHUD *showMBProgressHUDWithoutText();
//MBProgressHUD *setProgressHudWithCustom();
CGFloat statusBarHeight();
@end
