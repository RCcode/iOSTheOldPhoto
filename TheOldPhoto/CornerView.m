//
//  Corner.m
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//

#import "CornerView.h"


@implementation CornerView


#pragma mark - touch相关方法

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if([_delegate respondsToSelector:@selector(corner:TouchesBegin:)]){
        [_delegate corner:self TouchesBegin:[touches anyObject]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    if([_delegate respondsToSelector:@selector(corner:TouchesMoved:)]){
        [_delegate corner:self TouchesMoved:[touches anyObject]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

    if([_delegate respondsToSelector:@selector(corner:TouchesEnd:)]){
        [_delegate corner:self TouchesEnd:[touches anyObject]];
    }
}

@end
