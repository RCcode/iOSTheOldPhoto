//
//  ArrowLeftView.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/12/11.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "ArrowLeftView.h"

@implementation ArrowLeftView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 18, 19)]) {
        //        [self initView];
        [self setAnimation];
    }
    return self;
}

- (void)initView{
    self.arrowViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, self.frame.size.height)];
    self.arrowViewRight = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 10, self.frame.size.height)];
    UIImage *image = [UIImage imageNamed:@"home_arrow_left"];
    self.arrowViewLeft.image = image;
    self.arrowViewRight.image = image;
    [self addSubview:self.arrowViewLeft];
    [self addSubview:self.arrowViewRight];
}

- (void)setAnimation
{
    [self.arrowViewLeft removeFromSuperview];
    [self.arrowViewRight removeFromSuperview];
    self.arrowViewLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, self.frame.size.height)];
    self.arrowViewRight = [[UIImageView alloc] initWithFrame:CGRectMake(8, 0, 10, self.frame.size.height)];
    UIImage *image = [UIImage imageNamed:@"home_arrow_left"];
    self.arrowViewLeft.image = image;
    self.arrowViewRight.image = image;
    [self addSubview:self.arrowViewLeft];
    [self addSubview:self.arrowViewRight];
    [self.arrowViewLeft.layer removeAllAnimations];
    [self.arrowViewRight.layer removeAllAnimations];
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = 1.08;
    scale.fromValue = @1.20f;
    scale.removedOnCompletion = NO;
    scale.toValue = @1.0f;
    //    scale.fillMode = kCAFillModeForwards;
    CABasicAnimation *alpha = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha.duration = 1.08;
    alpha.fromValue = @1.f;
    alpha.toValue = @0.f;
    alpha.removedOnCompletion = NO;
    //    alpha.fillMode = kCAFillModeForwards;
    CABasicAnimation *alpha2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha2.duration = 0.56f;
    alpha2.fromValue = @0.0f;
    alpha2.toValue = @1.0f;
    alpha2.beginTime = 1.08f;
    CABasicAnimation *scale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale2.duration = 0.56f;
    scale2.fromValue = @1.0f;
    scale2.removedOnCompletion = NO;
    scale2.toValue = @1.20f;
    //    scale.fillMode = kCAFillModeForwards;
    scale2.beginTime = 1.08f;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 1.64f;
    group.animations = @[scale,alpha,scale2,alpha2];
    group.repeatCount = HUGE_VAL;
    //    [self.filterNameLabel.layer addAnimation:group forKey:nil];
    [self.arrowViewRight.layer addAnimation:group forKey:nil];
    
    CABasicAnimation *scaleUp = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleUp.duration = 1.08;
    scaleUp.fromValue = @1.0;
    scaleUp.removedOnCompletion = NO;
    scaleUp.toValue = @1.20f;
    scaleUp.fillMode = kCAFillModeForwards;
    //    scaleUp.repeatCount = HUGE_VAL;
    CABasicAnimation *alphaUp = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaUp.duration = 1.08;
    alphaUp.fromValue = @0.f;
    alphaUp.toValue = @1.f;
    alphaUp.removedOnCompletion = NO;
    alphaUp.fillMode = kCAFillModeForwards;
    CABasicAnimation *alphaUp2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaUp2.duration = 0.56f;
    alphaUp2.fromValue = @1.0f;
    alphaUp2.toValue = @0.0f;
    alphaUp2.beginTime = 1.08f;
    CABasicAnimation *scaleUp2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleUp2.duration = 0.56f;
    scaleUp2.fromValue = @1.20f;
    scaleUp2.removedOnCompletion = NO;
    scaleUp2.toValue = @1.0f;
    scaleUp2.beginTime = 1.08f;
    //    scale.fillMode = kCAFillModeForwards;
    CAAnimationGroup *groupUp = [CAAnimationGroup animation];
    groupUp.beginTime = 0.0f;
    groupUp.duration = 1.64f;
    groupUp.animations = @[scaleUp,alphaUp,scaleUp2,alphaUp2];
    groupUp.repeatCount = HUGE_VAL;
    //    [self.filterNameLabel.layer addAnimation:group forKey:nil];
    [self.arrowViewLeft.layer addAnimation:groupUp forKey:nil];
}


@end
