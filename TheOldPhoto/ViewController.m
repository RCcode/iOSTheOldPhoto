//
//  ViewController.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/9.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"
#import "PreviewImageConfig.h"
#import "CoverFlowView.h"
#import "ImageEditViewController.h"
#import "ScreenshotBorderView.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ImageEditDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *currentPics;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, assign) CropStyle currentCropStyle;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentCropStyle = CropStyleFree;
    [self.tableView setPagingEnabled:YES];
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"Now",@"1990's",@"1980's",@"1960's",@"1940's",@"unknow", nil];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
//    self.imagePicker.allowsEditing = YES;
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cellIde";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde target:self leftSelector:@selector(intentToAlbum:) middleSelector:@selector(intentToCamera:) rightSelector:@selector(shareImage:)];
    }
    NSString *title = [self.titleArray objectAtIndex:indexPath.row];
    NSMutableArray *pics = [PreviewImageConfig getScrollViewArrayWithIndexPath:indexPath];
    NSLog(@"pics .count = %ld",pics.count);
    self.currentIndexPath = indexPath;
    //    self.currentPics = [NSArray arrayWithArray:pics];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    NSLog(@"UItableView.ges = %@",tableView.gestureRecognizers);
//    [cell setTitleString:title];
    [cell setTitleImage:[UIImage imageNamed:@"demo2.jpg"]];
    
    [cell setShowImages:pics target:self seletor:@selector(openAlbum:) ];
//    for (UIGestureRecognizer *gess in self.tableView.gestureRecognizers) {
//        [gess requireGestureRecognizerToFail:cell.coverFlowView.ges];
//    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (void)intentToAlbum:(UIButton *)btn
{
    [self presentToImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    NSLog(@"album");
}

- (void)intentToCamera:(UIButton *)btn
{
    [self presentToImagePickerWithType:UIImagePickerControllerSourceTypeCamera];
    NSLog(@"camera");
}

- (void)shareImage:(UIButton *)btn
{
    NSLog(@"share");
}

- (void)presentToImagePickerWithType:(UIImagePickerControllerSourceType)type
{
    self.imagePicker.sourceType = type;
    [self presentViewController:self.imagePicker animated:YES completion:^{
        
    }];
}


- (void)openAlbum:(UITapGestureRecognizer *)tap
{
    NSInteger index = ((CoverFlowView *)tap.view).currentRenderingImageIndex;
    NSLog(@"index = %ld",index);
    [self presentToImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark
#pragma mark UIImagePickerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ImageEditViewController *editVC = [[ImageEditViewController alloc] init];
    NSLog(@"image = %@",image);
    editVC.delegate = self;
    editVC.srcImage = image;
    editVC.style = self.currentCropStyle;
    [picker pushViewController:editVC animated:YES];
    
}

- (void)imageEditResultImage:(UIImage *)image
{
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark
#pragma mark MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
