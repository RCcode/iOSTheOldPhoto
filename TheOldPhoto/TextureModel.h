//
//  TextureModel.h
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/11.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextureModel : NSObject
//@property (nonatomic, strong) UIImage *texture;
@property (nonatomic, copy) NSString *textureImageName;
@property (nonatomic, assign) NSUInteger filterType;
@property (nonatomic, assign) CGRect chromKeyRect;
@end
