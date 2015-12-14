//
//  StickerUtil.m
//  BestMe
//
//  Created by MAXToooNG on 15/9/2.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "DataUtil.h"

@implementation DataUtil

static DataUtil *dataUtil = nil;

+ (DataUtil *)defaultUtil
{
    if (dataUtil == nil) {
        dataUtil = [[DataUtil alloc] init];
    }
    return dataUtil;
}


@end
