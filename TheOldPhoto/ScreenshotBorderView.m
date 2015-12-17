//
//  ScreenshotBorder.m
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//

#import "ScreenshotBorderView.h"
#import "UIImage+SubImage.h"
//#import "CornerView.h"
#import "ControlBorder.h"
#import "ImageScaleUtil.h"
//#import "Defines.h"

@interface ScreenshotBorderView() <CameraApertureDelegate>

{
    //透明截图框
    CameraApertureView *_cameraAperture;
    
    //四周遮盖
    UIView *_topCover;
    UIView *_bottomCover;
    UIView *_leftCover;
    UIView *_rightCover;
    
    //srcIamge对象的尺寸
    CGSize _srcImageSize;
    
    
    
    ControlBorder *_controlBorder;
    CGPoint _center;
    
}

@end


@implementation ScreenshotBorderView

#pragma mark - setter method
- (void)setSrcImage:(UIImage *)srcImage{
    
    [self setImage:srcImage];
    self.backgroundColor = colorWithHexString(@"#f6f6f6");
    
    //初始化其它子控件
    [self setupChildViews];
}

- (void)resetSrcImage:(UIImage *)srcImage
{
    [self setImage:srcImage];
    [self setupChildViews];
    //    _imageView.image = srcImage;
    //    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}

- (void)setImage:(UIImage *)image
{
    _srcImage = image;
    
    //初始化srcImageSize
    _srcImageSize = _srcImage.size;
    
    //2448 3264
    //    NSAssert(_srcImageSize.width >= 100 && _srcImageSize.height >= 100,
    //             @"被用于截图的图片，尺寸不能小于100*100");
    
    CGFloat scale = [ImageScaleUtil getTheScaleForImageSize:_srcImageSize];
    //    CGFloat scale = [self getTheScaleForImageSize:_srcImageSize];
    
    _srcImageSize.height = _srcImageSize.height / scale;
    _srcImageSize.width = _srcImageSize.width / scale;
    
    
    CGSize size = self.frame.size;
    //等比缩放（针对大图片超出界面的情况）
    if(_srcImageSize.width > size.width){
        CGFloat scale = _srcImageSize.width / _srcImageSize.height;
        _srcImageSize.width = size.width;
        _srcImageSize.height = _srcImageSize.width / scale;
    }
    if(_srcImageSize.height > size.height){
        CGFloat scale = _srcImageSize.width / _srcImageSize.height;
        _srcImageSize.height = size.height;
        _srcImageSize.width = _srcImageSize.height * scale;
    }
    
    
    
    //初始化 borderRect
    CGSize borderSize = CGSizeMake(_srcImageSize.width - DefaultBorderSizeDiff,
                                   _srcImageSize.height - DefaultBorderSizeDiff);
    CGPoint boderOrigin = CGPointMake(DefaultBorderSizeDiff / 2,
                                      DefaultBorderSizeDiff / 2);
    
    CGRect rect = self.borderRect;
    rect.origin = boderOrigin;
    rect.size = borderSize;
    self.borderRect = rect;
}

- (void)hiddenBorderView
{
    _topCover.hidden = YES;
    _leftCover.hidden = YES;
    _rightCover.hidden = YES;
    _bottomCover.hidden = YES;
    _cameraAperture.hidden = YES;
}

- (void)showBorderView
{
    _topCover.hidden = NO;
    _leftCover.hidden = NO;
    _rightCover.hidden = NO;
    _bottomCover.hidden = NO;
    _cameraAperture.hidden = NO;
}

#pragma mark - private method

#pragma mark 初始化子控件
- (void)setupChildViews{
    
    //    _eagleContext = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    //    NSMutableDictionary *options=[[NSMutableDictionary alloc]init];
    //    [options setObject:[NSNull null] forKey:kCIContextWorkingColorSpace];
    //    [options setObject:[NSNumber numberWithBool:YES] forKey:kCIContextUseSoftwareRenderer];
    //    _ciContext = [CIContext contextWithEAGLContext:_eagleContext options:options];
    
    if(_srcImage == nil) return;
    
    //初始化imageVIew
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:(CGRect){CGPointZero, _srcImageSize}];
        [self addSubview:_imageView];
        
    }else{
        _imageView.frame = (CGRect){CGPointZero,_srcImageSize};
    }
    _imageView.center = self.center;
    _imageView.image = _srcImage;
    _imageView.userInteractionEnabled = YES;
    
    //初始化四周遮盖
    if (_topCover == nil) {
        _topCover = [[UIView alloc] init];
        _bottomCover = [[UIView alloc] init];
        _leftCover = [[UIView alloc] init];
        _rightCover = [[UIView alloc] init];
        
        [_imageView addSubview:_topCover];
        [_imageView addSubview:_bottomCover];
        [_imageView addSubview:_leftCover];
        [_imageView addSubview:_rightCover];
    }
    
    
    //初始化取景框
    if (_cameraAperture == nil) {
        _cameraAperture = [[CameraApertureView alloc] initWithFrame:_borderRect];
        [_imageView addSubview:_cameraAperture];
    }else{
        _cameraAperture.frame = _borderRect;
    }
    
    _center = _cameraAperture.center;
    _cameraAperture.delegate = self;
    
    //初始化操控边框
    if (_controlBorder == nil) {
        _controlBorder = [ControlBorder controlBorder];
        [_imageView addSubview:_controlBorder];
    }
    
    
    CGFloat margin = 15.0f;
    _controlBorder.frame = CGRectMake(_cameraAperture.frame.origin.x - margin,
                                      _cameraAperture.frame.origin.y - margin,
                                      _cameraAperture.frame.size.width + margin * 2 ,
                                      _cameraAperture.frame.size.height + margin * 2);
    //    controlBorder.frame = _cameraAperture.frame;
    
    _cameraAperture.controlBorder = _controlBorder;
    
    
    //设置遮盖背景为半透明黑色
    UIColor * background = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    _topCover.backgroundColor = background;
    _bottomCover.backgroundColor = background;
    _leftCover.backgroundColor = background;
    _rightCover.backgroundColor = background;
    
    //计算各个cover的frame
    [self cameraApertureFrameChanged:nil];
}


