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
@interface SceneView : UIView

- (instancetype)initWithFrame:(CGRect)frame oriImage:(UIImage *)oriImage andIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index ;

- (void)initFilterWithIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index oriImage:(UIImage *)image;

- (CropStyle)cropStyleWithIndexPath:(NSIndexPath *)indexpatn index:(NSInteger)index;
//- (BOOL)isWidthLongerThanHeight:(NCFilterType)index;

- (void)resetPreviewFrame;

@end
