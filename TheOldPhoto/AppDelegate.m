//
//  AppDelegate.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/9.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking/AFHTTPRequestOperationManager.h"
#import "UIDevice+DeviceInfo.h"

@interface AppDelegate ()
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *updateUrlStr;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self cancelNotification];
    [self registNotification];
    [self umengSetting];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark -
#pragma mark 配置AFN
- (void)netWorkingSeting
{
    self.manager = [AFHTTPRequestOperationManager manager];
    //    self.manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

- (void)registNotification{
    if([[[UIDevice currentDevice]systemVersion] floatValue] >= 8.0){
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
}
- (void)cancelNotification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)doNotificationActionWithInfo:(NSDictionary *)dic
{
    if(dic == nil) return;
    NSDictionary *dictionary = [dic objectForKey:@"aps"];
    NSString *alert = [dictionary objectForKey:@"alert"];
    NSString *type = [dic objectForKey:@"type"];
    NSString *urlStr = [dic objectForKey:@"url"];
    switch (type.intValue) {
        case 0:
        {
            // Ads
            //判断程序是否是由通知打开
            self.updateUrlStr = urlStr;
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                               message:alert
                                                              delegate:self
                                                     cancelButtonTitle:LocalizedString(@"main_cancel", @"")
                                                     otherButtonTitles:LocalizedString(@"main_yes", @""), nil];
            [alertView show];
            
        }
            break;
        case 1:
        {
            //            //Update
            //            self.updateUrlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",APPLE_ID];
            //            //            self.UpdateUrlStr = urlStr;
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
            //                                                           message:LocalizedString(@"root_new_version", @"")
            //                                                          delegate:self
            //                                                 cancelButtonTitle:LocalizedString(@"root_update_later", @"")
            //                                                 otherButtonTitles:LocalizedString(@"root_update_now", @""), nil];
            //            [alert show];
        }
            break;
        case 2:
            //Font
            //            [self OpenUrl:[NSURL URLWithString:urlStr]];
            break;
        case 3:
            //Tags
            //            [self OpenUrl:[NSURL URLWithString:urlStr]];
            break;
        case 4:
            //Filter
            //            [self OpenUrl:[NSURL URLWithString:urlStr]];
            break;
        case 5:
        {
//            //推广活动
//            PromotionViewController *pvc = [[PromotionViewController alloc] init];
//            pvc.urlString = urlStr;
//            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pvc];
//            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
    
    [self cancelNotification];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(self.updateUrlStr){
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.updateUrlStr]])
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.updateUrlStr]];
        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreScoreURL]];
    }
    
}
#pragma mark -
#pragma mark - Post User Data With Push
- (void)postData:(NSString *)token{
    
    //Bundle Id
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    //    NSLog(@"bundleIdentifier = %@",bundleIdentifier);
    //Idfv
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    //    NSLog(@"idfv = %@",idfv);
    //SystemVersion e.g. iOS
    NSString *systemVersion = [UIDevice currentVersion];
    //    NSLog(@"system Version = %@",systemVersion);
    //Model e.g. iPod
    NSString *model = [UIDevice currentModel];
    //    NSLog(@"currentModel = %@", model);
    //DeviceModel e.g. iPod4,1
    NSString *modelVersion = [UIDevice currentModelVersion];
    //    NSLog(@"currentModelVersion = %@",modelVersion);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"Z"];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:timeZone];
    NSDate *date = [NSDate date];
    //+0800
    NSString *timeZoneZ = [dateFormatter stringFromDate:date];
    NSRange range = NSMakeRange(0, 3);
    //+08
    NSString *timeZoneInt = [timeZoneZ substringWithRange:range];
    //    NSLog(@"timeZone = %@",timeZoneInt);
    
    //en
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    if ([language rangeOfString:@"zh-Hans"].location != NSNotFound) {
        language = @"zh-Hans";
    }else if([language rangeOfString:@"zh-Hant"].location != NSNotFound){
        language = @"zh-Hant";
    }else{
        NSArray *array = [language componentsSeparatedByString:@"-"];
        if (array) {
            language = [array firstObject];
        }
        
    }
    NSLog(@"language：%@", language);
    //US
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [[[locale localeIdentifier] componentsSeparatedByString:@"_"] lastObject];
    //    NSLog(@"country：%@", country);
    
    //     token           Push用token             String		N
    //     timeZone	 时区（-12--12）        int            N
    //     language     语言码                        String		N
    //     bundleid      bundleid                    String		N
    //     mac             使用唯一标识符 idfv   String		Y
    //     pagename	 应用包名                    String		N
    //     model          手机型号                    String		Y
    //     model_ver	 手机版本                    String		Y
    //     sysver          系统版本                    String		Y
    //     country        国家                           String		Y
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:token forKeyPath:@"token"];
    [params setValue:timeZoneInt forKeyPath:@"timeZone"];
    [params setValue:language forKey:@"language"];
    [params setValue:bundleIdentifier forKeyPath:@"bundleid"];
    [params setValue:idfv forKeyPath:@"mac"];
    [params setValue:bundleIdentifier forKeyPath:@"pagename"];
    [params setValue:model forKeyPath:@"model"];
    [params setValue:modelVersion forKeyPath:@"model_ver"];
    [params setValue:systemVersion forKeyPath:@"sysver"];
    [params setValue:country forKeyPath:@"country"];
    manager.requestSerializer = requestSerializer;
    [manager POST:PUSH_POST_URL_STRING parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary*)responseObject;
        NSString *result = [resultDic objectForKey:@"mess"];
        if ([result isEqualToString:@"succ"]) {
            NSLog(@"succ");
            [[NSUserDefaults standardUserDefaults] setObject:_deviceToken forKey:DEVICE_TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

#pragma mark -
#pragma mark 配置友盟
- (void)umengSetting
{
    [MobClick startWithAppkey:@"564d53d2e0f55abfbf00064e" reportPolicy:SEND_ON_EXIT channelId:@"App Store"];
    //在线参数配置
    [MobClick setAppVersion:XcodeAppVersion];
//    [MobClick updateOnlineConfig];
//    [UMFeedback setAppkey:UMENG_KEY];
}

@end
