//
//  CameraAperture.m
//  PRJ_Test
//
//  Created by 贺瑞 on 14-4-16.
//  Copyright (c) 2014年 rcplatfrom. All rights reserved.
//

#import "CameraApertureView.h"



typedef enum{
    OutOfBorderTypeNo = 0,  //未超出边界
    OutOfBorderTypeX,       //仅X轴方向超出边界
    OutOfBorderTypeY,       //仅Y轴方向超出边界
    OutOfBorderTypeXY,      //x,y轴均超出边界
}OutOfBorderType;

@interface CameraApertureView() <CornerDelegate, ControlBorderDelegate>

{
    //touch事件开始时手指所在的point
    CGPoint _touchBeginPoint;
    
    //是否显示网格线
    BOOL _isShowReseau;
    
    //边角点与边框线，用于控制尺寸
    CornerView *_rightDownBtn;
    CornerView *_rightUpBtn;
    CornerView *_leftUpBtn;
    CornerView *_leftDownBtn;
    
    CornerView *_topLine;
    CornerView *_buttomLine;
    CornerView *_leftLine;
    CornerView *_rightLine;
}

@end

@implementation CameraApertureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        //初始化子控件
        [self setupChildView];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    if(!_isShowReseau) return;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor lightGrayColor] set];
    CGContextSetLineWidth(context, 0.3f);
    
    //绘直线
    static NSUInteger lineCount = 2;
    CGFloat spacingY = self.frame.size.width / (lineCount + 1);
    CGFloat spacingX = self.frame.size.height / (lineCount + 1);
    
    for (int i=0; i<lineCount; i++) {
        
        CGFloat startX = 0;
        CGFloat startY = spacingX * (i+1);
        CGContextMoveToPoint(context, startX, startY);
        
        CGFloat endX = self.frame.size.width;
        CGFloat endY = startY;
        
        CGContextAddLineToPoint(context, endX, endY);
    }
    
    for (int i=0; i<lineCount; i++) {
        
        CGFloat startX = spacingY * (i+1);
        CGFloat startY = 0;
        CGContextMoveToPoint(context, startX, startY);
        
        CGFloat endX = startX;
        CGFloat endY = self.frame.size.height;
        
        CGContextAddLineToPoint(context, endX, endY);
    }
    
    CGContextDrawPath(context, kCGPathEOFillStroke);
}




- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    //重绘
    [self setNeedsDisplay];
    
    //通知代理
    if([_delegate respondsToSelector:@selector(cameraApertureFrameChanged:)]){
        [_delegate cameraApertureFrameChanged:self];
    }
}

- (void)setControlBorder:(ControlBorder *)controlBorder{
    _controlBorder = controlBorder;
    
    //初始化成员变量并设置代理
    _controlBorder.delegate = self;
    
    _rightDownBtn = _controlBorder.rightDownBox;
    _rightUpBtn = _controlBorder.rightUpBox;
    _leftDownBtn = _controlBorder.leftDownBox;
    _leftUpBtn = _controlBorder.leftUpBox;
    
    _topLine = _controlBorder.topLine;
    _buttomLine = _controlBorder.buttomLine;
    _leftLine = _controlBorder.leftLine;
    _rightLine = _controlBorder.rightLine;
    
    _rightDownBtn.delegate = self;
    _rightUpBtn.delegate = self;
    _leftDownBtn.delegate = self;
    _leftUpBtn.delegate = self;
    
    _topLine.delegate = self;
    _buttomLine.delegate = self;
    _leftLine.delegate = self;
    _rightLine.delegate = self;
}



#pragma mark - private method

#pragma mark 初始化子控件
- (void)setupChildView{
    
    //加边框线（纯粹为了看。。）
    UIView *border = [[[NSBundle mainBundle] loadNibNamed:@"ScreenshotBorder" owner:nil options:nil] lastObject];
    border.frame = CGRectMake(-2.5, -2.5, self.frame.size.width + 5, self.frame.size.height + 5);
    [self addSubview:border];
    
}


#pragma mark 检查是否超出参照view边框
- (OutOfBorderType)checkOutOfBorderWithFrame:(CGRect )viewF ReferFrame:(CGRect)referF{
    
    //取左上角坐标
    CGPoint viewLT = viewF.origin;
    CGPoint referLT = CGPointZero;
    //右下角坐标
    CGPoint viewRD = CGPointMake(CGRectGetMaxX(viewF), CGRectGetMaxY(viewF));
    CGPoint referRD = CGPointMake(referF.size.width, referF.size.height);
    
    
    //一定要先判断x,y轴是否均超出的情况
    if((viewLT.x < referLT.x || viewRD.x > referRD.x) &&
       (viewLT.y < referLT.y || viewRD.y > referRD.y )){
        return OutOfBorderTypeXY;
    }
    
    if(viewLT.x < referLT.x || viewRD.x > referRD.x ){
        return OutOfBorderTypeX;
    }
    
    if(viewLT.y < referLT.y || viewRD.y > referRD.y ){
        return OutOfBorderTypeY;
    }
    
    return OutOfBorderTypeNo;
}


