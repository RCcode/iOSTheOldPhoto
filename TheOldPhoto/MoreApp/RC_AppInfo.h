//
//  ME_AppInfo.h
//  IOSMirror
//
//  Created by gaoluyangrc on 14-7-14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RC_AppInfo : NSObject

@property (nonatomic ,strong) NSString *appCate;
@property (nonatomic ,assign) int appComment;
@property (nonatomic ,assign) int appId;
@property (nonatomic ,strong) NSString *appName;
@property (nonatomic ,strong) NSString *bannerUrl;
@property (nonatomic ,strong) NSString *downUrl;
@property (nonatomic ,strong) NSString *iconUrl;
@property (nonatomic ,strong) NSString *packageName;
@property (nonatomic ,strong) NSString *price;
@property (nonatomic ,strong) NSString *openUrl;
@property (nonatomic ,assign) BOOL isHave;
@property (nonatomic ,strong) NSString *appDesc;
@property (nonatomic ,assign) int state;

@property (nonatomic, strong) NSMutableDictionary *stuff;

- (id)initWithDictionary:(NSDictionary *)dic;

@end
