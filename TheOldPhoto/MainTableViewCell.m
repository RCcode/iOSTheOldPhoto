//
//  MainTableViewCell.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/9.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "MainTableViewCell.h"
#import "SceneView.h"
#import "DataUtil.h"

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
@property (nonatomic, strong) UIButton *downloadBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) NSArray *iapArray;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSIndexPath *indexPath;
//@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation MainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target leftSelector:(SEL)lSelector middleSelector:(SEL)mSelector rightSelector:(SEL)rSelector downloadSelector:(SEL)downloadSelector buySelector:(SEL)buySelector
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self.iapArray = @[@"nowPack",@"1990packs",k1980sPack,k1960sPack,k1940sPack,kUnknowPack];
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
    
    self.downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downloadBtn.frame = CGRectMake(windowWidth() - 70 - 15, windowWidth() - 70 - 15, 36, 36);
    [self.downloadBtn setImage:[UIImage imageNamed:@"classify_unlock_normal"] forState:UIControlStateNormal];
    [self.downloadBtn setImage:[UIImage imageNamed:@"classify_unlock_pressed"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.downloadBtn];
    self.downloadBtn.alpha = 0;
//    self.progressView = [[UIProgressView alloc] initWithFrame:self.downloadBtn.frame];
//    [self.progressView setProgressViewStyle:UIProgressViewStyleDefault];
//    [self.contentView addSubview:self.progressView];
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = self.downloadBtn.frame;
    [self.buyBtn setImage:[UIImage imageNamed:@"classify_buy_normal"] forState:UIControlStateNormal];
    [self.buyBtn setImage:[UIImage imageNamed:@"classify_buy_pressed"] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.buyBtn];
    self.buyBtn.alpha = 0;
    
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.leftBtn setTitle:@"Album" forState:UIControlStateNormal];
    [self.leftBtn setFrame:CGRectMake(setW(39), frame.origin.y + frame.size.height + setH(90), 49, 60)];

    if (iPhone4()) {
        [self.leftBtn setFrame:CGRectMake(setW(39), frame.origin.y + frame.size.height + setH(35), 49, 60)];
    }
    
    self.leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.leftLabel.center = CGPointMake(self.leftBtn.center.x, self.leftBtn.center.y + 25 + 12);
    [self.leftLabel setText:LocalizedString(@"main_gallery", nil)];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.leftLabel];
    self.leftLabel.adjustsFontSizeToFitWidth = YES;
    self.leftLabel.minimumScaleFactor = 0.5;
//    if (isChinese()) {
        self.leftLabel.font = [UIFont systemFontOfSize:15];
//    }
    
    self.middleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.middleBtn setTitle:@"Camera" forState:UIControlStateNormal];
    [self.middleBtn setFrame:CGRectMake(width / 2 - self.leftBtn.frame.size.width / 2, self.leftBtn.frame.origin.y, 49, 60)];

    self.middleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.middleLabel.center = CGPointMake(self.middleBtn.center.x, self.middleBtn.center.y + 25 + 12);
    self.middleLabel.adjustsFontSizeToFitWidth = YES;
    self.middleLabel.minimumScaleFactor = 0.5;
    [self.middleLabel setText:LocalizedString(@"main_camera", nil)];
    self.middleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.middleLabel];
//    if (isChinese()) {
        self.middleLabel.font = [UIFont systemFontOfSize:15];
//    }

    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.rightBtn setTitle:@"Share" forState:UIControlStateNormal];
    [self.rightBtn setFrame:CGRectMake(width - self.leftBtn.frame.size.width - setW(38) , self.leftBtn.frame.origin.y, 49, 60)];

    self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
    self.rightLabel.center = CGPointMake(self.rightBtn.center.x, self.rightBtn.center.y + 25 + 12);
    self.rightLabel.adjustsFontSizeToFitWidth = YES;
    self.rightLabel.minimumScaleFactor = 0.5;
    [self.rightLabel setText:LocalizedString(@"main_share", nil)];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.rightLabel];
//    if (isChinese()) {
        self.rightLabel.font = [UIFont systemFontOfSize:15];
//    }
    
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.middleBtn];
    [self.contentView addSubview:self.rightBtn];
    
    self.arrow = [[ArrowUpView alloc] initWithFrame:CGRectMake(windowWidth() / 2 - 18 / 2, windowHeight() - 12 - 18, 19, 18)];
    [self.contentView addSubview:self.arrow];
    
    
}

- (void)setTarget:(id)target leftSeletor:(SEL)leftS middleSelector:(SEL)middleS rightSeletor:(SEL)rightS downloadSelector:(SEL)downloadSelector buySelector:(SEL)buySelector
{
    [self.leftBtn addTarget:target action:leftS forControlEvents:UIControlEventTouchUpInside];
    [self.middleBtn addTarget:target action:middleS forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:target action:rightS forControlEvents:UIControlEventTouchUpInside];
    [self.downloadBtn addTarget:target action:downloadSelector forControlEvents:UIControlEventTouchUpInside];
    [self.buyBtn addTarget:target action:buySelector forControlEvents:UIControlEventTouchUpInside];
}

