//
//  SceneView.h
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/20.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCFilters.h"
#import "ScreenshotBorderView.h"
#import "ArrowLeftView.h"
@interface SceneView : UIView

@property (nonatomic, strong) UISwipeGestureRecognizer *swipe;

- (instancetype)initWithFrame:(CGRect)frame oriImage:(UIImage *)oriImage andIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index ;

- (void)initFilterWithIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index oriImage:(UIImage *)image;

- (CropStyle)cropStyleWithIndexPath:(NSIndexPath *)indexpatn index:(NSInteger)index;
//- (BOOL)isWidthLongerThanHeight:(NCFilterType)index;

- (void)setDisplayImage:(UIImage *)image;

- (void)resetPreviewFrame;

- (UIImage *)getResultImage;

- (BOOL)isDownloadFileWithIndexPath:(NSIndexPath *)indexpath andIndex:(int)index;
@property (nonatomic, strong) ArrowLeftView *arrow;
@end
