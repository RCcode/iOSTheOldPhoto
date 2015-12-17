//
//  ImageEditViewController.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/18.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "ImageEditViewController.h"
#import "DataUtil.h"
@interface ImageEditViewController ()

@property (nonatomic, strong) ScreenshotBorderView *screenShotView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) BOOL isWidthlongerThanHeight;

@end

@implementation ImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self initCropView]; 
    [self initView];
    // Do any additional setup after loading the view.
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
    
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightBtn setFrame:CGRectMake(0, 0, 44, 44)];
    if (self.style == CropStyleFree) {
        self.style = CropStyleSquareness4;
        _isWidthlongerThanHeight = NO;
        [self.rightBtn setImage:[UIImage imageNamed:@"crop_43_normal"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"crop_43_pressed"] forState:UIControlStateHighlighted];
        [self.rightBtn addTarget:self action:@selector(changeCropStyle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
        self.navigationItem.rightBarButtonItems = @[negativeSeperator, rightItem];
    }
    self.navigationItem.title = [NSString stringWithFormat:@"·    %@    ·",    LocalizedString(@"main_crop", nil)];
    self.navigationItem.leftBarButtonItems = @[negativeSeperator , leftItem];
}

- (void)changeCropStyle:(UIButton *)btn
{
    if (_isWidthlongerThanHeight) {
        self.style = CropStyleSquareness3;
        [self.screenShotView setCameraCropStyle:CameraCropStyleSquareness4];
        [self.rightBtn setImage:[UIImage imageNamed:@"crop_43_normal"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"crop_43_pressed"] forState:UIControlStateHighlighted];
    }else{
        self.style = CropStyleSquareness4;
        [self.screenShotView setCameraCropStyle:CameraCropStyleSquareness3];
        [self.rightBtn setImage:[UIImage imageNamed:@"crop_34_normal"] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:@"crop_34_pressed"] forState:UIControlStateHighlighted];
    }
    _isWidthlongerThanHeight = !_isWidthlongerThanHeight;
    
}

- (void)back
{
    if (_isNav) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)initView
{
    [self initCropView];
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setImage:[UIImage imageNamed:@"crop_cancel"] forState:UIControlStateNormal];
    [self.cancelBtn setImage:[UIImage imageNamed:@"crop_cancel_pressed"] forState:UIControlStateHighlighted];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"crop_cancel_pressed"] forState:UIControlStateHighlighted];
    self.cancelBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    self.cancelBtn.frame = CGRectMake(0,self.screenShotView.frame.origin.y + self.screenShotView.frame.size.height + 44, windowWidth() / 2, 44);
    [self.cancelBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = CGRectMake(windowWidth() / 2 + 1, self.screenShotView.frame.origin.y + self.screenShotView.frame.size.height + 44, windowWidth() / 2, 44);
    [self.confirmBtn setImage:[UIImage imageNamed:@"crop_ok"] forState:UIControlStateNormal];
    [self.confirmBtn setImage:[UIImage imageNamed:@"crop_ok_pressed"] forState:UIControlStateHighlighted];
    [self.confirmBtn setBackgroundImage:[UIImage imageNamed:@"crop_ok_pressed"] forState:UIControlStateHighlighted];
    [self.confirmBtn addTarget:self action:@selector(getResultImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmBtn];
    
}

- (void)getResultImage:(UIButton *)btn
{
    UIImage *image = self.screenShotView.subImage;
    if ([self.delegate respondsToSelector:@selector(imageEditResultImage:)]) {
        [DataUtil defaultUtil].fullImage = self.srcImage;
        NSArray *cfgArray = @[image,[NSNumber numberWithInt:self.style]];
        [self.delegate performSelector:@selector(imageEditResultImage:) withObject:cfgArray];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initCropView
{
    CGFloat viewW = self.view.frame.size.width;
    CGFloat viewH = self.view.frame.size.height - 44 - 44 ;
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 44, viewW, viewH)];
    //    view.backgroundColor = [UIColor yellowColor];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    self.screenShotView = [[ScreenshotBorderView alloc] initWithFrame:(CGRect){CGPointZero, view.frame.size}];
    self.screenShotView.backgroundColor = [UIColor blackColor];
    self.screenShotView.srcImage = _srcImage;
    if (self.style == CropStyleFree) {
        [self.screenShotView setCameraCropStyle:CameraCropStyleSquareness4];
    }else if (self.style == CropStyleSquareness4){
        [self.screenShotView setCameraCropStyle:CameraCropStyleSquareness4];
    }else if (self.style == CropStyleSquareness3){
        [self.screenShotView setCameraCropStyle:CameraCropStyleSquareness3];
    }else{
        [self.screenShotView setCameraCropStyle:CameraCropStyleSquareness4];
    }
    //    [self.screenShotView hiddenBorderView];
    [view addSubview:self.screenShotView];
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
