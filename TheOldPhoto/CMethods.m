//
//  CMethods.m
//  TaxiTest
//
//  Created by Xiaohui Guo  on 13-3-13.
//  Copyright (c) 2013年 FJKJ. All rights reserved.
//

#import "CMethods.h"
#import <stdlib.h>
#import <time.h>
#import "sys/sysctl.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonCrypto.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "JSONKit.h"

//#import "ME_AppInfo.h"
//用户当前的语言环境
#define CURR_LANG   ([[NSLocale preferredLanguages] objectAtIndex:0])
@implementation CMethods

//window 高度
CGFloat windowHeight(){
    return [UIScreen mainScreen].bounds.size.height;
}

//window 高度
CGFloat windowWidth(){
    return [UIScreen mainScreen].bounds.size.width;
}

CGFloat setW(CGFloat width){
    return width / 320.0f * windowWidth();
}
CGFloat setH(CGFloat height){
    if (windowHeight() > 480) {
        return height / 568.0f * windowHeight();
    }
    return height;
}

//statusBar隐藏与否的高
CGFloat heightWithStatusBar(){
    return NO==[UIApplication sharedApplication].statusBarHidden ? windowHeight()-20 :windowHeight();
}

//view 高度
CGFloat viewHeight(UIViewController *viewController){
    if (nil==viewController) {
        return heightWithStatusBar();
    }
    return YES==viewController.navigationController.navigationBarHidden ? heightWithStatusBar():heightWithStatusBar()-44;
    
}

UIImage* pngImagePath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

UIImage* jpgImagePath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    return image;
}

NSString *jpgImagePathWithPath(NSString *name)
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"jpg"];
    //    NSURL *url = [NSURL fileURLWithPath:path];
    return path;
}

NSString* stringForInteger(int value)
{
    NSString *str = [NSString stringWithFormat:@"%d",value];
    return str;
}


//當前语言环境
NSString* currentLanguage()
{
    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
    NSString *languangeType;
    NSString* preferredLang = [languages objectAtIndex:0];
    if ([preferredLang isEqualToString:@"zh-Hant"]){
        languangeType=@"ft";
    }else{
        languangeType=@"jt";
    }
    //    NSLog(@"Preferred Language:%@", preferredLang);
    return languangeType;
}

BOOL iPhone5(){
    if (568==windowHeight()) {
        return YES;
    }
    return NO;
}

BOOL iPhone4(){
    if (windowHeight() == 480) {
        return YES;
    }
    return NO;
}

BOOL IOS7(){
    return ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0 && [[UIDevice currentDevice].systemVersion floatValue] < 8.0)? YES : NO;
}
BOOL IOS8(){
    return ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion floatValue] < 9.0)? YES : NO;
}

BOOL iOS9(){
    return ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0 && [[UIDevice currentDevice].systemVersion floatValue] < 10.0)? YES : NO;

}

//数学意义上的随机数在计算机上已被证明不可能实现。通常的随机数是使用随机数发生器在一个有限大的线性空间里取一个数。“随机”甚至不能保证数字的出现是无规律的。使用系统时间作为随机数发生器是常见的选择
NSMutableArray* randrom(int count,int totalCount){
    int x;
    int i;
    NSMutableArray *array=[[NSMutableArray alloc]init];
    time_t t;
    srand((unsigned) time(&t));
    for(i=0; i<count; i++){
        x=rand() % totalCount;
        printf("%d ", x);
        [array addObject:[NSString stringWithFormat:@"%d",x]];
    }
    printf("\n");
    return array;
}

UIColor* colorWithHexStringAndAlpha(NSString *stringToConvert, CGFloat alpha)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];

}

UIColor* colorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

UIColor* cornerColorWithHexString(NSString *stringToConvert)
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    //例子，stringToConvert #ffffff
    if ([cString length] < 6)
        return [UIColor whiteColor];//如果非十六进制，返回白色
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [UIColor whiteColor];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    if (r <= 30) {
        r = 30;
    }
    if (g <= 30) {
        g = 30;
    }
    if (b <= 30) {
        b = 30;
    }
    //转换为UIColor
    return [UIColor colorWithRed:((float) (r-30)<=0?0:(r-30) / 255.0f)
                           green:((float) (g-30)<=0?0:(g-30) / 255.0f)
                            blue:((float) (b-30)<=0?0:(b-30) / 255.0f)
                           alpha:1.0f];
}


NSData* toJSONData(id theData)
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] != 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

