//
//  StickerUtil.h
//  BestMe
//
//  Created by MAXToooNG on 15/9/2.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtil : NSObject

@property (nonatomic, assign) BOOL is3_4;
@property (nonatomic, strong) NSMutableArray *indexCfgArray;
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic, assign) NSInteger downloadingIndex;
@property (nonatomic, strong) NSIndexPath *downloadingIndexpath;
@property (nonatomic, strong) NSIndexPath *validIndexPath;
@property (nonatomic, assign) NSInteger validIndex;

+ (DataUtil *)defaultUtil;


@end