#pragma mark - open method

#pragma mark 快速实例化
+ (instancetype)screenshotBorderWithSrcImage:(UIImage *)srcImage{
    
    ScreenshotBorderView *instance = [[[self class] alloc] initWithFrame:(CGRect){CGPointZero, srcImage.size}];
    //初始化 srcImage
    instance.srcImage = srcImage;
    
    return instance;
}

#pragma mark 截图
- (UIImage *)subImage{
    
    //缩放比例
    CGFloat scaleX = _srcImage.size.width / _imageView.frame.size.width;
    CGFloat scaleY =  _srcImage.size.height / _imageView.frame.size.height;
    
    //    NSLog(@"scaleX = %f",scaleX);
    //    NSLog(@"scaleY = %f",scaleY);
    //    NSLog(@"_srcImage = %@",NSStringFromCGSize(_srcImage.size));
    //    NSLog(@"_imageView.frame = %@",NSStringFromCGRect(_imageView.frame));
    
    CGFloat x = _cameraAperture.frame.origin.x * scaleX;
    CGFloat y = _cameraAperture.frame.origin.y * scaleY;
    CGFloat width = _cameraAperture.frame.size.width * scaleX;
    CGFloat height = _cameraAperture.frame.size.height * scaleY;
    
    //    CIImage *inputImage = [CIImage imageWithCGImage:_srcImage.CGImage];
    //    
    //    CIFilter *saveFilter = [CIFilter filterWithName:@"CICrop"];
    //    [saveFilter setValue:inputImage forKey:kCIInputImageKey];
    //    [saveFilter setValue:[CIVector vectorWithCGRect:CGRectMake(x, y, width, height)] forKey:@"inputRectangle"];
    //    
    //    CIImage *result = [saveFilter valueForKey: kCIOutputImageKey];
    //    CGImageRef cgimage = [self.ciContext createCGImage:result fromRect:[result extent]];
    //    UIImage *returnImage = [UIImage imageWithCGImage:cgimage];
    //    CGImageRelease(cgimage);
    if (x+width > _srcImage.size.width) {
        width = _srcImage.size.width - x;
    }
    if (y+height > _srcImage.size.height) {
        height = _srcImage.size.height - y;
    }
    return [_srcImage subImageWithRect:CGRectMake(x, y, width, height)];
    
    //    return returnImage;
}

- (CGRect)subRect
{
    return _cameraAperture.frame;
}

#pragma mark - CameraApertureDelegate

