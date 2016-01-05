//
//  RateGuideView.m
//  BestMe
//
//  Created by MAXToooNG on 15/8/5.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "RateGuideView.h"
@interface RateGuideView()
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *alertView;
@end

@implementation RateGuideView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, windowWidth(), windowHeight())]) {
        self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        self.alertView = [[UIView alloc] initWithFrame:CGRectMake(setW(20), windowHeight() / 2 - setH(125) - setH(50), setW(280), setH(250))];
        [self addSubview:self.alertView];
        //        self.alertView.layer.masksToBounds = YES;
        [self.alertView.layer setCornerRadius:setW(8)];
        [self.alertView.layer setShadowColor:[UIColor lightGrayColor].CGColor];
        [self.alertView.layer setShadowOffset:CGSizeMake(0, 0)];
        [self.alertView.layer setShadowRadius:5];
        [self.alertView.layer setShadowOpacity:0.5];
        //        self.alertView.clipsToBounds = YES;
        [self initViews];
        //        self.userInteractionEnabled = YES;
        self.alertView.userInteractionEnabled = YES;
    }
    return self;
}

- (void)initViews
{
    self.alertView.backgroundColor = [UIColor whiteColor];
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake((setW(280) - setW(50)) / 2, setH(9), setW(50), setW(50))];
    //    logo.center = CGPointMake(self.frame.size.width / 2, logo.center.y - 5);
    logo.image = [UIImage imageNamed:@"love"];
    [self.alertView addSubview:logo];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(setW(24), setH(63), setW(232), setH(30))];
    titleLabel.text = LocalizedString(@"title_like", nil);
    titleLabel.textColor = colorWithHexString(@"#9d874e");
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.3;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 2;
    titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:setW(16)];
    [self.alertView addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, setH(80), setW(270) - 10, setH(60))];
    contentLabel.text = LocalizedString(@"title_rate_five", nil);
    contentLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:setW(15)];
    if (isChinese()) {
        contentLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:setH(15)];
    }
    contentLabel.textColor = colorWithHexString(@"#949494");
    contentLabel.numberOfLines = 2;
    contentLabel.adjustsFontSizeToFitWidth = YES;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.minimumScaleFactor = 0.5;
    [self.alertView addSubview:contentLabel];
    
    UIImageView *starView = [[UIImageView alloc] initWithFrame:CGRectMake(setW(21), self.alertView.bounds.size.height - setH(70 + 44), setW(240), setH(48))];
    starView.image = [UIImage imageNamed:@"StarAera"];
    
    [self.alertView addSubview:starView];
    
    self.leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.leftButton setFrame:CGRectMake(0, self.alertView.bounds.size.height - setH(44), setW(140), setH(44))];
    [self.leftButton setBackgroundColor:colorWithHexString(@"#999999")];
    [self.leftButton setTitle:LocalizedString(@"title_remind", nil) forState:UIControlStateNormal];
    [self.leftButton setTitleColor:colorWithHexString(@"#b2b2b2") forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:setW(15)];
    self.leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.leftButton.titleLabel.minimumScaleFactor = 0.5f;
    [self.leftButton addTarget:self.target action:@selector(cancelEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.leftButton addTarget:self action:@selector(removeAlert) forControlEvents:UIControlEventTouchUpInside];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.leftButton.bounds byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.leftButton.bounds;
    maskLayer.path = maskPath.CGPath;
    self.leftButton.layer.mask = maskLayer;
    [self.alertView addSubview:self.leftButton];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.rightButton setFrame:CGRectMake(setW(140), self.alertView.bounds.size.height - setH(44), setW(140), setH(44))];
    self.rightButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:setW(15)];
    self.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.rightButton.titleLabel.minimumScaleFactor = 0.5;
    [self.rightButton setBackgroundColor:colorWithHexString(@"#ffa726")];
    [self.rightButton setTitle:LocalizedString(@"setting_rate_us", nil) forState:UIControlStateNormal];
    [self.rightButton setTitleColor:colorWithHexString(@"#ffffff") forState:UIControlStateNormal];
    UIBezierPath *maskPathR = [UIBezierPath bezierPathWithRoundedRect:self.rightButton.bounds byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayerR = [[CAShapeLayer alloc] init];
    maskLayerR.frame = self.rightButton.bounds;
    maskLayerR.path = maskPathR.CGPath;
    self.rightButton.layer.mask = maskLayerR;
    //    [self.rightButton addTarget:self.target action:@selector(rateNowEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(rateApp) forControlEvents:UIControlEventTouchUpInside];
    [self.alertView addSubview:self.rightButton];
    
    UIImageView *hand = [[UIImageView alloc] initWithFrame:CGRectMake(self.alertView.bounds.size.width - setW(52), starView.frame.origin.y + starView.frame.size.height / 2 - setH(3), setW(31), setH(41))];
    hand.image = [UIImage imageNamed:@"Hand"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @0.8f;
    animation.toValue = @1.2f;
    animation.beginTime = 0.0;
    animation.duration = 0.5;
    
    animation.removedOnCompletion = NO;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    [hand.layer addAnimation:animation forKey:nil];
    [self.alertView addSubview:hand];
}

- (void)removeAlert
{
    [self removeFromSuperview];
}

- (void)rateApp
{
    [[NSUserDefaults standardUserDefaults] setValue:@YES forKey:kRateUserDefaultKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreScoreURL]];
    [self removeFromSuperview];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
