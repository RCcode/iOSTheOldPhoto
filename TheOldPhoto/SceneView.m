//
//  SceneView.m
//  TheOldPhoto
//
//  Created by MAXToooNG on 15/11/20.
//  Copyright © 2015年 MaxToooNG. All rights reserved.
//

#import "SceneView.h"
#import "GPUImage.h"
#import "SceneModel.h"
#import "TextureModel.h"
#import "JSONKit.h"
#import <math.h>

#define kSceneWidth 2048

@interface SceneView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GPUImageView *previewView;
@property (nonatomic, strong) GPUImagePicture *oriImage;
@property (nonatomic, strong) GPUImagePicture *frameImage;
@property (nonatomic, strong) GPUImagePicture *lookupPicture;
@property (nonatomic, strong) GPUImagePicture *screenTexture;

@property (nonatomic, strong) GPUImageTransformFilter *transformFilter;
@property (nonatomic, strong) GPUImageGaussianBlurFilter *gaussianFIlter;
@property (nonatomic, strong) GPUImageLookupFilter *lookupFilter;
@property (nonatomic, strong) GPUImageToneCurveFilter *acvFilter;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *softLightFilter;
@property (nonatomic, strong) GPUImageOutput<GPUImageInput> *noiseFilter;
@property (nonatomic, strong) NSMutableDictionary *cfgDictionary;
@property (nonatomic, strong) NSMutableArray *cfgArray;
@property (nonatomic, strong) NSMutableArray *filterArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) NSMutableArray *sceneArray;

@property (nonatomic, strong) SceneModel *sceneModel;
@property (nonatomic, strong) TextureModel *textureModel;

@end

@implementation SceneView

- (instancetype)initWithFrame:(CGRect)frame oriImage:(UIImage *)oriImage andIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index{
    if (self = [super initWithFrame:frame]) {
        self.pictureArray = [[NSMutableArray alloc] init];
        self.filterArray = [[NSMutableArray alloc] init];
        self.cfgArray = [[NSMutableArray alloc] init];

        [self initView];
        [self initFilterWithIndexPath:indexpath index:index oriImage:oriImage];
//        [self initFilterWithType:type oriImage:oriImage];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.pictureArray = [[NSMutableArray alloc] init];
        self.filterArray = [[NSMutableArray alloc] init];
        self.cfgArray = [[NSMutableArray alloc] init];
//        self.sceneArray = [self getCfgArrayWithIndexpath:<#(NSIndexPath *)#> index:<#(NSInteger)#>];
        NSLog(@"sceneArray = %@",self.sceneArray);
//        [self parseDic:self.sceneArray];
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width)];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] init];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [swipe addTarget:self action:@selector(swipePage:)];
    [self addGestureRecognizer:swipe];
    [self addSubview:self.imageView];
}

- (NSMutableArray *)getCfgArrayWithIndexpath:(NSIndexPath *)indexPath index:(NSInteger)index
{
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//    for (int i = 1; i < 8; i++) {
//        [arr addObject:[NSString stringWithFormat:@"scene_%d",i]];
//    }
    NSString *fileName = [NSString stringWithFormat:@"scene%ld_%ld",indexPath.row, index];
//    for (NSString *fileName in arr) {
          NSString *pathString = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
        if (pathString != nil)
        {
            NSData *data = [NSData dataWithContentsOfFile:pathString];
            
            NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSDictionary *returnDic = [dataString objectFromJSONString];
            [resultArray addObject:returnDic];
            
        }else{
            NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"/Documents/Scene/%@/%@.txt",fileName,fileName]];
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            if (data ) {
                NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                NSDictionary *returnDic = [dataString objectFromJSONString];
                [resultArray addObject:returnDic];
            }
            
            
        }
//    }
    return [resultArray mutableCopy];
}

