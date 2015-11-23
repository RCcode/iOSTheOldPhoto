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
@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target leftSelector:(SEL)lSelector middleSelector:(SEL)mSelector rightSelector:(SEL)rSelector
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self setTarget:target leftSeletor:lSelector middleSelector:mSelector rightSeletor:rSelector];
    }
    return self;
}

- (void)initView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CGFloat width = window.bounds.size.width;
    CGRect frame = CGRectMake(0, statusBarHeight(), windowWidth(), windowWidth());
//    self.coverFlowView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleLabel.frame.size.height + self.titleLabel.frame.origin.y, width, width)];
    self.titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.origin.y + frame.size.height, windowWidth(), 44)];
    self.titleImageView.backgroundColor = [UIColor cyanColor];
    self.titleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.titleImageView];
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.leftBtn setTitle:@"Album" forState:UIControlStateNormal];
    [self.leftBtn setFrame:CGRectMake(50, frame.origin.y + frame.size.height + 50 + 44, 80, 30)];
    
    self.middleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.middleBtn setTitle:@"Camera" forState:UIControlStateNormal];
    [self.middleBtn setFrame:CGRectMake(width / 2 - self.leftBtn.frame.size.width / 2, self.leftBtn.frame.origin.y, 80, 30)];
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.rightBtn setTitle:@"Share" forState:UIControlStateNormal];
    [self.rightBtn setFrame:CGRectMake(width - self.leftBtn.frame.size.width - 50, self.leftBtn.frame.origin.y, 80, 30)];
    
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.middleBtn];
    [self.contentView addSubview:self.rightBtn];
    
}

- (void)setTarget:(id)target leftSeletor:(SEL)leftS middleSelector:(SEL)middleS rightSeletor:(SEL)rightS
{
    [self.leftBtn addTarget:target action:leftS forControlEvents:UIControlEventTouchUpInside];
    [self.middleBtn addTarget:target action:middleS forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:target action:rightS forControlEvents:UIControlEventTouchUpInside];
}

- (void)setShowImages:(NSMutableArray *)array target:(id)target seletor:(SEL)seletor
{
    NSLog(@"array.count = %lu",(unsigned long)array.count);
    [self.coverFlowView removeFromSuperview];
    self.coverFlowView = [CoverFlowView coverFlowViewWithFrame:CGRectMake(0, statusBarHeight(), windowWidth(), windowWidth()) andImages:array sideImageCount:3  sideImageScale:0.4 middleImageScale:0.6 target:target selector:seletor];
    
    self.coverFlowView.backgroundColor = [UIColor blackColor];
    self.coverFlowView.layer.masksToBounds = YES;
    //    self.mainImageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    //    self.scrollView.bounces = YES;
    [self.contentView addSubview:self.coverFlowView];
}

- (void)setDisplayImage:(UIImage *)Image withSceneType:(NCFilterType)type
{
    
}

- (void)setLeftImage:(UIImage *)lImage middleImage:(UIImage *)mImage rightImage:(UIImage *)rImage
{
    [self.leftBtn setImage:lImage forState:UIControlStateNormal];
    [self.middleBtn setImage:mImage forState:UIControlStateNormal];
    [self.rightBtn setImage:rImage forState:UIControlStateNormal];
}

- (void)setTitleImage:(UIImage *)image
{
    self.titleImageView.image = image;
}

@end
