//
//  ViewController.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/9.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"
#import "SettingCellTableViewCell.h"
#import "PreviewImageConfig.h"
#import "CoverFlowView.h"
#import "ImageEditViewController.h"
#import "ScreenshotBorderView.h"
#import "StoreViewController.h"
#import "ZipArchive.h"
#import <StoreKit/StoreKit.h>
#import "StoreObserver.h"
#import "StoreManager.h"
#import "MyModel.h"
#import "UIImage+Utility.h"
#import "DataUtil.h"

@interface ViewController () <UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, ImageEditDelegate,NSURLConnectionDelegate>
{
     long long totalBytes;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *currentPics;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, assign) CropStyle currentCropStyle;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, strong) NSMutableArray *leftBtnArray;
@property (nonatomic, strong) NSMutableArray *middleBtnArray;
@property (nonatomic, strong) NSMutableArray *rightBtnArray;

@property (nonatomic, strong) NSString *finalFileName;
@property (nonatomic, strong) NSString *filefo;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSMutableData *data;
@property (nonatomic, strong) UIImage *default3_4;
@property (nonatomic, strong) UIImage *default4_3;
//@property (nonatomic, strong) NSMutableArray *year_90Array;
//@property (nonatomic, strong) NSMutableArray *year_80Array;
//@property (nonatomic, strong) NSMutableArray *year_60Array;
//@property (nonatomic, strong) NSMutableArray *year_40Array;
//@property (nonatomic, strong) NSMutableArray *year_unknowArray;
//@property (nonatomic, strong) NSMutableArray *year_totalArray;

@end

@implementation ViewController
@synthesize connection = connection;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self.tableView setPagingEnabled:YES];
    self.tableView.backgroundColor = [UIColor yellowColor];
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    [self getInAppPurchasesList];
//    self.imagePicker.allowsEditing = YES;
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)getInAppPurchasesList
{
     [[SKPaymentQueue defaultQueue] addTransactionObserver:[StoreObserver sharedInstance]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleProductRequestNotification:)
                                                 name:IAPProductRequestNotification
                                               object:[StoreManager sharedInstance]];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handlePurchasesNotification:)
                                                 name:IAPPurchaseNotification
                                               object:[StoreObserver sharedInstance]];
    [self fetchProductInformation];
}

#pragma mark Handle product request notification

// Update the UI according to the product request notification result
-(void)handleProductRequestNotification:(NSNotification *)notification
{
    StoreManager *productRequestNotification = (StoreManager*)notification.object;
    IAPProductRequestStatus result = (IAPProductRequestStatus)productRequestNotification.status;
    
    if (result == IAPProductRequestResponse)
    {
        for (MyModel *model in productRequestNotification.productRequestResponse) {
            for (SKProduct *product in model.elements) {
                NSLog(@"product.name = %@",product.localizedDescription);
                NSLog(@"product.id = %@",product.productIdentifier);
//                NSLog(@"product.price = %@",product.priceLocale.localeIdentifier);
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
                [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
                [numberFormatter setLocale:product.priceLocale];
                
                NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
                NSMutableString *productPrice = [NSMutableString stringWithString:formattedPrice];
                [productPrice replaceOccurrencesOfString:@" " withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, formattedPrice.length)];
                NSLog(@"%@",productPrice);
            }
//            NSLog(@"")
        }
        // Switch to the iOSProductsList view controller and display its view
//        [self cycleFromViewController:self.currentViewController toViewController:self.productsList];
        
        // Set the data source for the Products view
//        [self.productsList reloadUIWithData:productRequestNotification.productRequestResponse];
    }
}


#pragma mark Handle purchase request notification

