

#import "NCFilters.h"
#import "UIDevice+DeviceInfo.h"
#import "IFBrightContSatTemperFilter.h"
#import "GPUImageMirrorLookupFilter.h"
//#import "FilterDataUtil.h"
#import "UIImage+SNImage.h"

@interface NCVideoCamera () <NCImageFilterDelegate>
{
    //滤镜处理完成之后的回调
    FilterCompletionBlock _filterCompletionBlock;
    NSInteger _index;
}


@property (nonatomic, strong) GPUImagePicture *sourcePicture1;
@property (nonatomic, strong) GPUImagePicture *sourcePicture2;
@property (nonatomic, strong) GPUImagePicture *mirrorPicture1;
@property (nonatomic, strong) GPUImagePicture *mirrorPicture2;
@property (nonatomic, strong) GPUImagePicture *mirrorPicture3;
@property (nonatomic, strong) GPUImagePicture *mirrorPicture4;

@property (nonatomic, strong) GPUImageFilter *internalFilter;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture1;
@property (nonatomic, strong) GPUImagePicture *internalSourcePicture2;
@property (nonatomic, strong) GPUImagePicture *internalMirrorPicture1;
@property (nonatomic, strong) GPUImagePicture *internalMirrorPicture2;
@property (nonatomic, strong) GPUImagePicture *internalMirrorPicture3;
@property (nonatomic, strong) GPUImagePicture *internalMirrorPicture4;
@property (nonatomic, strong) GPUImageMirrorLookupFilter *mirrorLookup1;
@property (nonatomic, strong) GPUImageMirrorLookupFilter *mirrorLookup2;
@property (nonatomic, strong) GPUImageMirrorLookupFilter *mirrorLookup3;
@property (nonatomic, strong) GPUImageMirrorLookupFilter *mirrorLookup4;

@property (nonatomic, strong) GPUImagePicture *blendPicture;



//@property (nonatomic, strong) GPUImageMultiplyBlendFilter *vignetteBlendFilter;

@property (strong, readwrite) GPUImageView *gpuImageView;

@property (nonatomic, strong) GPUImageFilter *rotationFilter;
@property (nonatomic, unsafe_unretained) NCFilterType currentFilterType;

@property (nonatomic, strong) GPUImageOutput *stillImageSource;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic, unsafe_unretained, readwrite) BOOL isRecordingMovie;
@property (nonatomic, strong) AVAudioRecorder *soundRecorder;
@property (nonatomic, strong) AVMutableComposition *mutableComposition;
@property (nonatomic, strong) AVAssetExportSession *assetExportSession;

@property (nonatomic ,strong) UIImage *resultImage;
@property (nonatomic, strong) NSArray *oriImages;
@property (nonatomic, strong) NSArray *typesArr;

@end

@implementation NCVideoCamera

@synthesize filter;
@synthesize sourcePicture1;
@synthesize sourcePicture2;
@synthesize mirrorPicture1;
@synthesize mirrorPicture2;
@synthesize mirrorPicture3;
@synthesize mirrorPicture4;

@synthesize internalFilter;
@synthesize internalSourcePicture1;
@synthesize internalSourcePicture2;
@synthesize internalMirrorPicture1;
@synthesize internalMirrorPicture2;
@synthesize internalMirrorPicture3;
@synthesize internalMirrorPicture4;


@synthesize gpuImageView;
@synthesize gpuImageView_HD;
@synthesize rotationFilter;
@synthesize currentFilterType;
@synthesize rawImage;
@synthesize stillImageSource;

@synthesize stillImageOutput;

@synthesize delegate;
@synthesize thumbDelegate;

@synthesize movieWriter;
@synthesize isRecordingMovie;
@synthesize soundRecorder;
@synthesize mutableComposition;
@synthesize assetExportSession;

GLfloat mirrorVertices[] = {-1.0f, 1.0f, 0.0f, 1.0f, -1.0f,  -1.0f, 0.0f,  -1.0f};
GLfloat mirrorVertices2[] = {1.0f, 1.0f, 0.0f, 1.0f,1.0f,  -1.0f, 0.0f,  -1.0f};
GLfloat mirrorCoor[] = {  0.25f, 1.0f,0.75f, 1.0f,0.25f, 0.0f,0.75f, 0.0f};
GLfloat mirrorCoor2[] = {  0.75f, 1.0f,0.25f, 1.0f,0.75f, 0.0f,0.25f, 0.0f};

