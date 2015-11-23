//
//  FC_FogFilterGroup.h
//  FilterCamera
//
//  Created by fuqingping on 14-11-19.
//  Copyright (c) 2014年 Chen.Liu. All rights reserved.
//

#import "GPUImageFilter.h"
#import "GPUImageTwoInputFilter.h"

@interface FC_FogFilterGroup : GPUImageTwoInputFilter
{
    NSMutableArray *filters;
}

@property(readwrite, nonatomic, strong) GPUImageOutput<GPUImageInput> *terminalFilter;
@property(readwrite, nonatomic, strong) NSArray *initialFilters;
@property(readwrite, nonatomic, strong) GPUImageOutput<GPUImageInput> *inputFilterToIgnoreForUpdates;

// Filter management
- (void)addFilter:(GPUImageOutput<GPUImageInput> *)newFilter;
- (GPUImageOutput<GPUImageInput> *)filterAtIndex:(NSUInteger)filterIndex;
- (NSUInteger)filterCount;

@end