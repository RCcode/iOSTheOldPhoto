//
//  PopUpADView.h
//  iOSFont
//
//  Created by wsq-wlq on 14-10-31.
//  Copyright (c) 2014年 wsq-wlq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RC_AppInfo.h"

@interface RC_PopUpADView : UIView

@property (nonatomic ,strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic ,strong) IBOutlet UIImageView *bannerImageView;
@property (nonatomic ,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic ,strong) IBOutlet UILabel *detailLabel;
@property (nonatomic ,strong) IBOutlet UIView *backView;

@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *detail;
@property (nonatomic ,strong) NSString *viewName;
@property (nonatomic ,strong) RC_AppInfo *appInfo;


- (void)setTitleColor:(UIColor *)titleColor;
- (void)setBackViewColor:(UIColor *)backgroundColor;


@end
