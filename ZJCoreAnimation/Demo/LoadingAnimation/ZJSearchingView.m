//
//  ZJSearchingView.m
//  Test
//
//  Created by ZJ on 1/19/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import "ZJSearchingView.h"

@interface ZJSearchingView ()

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation ZJSearchingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    
    return self;
}

- (void)initSetting {
    self.backgroundColor = [UIColor orangeColor];
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    
    // x轴0度角, 顺时针向下为正,逆时针向下为负
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) radius:(self.bounds.size.width - self.lineWidth) / 2 startAngle:self.startAngle endAngle:self.startAngle - self.angleSpan clockwise:YES];
    path.lineWidth = self.lineWidth;
    [path stroke];
 
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.layer.bounds;  // 设置frame,不能设置bounds,设置bounds位置会不正确
    self.shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.fillColor = nil;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:self.shapeLayer];
}

#pragma mark - getter

- (CGFloat)startAngle {
    if (_startAngle < FLT_EPSILON) {
        _startAngle = 0;
    }
    
    return _startAngle;
}

- (CGFloat)endAngle {
    if (fabs(_endAngle) < FLT_EPSILON) {
        _endAngle = -M_PI;
    }
    
    return _endAngle;
}

- (CGFloat)angleSpan {
    if (_angleSpan < FLT_EPSILON) {
        _angleSpan = M_PI;
    }
    
    return _angleSpan;
}

- (CGFloat)lineWidth {
    if (_lineWidth < FLT_EPSILON) {
        _lineWidth = 2;
    }
    
    return _lineWidth;
}

- (void)startSearching {
    self.searching = YES;
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateLayer) userInfo:nil repeats:NO];
    });
}

- (void)updateLayer {
    /**
     *  CABasicAnimation在这里比CATransaction效果更好
     */
#ifndef Transaction
    
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [self.shapeLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
#else
    [CATransaction new];
    self.shapeLayer.transform = CATransform3DRotate(self.shapeLayer.transform, M_PI_2, 0, 0, 1);
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 2.0;
    animation.keyTimes = @[@(0), @(0.5), @(1.0)];
    animation.timingFunction = [CAMediaTimingFunction
                                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.shapeLayer addAnimation:animation forKey:nil];
    [CATransaction commit];
#endif
}

- (void)stopSearching {
    self.searching = NO;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//
//    
//    
//    CGContextRestoreGState(context);
}

@end