#pragma mark - CornerDelegate

- (void)corner:(CornerView *)corner TouchesBegin:(UITouch *)touch{
    _isShowReseau = YES;
    [self setNeedsDisplay];
    _touchBeginPoint = [touch locationInView:self];
}

- (void)corner:(CornerView *)corner TouchesMoved:(UITouch *)touch{
    //调整自己的尺寸
    CGRect frame = self.frame;
    CGPoint touchMovePoint = [touch locationInView:self];
    CGPoint touchMovePrePoint = [touch previousLocationInView:self];
    
    //偏移量
    
    CGSize offset;
    if (self.style == CropStyleFree)
    {
        offset = CGSizeMake((touchMovePoint.x - touchMovePrePoint.x),
                            (touchMovePoint.y - touchMovePrePoint.y));
    }
    else if (self.style == CropStyleSquare)
    {
        //1:1
        offset = CGSizeMake((touchMovePoint.x - touchMovePrePoint.x),
                            (touchMovePoint.x - touchMovePrePoint.x));
    }
    else if (self.style == CropStyleSquareness1)
    {
        //2:3
        offset = CGSizeMake((touchMovePoint.x - touchMovePrePoint.x),
                            (touchMovePoint.x - touchMovePrePoint.x)*3/2);
    }
    else if (self.style == CropStyleSquareness2)
    {
        //3:2
        offset = CGSizeMake((touchMovePoint.x - touchMovePrePoint.x),
                            (touchMovePoint.x - touchMovePrePoint.x)*2/3);
    }
    else if (self.style == CropStyleSquareness3)
    {
        //4:3
        offset = CGSizeMake((touchMovePoint.x - touchMovePrePoint.x),
                            (touchMovePoint.x - touchMovePrePoint.x)*3/4);
    }
    else if (self.style == CropStyleSquareness4)
    {
        //3:4
        offset = CGSizeMake((touchMovePoint.x - touchMovePrePoint.x),
                            (touchMovePoint.x - touchMovePrePoint.x)*4/3);
    }
    else if (self.style == CropStyleSquareness5)
    {
        //16:9
        offset = CGSizeMake((touchMovePoint.x - touchMovePrePoint.x),
                            (touchMovePoint.x - touchMovePrePoint.x)*9/16);
    }
    else if (self.style == CropStyleSquareness6)
    {
        //9:16
        offset = CGSizeMake((touchMovePoint.x - touchMovePrePoint.x),
                            (touchMovePoint.x - touchMovePrePoint.x)*16/9);
    }
    
    static CGFloat margin = 15.0f;
    
    //右下角
    if(corner == _rightDownBtn){
        frame.size = CGSizeMake(frame.size.width + offset.width,frame.size.height + offset.height);
        
        //右上角
    }else if(corner == _rightUpBtn){
        if (self.style == CropStyleFree)
        {
            frame.origin.y = frame.origin.y + offset.height;
            frame.size = CGSizeMake(frame.size.width+offset.width,frame.size.height-offset.height);
        }
        else
        {
            //            frame.origin.y = frame.origin.y - offset.height;
            frame.size = CGSizeMake(frame.size.width+offset.width,frame.size.height+offset.height);
        }
        
        //左上角
    }else if(corner == _leftUpBtn){
        frame.origin.y = frame.origin.y + offset.height;
        frame.origin.x = frame.origin.x + offset.width;
        frame.size = CGSizeMake(frame.size.width-offset.width,frame.size.height-offset.height);
        //左下角
    }else if(corner == _leftDownBtn){
        if (self.style == CropStyleFree)
        {
            frame.origin.x = frame.origin.x + offset.width;
            frame.size = CGSizeMake(frame.size.width-offset.width,frame.size.height+offset.height);
        }
        else
        {
            frame.origin.x = frame.origin.x + offset.width;
            frame.size = CGSizeMake(frame.size.width-offset.width,frame.size.height-offset.height);
        }
    }
    //    //上
    //    }else if(corner == _topLine){
    //        frame.origin.y = locationInSuper.y + offset.height;
    //        frame.size = CGSizeMake(frame.size.width,
    //                                frame.size.height + (touchBeginInSuper.y - locationInSuper.y) - margin);
    //    //下
    //    }else if(corner == _buttomLine){
    //
    //        frame.size = CGSizeMake(frame.size.width,
    //                                locationInSuper.y + offset.height - margin);
    //    //左
    //    }else if(corner == _leftLine){
    //        frame.origin.x = locationInSuper.x + offset.width ;
    //        frame.size = CGSizeMake(frame.size.width + (touchBeginInSuper.x - locationInSuper.x) - margin,
    //                                frame.size.height);
    //    //右
    //    }else if(corner == _rightLine){
    //        frame.size = CGSizeMake(locationInSuper.x + offset.width - margin,
    //                                frame.size.height);
    //    }
    
    //    //限制矩形框最小为60*60
    //    if(frame.size.width < (60)){
    //        frame.size.width = 60;
    //    }
    //    if(frame.size.height < 60) {
    //        frame.size.height = 60;
    //    }
    
    //    switch (self.style) {
    //        case CropStyleFree:
    //        {
    //
    //        }
    //            break;
    //        case CropStyleSquare:
    //        {
    //            NSLog(@"%f---%f",frame.size.width,frame.size.height);
    //            frame.size.height = frame.size.width;
    //        }
    //            break;
    //        case CropStyleSquareness1:
    //        {
    //            frame.size.height = frame.size.width * 3 / 2;
    //        }
    //            break;
    //        case CropStyleSquareness2:
    //        {
    //            frame.size.height = frame.size.width * 2 / 3;
    //        }
    //            break;
    //        case CropStyleSquareness3:
    //        {
    //            frame.size.height = frame.size.width * 3 / 4;
    //        }
    //            break;
    //        case CropStyleSquareness4:
    //        {
    //            frame.size.height = frame.size.width * 4 / 3;
    //        }
    //            break;
    //        case CropStyleSquareness5:
    //        {
    //            frame.size.height = frame.size.width * 9 / 16;
    //        }
    //            break;
    //        case CropStyleSquareness6:
    //        {
    //            frame.size.height = frame.size.width * 16 / 9;
    //        }
    //            break;
    //        default:
    //            break;
    //    }
    //
    
    
    //是否超出边界
    if([self checkOutOfBorderWithFrame:frame ReferFrame:self.superview.frame])
        return;
    
    
    
    self.frame = frame;
    //    _controlBorder.frame = frame;
    
    
    _controlBorder.frame = CGRectMake(self.frame.origin.x - margin,
                                      self.frame.origin.y - margin,
                                      self.frame.size.width + margin * 2,
                                      self.frame.size.height + margin * 2);
    
}