- (void)parseDic:(NSMutableArray *)arr
{
//    NSArray *sceneAll = [dic objectForKey:@"scene_all_type"];
//    for (NSDictionary *dic in sceneAll) {
//        NSLog(@"dic = %@",dic);
//        NSArray *sceneArray = [dic objectForKey:@"scene"];
        for (NSDictionary *sceneDic in arr) {
            SceneModel *sceneModel = [[SceneModel alloc] init];
            NSDictionary *scene = [sceneDic objectForKey:@"scene_frame"];
            NSArray *frameCenter = [scene objectForKey:@"frame_center"];
            NSArray *imageCenter = [scene objectForKey:@"image_center"];
            sceneModel.frameCenter = CGPointMake(((NSNumber *)frameCenter.firstObject).floatValue, ((NSNumber *)frameCenter.lastObject).floatValue);
            sceneModel.imageCenter = CGPointMake(((NSNumber *)imageCenter.firstObject).floatValue, ((NSNumber *)imageCenter.lastObject).floatValue);
            sceneModel.imageWidth = ((NSNumber *)[scene objectForKey:@"imageWidth"]).floatValue;
            sceneModel.imageHeight = ((NSNumber *)[scene objectForKey:@"imageHeight"]).floatValue;
            sceneModel.frameWidth = ((NSNumber *)[scene objectForKey:@"width"]).floatValue;
            sceneModel.frameHeight = ((NSNumber *)[scene objectForKey:@"height"]).floatValue;
            sceneModel.frameAngle = ((NSNumber *)[scene objectForKey:@"angle"]).floatValue;
            sceneModel.backgroundImageName = [sceneDic objectForKey:@"filter_bg"];
            sceneModel.acvFilterName = [sceneDic objectForKey:@"filter_acv"];
            
            TextureModel *noiseTexture = [[TextureModel alloc] init];
            NSMutableArray *textureArray = [[NSMutableArray alloc] init];
            //noise filter (GPUImageScreenFilter)
            NSDictionary *noiseCfg = [sceneDic objectForKey:@"filter_noise"];
            noiseTexture.filterType = ((NSNumber *)[noiseCfg objectForKey:@"type"]).unsignedIntegerValue;
            noiseTexture.textureImageName = [noiseCfg objectForKey:@"image"];
            [textureArray addObject:noiseTexture];
            
            //frame (GPUImageChromkeyFilter)
            NSDictionary *chromKeyCfg = [sceneDic objectForKey:@"filter_frame"];
            TextureModel *chromKey = [[TextureModel alloc] init];
            chromKey.filterType = ((NSNumber *)[chromKeyCfg objectForKey:@"type"]).unsignedIntegerValue;
            chromKey.textureImageName = [chromKeyCfg objectForKey:@"image"];
            NSArray *rect = [chromKeyCfg objectForKey:@"frame"];
            chromKey.chromKeyRect = CGRectMake(((NSNumber *)rect[0]).floatValue, ((NSNumber *)rect[1]).floatValue, ((NSNumber *)rect[2]).floatValue, ((NSNumber *)rect[3]).floatValue);
            [textureArray addObject:chromKey];
            
            //blur setting
            CGFloat blurValue = ((NSNumber *)[sceneDic objectForKey:@"zh_blur"]).floatValue;
            sceneModel.blurValue = blurValue;
            
            //lookup setting
            sceneModel.lookupImageName = [sceneDic objectForKey:@"filter_lookup"];
            
            // texture setting
            NSArray *blendTextureArray = [sceneDic objectForKey:@"filter_texture"];
            for (NSDictionary *textureCfg in blendTextureArray) {
                TextureModel *blendTexture = [[TextureModel alloc] init];
                blendTexture.textureImageName = [textureCfg objectForKey:@"image"];
                blendTexture.filterType = ((NSNumber *)[textureCfg objectForKey:@"type"]).unsignedIntegerValue;
                [textureArray addObject:blendTexture];
            }
            sceneModel.textureConfigArray = [textureArray mutableCopy];
            NSLog(@"sceneModel =                                                                                                                                                                                                                                                                                                                                                                                                                                                      %@",sceneModel.textureConfigArray);
            [self.cfgArray addObject:sceneModel];
        }
        //        sceneModel.
//    }
    NSLog(@"cfgArray = %@",self.cfgArray);
}

/*
 1. gauss
 2. screenblend
 3. lookup
 4. transform
 5. chromkey
 6. overlay
 7. multiply
 8. hardlight
 9. softlight
 10.normal
 */