// Update the UI according to the purchase request notification result
-(void)handlePurchasesNotification:(NSNotification *)notification
{
    StoreObserver *purchasesNotification = (StoreObserver *)notification.object;
    IAPPurchaseNotificationStatus status = (IAPPurchaseNotificationStatus)purchasesNotification.status;
    
    switch (status)
    {
        case IAPPurchaseFailed:
            [self alertWithTitle:@"Purchase Status" message:purchasesNotification.message];
            break;
            // Switch to the iOSPurchasesList view controller when receiving a successful restore notification
        case IAPRestoredSucceeded:
        {
            
//            self.segmentedControl.selectedSegmentIndex = 1;
//            self.restoreWasCalled = YES;
//            
//            [self cycleFromViewController:self.currentViewController toViewController:self.purchasesList];
//            [self.purchasesList reloadUIWithData:[self dataSourceForPurchasesUI]];
        }
            break;
        case IAPRestoredFailed:
            [self alertWithTitle:@"Purchase Status" message:purchasesNotification.message];
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


#pragma mark Fetch product information

// Retrieve product information from the App Store
-(void)fetchProductInformation
{
    // Query the App Store for product information if the user is is allowed to make purchases.
    // Display an alert, otherwise.
    if([SKPaymentQueue canMakePayments])
    {
        // Load the product identifiers fron ProductIds.plist
        NSURL *plistURL = [[NSBundle mainBundle] URLForResource:@"ProductIds" withExtension:@"plist"];
        NSArray *productIds = [NSArray arrayWithContentsOfURL:plistURL];
        
        [[StoreManager sharedInstance] fetchProductInformationForIds:productIds];
    }
    else
    {
        // Warn the user that they are not allowed to make purchases.
        [self alertWithTitle:@"Warning" message:@"Purchases are disabled on this device."];
    }
}

#pragma mark Display message

-(void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)initData
{
    DataUtil *util = [DataUtil defaultUtil];
    util.is3_4 = YES;
    util.indexCfgArray = [[NSMutableArray alloc] initWithObjects:@0,@0,@0,@0,@0,@0, nil];
    
    self.default3_4 = [UIImage imageNamed:@"default3_4.jpg"];
    self.default4_3 = [UIImage imageNamed:@"default4_3.jpg"];
    self.currentCropStyle = CropStyleFree;
//    self.year_totalArray = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] initWithObjects:@"home_now",@"home_90",@"home_80",@"home_60",@"home_40",@"home_un",nil];
    self.leftBtnArray = [[NSMutableArray alloc] initWithObjects:@"home_now_library",@"home_90_library",@"home_80_library",@"home_60_library",@"home_40_library",@"home_un_library", nil];
    self.middleBtnArray = [[NSMutableArray alloc] initWithObjects:@"home_now_camera",@"home_90_camera",@"home_80_camera",@"home_60_camera",@"home_40_camera",@"home_un_camera", nil];
    self.rightBtnArray = [[NSMutableArray alloc] initWithObjects:@"home_now_share",@"home_90_share",@"home_80_share",@"home_60_share",@"home_40_share",@"home_un_share", nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.titleArray.count) {
        static NSString *settingCellIde = @"settingCell";
        SettingCellTableViewCell *settingCell = [tableView dequeueReusableCellWithIdentifier:settingCellIde];
        if (!settingCell) {
            settingCell = [[SettingCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:settingCellIde target:self];
        }
        return settingCell;
    }
    static NSString *cellIde = @"cellIde";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell == nil) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde target:self leftSelector:@selector(intentToAlbum:) middleSelector:@selector(intentToCamera:) rightSelector:@selector(shareImage:) downloadSelector:@selector(download:) buySelector:@selector(iapEvent:)];
    }
    NSString *imageName = [self.titleArray objectAtIndex:indexPath.row];
    NSMutableArray *pics = [PreviewImageConfig getScrollViewArrayWithIndexPath:indexPath];
    NSLog(@"pics .count = %ld",pics.count);
    self.currentIndexPath = indexPath;
    //    self.currentPics = [NSArray arrayWithArray:pics];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTitleImage:[UIImage imageNamed:imageName]];
    NSString *leftBtnImageName = [self.leftBtnArray objectAtIndex:indexPath.row];
    NSString *middleBtnImageName = [self.middleBtnArray objectAtIndex:indexPath.row];
    NSString *rightBtnImageName = [self.rightBtnArray objectAtIndex:indexPath.row];
    [cell setLeftImageName:leftBtnImageName middleImageName:middleBtnImageName rightImageName:rightBtnImageName];
    NSNumber *indexNum = [DataUtil defaultUtil].indexCfgArray[indexPath.row];
    NSInteger index = indexNum.integerValue;
    if (self.currentImage) {
        CropStyle style = [cell cropStyleWithIndexpath:indexPath index:index];
        if ([DataUtil defaultUtil].is3_4) {
            if ( style == CropStyleSquareness3) {
                index = 0;
            }
        }else{
            if ( style == CropStyleSquareness4) {
                index = 1;
            }
        }
        [cell setDisplayImage:self.currentImage withIndexPath:indexPath index:index];
//        [cell setDisplayImage:self.currentImage withSceneType:indexPath.row];
    }else{
        if ([DataUtil defaultUtil].is3_4) {
            [cell setDisplayImage:self.default3_4 withIndexPath:indexPath index:index];
        }else{
            [cell setDisplayImage:self.default4_3 withIndexPath:indexPath index:index];
        }
//        cell setDisplayImage
//        [cell setDisplayImage:[UIImage imageNamed:pics.firstObject]];
    }
    [cell.arrow setAnimation];
    [cell resetDisplayView];
    [cell setShowImages:pics target:self seletor:@selector(openAlbum:) ];
    if (indexPath.row == 0) {
        [cell disableGestureRecognizer];
    }else{
        [cell enableGestureRecognizer];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.bounds.size.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count + 1;
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
    CGPoint point = CGPointMake(self.tableView.contentOffset.x , self.tableView.contentOffset.y + self.tableView.frame.size.height / 2);
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    self.currentIndexPath = indexPath;
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    if (cell.isCurrentModel) {
        
    }else{
        self.currentCropStyle = [cell cropStyleWithIndexpath:self.currentIndexPath index:cell.coverFlowView.currentRenderingImageIndex];
    }
    self.imagePicker.sourceType = type;
    [self presentViewController:self.imagePicker animated:YES completion:^{
        
    }];
}


- (void)openAlbum:(UITapGestureRecognizer *)tap
{
    CropStyle style = [self getCropStyleWithIndex:_currentIndexPath andIndex:(((CoverFlowView *)tap.view).currentRenderingImageIndex)];
//    NSInteger index = ((CoverFlowView *)tap.view).currentRenderingImageIndex;
    NSLog(@"self.currentCropStyle = %ld style = %ld",self.currentCropStyle,style);
    if ((self.currentCropStyle == CropStyleFree || self.currentCropStyle == style || style == CropStyleFree)) {
        [self setScene];
    }else{
        [self presentToImagePickerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    if (self.currentImage) {
        self.currentCropStyle = style;
    }
    if (_currentIndexPath.row<3) {
        self.currentCropStyle = CropStyleFree;
    }
}

- (CropStyle)getCropStyleWithIndex:(NSIndexPath *)indexPath andIndex:(NSInteger)index
{
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    return  [cell cropStyleWithIndexpath:indexPath index:index]; 
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
//    editVC.srcImage = [image setMaxResolution:kImportImageMaxResolution imageOri:image.imageOrientation];
    editVC.srcImage = [image fixOrientation:image.imageOrientation];
    if (self.currentCropStyle == CropStyleFree || self.currentCropStyle == CropStyleSquareness4 || self.currentCropStyle == CropStyleSquareness3) {
        editVC.style = self.currentCropStyle;
    }else{
        editVC.style = CropStyleFree;
    }
    [picker pushViewController:editVC animated:YES];
}

- (void)imageEditResultImage:(UIImage *)image
{
    self.currentImage = image;
    [self setScene];
//    [cell setDisplayImage:image withSceneType:self.currentIndexPath.row];
}

- (void)setScene
{
    CGPoint point = CGPointMake(self.tableView.contentOffset.x , self.tableView.contentOffset.y + self.tableView.frame.size.height / 2);
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    self.currentIndexPath = indexPath;
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    NSLog(@"cell = %@",cell );
    NSLog(@"indexPath = %ld",self.currentIndexPath.row);
    [cell resetDisplayView];
    NSInteger index = cell.coverFlowView.currentRenderingImageIndex;
    if (self.currentImage) {
        if (self.currentImage.size.width > self.currentImage.size.height) {
            [DataUtil defaultUtil].is3_4 = NO;
        }else{
            [DataUtil defaultUtil].is3_4 = YES;
        }
        [cell setDisplayImage:self.currentImage withIndexPath:self.currentIndexPath index:index];
    }else{
        CropStyle style = [cell cropStyleWithIndexpath:self.currentIndexPath index:index];
        if ( style == CropStyleSquareness4) {
             [cell setDisplayImage:self.default3_4 withIndexPath:self.currentIndexPath index:index];
            [DataUtil defaultUtil].is3_4 = YES;
        }else if(style == CropStyleSquareness3){
             [cell setDisplayImage:self.default4_3 withIndexPath:self.currentIndexPath index:index];
            [DataUtil defaultUtil].is3_4 = NO;
        }else{
            if ([DataUtil defaultUtil].is3_4) {
                [cell setDisplayImage:self.default3_4 withIndexPath:self.currentIndexPath index:index];
            }else{
                [cell setDisplayImage:self.default4_3 withIndexPath:self.currentIndexPath index:index];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (void)download:(UIButton *)btn
{
    CGPoint point = CGPointMake(self.tableView.contentOffset.x , self.tableView.contentOffset.y + self.tableView.frame.size.height / 2);
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentIndexPath];
    NSInteger index = cell.coverFlowView.currentRenderingImageIndex;
    NSString *fileName = [NSString stringWithFormat:@"scene%ld_%ld",indexPath.row,index];
    NSString *downloadPath = [NSString stringWithFormat:@"%@%@.zip",kBaseUrl,fileName];
    NSString *basePath =  [NSHomeDirectory() stringByAppendingString:@"/Documents/Scene"];
    [self downloadFileURL:downloadPath savePath:basePath fileName:fileName tag:0];
}

- (void)iapEvent:(UIButton *)btn
{
    StoreViewController *store = [[StoreViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:store];
    
    [self presentViewController:nav animated:YES completion:nil];
}

/**
 * 下载文件
 */
- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName tag:(NSInteger)aTag
{
//    _isDownload = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@.zip", aSavePath, aFileName];
    NSLog(@"fileName = %@",fileName);
    NSLog(@"downloadUrl = %@",aUrl);
    self.finalFileName = fileName;
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        [fileManager removeItemAtPath:fileName error:nil];
    }
    if ([fileManager fileExistsAtPath:aSavePath]) {
        //        [fileManager removeItemAtPath:aSavePath error:nil];
    }else{
        [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.filefo = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    //下载附件
    NSURL *url = [[NSURL alloc] initWithString:aUrl];
    NSLog(@"aUrl = %@",aUrl);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    connection = nil;
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
 }


#pragma mark -
#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response");
    
    self.data= [[NSMutableData alloc]init];
    
    NSHTTPURLResponse*httpResponse=(NSHTTPURLResponse*)response;
    
    if(httpResponse&&[httpResponse respondsToSelector:@selector(allHeaderFields)]){
        
        NSDictionary*httpResponseHeaderFields=[httpResponse allHeaderFields];
        
        totalBytes = [[httpResponseHeaderFields objectForKey:@"Content-Length"]longLongValue];
        NSLog(@"totalBytes = %lld",totalBytes);
    }//获取文件文件的大小
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"faild , error = %@",error.localizedDescription);
    NSLog(@"faild");
    //    if (error.code != -999) {
    [[[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"main_download_failed", nil) delegate:nil cancelButtonTitle:LocalizedString(@"main_confirm", nil) otherButtonTitles:nil, nil] show];
    //    }
//    self.asProgressView.hidden = YES;
//    self.downloadView.hidden = NO;
//    self.isDownload = NO;
//    self.bottomView.backgroundColor = colorWithHexString(@"#42cf9b");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
//    NSLog(@"data.length = %d",[_data length]);
//    NSLog(@"totalBytes = %lld",totalBytes);
//    NSUInteger currentData = [_data length];
//    float progress = (CGFloat)((currentData / 1.0f)/(totalBytes / 1.0f));
    
    NSLog(@"is download：%lld",([_data length])/totalBytes);
    //             [_progressView setProgress:progress animated:YES];
    
//    [self.asProgressView setProgress:progress animated:YES];
//    if (progress == 1) {
//        self.isDownload = NO;
//        //            [preview.asProgressView hidePopUpViewAnimated:YES];
//    }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{//完成时调用
    
    NSLog(@"Finish");
    
    //    NSString*filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)objectAtIndex:0]stringByAppendingPathComponent:@"android.mp4"];
    
    [_data writeToFile:self.finalFileName atomically:NO];//将数据写入Documents目录。
    
    NSLog(@"%@",self.finalFileName);
    
//    NSLog(@"getMd5 = %@", [MD5Tools getFileMD5WithPath:self.finalFileName]);
//    NSLog(@"file.md5 = %@",self.dataModel.stickerMd5String);
//    if (![[MD5Tools getFileMD5WithPath:self.finalFileName] isEqualToString:self.dataModel.stickerMd5String] ) {
//        NSLog(@"downloadFaild");
//        //           BOOL ret =  [fileManager removeItemAtPath:fileName error:nil];
//        //            NSLog(@"ret = %d",ret);
//        [[[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"main_download_failed", nil) delegate:nil cancelButtonTitle:LocalizedString(@"main_confirm", nil) otherButtonTitles:nil, nil] show];
//        self.asProgressView.hidden = YES;
//        self.downloadView.hidden = NO;
//        self.isDownload = NO;
//        self.bottomView.backgroundColor = colorWithHexString(@"#42cf9b");
//        self.completeBtn.hidden = YES;
    
//        return ;
//    }
//    [self.asProgressView hidePopUpViewAnimated:YES];

    NSLog(@"success");
    //检查本地文件是否已存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //        NSString *fileFolder = [NSString stringWithFormat:@"%@/%@", aSavePath, preview.dataModel.stickerMd5String];
    //        if (![fileManager fileExistsAtPath:fileFolder]) {
    //            [fileManager createDirectoryAtPath:fileFolder withIntermediateDirectories:YES attributes:nil error:nil];
    //        }
    ZipArchive *za = [[ZipArchive alloc] init];
    if ([za UnzipOpenFile: self.finalFileName]) {
        BOOL ret = [za UnzipFileTo: self.filefo overWrite: YES];
        if (YES == ret){
            NSLog(@"unZip Success");
            BOOL res =  [fileManager removeItemAtPath:self.finalFileName error:nil];
            if (res) {
                NSLog(@"delete File Success");
            }
            //                    NSFileManager * fm = [NSFileManager defaultManager];
            //                     NSArray * filels = [fm contentsOfDirectoryAtPath:fileFolder error:nil];
//            NSLog(@"sid = %d , folderPath = %@",self.dataModel.stickerId,self.filefo);
            NSDate *date = [NSDate date];
            long time = (long)[date timeIntervalSince1970];
//            if (self.type == kStickerShop) {
//                [[Sticker_SQLiteManager shareStance] updateStickerInfo:self.dataModel.stickerId withDownloadDir:self.filefo andDownloadTime:time andType:@"sticker"];
//                [[Sticker_SQLiteManager shareStance] updateSitckerInfo:self.dataModel.stickerId withIsLooked:0 andType:@"sticker"];
//                NSArray *array = [[Sticker_SQLiteManager shareStance] getStickerDataWithType:@"sticker"];
//                [Sticker_DataUtil defaultDateUtil].stickerModelArray = array;
//            }else if (self.type == kBackgroundShop){
//                [[Sticker_SQLiteManager shareStance] updateStickerInfo:self.dataModel.stickerId withDownloadDir:self.filefo andDownloadTime:time andType:@"background"];
//                [[Sticker_SQLiteManager shareStance] updateSitckerInfo:self.dataModel.stickerId withIsLooked:0 andType:@"background"];
//                NSArray *array = [[Sticker_SQLiteManager shareStance] getStickerDataWithType:@"background"];
//                [Sticker_DataUtil defaultDateUtil].stickerModelArray = array;
//            }
        }
        [za UnzipCloseFile];
        
    }else{
        NSLog(@"UnzipFaild");
        BOOL ret =  [fileManager removeItemAtPath:self.finalFileName error:nil];
        NSLog(@"ret = %d",ret);
        [[[UIAlertView alloc] initWithTitle:nil message:LocalizedString(@"main_download_failed", nil) delegate:nil cancelButtonTitle:LocalizedString(@"main_confirm", nil) otherButtonTitles:nil, nil] show];
//        self.asProgressView.hidden = YES;
//        self.downloadView.hidden = NO;
//        self.isDownload = NO;
//        self.bottomView.backgroundColor = colorWithHexString(@"#42cf9b");
//        self.completeBtn.hidden = YES;
        
        return ;
    }
}


#pragma mark
#pragma mark MemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
    // Dispose of any resources that can be recreated.
}



@end