- (void)setShowImages:(NSMutableArray *)array target:(id)target seletor:(SEL)seletor
{
    NSLog(@"array.count = %lu",(unsigned long)array.count);
    if (self.coverFlowView != nil) {
         [self.coverFlowView removeObserver:self forKeyPath:@"currentRenderingImageIndex"];
    }
    [self.coverFlowView removeFromSuperview];
    self.coverFlowView = [CoverFlowView coverFlowViewWithFrame:CGRectMake(0, statusBarHeight(), windowWidth(), windowWidth()) andImages:array sideImageCount:3  sideImageScale:setW(0.5) middleImageScale:setW(0.5) target:target selector:seletor];
    if (self.coverFlowView != nil) {
//
        [self.coverFlowView addObserver:self forKeyPath:@"currentRenderingImageIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
   
    self.coverFlowView.backgroundColor = [UIColor clearColor];
    self.coverFlowView.layer.masksToBounds = YES;
    //    self.mainImageView = [[UIImageView alloc] initWithFrame:self.scrollView.bounds];
    //    self.scrollView.bounces = YES;
    [self.contentView addSubview:self.coverFlowView];
    [self.contentView bringSubviewToFront:self.coverView];
    [self.contentView bringSubviewToFront:self.downloadBtn];
    [self.contentView bringSubviewToFront:self.buyBtn];
}

- (void)setDisplayImage:(UIImage *)image withIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index
{
    
    [self.displayView initFilterWithIndexPath:indexpath index:index oriImage:image];
    [[DataUtil defaultUtil].indexCfgArray removeObjectAtIndex:indexpath.row];
    [[DataUtil defaultUtil].indexCfgArray insertObject:[NSNumber numberWithInteger:index] atIndex:indexpath.row];
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
    self.categoryName = self.iapArray[indexpath.row];
    self.indexPath = indexpath;
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

- (void)disableGestureRecognizer
{
    self.displayView.swipe.enabled = NO;
}

- (void)enableGestureRecognizer
{
    self.displayView.swipe.enabled = YES;
}

- (UIImage *)getResultImage
{
    return [self.displayView getResultImage];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentRenderingImageIndex"]) {
           NSNumber *index = [self.coverFlowView valueForKey:keyPath];
        NSNumber *purAll = [[NSUserDefaults standardUserDefaults] objectForKey:kAllPacks];
        NSNumber *pur = [[NSUserDefaults standardUserDefaults] objectForKey:self.categoryName];
        if (self.indexPath.row <= 2) {
            self.downloadBtn.frame = CGRectMake(windowWidth() - 70 - 50, windowWidth() - 70 - 15, 36, 36);
            self.buyBtn.frame = CGRectMake(windowWidth() - 70 - 50, windowWidth() - 70 - 15, 36, 36);
        }else{
             self.downloadBtn.frame = CGRectMake(windowWidth() - 70 - 15, windowWidth() - 70 - 15, 36, 36);
            self.buyBtn.frame = CGRectMake(windowWidth() - 70 - 15, windowWidth() - 70 - 15, 36, 36);
        }
        
        if (![self.categoryName isEqualToString:@"1990packs"]) {
            if ((purAll.boolValue || pur.boolValue) ) {
                self.buyBtn.alpha = 0;
            }else{
                if (index.intValue > 7 ) {
                    self.buyBtn.alpha = 1;
                }else{
                    self.buyBtn.alpha = 0;
                }
            }
        }
        if (self.buyBtn.alpha == 0) {
            if (![self.displayView isDownloadFileWithIndexPath:self.indexPath andIndex:index.intValue]) {
                self.downloadBtn.alpha = 1;
            }else{
                self.downloadBtn.alpha = 0;
            }
        }else{
            self.downloadBtn.alpha = 0;
        }
        
        if (self.downloadBtn.alpha == 1) {
            self.coverFlowView.tapGestureRecognizer.enabled = NO;
        }else{
            if (self.buyBtn.alpha == 1) {
                self.coverFlowView.tapGestureRecognizer.enabled = NO;
            }else{
                self.coverFlowView.tapGestureRecognizer.enabled = YES;
            }
        }
//        if ([DataUtil defaultUtil].downloadingIndexpath.row == self.indexPath.row && [DataUtil defaultUtil].downloadingIndex == index.integerValue) {
//            if (self.downloadBtn.alpha == 1) {
//                self.progressView.alpha = 1;
//            }else{
//                self.progressView.alpha = 0;
//            }
//        }else{
//            if (self.downloadBtn.alpha == 1) {
//                self.downloadBtn.enabled = NO;
//            }else{
//                self.downloadBtn.enabled = YES;
//            }
//        }
    }
}

- (void)updateDownloadBtnWithIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index
{
    self.downloadBtn.alpha = 0;
    self.coverFlowView.tapGestureRecognizer.enabled = YES;
}

- (void)setCoverFlowCurrentIndex:(NSInteger)index
{
    self.coverFlowView.currentRenderingImageIndex = index;
}

//- (void)dealloc{
//    [self.coverFlowView removeObserver:self forKeyPath:@"currentRenderingImageIndex"];
////    [self.coverFlowView addObserver:self forKeyPath:@"currentRenderingImageIndex" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
//}

@end
