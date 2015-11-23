//
//  SceneView.h
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/20.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NCFilters.h"
@interface SceneView : UIView

- (instancetype)initWithFrame:(CGRect)frame oriImage:(UIImage *)oriImage andSceneType:(NCFilterType)type ;

@end
