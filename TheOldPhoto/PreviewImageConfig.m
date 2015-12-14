//
//  PreviewImageConfig.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/9.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "PreviewImageConfig.h"

@implementation PreviewImageConfig

+ (NSMutableArray *)getScrollViewArrayWithIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *imageNameArray = [[NSMutableArray alloc] init];
    switch (indexPath.row) {
        case 0:
        {
             [imageNameArray addObject:@"default3_4.jpg"];
        }
            break;
        case 1:
        {
            for (int i = 0; i < 17; i++) {
                NSString *imageName = [NSString stringWithFormat:@"scene1_%d.jpg",i];
                [imageNameArray addObject:imageName];
            }
        }
            break;
        case 2:
        {
            for (int i = 0; i < 14; i++) {
                NSString *imageName = [NSString stringWithFormat:@"scene2_%d.jpg",i];
                [imageNameArray addObject:imageName];
            }
           
        }
            break;
        case 3:
        {
            for (int i = 0 ; i < 16 ; i++) {
                NSString *imageName = [NSString stringWithFormat:@"scene3_%d.jpg",i];
                [imageNameArray addObject:imageName];
            }
//            return [imageNameArray mutableCopy];
        }
            break;
        case 4:
        {
            for (int i = 0 ; i < 18 ; i++) {
                NSString *imageName = [NSString stringWithFormat:@"scene4_%d.jpg",i];
                [imageNameArray addObject:imageName];
            }
        }
            break;
        case 5:
        {
            for (int i = 0 ; i < 16 ; i++) {
                NSString *imageName = [NSString stringWithFormat:@"scene5_%d.jpg",i];
                [imageNameArray addObject:imageName];
            }
        }
            break;
        default:
        {
            [imageNameArray addObject:@"demo5.jpg"];
        }
            break;
    }
    return [imageNameArray mutableCopy];
}

@end
