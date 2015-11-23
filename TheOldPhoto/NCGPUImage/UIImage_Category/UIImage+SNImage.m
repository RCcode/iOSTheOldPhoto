//
//  UIImage+SNImage.m
//  BestMe
//
//  Created by MAXToooNG on 15/7/17.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "UIImage+SNImage.h"

@implementation UIImage (SNImage)
/**
 *  从加密图片获取图片
 *
 *  @param imageName 图片名字
 *
 *  @return 图片
 */
+(UIImage*)imageInSnWithName:(NSString*)imageName
{
    //获取加密文件路径
    NSLog(@"imageName = %@",imageName);
    
    NSString *imDataStr = [[NSBundle mainBundle] pathForResource:imageName ofType:@"rc"];
    NSLog(@"imDataStr = %@",imDataStr);
    //加密文件转成NSData
    NSData *imageData = [NSData dataWithContentsOfFile: imDataStr ];
    //密码文件
    NSData *sn = [kImageSN dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger pre = sn.length;
    NSUInteger total = imageData.length;
    NSRange range = {pre , total-pre};
    //除去加密文件
    NSData *imData = [imageData subdataWithRange:range];
    //生成可使用的图片资源
    UIImage *image = [[UIImage alloc]initWithData:imData];
    
    return image;
}
@end