- (GPUImageOutput <GPUImageInput> *)setFilter:(GPUImageOutput <GPUImageInput> *)filter withType:(NSUInteger)type
{
    switch (type) {
        case 0:
            NSLog(@"GPUImageFilter");
            return [[GPUImageFilter alloc] init];
        case 1:
            NSLog(@"Gaussian");
            return [[GPUImageGaussianBlurFilter alloc] init];
            //            break;
        case 2:
            NSLog(@"ScreenBlend");
            return [[GPUImageScreenBlendFilter alloc] init];
            //            break;
        case 3:
            NSLog(@"Lookup");
            return [[GPUImageLookupFilter alloc] init];
            break;
        case 4:
            NSLog(@"Transform");
            return [[GPUImageTransformFilter alloc] init];
            //            break;
        case 5:
            NSLog(@"ChromaKeyBlend");
            return [[GPUImageChromaKeyBlendFilter alloc] init];
            //            break;
        case 6:
            NSLog(@"Overlay");
            return [[GPUImageOverlayBlendFilter alloc] init];
            //            break;
        case 7:
            NSLog( @"Multiply");
            return [[GPUImageMultiplyBlendFilter alloc] init];
            //            break;
        case 8:
            NSLog(@"HardLight");
            return [[GPUImageHardLightBlendFilter alloc] init];
            //            break;
        case 9:
            NSLog(@"SoftLight");
            return [[GPUImageSoftLightBlendFilter alloc] init];
        case 10:
            NSLog(@"Normal");
            return [[GPUImageNormalBlendFilter alloc] init];
        default:
            break;
    }
    return nil;
}



