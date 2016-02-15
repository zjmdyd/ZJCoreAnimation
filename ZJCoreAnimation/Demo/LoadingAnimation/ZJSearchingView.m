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
@property (nonatomic, strong) CALayer *bottomLayer;

@end

@implementation ZJSearchingView

@synthesize contents = _contents;

- (nullable instancetype)initWithFrame:(CGRect)frame content:(nullable id)content {
    self = [super initWithFrame:frame];
    if (self) {
        _contents = content;
        [self initSetting];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    
    return self;
}

- (void)initSetting {
    self.backgroundColor = [UIColor orangeColor];
    
    // 默认顺时针
    self.clockwise = YES;
    self.angleSpan = M_PI*0.75;
    self.lineWidth = 2.0;
    self.duration = 1.0;
    
    self.bottomLayer = [CALayer layer];
    self.bottomLayer.frame = self.bounds;
    self.bottomLayer.contents = self.contents;
    self.bottomLayer.contentsGravity = kCAGravityCenter;
//    self.bottomLayer.geometryFlipped = NO;
//    self.bottomLayer.borderColor = [UIColor whiteColor].CGColor;
//    self.bottomLayer.backgroundColor = [UIColor colorWithRed:11/255.0 green:86/255.0 blue:14/255.0 alpha:1.0].CGColor;
//    self.bottomLayer.shadowOpacity = 0.75;
//    self.bottomLayer.shadowOffset = CGSizeMake(0, 3);
//    self.bottomLayer.shadowRadius = 3.0;
    self.bottomLayer.magnificationFilter = kCAFilterLinear;
    
    [self.layer addSublayer:self.bottomLayer];
    
    // x轴0度角, 顺时针向下为正,逆时针向下为负
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) radius:(self.bounds.size.width - self.lineWidth) / 2 startAngle:0 endAngle:self.angleSpan clockwise:self.clockwise];
    path.lineWidth = self.lineWidth;
    
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = self.layer.bounds;  // 设置frame,不能设置bounds,设置bounds位置会不正确
    self.shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.shapeLayer.path = path.CGPath;
    self.shapeLayer.fillColor = nil;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    [self.layer addSublayer:self.shapeLayer];
}

#pragma mark - setter

- (void)setSearching:(BOOL)searching {
    if (searching) {
        [self startAnimation];
    }else {
        [self stopAnimation];
    }
    
    _searching = searching;
}

- (void)setContents:(id)contents {
    _contents = contents;
    self.bottomLayer.contents = _contents;
}

- (id)contents {
    return _contents;
}

#pragma mark - getter

- (CGFloat)angleSpan {
    if (self.isClosewise) {
        return _angleSpan;
    }else {
        return -_angleSpan;
    }
}

#pragma mark - public

- (void)startSearching {
    [self startAnimation];
    
    _searching = YES;
}

- (void)stopSearching {
    [self stopAnimation];
    
    _searching = NO;
}

#pragma mark - private

- (void)startAnimation {
    if (self.isSearching == NO) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateLayer) userInfo:nil repeats:NO];
        });
    }
}

- (void)stopAnimation {
    if (self.isSearching) {
        [self.shapeLayer removeAnimationForKey:@"rotationAnimation"];
    }
}

- (void)updateLayer {
    /**
     *  CABasicAnimation在这里比CATransaction效果更好
     */
#ifndef Transaction
    
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = self.duration;
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
