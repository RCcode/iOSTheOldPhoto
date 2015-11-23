
#import "GPUImage.h"
#import "NCFilters.h"
#import "NCImageFilter.h"
#import "IFBrightContSatTemperFilter.h"
#import "FC_FogCircleFilter.h"
#import "FC_FogRectangularFilter.h"
//#import "PhotoModel.h"

@class NCVideoCamera;

typedef void(^FilterCompletionBlock) (UIImage *filterImage);

@protocol IFVideoCameraDelegate <NSObject>
@optional
- (void)filterFinished;
- (void)videoCameraResultImage:(UIImage *)image;
- (void)videoCameraType:(NSNumber *)type;
@end

@protocol NCThumbnailImageDelegate <NSObject>

- (void)videoCameraThumbImage:(UIImage *)image andIndex:(NSInteger)index;

@end

@interface NCVideoCamera : NSObject

@property (strong, readonly) GPUImageView *gpuImageView;
@property (strong, readonly) GPUImageView *gpuImageView_HD;

@property (nonatomic, assign) CGFloat widthRatio;
@property (nonatomic, assign) CGFloat heightRatio;
@property (nonatomic, strong) UIImage *rawImage;
@property (nonatomic, assign) id<IFVideoCameraDelegate> delegate;
@property (nonatomic, assign) id<NCThumbnailImageDelegate> thumbDelegate;
@property (nonatomic, unsafe_unretained, readonly) BOOL isRecordingMovie;
@property (nonatomic, strong) GPUImageFilter *effectFilter;
@property (nonatomic, strong) FC_FogCircleFilter *circleBlurFilter;
@property (nonatomic, strong) FC_FogRectangularFilter *rectangularFilter;
@property (nonatomic, strong) GPUImageBrightnessFilter *briFilter;
@property (nonatomic, strong) GPUImageCropFilter *cropFilter;
@property (nonatomic, strong) GPUImageFilter *filter;
@property (nonatomic, strong) GPUImageBrightnessFilter *brihtnessFilter;
@property (nonatomic, strong) GPUImageTwoInputFilter *blendFilter;
@property (nonatomic, strong) GPUImageTwoInputFilter *blendFilter2;
@property (nonatomic, strong) GPUImageTwoInputFilter *blendFilter3;
@property (nonatomic, assign) NSInteger brightnessShowValue;

//effect
@property (nonatomic, assign) CGFloat brightnessValue;
@property (nonatomic, assign) CGFloat saturationValue;
@property (nonatomic, assign) CGFloat contrastValue;
@property (nonatomic, assign) CGFloat colorTemperatureValue;
@property (nonatomic, assign) CGFloat vignetteValue;

//rect blur
@property (nonatomic, assign) CGFloat topFocusLevel;
@property (nonatomic, assign) CGFloat bottomFocusLevel;
@property (nonatomic, assign) CGFloat focusFallOffRate;
@property (nonatomic, assign) CGFloat angleRate;

//circle blur
@property (nonatomic, assign) CGPoint excludeCirclePoint;
@property (nonatomic, assign) CGFloat excludeBlurSize;
@property (nonatomic, assign) CGFloat excludeCircleRadius;


@property (nonatomic, assign) BOOL isUseCircleBlur;
@property (nonatomic, assign) BOOL isUseRectangular;
@property (nonatomic, assign) BOOL isResultImage;
@property (nonatomic, assign) BOOL isSupportVignette;
@property (nonatomic, assign) CGFloat multiple;
@property (nonatomic, assign) CGRect cropRect;
@property (nonatomic, assign) GPUImageRotationMode ori;
@property (nonatomic, strong) NSDictionary *cfgDic;
@property (nonatomic, strong) NSMutableArray *cfgArray;
@property (nonatomic, assign) BOOL hasVig;
/**
 *  addSubView展示即可
 */
//@property (strong, nonatomic) GPUImageView *gpuImageView;

//- (id)initWithSessionPreset:(NSString *)sessionPreset cameraPosition:(AVCaptureDevicePosition)cameraPosition highVideoQuality:(BOOL)isHighQuality WithFrame:(CGRect)frame;

- (id)initWIthFrame:(CGRect )frame;

- (id)initWithImage:(UIImage *)newImageSource;


/**
 *  选择不同的滤镜类型
 */
- (void)switchFilterType:(NCFilterType)type;
- (void)switchRatio:(NSInteger)type;
- (void)switchFilterWithLookupImage:(NSString *)imageName;
/**
 *  快速实例化对象
 *
 *  @param frame    gpuImageView的frame
 *  @param rawImage 需要进行滤镜处理的image对象
 */
+ (instancetype)videoCameraWithFrame:(CGRect)frame Image:(UIImage *)rawImage;
+ (instancetype)videoCameraWithGPUImageView:(GPUImageView *)view videoCamera:(GPUImageStillCamera *)videocamera;
+ (instancetype)videoCameraWithGPUImageView:(GPUImageView *)view rawImage:(UIImage *)image;
- (void)switchFilter:(NCFilterType)type WithCompletionBlock:(FilterCompletionBlock)completion;

- (void)setBrightnessParams:(CGFloat)value;
- (void)updateBrightnessFilterParams:(CGFloat)value;

@end