GLfloat mirrorVertices_h[] = {-1.0f, 0.0f, 1.0f, 0.0f, -1.0f, -1.0f ,1.0f, -1.0f};
GLfloat mirrorVertices2_h[] = {-1.0f, -0.0f, 1.0f, -0.0f, -1.0f, 1.0f, 1.0f, 1.0f};
GLfloat mirrorCoor_h[] = {0.0f, 0.75f, 1.0f, 0.75f, 0.0f, 0.25f, 1.0f, 0.25f};
GLfloat mirrorCoor_h2[] = {0.0f, 0.25f, 1.0f, 0.25f, 0.0f, 0.75f, 1.0f, 0.75f};

GLfloat mirrorVertices_q[] = {-1.0f, 0.0f, 0.0f, 0.0f,-1.0f, -1.0f, 0.0f, -1.0f };
GLfloat mirrorVertices2_q[] = {1.0f, 0.0f, 0.0f, 0.0f,1.0f, -1.0f, 0.0f, -1.0f};
GLfloat mirrorVertices3_q[] = {-1.0f, 0.0f, 0.0f, 0.0f, -1.0f, 1.0f, 0.0f, 1.0f};
GLfloat mirrorVertices4_q[] = {1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 1.0f, 0.0f, 1.0f};
GLfloat mirrorCoor_q[] = {0.25f, 0.75f, 0.75f, 0.75f, 0.25f, 0.25f, 0.75f, 0.25f};
GLfloat mirrorCoor_q2[] = {0.25f, 0.25f, 0.75f, 0.25f, 0.25f, 0.75f, 0.75f, 0.75f};

- (CGRect)getRectWithWidthRatio:(CGFloat)widthRatio andHeightRatio:(CGFloat)heightRatio
{
    CGRect rect = CGRectZero;
    if ((widthRatio / heightRatio) >= (3.0f/4.0f)) {
        rect = CGRectMake(0, (1.0f - (3.0f/4.0f) * (heightRatio/widthRatio)) / 2.0f, 1, (3.0f/4.0f) * (heightRatio/widthRatio));
    }else{
        rect = CGRectMake((1.0f - (4.0f/3.0f)*(widthRatio / heightRatio)) / 2.0f, 0, (4.0f/3.0f)*(widthRatio / heightRatio), 1);
    }
    NSLog(@"rect = %@",NSStringFromCGRect(rect));
    return rect;
}

#pragma mark - Switch Filter
- (void)switchToNewFilter {
    if (self.stillImageSource == nil) {
        self.filter = self.internalFilter;
    } else {
        [self.brihtnessFilter removeAllTargets];
        [self.cropFilter removeAllTargets];
        [self.stillImageSource removeAllTargets];
        [self.cropFilter setCropRegion:_cropRect];
        self.filter = self.internalFilter;
        [self.stillImageSource addTarget:self.brihtnessFilter];
        [self.brihtnessFilter addTarget:self.cropFilter];
        [self.brihtnessFilter setBrightness:_brightnessValue];
        
    }
    if ([self.delegate respondsToSelector:@selector(videoCameraResultImage:)]) {
        self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatio;
        [[self getCaptureFilter] useNextFrameForImageCapture];
        [((GPUImagePicture *)self.stillImageSource) processImageWithCompletionHandler:^{
            
            UIImage *image = [[self getCaptureFilter] imageFromCurrentFramebuffer];
            [self.delegate videoCameraResultImage:image];
        }];
    }else{
        if ([self.stillImageSource isKindOfClass:[GPUImagePicture class]]) {
            self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatio;
            [((GPUImagePicture *)self.stillImageSource) processImage];
        }
        
    }
    //    self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    if ([self.delegate respondsToSelector:@selector(filterFinished)]) {
        [self.delegate filterFinished];
    }
}

- (void)forceSwitchToNewFilter:(NCFilterType)type {
    //    FilterDataUtil *dataUtil = [FilterDataUtil defaultDateUtil];
    //    if (type != NC_NORMAL_FILTER && [self.stillImageSource isKindOfClass:[GPUImageStillCamera class]]) {
    //        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:(NSInteger)type] forKey:kLastFilterType];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //    }
    currentFilterType = type;
    NSLog(@"%lu",type);
    self.internalSourcePicture1 = nil;
    self.internalSourcePicture2 = nil;
    self.internalMirrorPicture1 = nil;
    self.internalMirrorPicture2 = nil;
    self.internalMirrorPicture3 = nil;
    self.blendFilter = nil;
    
    self.internalFilter = [[GPUImageLookupFilter alloc] init];
    
    NSString *filterCfg = nil;
    NSString *lookupImageName = nil;
    NSString *blendImageName = nil;
    NSString *vignetteImageName = nil;
    
    switch (type) {
        case RC_FILTER_NOW:
        {
            self.internalFilter = [[GPUImageFilter alloc] init];
        }
            break;
    }
    [self performSelectorOnMainThread:@selector(switchToNewFilter) withObject:nil waitUntilDone:NO];
}


