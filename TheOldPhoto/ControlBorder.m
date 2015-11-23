//
//  ControlBorder.m
//  IOSNoCrop
//
//  Created by rcplatform on 5/5/14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "ControlBorder.h"



@implementation ControlBorder

+ (instancetype)controlBorder{
    return [[[NSBundle mainBundle] loadNibNamed:@"ControlBorder" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib{
    //清除背景色
    
    UIColor *clearColor = [UIColor clearColor];

    self.backgroundColor = clearColor;
    _leftUpBox.backgroundColor = clearColor;
    _leftDownBox.backgroundColor = clearColor;
    _rightUpBox.backgroundColor = clearColor;
    _rightDownBox.backgroundColor = clearColor;
    
    _topLine.backgroundColor = clearColor;
    _buttomLine.backgroundColor = clearColor;
    _leftLine.backgroundColor = clearColor;
    _rightLine.backgroundColor = clearColor;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if([_delegate respondsToSelector:@selector(controlBorder:MoveBeginWithTouch:)]){
        [_delegate controlBorder:self MoveBeginWithTouch:[touches anyObject]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if([_delegate respondsToSelector:@selector(controlBorder:MovedWithTouch:)]){
        [_delegate controlBorder:self MovedWithTouch:[touches anyObject]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if([_delegate respondsToSelector:@selector(controlBorderMoveEnd:)]){
        [_delegate controlBorderMoveEnd:self];
    }
}

@end
