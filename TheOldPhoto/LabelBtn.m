//
//  LabelBtn.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/12/10.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "LabelBtn.h"

@interface LabelBtn()

@property (nonatomic, strong) UILabel *lLabel;
@property (nonatomic, strong) UILabel *lLabel2;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation LabelBtn

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
//    [self.titleLabel removeFromSuperview];;
    if (self.lLabel) {
        [self.lLabel removeFromSuperview];
    }
    self.lLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width * 3.5 / 5 - 5, self.frame.size.height - 5)];
    
    self.lLabel.text = LocalizedString(@"iap_all", nil);
    self.lLabel.textColor = colorWithHexString(@"#fdcf03");
    self.lLabel.textAlignment = NSTextAlignmentRight;
    self.lLabel.highlightedTextColor = colorWithHexString(@"#4d3f07");
    self.lLabel.adjustsFontSizeToFitWidth = YES;
    self.lLabel.minimumScaleFactor = 0.5;
    self.lLabel.font = [UIFont systemFontOfSize:15];
    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width * 3.5 / 5, 5, self.frame.size.width * 1.5 / 5, self.frame.size.height - 5)];
//    self.lLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.frame.size.width * 4 / 5 - 5, self.frame.size.height - 5)];
//    
//    self.lLabel2.text = LocalizedString(@"iap_all", nil);
//    self.lLabel2.textColor = colorWithHexString(@"#fdcf03");
//    self.lLabel2.textAlignment = NSTextAlignmentRight;
//    self.lLabel2.adjustsFontSizeToFitWidth = YES;
//    self.lLabel2.minimumScaleFactor = 0.5;


    self.rightLabel.text = [NSString stringWithFormat:@"- %@",LocalizedString(@"setting_off_50", nil)];
    self.rightLabel.textColor = colorWithHexString(@"#fa5745");
    self.rightLabel.highlightedTextColor = colorWithHexString(@"#8a2b25");
    self.rightLabel.textAlignment = NSTextAlignmentLeft;
    self.rightLabel.adjustsFontSizeToFitWidth = YES;
    self.rightLabel.minimumScaleFactor = 0.5;
    self.rightLabel.font = [UIFont systemFontOfSize:15];
    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    self.lineLabel.backgroundColor = colorWithHexString(@"#fdcf03");
    [self addSubview:self.lLabel];
//    [self addSubview:self.lLabel2];
    [self addSubview:self.rightLabel];
    [self addSubview:self.lineLabel];
    [self addTarget:self action:@selector(setLabelHighlighted:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(resetLabelHighlightedState:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(resetLabelHighlightedState:) forControlEvents:UIControlEventTouchUpOutside   ];
    [self addTarget:self action:@selector(resetLabelHighlightedState:) forControlEvents:UIControlEventTouchDragOutside   ];
}

- (void)setLabelHighlighted:(UIButton *)btn
{
    self.lLabel.highlighted = YES;
    self.rightLabel.highlighted = YES;
}

- (void)resetLabelHighlightedState:(UIButton *)btn
{
    self.lLabel.highlighted = NO;
    self.rightLabel.highlighted = NO;
}

- (void)setPurchasedBtnFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setTitle:LocalizedString(@"iap_purchased", nil) forState:UIControlStateNormal];
    self.titleLabel.textColor = colorWithHexString(@"#fdcf03");;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
    self.lineLabel.backgroundColor = colorWithHexString(@"#fdcf03");
    [self addSubview:self.lineLabel];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [super setTitleColor:color forState:state];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
