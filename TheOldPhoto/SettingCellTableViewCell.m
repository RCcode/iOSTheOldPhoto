//
//  SettingCellTableViewCell.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/25.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "SettingCellTableViewCell.h"
#import "SettingStoreViewController.h"
#import "AboutViewController.h"


@interface SettingCellTableViewCell ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic,strong) UIView *titleView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *imageNameArray;
@end

@implementation SettingCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier target:(id)target
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.target = target;
        [self initData];
        [self initView];
    }
    return self;
}

- (void)initData
{
    self.dataArray = @[LocalizedString(@"setting_store",nil),LocalizedString(@"setting_rate_us", nil),LocalizedString(@"setting_about_us", nil), LocalizedString(@"setting_feedback", nil),LocalizedString(@"setting_terms", nil),LocalizedString(@"setting_policy", nil),LocalizedString(@"setting_version", nil)];
    self.imageNameArray = @[@"setting_store",@"setting_rateus",@"setting_followus",@"setting_feedback",@"setting_terms",@"setting_privacy",@"setting_version"];
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth(), setH(44))];
    self.titleView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    NSString *titleString = [NSString stringWithFormat:@"·    %@    ·",LocalizedString(@"Setting", nil)];
    [label setText:titleString];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleView];
    [self.titleView addSubview:label];
    label.center = CGPointMake(windowWidth() / 2.f, setH(44) / 2.f);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, setH(44), windowWidth(), setH(44) * self.dataArray.count)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleView.frame.size.height, windowWidth(), 1)];
    line.backgroundColor = colorWithHexString(@"#b2b2b2");
    line.alpha = 0.3;
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:line];
    self.contentView.backgroundColor = colorWithHexString(@"f6f6f6");
    self.tableView.scrollEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            //商店
            SettingStoreViewController *store = [[SettingStoreViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:store];
            [self.target presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 1:
        {
            //评分
        }
            break;
        case 2:
        {
            //关于我们
            AboutViewController *about = [[AboutViewController alloc] init];
            
            [self.target presentViewController:about animated:YES completion:nil];
        }
            break;
        case 3:
        {
            //反馈
        }
            break;
        case 4:
        {
            //使用条款
        }
            break;
        case 5:
        {
            //隐私政策
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return setH(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cellIde";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    NSString *imageName = [self.imageNameArray objectAtIndex:indexPath.row];
    NSString *title = [self.dataArray objectAtIndex:indexPath.row];
    [cell.imageView setImage:[UIImage imageNamed:imageName]];
    cell.contentView.backgroundColor = colorWithHexString(@"#f6f6f6");
    cell.backgroundColor = colorWithHexString(@"#f6f6f6");
    cell.textLabel.text = title;
    if (indexPath.row != self.dataArray.count -1) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView.backgroundColor = colorWithHexString(@"#f6f6f6");
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

@end