- (void)switchFilterWithLookupImage:(NSString *)imageName
{
    self.internalSourcePicture1 = nil;
    self.internalSourcePicture2 = nil;
    self.internalMirrorPicture1 = nil;
    self.internalMirrorPicture2 = nil;
    self.internalMirrorPicture3 = nil;
    if (imageName) {
        self.internalFilter = [[GPUImageLookupFilter alloc] init];
        self.internalSourcePicture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:imageName]];
    }else{
        self.internalFilter = [[GPUImageFilter alloc] init];
    }
    [self switchToNewFilter];
}

- (void)switchFilterTypes:(NSArray *)types withImage:(UIImage *)image
{
    _index = 0;
    self.typesArr = types;
    currentFilterType = ((NSNumber *)[types objectAtIndex:_index]).intValue;
    self.rawImage = image;
    [self switchFilterType:currentFilterType];
    
}

- (void)switchFilterType:(NCFilterType)type {
    _brightnessValue = 0.0f;
    [self performSelector:@selector(forceSwitchToNewFilterAfterDelay:) withObject:[NSNumber numberWithInt:type] afterDelay:0.0f];
}

//- (void)switchRatio:(NSInteger )type
//{
//    switch (type) {
//        case kPhotoRatio1:
//        {
//            _cropRect = CGRectMake(0.f, 0.125f, 1.0f, 0.75f);
//            self.gpuImageView.fillMode = kGPUImageFillModePreserveAspectRatio;
//        }
//            break;
//        case kPhotoRatio2:
//        {
//            _cropRect = CGRectMake(0.f, 0.f, 1.f, 1.f);
//            self.gpuImageView.fillMode = kGPUImageFillModeStretch;
//        }
//            break;
//        case kPhotoRatio3:
//        {
//            if (windowHeight() == 480 || windowHeight() == 1024) {
//                _cropRect = CGRectMake(1.0f/9.0f/2, 0.f, 8.0f/9.0f, 1.f);
//            }else{
//                _cropRect = CGRectMake(0.125f, 0.f, 0.75f, 1.f);
//            }
//            self.gpuImageView.fillMode = kGPUImageFillModeStretch;
//        }
//            break;
//        default:
//        {
//            _cropRect = CGRectMake(0.f, 0.f, 1.f, 1.f);
//            self.gpuImageView.fillMode = kGPUImageFillModeStretch;
//        }
//            break;
//    }
//    [self.cropFilter setCropRegion:_cropRect];
//    //    [self performSelector:@selector(forceSwitchToNewFilterAfterDelay:) withObject:[NSNumber numberWithInt:currentFilterType] afterDelay:0.0f];
//    
//}

- (void)forceSwitchToNewFilterAfterDelay:(NSNumber *)type
{
    [self forceSwitchToNewFilter:(NCFilterType)type.intValue];
}

- (id)initWIthFrame:(CGRect)frame
{
    if (!(self = [super init])) {
        return nil;
    }
    self.filter = [[GPUImageFilter alloc] init];
    self.internalFilter = self.filter;
    gpuImageView = [[GPUImageView alloc] initWithFrame:frame];
    gpuImageView.layer.contentsScale = 2.0f;
    [filter addTarget:gpuImageView];
    
    return self;
}

- (id)initWithGPUImageView:(GPUImageView *)view
{
    if (!(self = [super init])) {
        return nil;
    }
    //circle blur
    self.excludeCircleRadius = 60.0/320.0;
    self.excludeCirclePoint = CGPointMake(0.5f, 0.5f);
    self.excludeBlurSize = 30.0/320.0;
    //rect blur
    self.topFocusLevel = 0.4;
    self.bottomFocusLevel = 0.6;
    self.focusFallOffRate = 0.2;
    self.angleRate = 0.0;
    //effect
    self.brightnessValue = 0;
    self.contrastValue = 1;
    self.saturationValue = 0;
    self.colorTemperatureValue = 0;
    self.vignetteValue = 0.3;
    
    self.filter = [[GPUImageFilter alloc] init];
    self.internalFilter = self.filter;
    
    self.gpuImageView = view;
    [self.filter addTarget:self.gpuImageView];
    return self;
}

- (id)initWithImage:(UIImage *)newImageSource
{
    if (self = [super init]) {
        self.rawImage = newImageSource;
    }
    return self;
}

