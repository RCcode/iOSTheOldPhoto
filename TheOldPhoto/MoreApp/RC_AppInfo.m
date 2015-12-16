//
//  ME_AppInfo.m
//  IOSMirror
//
//  Created by gaoluyangrc on 14-7-14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "RC_AppInfo.h"

@implementation RC_AppInfo

@synthesize stuff;

- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    [self setValuesForKeysWithDictionary:dic];
    
    return self;
}
//- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
//{
//    for (NSString *key in [keyedValues allKeys])
//    {
//        [self setValue:[keyedValues objectForKey:key] forUndefinedKey:key];
//    }
//}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if (stuff == nil)
    {
        stuff = [[NSMutableDictionary alloc]init];
    }
    [stuff setObject:value forKey:key];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    id value = [stuff objectForKey:key];
    return (value);
}

- (void)setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    for (NSString *key in [keyedValues allKeys])
    {
        if ([key isEqualToString:@"openUrl"])
        {
            NSString *string = [keyedValues objectForKey :@"openUrl"];
            NSURL *url = nil;
            
            if (![string isKindOfClass:[NSNull class]] && string != nil ) {
                url = [NSURL URLWithString:string];
            }else{
                url = nil;
            }
            if ([[UIApplication sharedApplication] canOpenURL:url])
            {
                self.isHave = YES;
            }
            else
            {
                self.isHave = NO;
            }
        }
        if ([keyedValues objectForKey:key] != [NSNull null])
        {
            [self setValue:[keyedValues objectForKey:key] forKey:key];
        }
        else
        {
            if ([key isEqualToString:@"price"])
            {
                [self setValue:@"0" forKey:key];
            }
            else
            {
                [self setValue:@"" forKey:key];
            }
        }
    }
}

@end
