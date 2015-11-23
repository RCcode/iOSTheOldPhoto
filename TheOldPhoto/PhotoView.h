//
//  PhotoView.h
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/17.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoView : UIView

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setImage:(UIImage *)image andSceneType:(NSUInteger)type;

@end
