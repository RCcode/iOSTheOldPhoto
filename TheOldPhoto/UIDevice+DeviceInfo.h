//
//  UIDevice+DeviceInfo.h
//  PushDemo
//
//  Created by MAXToooNG on 14-5-6.
//  Copyright (c) 2014年 MAXToooNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (DeviceInfo)
+ (NSString *)currentVersion;
+ (NSString *)currentModel;
+ (NSString *)currentModelVersion;
@end