- (void)initFilterWithIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index oriImage:(UIImage *)image
{
//    self.previewView = nil;
//    [self.previewView removeFromSuperview];
    [self.cfgArray removeAllObjects];
    [self.sceneArray removeAllObjects];
    self.sceneArray = [self getCfgArrayWithIndexpath:indexpath index:index];
    //    NSLog(@"cfgDic = %@",_cfgDictionary);
    if (self.sceneArray.count < 1) {
        NSLog(@"fileNotFound");
        return;
    }
    [self parseDic:self.sceneArray];
    @autoreleasepool {
        [self.pictureArray removeAllObjects];
        [self.filterArray removeAllObjects];
        [self.oriImage removeAllTargets];
        self.screenTexture = nil;
        self.lookupPicture = nil;
        
//        NSLog(@"type = %lu",type);
        SceneModel *scene = self.cfgArray.firstObject;
        if (!self.previewView) {
            if (scene.frameWidth > 5 && scene.frameHeight >5) {
                self.previewView = [[GPUImageView alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width
                                                                                   * scene.frameWidth / kSceneWidth, self.bounds.size.width
                                                                                   * scene.frameHeight / kSceneWidth)];
            }else{
                CGFloat width,height;
                if (image.size.width > image.size.height) {
                    width = 1.0;
                    height = 3.0/4.0;
                }else{
                    height = 1.0;
                    width =  3.0 / 4.0;
                }
                self.previewView = [[GPUImageView alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width * width, self.bounds.size.height * height)];
            }
            
            [self.imageView addSubview:self.previewView];
        }else{
            self.previewView.hidden = YES;
            self.previewView.transform = CGAffineTransformIdentity;
            [self.previewView setFrame:CGRectMake(0, 0, self.bounds.size.width
                                                 * scene.frameWidth / kSceneWidth, self.bounds.size.width
                                                  * scene.frameHeight / kSceneWidth)];
            
            if (scene.frameWidth > 5 && scene.frameHeight >5) {
                [self.previewView setFrame:CGRectMake(0, 0, self.bounds.size.width
                                                                                   * scene.frameWidth / kSceneWidth, self.bounds.size.width
                                                                                   * scene.frameHeight / kSceneWidth)];
            }else{
                CGFloat width,height;
                if (image.size.width > image.size.height) {
                    width = 1.0;
                    height = 3.0/4.0;
                }else{
                    height = 1.0;
                    width =  3.0 / 4.0;
                }
                [self.previewView setFrame:CGRectMake(0, 0, self.bounds.size.width * width, self.bounds.size.height * height)];
            }
            
            
        }
        NSString *backImageName = scene.backgroundImageName;
        if (![backImageName isEqualToString:@"null"]) {
            UIImage *image = [self imageWithIndexpath:indexpath index:index imageName:backImageName];
//            if (image) {
                self.imageView.image = image;
//            }
        }
 
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.previewView setBackgroundColorRed:1.0 green:1.0 blue:1.0 alpha:0.0];
            self.previewView.backgroundColor = [UIColor clearColor];
            //    self.previewView.frame = CGRectMake(0, 0, (int)self.view.bounds.size.width
            //                                        * scene.imageWidth / kSceneWidth, (int)self.view.bounds.size.width
            //                                        * scene.imageHeight / kSceneWidth);
            NSLog(@"self.preview.frame = %@",NSStringFromCGRect(self.previewView.frame));
            self.previewView.center = CGPointMake(scene.frameCenter.x * self.imageView.frame.size.width, scene.frameCenter.y * self.imageView.frame.size.height);
            self.imageView.image = [self imageWithIndexpath:indexpath index:index imageName:scene.backgroundImageName];
//            self.imageView.image = [UIImage imageNamed:scene.backgroundImageName];
            self.oriImage = [[GPUImagePicture alloc] initWithImage:image];
            
            NSLog(@"angle = %f",M_PI_2);
            self.previewView.transform = CGAffineTransformRotate(self.previewView.transform, scene.frameAngle * M_PI / 180 );
            
            NSArray *textureArray = scene.textureConfigArray;
            //noise filter
            TextureModel *noiseModel = textureArray[0];
            UIImage *noiseImage = nil;
            if (![noiseModel.textureImageName isEqualToString:@"null"]) {
                noiseImage = [self imageWithIndexpath:indexpath index:index imageName:noiseModel.textureImageName];
//                noiseImage =  [UIImage imageNamed:noiseModel.textureImageName];
                NSUInteger type = noiseModel.filterType;
                self.noiseFilter = [self setFilter:self.noiseFilter withType:type];
            }else{
                self.noiseFilter = [self setFilter:self.noiseFilter withType:0];
            }
            [self.oriImage addTarget:self.noiseFilter atTextureLocation:0];
            if (noiseImage) {
                self.screenTexture = [[GPUImagePicture alloc] initWithImage:noiseImage];
                [self.screenTexture addTarget:self.noiseFilter atTextureLocation:1];
                [self.screenTexture processImage];
            }
            
            //gauss
            self.gaussianFIlter = [[GPUImageGaussianBlurFilter alloc] init];
            [self.noiseFilter addTarget:self.gaussianFIlter atTextureLocation:0];
            //    [self.gaussianFIlter setBlurPasses:2];
            [self.gaussianFIlter setBlurRadiusInPixels:scene.blurValue];
            
            self.lookupFilter = [[GPUImageLookupFilter alloc] init];
            NSLog(@"lookupImageName = %@",scene.lookupImageName);
//            self.lookupPicture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:scene.lookupImageName]];
            self.lookupPicture = [[GPUImagePicture alloc] initWithImage:[self imageWithIndexpath:indexpath index:index imageName:scene.lookupImageName]];
            [self.gaussianFIlter addTarget:self.lookupFilter atTextureLocation:0];
            [self.lookupPicture addTarget:self.lookupFilter atTextureLocation:1];
            [self.lookupPicture processImage];
            //     [self.oriImage processImage];
            
            //transform
            self.transformFilter = [[GPUImageTransformFilter alloc] init];
            NSString *acvFileName = scene.acvFilterName;
            if (![acvFileName isEqualToString:@"null"]) {
                self.acvFilter = [[GPUImageToneCurveFilter alloc] initWithACV:acvFileName];
                [self.lookupFilter addTarget:self.acvFilter];
                [self.acvFilter addTarget:self.transformFilter];
            }else{
                [self.lookupFilter addTarget:self.transformFilter];
            }
            
            //noise filter
            for (int i = 1; i < textureArray.count; i++) {
                TextureModel *frameModel = textureArray[i];
                UIImage *textureImage = nil;
                GPUImageOutput <GPUImageInput> *filter = nil;
                GPUImagePicture *texture = nil;
                if (![frameModel.textureImageName isEqualToString:@"null"]) {
//                    textureImage =  [UIImage imageNamed:frameModel.textureImageName];
                    textureImage = [self imageWithIndexpath:indexpath index:index imageName:frameModel.textureImageName];
                    NSUInteger type = frameModel.filterType;
                    NSLog(@"%lu",frameModel.filterType);
                    filter = [self setFilter:filter withType:type];
                }else{
                    filter =  [self setFilter:filter withType:0];
                }
                
                //        [self.transformFilter addTarget:self.filter1];
                if (textureImage) {
                    texture = [[GPUImagePicture alloc] initWithImage:textureImage];
                    if (i == 1) {
                        NSLog(@"textureName = %@",frameModel.textureImageName);
                        [((GPUImageChromaKeyBlendFilter *)filter) setColorToReplaceRed:0 green:1 blue:0];
                        [texture addTarget:filter atTextureLocation:0];
                        [self.transformFilter addTarget:filter atTextureLocation:1];
                        //                [texture processImage];
                    }else{
                        [(GPUImageOutput <GPUImageInput> *)self.filterArray.lastObject addTarget:filter atTextureLocation:0];
                        [texture addTarget:filter atTextureLocation:1];
                    }
                    [texture processImage];
                    [self.pictureArray addObject:texture];
                }else{
                    if (i == 1) {
                        [self.transformFilter addTarget:filter atTextureLocation:0];
                    }else{
                        [(GPUImageOutput <GPUImageInput> *)self.filterArray.lastObject addTarget:filter atTextureLocation:0];
                    }
                }
                [self.filterArray addObject:filter];
            }
            NSLog(@"filterArray = %@",self.filterArray);
            [(GPUImageOutput <GPUImageInput> *)self.filterArray.lastObject addTarget:self.previewView];
//            [self.lookupFilter addTarget:self.previewView];
                [self.oriImage processImageWithCompletionHandler:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                         self.previewView.center = CGPointMake(scene.frameCenter.x * self.imageView.frame.size.width, scene.frameCenter.y * self.imageView.frame.size.height);
                        self.previewView.hidden = NO;
                    });
                }];
        });
    }
