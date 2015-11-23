//
//  ImageEditViewController.h
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/18.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenshotBorderView.h"

@protocol ImageEditDelegate <NSObject>

- (void)imageEditResultImage:(UIImage *)image;

@end

@interface ImageEditViewController : UIViewController

@property (nonatomic, strong) UIImage *srcImage;
@property (nonatomic, assign) CropStyle style;
@property (nonatomic, assign) id<ImageEditDelegate> delegate;

@end
