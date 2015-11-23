//
//  MainTableViewCell.h
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/9.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoverFlowView.h"
#import "NCFilters.h"

@interface MainTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *middleBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) CoverFlowView *coverFlowView;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target leftSelector:(SEL)lSelector middleSelector:(SEL)mSelector rightSelector:(SEL)rSelector;

- (void)setTitleImage:(UIImage *)image;

- (void)setShowImages:(NSMutableArray *)array target:(id)target seletor:(SEL)seletor;

- (void)setLeftImage:(UIImage *)lImage middleImage:(UIImage *)mImage rightImage:(UIImage *)rImage;

- (void)setDisplayImage:(UIImage *)Image withSceneType:(NCFilterType)type;

@end