//MBProgressHUD *mb;
//MBProgressHUD * showMBProgressHUD(NSString *content,BOOL showView)
//{
//    //显示LoadView
//    @try {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (mb==nil) {
//                UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//                mb = [[MBProgressHUD alloc] initWithView:window];
//                mb.mode = showView?MBProgressHUDModeIndeterminate:MBProgressHUDModeText;
//                [window addSubview:mb];
//                //如果设置此属性则当前的view置于后台
//                //            mb.dimBackground = YES;
//                mb.labelText = content;
//            }else{
//                mb.mode = showView?MBProgressHUDModeIndeterminate:MBProgressHUDModeText;
//                mb.labelText = content;
//            }
//            [mb show:YES];
//            mb.color = [UIColor colorWithWhite:0 alpha:0.7];
//        });
//        
//    }
//    @catch (NSException *exception) {
//        NSLog(@"catch error for mbhud!!!!");
//    }
//    @finally {
//        
//    }
//    
//    return mb;
//}

//void hideMBProgressHUD()
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        mb.removeFromSuperViewOnHide = YES;
//        [mb hide:YES];
//        //    [mb removeFromSuperview];
//        mb = nil;
//        
//    });
//}

//MBProgressHUD *mbWithoutView;
//MBProgressHUD * showMBProgressHUDWithoutView(NSString *content,BOOL showView)
//{
//    if (mb==nil) {
//        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//        mb = [[MBProgressHUD alloc] initWithView:window];
//        mb.mode = showView?MBProgressHUDModeIndeterminate:MBProgressHUDModeText;
//        [window addSubview:mb];
//        //如果设置此属性则当前的view置于后台
//        //mb.dimBackground = YES;
//        
//        mb.labelText = content;
//    }else{
//        mb.mode = showView?MBProgressHUDModeIndeterminate:MBProgressHUDModeText;
//        mb.labelText = content;
//    }
//    mb.color = [UIColor clearColor];
//    [mb show:YES];
//    return mb;
//}
//
//void hideMBProgressHUDWithoutView()
//{
//    [mbWithoutView hide:YES];
//}


NSString *exchangeTime(NSString *time)
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSInteger timeValues = [time integerValue];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeValues];
    NSString *dataStr = [formatter stringFromDate:confromTimesp];
    return dataStr;
}

CGFloat fontSizeFromPX(CGFloat pxSize){
    return (pxSize / 96.0) * 72 * 0.65;
}


NSString *appVersion(){
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

BOOL isChineseS(){
    if ([CURR_LANG rangeOfString:@"zh-Hans"].location != NSNotFound) {
        return YES;
    }
    return NO;
}
BOOL isChinese(){
    if ([CURR_LANG rangeOfString:@"zh-Hans"].location != NSNotFound || [CURR_LANG rangeOfString:@"zh-Hant"].location != NSNotFound) {
        return YES;
    }
    return NO;
}

NSString *LocalizedString(NSString *translation_key, id none)
{
    
    NSString *language = @"en";
    NSArray *arr = [NSLocale preferredLanguages];
    //只适配这么些种语言，其余一律用en
    if([CURR_LANG isEqualToString:@"zh-Hans"] ||
       [CURR_LANG isEqualToString:@"zh-Hant"] ||
       [CURR_LANG isEqualToString:@"de"] ||
       [CURR_LANG isEqualToString:@"es"] ||
       [CURR_LANG isEqualToString:@"es-MX"] ||
       [CURR_LANG isEqualToString:@"fr"] ||
       [CURR_LANG isEqualToString:@"it"] ||
       [CURR_LANG isEqualToString:@"js"] ||
       [CURR_LANG isEqualToString:@"ko"] ||
       [CURR_LANG isEqualToString:@"ja"] ||
       [CURR_LANG isEqualToString:@"pt"] ||
       [CURR_LANG isEqualToString:@"pt-PT"] ||
       [CURR_LANG isEqualToString:@"id"] ||
       [CURR_LANG isEqualToString:@"th"] ||
       [CURR_LANG isEqualToString:@"ru"] ||
       [CURR_LANG isEqualToString:@"ar"] ||
       [CURR_LANG isEqualToString:@"tr"]){
        language = CURR_LANG;
    }
    if (iOS9()) {
        return NSLocalizedString(translation_key, nil);
    }
    NSString * path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
    NSBundle * languageBundle = [NSBundle bundleWithPath:path];
    return [languageBundle localizedStringForKey:translation_key value:@"" table:nil];
}

NSString *doDevicePlatform()
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    NSDictionary *devModeMappingMap = @{
                                        @"x86_64"    :@"Simulator",
                                        @"iPod1,1"   :@"iPod Touch",      // (Original)
                                        @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                                        @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                                        @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                                        @"iPod5,1"   :@"iPod Touch",
                                        @"iPhone1,1" :@"iPhone",          // (Original)
                                        @"iPhone1,2" :@"iPhone",          // (3G)
                                        @"iPhone2,1" :@"iPhone",          // (3GS)
                                        @"iPhone3,1" :@"iPhone 4",        //
                                        @"iPhone4,1" :@"iPhone 4S",       //
                                        @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                                        @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                                        @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                                        @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                                        @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                                        @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                                        @"iPad1,1"   :@"iPad",            // (Original)
                                        @"iPad2,1"   :@"iPad 2",          //
                                        @"iPad2,2"   :@"iPad 2",
                                        @"iPad2,3"   :@"iPad 2",
                                        @"iPad2,4"   :@"iPad 2",
                                        @"iPad2,5"   :@"iPad Mini",       // (Original)
                                        @"iPad2,6"   :@"iPad Mini",
                                        @"iPad2,7"   :@"iPad Mini",
                                        @"iPad3,1"   :@"iPad 3",          // (3rd Generation)
                                        @"iPad3,2"   :@"iPad 3",
                                        @"iPad3,3"   :@"iPad 3",
                                        @"iPad3,4"   :@"iPad 4",          // (4th Generation)
                                        @"iPad3,5"   :@"iPad 4",
                                        @"iPad3,6"   :@"iPad 4",
                                        @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                                        @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                                        @"iPad4,4"   :@"iPad Mini 2",     // (2nd Generation iPad Mini - Wifi)
                                        @"iPad4,5"   :@"iPad Mini 2"      // (2nd Generation iPad Mini - Cellular)
                                        };
    
    NSString *devModel = [devModeMappingMap valueForKeyPath:platform];
    return (devModel) ? devModel : platform;
}


