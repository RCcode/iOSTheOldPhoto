//
//  MainTableViewCell.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/9.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "MainTableViewCell.h"
#import "SceneView.h"

@interface MainTableViewCell ()

@property (nonatomic, strong) UIImageView *mainImageView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) NSArray *gesArr;
@property (nonatomic, strong) SceneView *displayView;
@property (nonatomic, strong) UIImageView *shadowView;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UIButton *unlockBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target leftSelector:(SEL)lSelector middleSelector:(SEL)mSelector rightSelector:(SEL)rSelector downloadSelector:(SEL)downloadSelector buySelector:(SEL)buySelector
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self setTarget:target leftSeletor:lSelector middleSelector:mSelector rightSeletor:rSelector downloadSelector:downloadSelector buySelector:buySelector];
    }
    return self;
}

- (void)initView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat width = window.bounds.size.width;
    CGRect frame = CGRectMake(0, statusBarHeight(), windowWidth(), windowWidth());
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, windowWidth(), windowWidth())];
    self.backgroundImage.image = [UIImage imageNamed:@"classify_bg"];
    self.backgroundImage.userInteractionEnabled = YES;
    [self.contentView addSubview:self.backgroundImage];
    self.coverView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, windowWidth(), windowWidth())];
    self.coverView.image = [UIImage imageNamed:@"classify_shadow"];
    [self.contentView addSubview:self.coverView];
    self.displayView = [[SceneView alloc] initWithFrame:CGRectMake(0, 0, windowWidth(), windowWidth())];
//    self.displayView.backgroundColor = [UIColor brownColor];
    [self addSubview:self.displayView];
    
    self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.origin.y + frame.size.height + 11, windowWidth(), 12)];
//    self.titleImageView.backgroundColor = [UIColor cyanColor];
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.titleImageView];
    
    self.shadowView = [[UIImageView alloc]initWithFrame:CGRectMake(0, frame.origin.y + frame.size.height, windowWidth(), 9)];
    self.shadowView.image = [UIImage imageNamed:@"home_shadow_all"];
    [self.contentView addSubview:self.shadowView];
    
    self.unlockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unlockBtn.frame = CGRectMake(windowWidth() - 70 - 8, windowWidth() - 70 - 8, 36, 36);
    [self.unlockBtn setImage:[UIImage imageNamed:@"classify_unlock_normal"] forState:UIControlStateNormal];
    [self.unlockBtn setImage:[UIImage imageNamed:@"classify_unlock_pressed"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.unlockBtn];
    self.unlockBtn.alpha = 0;
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = self.unlockBtn.frame;
    [self.buyBtn setImage:[UIImage imageNamed:@"classify_buy_normal"] forState:UIControlStateNormal];
    [self.buyBtn setImage:[UIImage imageNamed:@"classify_buy_pressed"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.buyBtn];
//    self.buyBtn.alpha = 0;
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.leftBtn setTitle:@"Album" forState:UIControlStateNormal];
    [self.leftBtn setFrame:CGRectMake(setW(39), frame.origin.y + frame.size.height + setH(90), 49, 49)];
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.leftLabel.center = CGPointMake(self.leftBtn.center.x, self.leftBtn.center.y + 25 + 12);
    [self.leftLabel setText:LocalizedString(@"main_gallery", nil)];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.leftLabel];
    
    self.middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.middleBtn setTitle:@"Camera" forState:UIControlStateNormal];
    [self.middleBtn setFrame:CGRectMake(width / 2 - self.leftBtn.frame.size.width / 2, self.leftBtn.frame.origin.y, 49, 49)];
    self.middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.middleLabel.center = CGPointMake(self.middleBtn.center.x, self.middleBtn.center.y + 25 + 12);
    [self.middleLabel setText:LocalizedString(@"main_camera", nil)];
    self.middleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.middleLabel];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.rightBtn setTitle:@"Share" forState:UIControlStateNormal];
    [self.rightBtn setFrame:CGRectMake(width - self.leftBtn.frame.size.width - setW(38) , self.leftBtn.frame.origin.y, 49, 49)];
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.rightLabel.center = CGPointMake(self.rightBtn.center.x, self.rightBtn.center.y + 25 + 12);
    [self.rightLabel setText:LocalizedString(@"main_share", nil)];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rightLabel];
    
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.middleBtn];
    [self.contentView addSubview:self.rightBtn];
    
}

- (void)setTarget:(id)target leftSeletor:(SEL)leftS middleSelector:(SEL)middleS rightSeletor:(SEL)rightS downloadSelector:(SEL)downloadSelector buySelector:(SEL)buySelector
{
    [self.leftBtn addTarget:target action:leftS forControlEvents:UIControlEventTouchUpInside];
    [self.middleBtn addTarget:target action:middleS forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:target action:rightS forControlEvents:UIControlEventTouchUpInside];
    [self.unlockBtn addTarget:target action:downloadSelector forControlEvents:UIControlEventTouchUpInside];
    [self.buyBtn addTarget:target action:buySelector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setShowImages:(NSMutableArray *)array target:(id)target seletor:(SEL)seletor
{
    NSLog(@"array.count = %lu",(unsigned long)array.count);
    [self.coverFlowView removeFromSuperview];
    self.coverFlowView = [CoverFlowView coverFlowViewWithFrame:CGRectMake(0, statusBarHeight(), windowWidth(), windowWidth()) andImages:array sideImageCount:3  sideImageScale:0.4 middleImageScale:0.6 target:target selector:seletor];
    
    self.coverFlowView.backgroundColor = [UIColor clearColor];
    self.coverFlowView.layer.masksToBounds = YES;
    //    self.mainImageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    //    self.scrollView.bounces = YES;
    [self.contentView addSubview:self.coverFlowView];
    [self.contentView bringSubviewToFront:self.coverView];
    [self.contentView bringSubviewToFront:self.buyBtn];
    [self.contentView bringSubviewToFront:self.unlockBtn];
}

- (void)setDisplayImage:(UIImage *)image withIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index
{
    [self.displayView initFilterWithIndexPath:indexpath index:index oriImage:image];
//    [self.displayView initFilterWithType:type oriImage:displayImage];
}

- (void)setDisplayImage:(UIImage *)image
{
    [self.displayView setDisplayImage:image];
}

- (void)resetDisplayView
{
    NSLog(@"reset");
    [self.displayView resetPreviewFrame];
}

- (void)setLeftImageName:(NSString *)lImage middleImageName:(NSString *)mImage rightImageName:(NSString *)rImage
{
    [self.leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",lImage]] forState:UIControlStateNormal];
    [self.middleBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",mImage]] forState:UIControlStateNormal];
    [self.rightBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",rImage]] forState:UIControlStateNormal];
    
    [self.leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",lImage]] forState:UIControlStateHighlighted];
    [self.middleBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",mImage]] forState:UIControlStateHighlighted];
    [self.rightBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_pressed",rImage]] forState:UIControlStateHighlighted];
}

- (void)setTitleImage:(UIImage *)image
{
    self.titleImageView.image = image;
}

- (CropStyle)cropStyleWithIndexpath:(NSIndexPath *)indexpath index:(NSInteger)index
{
    return [self.displayView cropStyleWithIndexPath:indexpath index:index];
//    return [self.displayView isWidthLongerThanHeight:type];
}

- (BOOL)isCurrentModel
{
    if (self.displayView.frame.origin.x < 0) {
        return NO;
    }else{
        return YES;
    }
    
}

@end
