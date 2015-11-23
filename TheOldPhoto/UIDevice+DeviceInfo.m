//
//  UIDevice+DeviceInfo.m
//  PushDemo
//
//  Created by MAXToooNG on 14-5-6.
//  Copyright (c) 2014年 MAXToooNG. All rights reserved.
//

#import "UIDevice+DeviceInfo.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
@implementation UIDevice (DeviceInfo)
- (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

- (NSString *) platformString{
    NSString *platform = [self platform];
//    if ([platform isEqualToString:@"iPhone1,1"]){
//        return @"iPhone 1G";
//    }
//    if ([platform isEqualToString:@"iPhone1,2"]){
//        return @"iPhone 3G";
//    }
//    if ([platform isEqualToString:@"iPhone2,1"]){
//        return @"iPhone 3GS";
//    }
//    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
//    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
//    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])
//        return @"iPhone Simulator";
    return platform;
}  


+ (NSString *)currentVersion{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)currentModel{
    return [[UIDevice currentDevice] model];
}

+ (NSString *)currentModelVersion{
    return [[UIDevice currentDevice] platformString];
}

@end
