//
//  ZJTiledView.m
//  ZJCALayerSample
//
//  Created by YunTu on 15/3/27.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJTiledView.h"
#import "ZJTiledLayer.h"

CGFloat sideLength  = 100.0;

@implementation ZJTiledView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {                     // 方法执行顺序: 3
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGFloat red = drand48();    // The drand48() and erand48() functions shall return non-negative, double-precision, floating-point values, uniformly distributed over the interval [0.0,1.0).
    CGFloat green = drand48();
    CGFloat blue = drand48();
    CGContextSetRGBFillColor(context, red, green, blue, 1.0);
    CGContextFillRect(context, rect);
    
    
    CGFloat x = self.bounds.origin.x;
    CGFloat y = self.bounds.origin.y;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat offset = CGRectGetWidth(self.bounds) / sideLength * (scale == 3 ? 2 : scale);
    
    CGContextMoveToPoint(context, x + 9.0 * offset, y + 43.0 * offset);
    CGContextAddLineToPoint(context, x + 18.06 * offset, y + 22.6 * offset);
    CGContextAddLineToPoint(context, x + 25.0 * offset, y + 7.5 * offset);
    CGContextAddLineToPoint(context, x + 41.0 * offset, y + 43.0 * offset);
    CGContextAddLineToPoint(context, x + 9.0 * offset, y + 21.66 * offset);
    CGContextAddLineToPoint(context, x + 41.0 * offset, y + 14.54 * offset);
    CGContextAddLineToPoint(context, x + 9.0 * offset, y + 43.0 * offset);
    CGContextClosePath(context);

    red = drand48();
    green = drand48();
    blue = drand48();
    CGContextSetRGBFillColor(context, red, green, blue, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, 4.0 / scale);
    CGContextDrawPath(context, kCGPathEOFillStroke);
    
    CGContextRestoreGState(context);
}

+ (Class)layerClass {                               // 方法执行顺序: 2
    return [ZJTiledLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)coder {    // 方法执行顺序: 1
    NSLog(@"%s", __func__);
    self = [super initWithCoder:coder];
    if (self) {
        CGFloat sideLength = 50.0;
        srand48(time(NULL));
        CATiledLayer *layer = (CATiledLayer *)self.layer;
        CGFloat scale = [UIScreen mainScreen].scale;
        layer.contentsScale = scale;
        layer.tileSize = CGSizeMake(sideLength * scale, sideLength * scale);
    }
    return self;
}

@end

/*
 
 contentsScale
 Property
 The scale factor applied to the layer.
 
 Declaration
 SWIFT
 var contentsScale: CGFloat
 OBJECTIVE-C
 @property CGFloat contentsScale
 Discussion
 This value defines the mapping between the logical coordinate space of the layer (measured in points) and the physical coordinate space (measured in pixels). Higher scale factors indicate that each point in the layer is represented by more than one pixel at render time. For example, if the scale factor is 2.0 and the layer’s bounds are 50 x 50 points, the size of the bitmap used to present the layer’s content is 100 x 100 pixels.
 
 The default value of this property is 1.0. For layers attached to a view, the view changes the scale factor automatically to a value that is appropriate for the current screen. For layers you create and manage yourself, you must set the value of this property yourself based on the resolution of the screen and the content you are providing. Core Animation uses the value you specify as a cue to determine how to render your content.
 */