- (void)cameraApertureFrameChanged:(CameraApertureView *)cameraAperture{
    //根据_cameraAperture.frame，计算四个遮盖的frame
    
    CGRect cameraApertureF = _cameraAperture.frame;
    
    CGFloat topX = 0;
    CGFloat topY = 0;
    CGFloat topW = _imageView.frame.size.width;
    CGFloat topH = cameraApertureF.origin.y;
    CGRect topF = CGRectMake(topX, topY, topW, topH);
    
    CGFloat buttomX = topX;
    CGFloat buttomY = CGRectGetMaxY(cameraApertureF);
    CGFloat buttomW = topW;
    CGFloat buttomH = _imageView.frame.size.height - buttomY;
    CGRect buttomF = CGRectMake(buttomX, buttomY, buttomW, buttomH);
    
    CGFloat leftX = topX;
    CGFloat leftY = CGRectGetMaxY(topF);
    CGFloat leftW = cameraApertureF.origin.x;
    CGFloat leftH = cameraApertureF.size.height;
    CGRect leftF = CGRectMake(leftX, leftY, leftW, leftH);
    
    CGFloat rightX = CGRectGetMaxX(cameraApertureF);
    CGFloat rightY = cameraApertureF.origin.y;
    CGFloat rightW = _imageView.frame.size.width - rightX;
    CGFloat rightH = cameraApertureF.size.height;
    CGRect rightF = CGRectMake(rightX, rightY, rightW, rightH);
    
    _topCover.frame = topF;
    _bottomCover.frame = buttomF;
    _leftCover.frame = leftF;
    _rightCover.frame = rightF;
}

