//
//  HelpViewController.m
//  BestMe
//
//  Created by MAXToooNG on 15/6/16.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view.
}

- (void)initViews
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, windowWidth(), windowHeight())];
    [self.view addSubview:webView];
//    NSArray *languageArray = [NSLocale preferredLanguages];
//    NSString *language = [languageArray objectAtIndex:0];
    NSString *urlString = nil;
    
    switch (self.type) {
//        case kWebViewTips:
//        {
//            if ([language isEqualToString:@"zh-Hans"] || [language isEqualToString:@"zh-Hant"])  {
//                urlString = WEBVIEW_TIPS_CN;
//            }else{
//                urlString = WEBVIEW_TIPS_EN;
//            }
//        }
//            break;
        case kWebViewTerms:
        {
            urlString  = WEBVIEW_TERMS;
            self.navigationItem.title = [NSString stringWithFormat:@"·    %@    ·",    LocalizedString(@"setting_terms", nil)];
        }
            break;
        case kWebViewPrivacy:
        {
            urlString = WEBVIEW_PRIVACY;
            self.navigationItem.title = [NSString stringWithFormat:@"·    %@    ·",    LocalizedString(@"setting_policy", nil)];
        }
            break;
        default:
            break;
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIImage *image = [UIImage imageNamed:@"crop_back_normal"];
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [leftBtn setImage:image forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"crop_back_pressed"] forState:UIControlStateHighlighted];
    [leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
//    self.navigationItem.title = [NSString stringWithFormat:@"·    %@    ·",    LocalizedString(@"main_crop", nil)];
    self.navigationItem.leftBarButtonItems = @[negativeSeperator , leftItem];
}

- (void)back
{
//    CATransition *animation = [CATransition animation];
//    animation.duration = 0.3;
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
//    //            animation.type = @"rippleEffect";
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromLeft;
//    [self.view.window.layer addAnimation:animation forKey:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
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
