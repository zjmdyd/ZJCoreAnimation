//
//  ZJCATransformLayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/12/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCATransformLayerViewController.h"

@interface ZJCATransformLayerViewController () {
    CATextLayer *_swipeMeTextLayer;
    CATransformLayer *_transformLayer;
}

@property (weak, nonatomic) IBOutlet UIView *transformLayerView;

@end

static CGFloat SideLength = 160.0;

typedef NS_ENUM(NSInteger, Color) {
    Red,
    Green,
    Blue,
    Yellow,
    Orange,
    Purple
};

@implementation ZJCATransformLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSwipeMeTextLayer];
    [self setupCube];
}

- (void)setupSwipeMeTextLayer {
    _swipeMeTextLayer = [CATextLayer layer];
    _swipeMeTextLayer.frame = CGRectMake(0, SideLength / 4, SideLength, SideLength);
    _swipeMeTextLayer.string = @"Swipe me";
    _swipeMeTextLayer.alignmentMode = kCAAlignmentCenter;
    _swipeMeTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    _swipeMeTextLayer.font = (__bridge CFTypeRef _Nullable)([UIFont fontWithName:@"Noteworthy-Light" size:24.0]);
    _swipeMeTextLayer.contentsScale = [UIScreen mainScreen].scale;
}

- (void)setupCube {
    _transformLayer = [CATransformLayer layer];
    [self.transformLayerView.layer addSublayer:_transformLayer];
    
    CALayer *layer = [self sideLayerWithColor:[UIColor redColor]];
    [layer addSublayer:_swipeMeTextLayer];
    [_transformLayer addSublayer:layer];
    
    /*******    方向均以swipeTextLayer的方向为基准   *******/
    // 右侧
    layer = [self sideLayerWithColor:[UIColor orangeColor]];
    CATransform3D transform = CATransform3DMakeTranslation(SideLength / 2.0, 0.0, SideLength / -2.0);
    transform = CATransform3DRotate(transform, M_PI_2, 0.0, 1.0, 0.0);      // angle大于0逆时针旋转,小于0顺时针
    layer.transform = transform;
    [_transformLayer addSublayer:layer];
    
    // 后
    layer = [self sideLayerWithColor:[UIColor yellowColor]];
    layer.transform = CATransform3DMakeTranslation(0.0, 0.0, -SideLength);
    [_transformLayer addSublayer:layer];
    
    // 左侧
    layer = [self sideLayerWithColor:[UIColor greenColor]];
    transform = CATransform3DMakeTranslation(SideLength / -2.0, 0.0, SideLength / -2.0);
    transform = CATransform3DRotate(transform, M_PI_2, 0.0, 1.0, 0.0);
    layer.transform = transform;
    [_transformLayer addSublayer:layer];
    
    // 顶
    layer = [self sideLayerWithColor:[UIColor blueColor]];
    transform = CATransform3DMakeTranslation(0.0, SideLength / -2.0, SideLength / -2.0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0.0, 0.0);
    layer.transform = transform;
    [_transformLayer addSublayer:layer];
    
    // 底部
    layer = [self sideLayerWithColor:[UIColor purpleColor]];
    transform = CATransform3DMakeTranslation(0.0, SideLength / 2.0, SideLength / -2.0);
    transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0.0, 0.0);
    layer.transform = transform;
    [_transformLayer addSublayer:layer];
    
    _transformLayer.anchorPointZ = SideLength / -2.0;
}

- (CALayer *)sideLayerWithColor:(UIColor *)color {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, SideLength, SideLength);
    layer.position = CGPointMake(CGRectGetMidX(self.transformLayerView.bounds), CGRectGetMidY(self.transformLayerView.bounds));
    layer.backgroundColor = color.CGColor;
    
    return layer;
}

- (IBAction)colorAlphaSwitchChanged:(UISwitch *)sender {

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self.transformLayerView];
    
}

- (UIColor *)getNewColorWithNewAlpha:(CGFloat)newAlpha andColor:(UIColor *)color {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    color = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    
    return color;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
