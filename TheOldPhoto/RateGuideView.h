//
//  RateGuideView.h
//  BestMe
//
//  Created by MAXToooNG on 15/8/5.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RateGuideView : UIView
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL cancelEvent;
@property (nonatomic, assign) SEL rateNowEvent;
- (id)initWithFrame:(CGRect)frame;

@end
