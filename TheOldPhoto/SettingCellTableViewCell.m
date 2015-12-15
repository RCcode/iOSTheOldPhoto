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
#import <MessageUI/MessageUI.h>
#import "HelpViewController.h"

@interface SettingCellTableViewCell ()<UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>
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
    self.dataArray = @[LocalizedString(@"setting_store",nil),LocalizedString(@"setting_rate_us", nil),LocalizedString(@"setting_about", nil), LocalizedString(@"setting_feedback", nil),LocalizedString(@"setting_terms", nil),LocalizedString(@"setting_policy", nil),LocalizedString(@"setting_version", nil)];
    self.imageNameArray = @[@"setting_store",@"setting_rateus",@"setting_followus",@"setting_feedback",@"setting_terms",@"setting_privacy",@"setting_version"];
}

- (void)initView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowWidth(), 44)];
    self.titleView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    NSString *titleString = [NSString stringWithFormat:@"·    %@    ·",LocalizedString(@"setting_setting", nil)];
    [label setText:titleString];
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleView];
    [self.titleView addSubview:label];
    label.center = CGPointMake(windowWidth() / 2.f, self.titleView.frame.size.height / 2.f);
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, windowWidth(), 44 * self.dataArray.count)];
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
            store.isPush = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:store];
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            //            animation.type = @"rippleEffect";
            animation.type = kCATransitionPush;
            animation.subtype = kCATransitionFromRight;
            [self.window.layer addAnimation:animation forKey:nil];
            [self.target presentViewController:nav animated:NO completion:nil];
        }
            break;
        case 1:
        {
            //评分
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreScoreURL]];
        }
            break;
        case 2:
        {
            //关于我们
            AboutViewController *about = [[AboutViewController alloc] init];
            CATransition *animation = [CATransition animation];
            animation.duration = 0.3;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//            animation.type = @"rippleEffect";
            animation.type = kCATransitionMoveIn;
            animation.subtype = kCATransitionFromRight;
            [self.window.layer addAnimation:animation forKey:nil];
//            [self presentModalViewController:myNextViewController animated:NO completion:nil];
            [self.target presentViewController:about animated:NO completion:nil];
        }
            break;
        case 3:
        {
            //反馈
            // app名称 版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            
            //设备型号 系统版本
            NSString *deviceName = doDevicePlatform();
            NSString *deviceSystemName = [[UIDevice currentDevice] systemName];
            NSString *deviceSystemVer = [[UIDevice currentDevice] systemVersion];
            
            //设备分辨率
            //            CGFloat scale = [UIScreen mainScreen].scale;
            //            CGFloat resolutionW = [UIScreen mainScreen].bounds.size.width * scale;
            //            CGFloat resolutionH = [UIScreen mainScreen].bounds.size.height * scale;
            //            NSString *resolution = [NSString stringWithFormat:@"%.f * %.f", resolutionW, resolutionH];
            
            //本地语言
            NSString *language = [[NSLocale preferredLanguages] firstObject];

            //            NSString *diveceInfo = @"app版本号 手机型号 手机系统版本 语言";
            NSString *diveceInfo = [NSString stringWithFormat:@"%@, %@, %@ %@, %@", app_Version, deviceName, deviceSystemName, deviceSystemVer, language];
            
            //直接发邮件
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            if(!picker) break;
            picker.mailComposeDelegate =self;
            NSString *subject = [NSString stringWithFormat:@"%@ %@ (iOS)",LocalizedString(@"Time Photo Studio", nil),LocalizedString(@"setting_feedback", nil)];
            [picker setSubject:subject];
            [picker setToRecipients:@[kFeedbackEmail]];
            [picker setMessageBody:diveceInfo isHTML:NO];
            [self.target presentViewController:picker animated:YES completion:nil];
        }
            break;
        case 4:
        {
            //使用条款
            HelpViewController *hvc = [[HelpViewController alloc] init];
            hvc.type = kWebViewTerms;
//            [self.navigationController pushViewController:hvc animated:YES];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
            [self.target presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 5:
        {
            //隐私政策
            HelpViewController *hvc = [[HelpViewController alloc] init];
            hvc.type = kWebViewPrivacy;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:hvc];
//            [self.navigationController pushViewController:hvc animated:YES];
            [self.target presentViewController:nav animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 100)];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor lightGrayColor];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    label.text = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (indexPath.row != self.dataArray.count -1) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryView.backgroundColor = colorWithHexString(@"#f6f6f6");
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = label;
    }
    return cell;
}

#pragma mark - MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    [controller dismissViewControllerAnimated:YES completion:^{
        if(MFMailComposeResultSent == result){
            showMBProgressHUD(@"success", NO);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                hideMBProgressHUD();
            });
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

@end