- (void)corner:(CornerView *)corner TouchesEnd:(UITouch *)touch{
    _isShowReseau = NO;
    [self setNeedsDisplay];
    _touchBeginPoint = CGPointZero;
}


#pragma mark - ControlBorderDelegate
- (void)controlBorder:(ControlBorder *)controlBorder MoveBeginWithTouch:(UITouch *)touch{
    _isShowReseau = YES;
    [self setNeedsDisplay];
    _touchBeginPoint = [touch locationInView:self];
}

- (void)controlBorder:(ControlBorder *)controlBorder MovedWithTouch:(UITouch *)touch{
    CGPoint location = [touch locationInView:self.superview];
    
    //调整自己位置
    CGRect frame = self.frame;
    frame.origin.x = location.x - _touchBeginPoint.x;
    frame.origin.y = location.y - _touchBeginPoint.y;
    
    //边界检测
    OutOfBorderType result = [self checkOutOfBorderWithFrame:frame ReferFrame:self.superview.frame];
    switch (result) {
            
            //后面两种处理方式都得搞，这里不要加break
        case OutOfBorderTypeXY:
            
        case OutOfBorderTypeX:
        {
            //重置x轴
            if(frame.origin.x <= 0){
                frame.origin.x = 0.1;
            }else{
                frame.origin.x = self.superview.frame.size.width - self.frame.size.width;
            }
            
            if(OutOfBorderTypeXY != result) break;
        }
            
        case OutOfBorderTypeY:
        {
            //重置y轴
            if(frame.origin.y <= 0){
                frame.origin.y = 0.1;
            }else{
                frame.origin.y = self.superview.frame.size.height - self.frame.size.height;
            }
            
            break;
        }
            
            //暂不作处理
        case OutOfBorderTypeNo:
            break;
            
        default:
            break;
    }
    
    self.frame = frame;
    
    //    _controlBorder.frame = frame;
    CGFloat margin = 15.0f;
    _controlBorder.frame = CGRectMake(self.frame.origin.x - margin ,
                                      self.frame.origin.y - margin ,
                                      self.frame.size.width + margin * 2,
                                      self.frame.size.height + margin * 2);
}

- (void)controlBorderMoveEnd:(ControlBorder *)controlBorder{
    _isShowReseau = NO;
    [self setNeedsDisplay];
    _touchBeginPoint = CGPointZero;
}


@end
