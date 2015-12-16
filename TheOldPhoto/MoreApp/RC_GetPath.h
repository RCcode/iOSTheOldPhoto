//
//  GetPath.h
//  RC_moreAPPsLib
//
//  Created by wsq-wlq on 14-11-27.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RC_GetPath : NSObject

+ (NSString *)getMyBundlePath:(NSString *)filename;

+ (NSBundle *)getBundle;

@end
