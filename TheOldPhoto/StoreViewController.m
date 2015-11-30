//
//  StoreViewController.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/26.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreManager.h"
#import <StoreKit/StoreKit.h>
#import "StoreObserver.h"


@interface StoreViewController ()
@property (nonatomic, strong) UIButton *buyOneBtn;
@property (nonatomic, strong) UIButton *buyAllBtn;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     self.buyOneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.buyOneBtn addTarget:self action:@selector(buyPub:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyOneBtn setTitle:@"商品1" forState:UIControlStateNormal];
    [self.buyOneBtn setFrame:CGRectMake(0 , 100, 100, 40)];
    [self.view addSubview:self.buyOneBtn];
    self.buyAllBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.buyAllBtn addTarget:self action:@selector(buyAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.buyAllBtn setTitle:@"全部" forState: UIControlStateNormal];
    [self.buyAllBtn setFrame:CGRectMake(0, 140, 100, 40)];
    [self.view addSubview:self.buyAllBtn];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *titleName = [NSString stringWithFormat:@"·      %@      ·",LocalizedString(@"setting_store", nil)];
    [self.navigationController setTitle:titleName];
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:back];
    self.navigationItem.leftBarButtonItem = item;
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
   
    
}

- (void)buyPub:(UIButton *)btn
{
    StoreObserver *observer = [StoreObserver sharedInstance];
    StoreManager *manager = [StoreManager sharedInstance];
    for (SKProduct * product in manager.availableProducts) {
        if ([product.productIdentifier isEqualToString:@"Oldphoto_1960"]) {
            [observer buy:product];
        }
    }
}

- (void)buyAll:(UIButton *)btn
{

}

- (void)back:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
