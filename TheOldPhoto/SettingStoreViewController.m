//
//  SettingStoreViewController.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/26.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "SettingStoreViewController.h"
#import "LabelBtn.h"
#import "StoreManager.h"
#import "StoreObserver.h"

@interface SettingStoreViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *yearArray;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) NSArray *iapArray;
@property (nonatomic, strong) NSString *all;
@property (nonatomic, strong) UIButton *buyOneBtn;
@end

@implementation SettingStoreViewController
@synthesize buyOneBtn = buyOneBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.all = @"Oldphoto_all";
    self.iapArray = @[k1980sPack,k1960sPack,k1940sPack,kUnknowPack];
    self.view.backgroundColor = colorWithHexString(@"#f6f6f6");
    self.array = @[@"store_80.jpg",@"store_60.jpg",@"store_40.jpg",@"store_un.jpg"];
    self.yearArray = @[@"store_1980s",@"store_1960s",@"store_1940s",@"store_unknow"];
    [self initView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesNotification:)
                                                 name:@"IAPPurchaseNotification"
                                               object:[StoreObserver sharedInstance]];
    // Do any additional setup after loading the view.
}

#pragma mark Handle purchase request notification

// Update the UI according to the purchase request notification result
-(void)handlePurchasesNotification:(NSNotification *)notification
{
    StoreObserver *purchasesNotification = (StoreObserver *)notification.object;
    IAPPurchaseNotificationStatus status = (IAPPurchaseNotificationStatus)purchasesNotification.status;
    hideMBProgressHUD();
    switch (status)
    {
        case IAPPurchaseFailed:
            break;
            // Switch to the iOSPurchasesList view controller when receiving a successful restore notification
        case IAPRestoredSucceeded:
        {
            NSLog(@"restore successssss");
            [self back];
        }
            break;
        case IAPPurchaseSucceeded:
        {
            NSLog(@"successssssss");
            [self back];
        }
            break;
        case IAPRestoredFailed:
            break;
            // Notify the user that downloading is about to start when receiving a download started notification
        case IAPDownloadStarted:
        {
            //            self.hasDownloadContent = YES;
            //            [self.view addSubview:self.statusMessage];
        }
            break;
            // Display a status message showing the download progress
        case IAPDownloadInProgress:
        {
            //            self.hasDownloadContent = YES;
            //            NSString *title = [[StoreManager sharedInstance] titleMatchingProductIdentifier:purchasesNotification.purchasedID];
            //            NSString *displayedTitle = (title.length > 0) ? title : purchasesNotification.purchasedID;
            //            self.statusMessage.text = [NSString stringWithFormat:@" Downloading %@   %.2f%%",displayedTitle, purchasesNotification.downloadProgress];
        }
            break;
            // Downloading is done, remove the status message
        case IAPDownloadSucceeded:
        {
            //            self.hasDownloadContent = NO;
            //            self.statusMessage.text = @"Download complete: 100%";
            //
            //            // Remove the message after 2 seconds
            //            [self performSelector:@selector(hideStatusMessage) withObject:nil afterDelay:2];
        }
            break;
        default:
            break;
    }
}