//MBProgressHUD *HUD;
//void showLabelHUD(NSString *content)
//{
//    //显示LoadView
//    if (HUD==nil) {
//        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//        HUD = [[MBProgressHUD alloc] initWithView:window];
//        HUD.mode = MBProgressHUDModeText;
//        [window addSubview:HUD];
//        //如果设置此属性则当前的view置于后台
//    }
//    HUD.labelText = content;
//    [HUD showAnimated:YES whileExecutingBlock:^{
//        sleep(1.5);
//    } completionBlock:^{
//        [HUD removeFromSuperview];
//        HUD = nil;
//    }];
//}

CGFloat statusBarHeight()
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

#pragma mark - 打印系统所有已注册的字体名称
void enumerateFonts() {
    for(NSString *familyName in [UIFont familyNames]){
//        NSLog(@"%@",familyName);
        
        NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
        
        for(NSString *fontName in fontNames){
//            NSLog(@"\t|- %@",fontName);
        }
    }
}

CGRect getTextLabelRectWithContentAndFont(NSString *content ,UIFont *font)
{
    CGSize size = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    
    CGRect returnRect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil];
    
    return returnRect;
}

NSString *signWithKey(NSString *key ,NSString *data)
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    return [[HMAC.description stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//NSDictionary *getCollageConfigDic(NSInteger type)
//{
//    NSArray *nameArray = [[NSArray alloc]initWithObjects:
//                          @"Grid_01",
//                          @"Grid_02",
//                          @"Grid_03",
//                          @"Grid_04",
//                          @"Grid_05",
//                          @"Grid_06",
//                          @"Grid_07",
//                          @"Grid_08",
//                          @"Grid_09",
//                          @"Grid_10",
//                          
//                          nil];
//    //    NSDictionary *returnDic = [[NSDictionary alloc]init];
//    
//    
//    NSString *tempName = [nameArray objectAtIndex:type];
////    tempName = [[tempName componentsSeparatedByString:@"_"] objectAtIndex:1];
////    NSString *fileName = [NSString stringWithFormat:@"%@",tempName];
////    NSLog(@"fileName = %@",tempName);
//    
//    NSString *pathString = [[NSBundle mainBundle] pathForResource:tempName ofType:@"cfg"];
//    
//    if (pathString != nil)
//    {
//        NSData *data = [NSData dataWithContentsOfFile:pathString];
//        
//        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSDictionary *returnDic = [dataString objectFromJSONString];
//        //        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
//        //        returnDic = [tempDic objectForKey:@"progressConfig"];
////        NSLog(@"returnDic - %@",returnDic);
//        return returnDic;
//    }
//    
//    return nil;
//}

//NSDictionary *getEurFilterConfig()
//{
//    //    NSDictionary *returnDic = [[NSDictionary alloc]init];
//    NSArray *languageArray = [NSLocale preferredLanguages];
//    NSString *language = [languageArray objectAtIndex:0];
//    NSString *fileName = nil;
//    
//    if ([language rangeOfString:@"ja"].location != NSNotFound || [language rangeOfString:@"ko"].location != NSNotFound || [language rangeOfString:@"zh-Hans"].location != NSNotFound || [language rangeOfString:@"zh-Hant"].location != NSNotFound ) {
//        fileName = @"filterCfg1";
//    }else{
//        fileName = @"filterCfg2";
//    }
////    NSLog(@"fileName = %@",fileName);
//    
//    NSString *pathString = [[NSBundle mainBundle] pathForResource:fileName ofType:@"cfg"];
//    
//    if (pathString != nil)
//    {
//        NSData *data = [NSData dataWithContentsOfFile:pathString];
//        
//        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSDictionary *returnDic = [dataString objectFromJSONString];
//        //        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
//        //        returnDic = [tempDic objectForKey:@"progressConfig"];
////        NSLog(@"returnDic - %@",returnDic);
//        return returnDic;
//    }
//    
//    return nil;
//}

//NSArray *getFilterPreviewArray()
//{
//    //    NSDictionary *returnDic = [[NSDictionary alloc]init];
//    NSArray *languageArray = [NSLocale preferredLanguages];
//    NSString *language = [languageArray objectAtIndex:0];
//    NSString *fileName = nil;
//    
//    if ([language rangeOfString:@"ja"].location != NSNotFound || [language rangeOfString:@"ko"].location != NSNotFound || [language rangeOfString:@"zh-Hans"].location != NSNotFound || [language rangeOfString:@"zh-Hant"].location != NSNotFound ) {
//        fileName = @"filterPreviewCfg1";
//    }else{
//        fileName = @"filterPreviewCfg2";
//    }
////    NSLog(@"fileName = %@",fileName);
//    
//    NSString *pathString = [[NSBundle mainBundle] pathForResource:fileName ofType:@"cfg"];
//    
//    if (pathString != nil)
//    {
//        NSData *data = [NSData dataWithContentsOfFile:pathString];
//        
//        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSDictionary *dic = [dataString objectFromJSONString];
//        //        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
//        //        returnDic = [tempDic objectForKey:@"progressConfig"];
////        NSLog(@"dic - %@",dic);
//        NSArray *array = [dic objectForKey:@"filter_preview_configs"];
//        return array;
//    }
//    
//    return nil;
//}


//NSString *getHeaderData()
//{
//    NSString *ipString = getIPAddress();
//    NSLog(@"ip = %@",ipString);
//    NSString *signature = signWithKey(kClientSecret, ipString);
//    return signature;
//}
//
//NSString *getIPAddress()
//{
//    NSString *address = @"error";
//    struct ifaddrs *interfaces = NULL;
//    struct ifaddrs *temp_addr = NULL;
//    int success = 0;
//    
//    // retrieve the current interfaces - returns 0 on success
//    success = getifaddrs(&interfaces);
//    if (success == 0) {
//        // Loop through linked list of interfaces
//        temp_addr = interfaces;
//        while (temp_addr != NULL) {
//            if( temp_addr->ifa_addr->sa_family == AF_INET) {
//                // Check if interface is en0 which is the wifi connection on the iPhone
//                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
//                    // Get NSString from C String
//                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                }
//            }
//            
//            temp_addr = temp_addr->ifa_next;
//        }
//    }
//    
//    // Free memory
//    freeifaddrs(interfaces);
//    
//    return address;
//}

// MBProgressHUD *setProgressHudWithCustom()
//{
//    MBProgressHUD *progressHud = [[MBProgressHUD alloc] initWithFrame:CGRectMake(0, 0, setW(60), setW(60))];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iOS_Loading"]];
//    imageView.frame = CGRectMake(0, 0, setW(60), setW(60));
//    CABasicAnimation *rotateAni = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotateAni.toValue = @(M_PI * 2);
//    rotateAni.repeatCount = HUGE_VALF;
//    rotateAni.duration = 1.0f;
//    [imageView.layer addAnimation:rotateAni forKey:nil];
//    progressHud.customView = imageView;
//    progressHud.color = [UIColor clearColor];
//    progressHud.removeFromSuperViewOnHide = YES;
//    progressHud.mode = MBProgressHUDModeCustomView;
//    progressHud.yOffset = -(windowHeight() - (windowWidth() / 3.0f * 4.0f) )/ 2.0f ;
//    return progressHud;
//}

@end