//    [self.acvFilter addTarget:self.previewView];
}

- (UIImage *)imageWithIndexpath:(NSIndexPath *)indexpath index:(NSInteger)index imageName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    if (!image){
        NSString *filePath = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/Scene/scene%ld_%ld/%@",indexpath.row,index,imageName]];
        image = [UIImage imageWithContentsOfFile:filePath];
    }
    return image;
}

- (void)resetPreviewFrame
{
    self.frame = CGRectMake(0, 0, windowWidth(), windowWidth());
}

- (void)swipePage:(UISwipeGestureRecognizer *)recognizer
{
    NSLog(@"swipe");
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        
        //先加载数据，再加载动画特效
        
//        [self nextQuestion];
        
//        recognizer.view.frame = CGRectMake(320, 0, 320, 480);
        
        [UIView beginAnimations:@"animationID"context:nil];
        
        [UIView setAnimationDuration:0.3f];
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        
        [UIView setAnimationRepeatAutoreverses:NO];
        
        recognizer.view.frame = CGRectMake(-windowWidth(), 0, windowWidth(), windowWidth());
        
        [UIView commitAnimations];
        
    }
}

- (CropStyle)cropStyleWithIndexPath:(NSIndexPath *)indexpath index:(NSInteger)index
{
    [self.cfgArray removeAllObjects];
    [self.sceneArray removeAllObjects];
    self.sceneArray = [self getCfgArrayWithIndexpath:indexpath index:index];
    //    NSLog(@"cfgDic = %@",_cfgDictionary);
    [self parseDic:self.sceneArray];
    if (index < self.cfgArray.count) {
        SceneModel *scene = self.cfgArray[index];
        if (scene.frameWidth > scene.frameHeight) {
            return CropStyleSquareness3;
        }else if (scene.frameHeight > scene.frameWidth){
            return CropStyleSquareness4;
        }else{
            return CropStyleFree;
        }
    }
    return CropStyleFree;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