- (void)setSubViewBorder
{
    CGFloat margin = 15.0f;
    CGRect frame;
    CGSize borderSize = CGSizeMake(_srcImageSize.width,
                                   _srcImageSize.height);
    CGPoint boderOrigin = CGPointMake(0,
                                      0);
    
    CGRect rect = self.borderRect;
    rect.origin = boderOrigin;
    rect.size = borderSize;
    self.borderRect = rect;
    frame = self.borderRect;
    [UIView animateWithDuration:0.3 animations:^{
        
        _cameraAperture.frame = frame;
        
        _controlBorder.frame = CGRectMake(_cameraAperture.frame.origin.x - margin,
                                          _cameraAperture.frame.origin.y - margin,
                                          _cameraAperture.frame.size.width + margin * 2 ,
                                          _cameraAperture.frame.size.height + margin * 2);
        
        _cameraAperture.controlBorder = _controlBorder;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)setCameraCropStyle:(CameraCropStyle)style
{
    CGFloat margin = 15.0f;
    CGRect frame;
    switch (style) {
        case CameraCropStyleOriginal:
        {
            CGSize borderSize = CGSizeMake(_srcImageSize.width,
                                           _srcImageSize.height);
            CGPoint boderOrigin = CGPointMake(0,
                                              0);
            
            CGRect rect = self.borderRect;
            rect.origin = boderOrigin;
            rect.size = borderSize;
            self.borderRect = rect;
            frame = self.borderRect;
            _cameraAperture.style = CropStyleOriginal;
        }
            break;
        case CameraCropStyleFree:
        {
            CGSize borderSize = CGSizeMake(_srcImageSize.width - DefaultBorderSizeDiff,
                                           _srcImageSize.height - DefaultBorderSizeDiff);
            CGPoint boderOrigin = CGPointMake(DefaultBorderSizeDiff / 2,
                                              DefaultBorderSizeDiff / 2);
            
            CGRect rect = self.borderRect;
            rect.origin = boderOrigin;
            rect.size = borderSize;
            self.borderRect = rect;
            frame = self.borderRect;
            _cameraAperture.style = CropStyleFree;
        }
            break;
        case CameraCropStyleSquare:
        {
            
            CGFloat length = 0;
            length = self.borderRect.size.width > self.borderRect.size.height ? self.borderRect.size.height : self.borderRect.size.width;
            
            frame = self.borderRect;
            frame.size = CGSizeMake(length, length);
            if (self.borderRect.size.width > self.borderRect.size.height) {
                frame.origin.x += (self.borderRect.size.width - length) / 2;
            }else{
                frame.origin.y += (self.borderRect.size.height - length) / 2;
            }
            _cameraAperture.style = CropStyleSquare;
        }
            break;
        case CameraCropStyleSquareness1://2:3
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width) {
                float width = frame.size.height * 2 / 3;
                frame.origin.x += (frame.size.width - width) /2 ;
                frame.size.width = width;
            }else{
                if (self.borderRect.size.height * 2 / 3 > self.borderRect.size.width )
                {
                    float height = frame.size.width * 3 / 2;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 2 / 3;
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                    
                }
                
            }
            _cameraAperture.style = CropStyleSquareness1;
        }
            break;
        case CameraCropStyleSquareness2://3:2
        {
            frame = self.borderRect;
            if (self.borderRect.size.width <= self.borderRect.size.height)
            {
                float height = frame.size.width * 2 / 3;
                frame.origin.y += (frame.size.height - height) / 2;
                frame.size.height = height;
            }else{
                if (self.borderRect.size.width * 2 / 3 > self.borderRect.size.height )
                {
                    float width = frame.size.height * 3 / 2;
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                }else{
                    float height = frame.size.width * 2 / 3;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                
            }
            _cameraAperture.style = CropStyleSquareness2;
        }
            break;
        case CameraCropStyleSquareness3://4:3
        {
            frame = self.borderRect;
            if (self.borderRect.size.width <= self.borderRect.size.height)
            {
                float height = frame.size.width * 3 / 4;
                frame.origin.y += (frame.size.height - height) / 2;
                frame.size.height = height;
            }else{
                if (self.borderRect.size.width * 3 / 4 > self.borderRect.size.height )
                {
                    float width = frame.size.height * 4 / 3;
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                }else{
                    float height = frame.size.width * 3 / 4;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                
            }
            
            _cameraAperture.style = CropStyleSquareness3;
        }
            break;
        case CameraCropStyleSquareness4://3:4
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width) {
                float width = frame.size.height * 3 / 4;
                frame.origin.x += (frame.size.width - width) /2 ;
                frame.size.width = width;
            }else{
                if (self.borderRect.size.height * 3 / 4 > self.borderRect.size.width )
                {
                    float height = frame.size.width * 4 / 3;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 3 / 4;
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                    
                }
                
            }
            _cameraAperture.style = CropStyleSquareness4;
        }
            break;
        case CameraCropStyleSquareness5://16:9
        {
            frame = self.borderRect;
            if (self.borderRect.size.width <= self.borderRect.size.height)
            {
                float height = frame.size.width * 9 / 16;
                frame.origin.y += (frame.size.height - height) / 2;
                frame.size.height = height;
            }else{
                if (self.borderRect.size.width * 9 / 16 > self.borderRect.size.height )
                {
                    float width = frame.size.height * 16 / 9;
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                }else{
                    float height = frame.size.width * 9 / 16;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }
                
            }
            
            _cameraAperture.style = CropStyleSquareness5;
        }
            break;
        case CameraCropStyleSquareness6://9:16
        {
            frame = self.borderRect;
            if (self.borderRect.size.height <= self.borderRect.size.width) {
                float width = frame.size.height * 9 / 16;
                frame.origin.x += (frame.size.width - width) /2 ;
                frame.size.width = width;
            }else{
                if (self.borderRect.size.height * 9 / 16 > self.borderRect.size.width )
                {
                    float height = frame.size.width * 16 / 9;
                    frame.origin.y += (frame.size.height - height) / 2;
                    frame.size.height = height;
                }else{
                    float width = frame.size.height * 9 / 16;
                    frame.origin.x += (frame.size.width - width) / 2;
                    frame.size.width = width;
                    
                }
                
            }
            _cameraAperture.style = CropStyleSquareness6;
        }
            break;
        default:
            break;
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        _cameraAperture.frame = frame;
        
        _controlBorder.frame = CGRectMake(_cameraAperture.frame.origin.x - margin,
                                          _cameraAperture.frame.origin.y - margin,
                                          _cameraAperture.frame.size.width + margin * 2 ,
                                          _cameraAperture.frame.size.height + margin * 2);
        
        _cameraAperture.controlBorder = _controlBorder;
    } completion:^(BOOL finished) {
        
    }];
}

- (CGFloat)getTheScaleForImageSize:(CGSize)size
{
    CGFloat width = self.superview.frame.size.width;
    CGFloat height = self.superview.frame.size.height;
    CGFloat scale = 0;
    
    if (size.width > size.height)
    {
        scale = size.width/width;
        
    }else{
        if (size.width / size.height < width / height)
        {
            scale = size.height/height ;
        }else{
            scale = size.width/width ;
        }
    }
    return scale;
}

@end
