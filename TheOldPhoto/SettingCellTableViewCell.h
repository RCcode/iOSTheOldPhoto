//
//  SettingCellTableViewCell.h
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/25.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCellTableViewCell : UITableViewCell

@property (nonatomic, assign) id target;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target;
@end
