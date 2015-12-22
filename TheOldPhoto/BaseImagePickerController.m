//
//  BaseImagePickerController.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/12/22.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "BaseImagePickerController.h"

@interface BaseImagePickerController ()

@end

@implementation BaseImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
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
