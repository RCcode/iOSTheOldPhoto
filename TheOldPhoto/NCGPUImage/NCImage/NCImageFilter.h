#import "GPUImageTwoInputFilter.h"
#import "GPUImageContext.h"
@class NCImageFilter;

@protocol NCImageFilterDelegate <NSObject>

@optional
//图片渲染完成 
- (void)imageFilterdidFinishRender:(NCImageFilter *)imageFilter;
@end


@interface NCImageFilter : GPUImageTwoInputFilter {
    GLuint filterSourceTexture3, filterSourceTexture4, filterSourceTexture5, filterSourceTexture6;
}

@property (nonatomic, weak) id<NCImageFilterDelegate> delegate;

@end
