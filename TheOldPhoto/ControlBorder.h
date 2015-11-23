//
//  ControlBorder.h
//  IOSNoCrop
//
//  Created by rcplatform on 5/5/14.
//  Copyright (c) 2014年 rcplatformhk. All rights reserved.
//

#import "CornerView.h"

@interface ControlBorder : UIView

@property (weak, nonatomic) IBOutlet CornerView *topLine;
@property (weak, nonatomic) IBOutlet CornerView *buttomLine;
@property (weak, nonatomic) IBOutlet CornerView *leftLine;
@property (weak, nonatomic) IBOutlet CornerView *rightLine;
@property (weak, nonatomic) IBOutlet CornerView *leftUpBox;
@property (weak, nonatomic) IBOutlet CornerView *leftDownBox;
@property (weak, nonatomic) IBOutlet CornerView *rightUpBox;
@property (weak, nonatomic) IBOutlet CornerView *rightDownBox;



@property (nonatomic, weak) id<ControlBorderDelegate> delegate;

+ (instancetype)controlBorder;

@end