- (void)initView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, windowWidth(), windowHeight() - setH(79) - 44)];
    self.scrollView.contentSize = CGSizeMake(4 * windowWidth(), 1);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(setW(127), setH(445), setW(100), setH(20))];
    self.pageControl.center = CGPointMake(windowWidth() / 2, self.pageControl.center.y);
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    for (int i = 0; i < 4 ; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(windowWidth() * i, 0, windowWidth(), setH(354))];
        imageView.image = [UIImage imageNamed:self.array[i]];
        [self.scrollView addSubview:imageView];
        UIImageView *yearView = [[UIImageView alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y + imageView.frame.size.height , 157, 15)];
        yearView.center = CGPointMake(i * windowWidth() + windowWidth() / 2, yearView.center.y + 20);
        [self.scrollView addSubview:yearView];
        yearView.image =  [UIImage imageNamed:self.yearArray[i]];
    }
    self.pageControl.numberOfPages = 4;
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = colorWithHexString(@"#797979");
    self.pageControl.pageIndicatorTintColor = colorWithHexString(@"#d2d2d2");
    [self.view addSubview:self.pageControl];
    
    self.bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, windowHeight() - setH(79), windowWidth(), setH(79))];
    self.bottomBar.backgroundColor = colorWithHexString(@"#1b1811");
    [self.view addSubview:self.bottomBar];
    
    buyOneBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buyOneBtn.frame = CGRectMake(0, setH(7), windowWidth() - 60, setH(30));
    buyOneBtn.center = CGPointMake(windowWidth() / 2, buyOneBtn.center.y);
    NSNumber *pur = [[NSUserDefaults standardUserDefaults] valueForKey:kAllPacks];
    NSNumber *pur80 = [[NSUserDefaults standardUserDefaults] valueForKey:k1980sPack];
    if (pur.boolValue || pur80.boolValue) {
        [buyOneBtn setTitle:LocalizedString(@"iap_purchased", nil) forState:UIControlStateNormal];
    }else{
        [buyOneBtn setTitle:LocalizedString(@"iap_one", nil) forState:UIControlStateNormal];
    }
    
    buyOneBtn.backgroundColor = [UIColor clearColor];
    buyOneBtn.layer.cornerRadius = setH(15);
    buyOneBtn.layer.borderColor = colorWithHexString(@"#fdcf03").CGColor;
    buyOneBtn.layer.borderWidth = 1;
    [buyOneBtn setTitleColor:colorWithHexString(@"#fdcf03") forState:UIControlStateNormal];
    [buyOneBtn addTarget:self action:@selector(buyOne:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label;
    label.minimumScaleFactor = YES;
    
    [self.bottomBar addSubview:buyOneBtn];
    
    LabelBtn *labelBtn = [LabelBtn buttonWithType:UIButtonTypeCustom];
    if (pur.boolValue) {
        [buyOneBtn setTitle:LocalizedString(@"iap_purchased", nil) forState:UIControlStateNormal];
    }else{
        [buyOneBtn setTitle:LocalizedString(@"iap_one", nil) forState:UIControlStateNormal];
    }
    labelBtn.frame = CGRectMake(0, self.bottomBar.frame.size.height - setH(12) - setH(30), windowWidth() - 60, setH(30));
    [labelBtn setTitle:nil forState:UIControlStateNormal];
    labelBtn.center = CGPointMake(windowWidth() / 2, labelBtn.center.y);
    [labelBtn addTarget:self action:@selector(buyAll:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:labelBtn];
}

- (void)resetBtnTitleWithId:(NSString *)idString
{
    NSNumber *pur = [[NSUserDefaults standardUserDefaults] valueForKey:idString];
    if (pur && pur.boolValue) {
        [buyOneBtn setTitle:LocalizedString(@"iap_purchased", nil) forState:UIControlStateNormal];
        buyOneBtn.enabled = NO;
    }else{
        [buyOneBtn setTitle:LocalizedString(@"iap_one", nil) forState:UIControlStateNormal];
        buyOneBtn.enabled = YES;
    }
}

- (void)buyAll:(UIButton *)btn
{
    StoreObserver *observer = [StoreObserver sharedInstance];
    StoreManager *manager = [StoreManager sharedInstance];
    NSString *nowPurchase = @"Oldphoto_all";
    for (SKProduct * product in manager.availableProducts) {
        if ([product.productIdentifier isEqualToString:nowPurchase]) {
            showMBProgressHUD(nil, YES);
            [observer buy:product];
        }
    }
}

- (void)buyOne:(UIButton *)btn
{
    StoreObserver *observer = [StoreObserver sharedInstance];
    StoreManager *manager = [StoreManager sharedInstance];
    NSString *nowPurchase = self.iapArray[self.pageControl.currentPage];
    for (SKProduct * product in manager.availableProducts) {
        if ([product.productIdentifier isEqualToString:nowPurchase]) {
            showMBProgressHUD(nil, YES);
            [observer buy:product];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / windowWidth();
     NSNumber *pur = [[NSUserDefaults standardUserDefaults] valueForKey:kAllPacks];
    if (pur && pur.boolValue) {
        
    }else{
        [self resetBtnTitleWithId:self.iapArray[_pageControl.currentPage]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *titleName = [NSString stringWithFormat:@"·      %@      ·",LocalizedString(@"setting_store", nil)];
//    [self.navigationController setTitle:titleName];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = titleName;
    self.navigationItem.titleView = label;
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:[UIImage imageNamed:@"crop_back_normal"] forState:UIControlStateNormal];
    [back setImage:[UIImage imageNamed:@"crop_back_pressed"] forState:UIControlStateHighlighted];
    [back setFrame:CGRectMake(0, 0, 44, 44)];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:back];
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
    self.navigationItem.leftBarButtonItems = @[negativeSeperator , leftItem];
    
    UIButton *restoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [restoreBtn setImage: [UIImage imageNamed:@"store_restore_normal"] forState:UIControlStateNormal];
    [restoreBtn setImage:[UIImage imageNamed:@"store_restore_pressed"] forState:UIControlStateHighlighted];
    [restoreBtn setFrame:CGRectMake(0, 0, 44, 44)];
    [restoreBtn addTarget:self action:@selector(restore:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:restoreBtn];
    self.navigationItem.rightBarButtonItems = @[negativeSeperator , rightItem];
    
}

- (void)restore:(UIButton *)btn
{
    StoreObserver *observer = [StoreObserver sharedInstance];
    showMBProgressHUD(nil, YES);
    [observer restore];
}

- (void)back
{
    if (_isPush) {
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        //            animation.type = @"rippleEffect";
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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