+ (instancetype)videoCameraWithFrame:(CGRect)frame Image:(UIImage *)rawImage{
    
    NCVideoCamera *instance = [[[self class] alloc]initWIthFrame:frame];
    
    instance.rawImage = rawImage;
    
    return instance;
}

+ (instancetype)videoCameraWithGPUImageView:(GPUImageView *)view rawImage:(UIImage *)image
{
    NCVideoCamera *instance = [[[self class] alloc] init];
    //    instance.cfgDic = getEurFilterConfig();
    //    instance.hasVig = NO;
    //    instance.cfgArray = [instance.cfgDic objectForKey:@"filter_configs"];
    //    instance.filter = [[GPUImageFilter alloc] init];
    //    instance.cropFilter = [[GPUImageCropFilter alloc] init];
    //    instance.cropRect = CGRectMake(0.f, 0.f, 1.f, 1.f);
    //    instance.brihtnessFilter = [[GPUImageBrightnessFilter alloc] init];
    //    [instance.brihtnessFilter setBrightness:0.f];
    //    [instance.cropFilter setCropRegion:instance.cropRect];
    //    view.fillMode = kGPUImageFillModePreserveAspectRatio;
    //    instance.stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
    //    instance.gpuImageView = view;
    //    [instance.stillImageSource addTarget:instance.brihtnessFilter];
    //    [instance.brihtnessFilter addTarget:instance.filter];
    //    [instance.filter addTarget:instance.gpuImageView];
    //    [((GPUImagePicture *)instance.stillImageSource) processImage];
    return instance;
}

+ (instancetype)videoCameraWithGPUImageView:(GPUImageView *)view videoCamera:(GPUImageStillCamera *)stillCamera;
{
    NCVideoCamera *instance = [[[self class] alloc]init];
//    instance.cfgDic = getEurFilterConfig();
//    instance.hasVig = NO;
//    instance.cfgArray = [instance.cfgDic objectForKey:@"filter_configs"];
//    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    instance.filter = [[GPUImageFilter alloc] init];
//    instance.cropFilter = [[GPUImageCropFilter alloc] init];
//    instance.cropRect = CGRectMake(0.f, 0.f, 1.f, 1.f);
//    instance.brihtnessFilter = [[GPUImageBrightnessFilter alloc] init];
//    [instance.brihtnessFilter setBrightness:0.f];
//    [instance.cropFilter setCropRegion:instance.cropRect];
//    view.fillMode = kGPUImageFillModeStretch;
//    instance.stillImageSource = stillCamera;
//    instance.gpuImageView = view;
//    [instance.stillImageSource addTarget:instance.brihtnessFilter];
//    [instance.brihtnessFilter addTarget:instance.filter];
//    [instance.filter addTarget:instance.gpuImageView];
    return instance;
}

- (void)switchFilter:(NCFilterType)type WithCompletionBlock:(FilterCompletionBlock)filterCompletionBlock{
    [self switchFilterType:type];
    _filterCompletionBlock = filterCompletionBlock;
}

- (void)updateBrightnessFilterParams:(CGFloat)value
{
    CGFloat bri = _brightnessValue + value;
    if (bri > 0.5f) {
        bri = 0.5f;
    }
    if (bri < -0.5f) {
        bri = -0.5f;
    }
    self.brightnessShowValue = (bri + 0.5f) *100;
    [self.brihtnessFilter setBrightness:bri];
}

- (void)setBrightnessParams:(CGFloat)value
{
    _brightnessValue +=value;
    if (_brightnessValue > 0.5f) {
        _brightnessValue = 0.5f;
    }
    if (_brightnessValue < -0.5f) {
        _brightnessValue = -0.5f;
    }
}

- (void)updateFilter
{
    if (self.internalSourcePicture1) {
        [self.sourcePicture1 processImage];
    }
    if (self.internalSourcePicture2) {
        [self.sourcePicture2 processImage];
    }
    if (self.internalMirrorPicture1) {
        [self.mirrorPicture1 processImage];
    }
    if (self.internalMirrorPicture2) {
        [self.mirrorPicture2 processImage];
    }
    if (self.internalMirrorPicture3) {
        [self.mirrorPicture3 processImage];
    }
}

/**
 *  得到当前使用的最终滤镜对象
 *
 *  @return 滤镜对象
 */
- (GPUImageFilter *)getCaptureFilter
{
    if (self.blendFilter) {
        if ([self.blendFilter isKindOfClass:[GPUImageMultiplyBlendFilter class]]) {
            if (self.hasVig) {
                return self.blendFilter;
            }else{
                return self.filter;
            }
        }else{
            return self.blendFilter;
        }
    }
    return  self.filter;
}


@end
