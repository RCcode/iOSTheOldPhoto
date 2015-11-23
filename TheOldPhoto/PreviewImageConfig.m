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
    switch (indexPath.row) {
        case 0:
        {
            return [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"],[UIImage imageNamed:@"demo4.jpg"],[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"], nil];
            
        }
            break;
        case 1:
        {
            return [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"demo1.jpg.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"],[UIImage imageNamed:@"demo4.jpg"],[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"], nil];
        }
            break;
        case 2:
        {
            return [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"],[UIImage imageNamed:@"demo4.jpg"],[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"], nil];
        }
            break;
        case 3:
        {
            return [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"],[UIImage imageNamed:@"demo4.jpg"],[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"], nil];
        }
            break;
        case 4:
        {
            return [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"],[UIImage imageNamed:@"demo4.jpg"],[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"], nil];
        }
            break;
        default:
        {
            return [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"],[UIImage imageNamed:@"demo4.jpg"],[UIImage imageNamed:@"demo1.jpg"],[UIImage imageNamed:@"demo2.jpg"],[UIImage imageNamed:@"demo3.jpg"], nil];
        }
            break;
    }
    return nil;
}

@end
