//
//  SceneModel.h
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/11.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SceneModel : NSObject

//@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, copy) NSString *backgroundImageName;
@property (nonatomic, assign) CGPoint imageCenter;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGPoint frameCenter;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;
@property (nonatomic, assign) CGFloat frameAngle;
//@property (nonatomic, strong) UIImage *frameImage;
//@property (nonatomic, strong) UIImage *noisyImage;
@property (nonatomic, assign) CGFloat blurValue;
//@property (nonatomic, strong) UIImage *lookupImage;
@property (nonatomic, copy) NSString *lookupImageName;
@property (nonatomic, strong) NSMutableArray *textureConfigArray;
@property (nonatomic, copy) NSString *acvFilterName;

@end
