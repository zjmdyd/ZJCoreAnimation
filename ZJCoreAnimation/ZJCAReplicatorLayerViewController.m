//
//  ZJCAReplicatorLayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 9/26/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCAReplicatorLayerViewController.h"

@interface ZJCAReplicatorLayerViewController () {
    CABasicAnimation *_moveAnimation;
    CALayer *_barLayer;
    
    //
    CALayer *_instanceLayer;
    CAReplicatorLayer *_replicatorLayer;
    CABasicAnimation *_fadeAnimation;
}

@property (weak, nonatomic) IBOutlet UIView *replicatorLayerView;
@property (weak, nonatomic) IBOutlet UIView *rightItemView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *siderValueLabels;
@property (weak, nonatomic) IBOutlet UILabel *layerSizeSliderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *instanceCountSliderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *instanceDelaySliderValueLabel;

@end

static NSString *VOLUMBARANIMATION = @"volumBarAnimation";

@implementation ZJCAReplicatorLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createVolumBars];
    [self activityIndicator];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    if (_barLayer.animationKeys.count) {
        [_barLayer removeAnimationForKey:VOLUMBARANIMATION];
    }else {
        [_barLayer addAnimation:_moveAnimation forKey:VOLUMBARANIMATION];
    }
}

// 播放音乐动态按钮
- (void)createVolumBars {
    self.rightItemView.backgroundColor = [UIColor clearColor];
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = self.rightItemView.bounds;
    replicatorLayer.position = CGPointMake(self.rightItemView.center.x - self.rightItemView.left + 30, self.rightItemView.center.y);
    replicatorLayer.instanceCount = 3;      // The number of copies to create
    replicatorLayer.instanceDelay = 0.33;
    replicatorLayer.masksToBounds = YES;
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(15.0, 0.0, 0.0);
    [self.rightItemView.layer addSublayer:replicatorLayer];
    
    _barLayer = [CALayer layer];
    _barLayer.bounds = CGRectMake(0, 0, 8, 33);
    _barLayer.position = CGPointMake(10, 43);
    _barLayer.backgroundColor = [UIColor redColor].CGColor;
    [replicatorLayer addSublayer:_barLayer];  // replicatorLayer的每份拷贝都会添加此layer及layer的动画
    
    //
    _moveAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    _moveAnimation.toValue = @(_barLayer.position.y - 25);
    _moveAnimation.duration = 0.5;
    _moveAnimation.autoreverses = YES;   // 循环往返 : This will make the bar repeatedly move up and down
    _moveAnimation.repeatCount = MAXFLOAT;
    [_barLayer addAnimation:_moveAnimation forKey:VOLUMBARANIMATION];
}

- (void)activityIndicator {
    // 1
    _replicatorLayer = [CAReplicatorLayer layer]; //
    _replicatorLayer.frame = self.replicatorLayerView.bounds;
    
    // 2
    _replicatorLayer.instanceCount = 30;                         // The number of copies to create, including the source layers.
    _replicatorLayer.instanceDelay = (CFTimeInterval)(1/30.0);     // Specifies the delay, in seconds, between replicated copies. Animatable.
    _replicatorLayer.preservesDepth = NO;        // 设图层为2D
    _replicatorLayer.instanceColor = [UIColor whiteColor].CGColor;   // source color component:red:1 green:1 blue:1 alpha:1
    self.instanceCountSliderValueLabel.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithInt:_replicatorLayer.instanceCount]];
    self.instanceDelaySliderValueLabel.text = [NSString stringWithFormat:@"%.2f", _replicatorLayer.instanceDelay];
    // 3
    _replicatorLayer.instanceRedOffset = 0.0;    // Defines the offset added to the red component of the color for each replicated instance
    _replicatorLayer.instanceGreenOffset = -0.5;
    _replicatorLayer.instanceBlueOffset = -0.5;
    _replicatorLayer.instanceAlphaOffset = 0.0;  // end color component: red:1 green:0.5 blue:0.5 alpha:1.0 462907284
    
    // 4
    CGFloat angle = (M_PI * 2.0) / 29;
    _replicatorLayer.instanceTransform = CATransform3DRotate(_replicatorLayer.transform, angle, 0.0, 0.0, 1.0);
    [self.replicatorLayerView.layer addSublayer:_replicatorLayer];
    
    // 5
    _instanceLayer = [CALayer layer];
    CGFloat layerWidth = 10.0;
    CGFloat midX = CGRectGetMidX(self.replicatorLayerView.bounds) - layerWidth / 2.0;
    _instanceLayer.frame = CGRectMake(midX, 0, layerWidth, layerWidth * 3.0);    // replicatorLayer顶部的那个copies
    _instanceLayer.backgroundColor = [UIColor whiteColor].CGColor;
    [_replicatorLayer addSublayer:_instanceLayer];
    self.layerSizeSliderValueLabel.text = @"10 x 30";
    // 6
    _fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    _fadeAnimation.fromValue = @1.0;
    _fadeAnimation.toValue = @0.0;
    _fadeAnimation.duration = 1;
    _fadeAnimation.repeatCount = MAXFLOAT;
    
    // 7
    _instanceLayer.opacity = 0.0;
    [_instanceLayer addAnimation:_fadeAnimation forKey:@"FadeAnimation"];
    
    /*
     创建一个CAReplicatorLayer实例，设框架为someView边界。
     设复制图层数instanceCount和绘制延迟，设图层为2D（preservesDepth = false），实例颜色为白色。
     为陆续的实例复件设置RGB颜色偏差值（默认为0，即所有复件保持颜色不变），不过这里实例初始颜色为白色，即RGB都为1.0，所以偏差值设红色为0，绿色和蓝色为相同负数会使其逐渐现出红色，alpha透明度偏差值的变化也与此类似，针对陆续的实例复件。
     创建旋转变换，使得实例复件按一个圆排列。
     创建供复制图层使用的实例图层，设置框架，使第一个实例在someView边界顶端水平中心处绘制，另外设置实例颜色，把实例图层添加到复制图层。
     创建一个透明度由1（不透明）过渡为0（透明）的淡出动画。
     设实例图层透明度为0，使得每个实例在绘制和改变颜色与alpha前保持透明。
     */
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (sender.tag ==0) {
        CGFloat midX = CGRectGetMidX(self.replicatorLayerView.bounds) - sender.value / 2.0;
        CGRect frame = _instanceLayer.frame;
        frame.origin = CGPointMake(midX, 0);
        frame.size = CGSizeMake(sender.value, sender.value* 3);
        _instanceLayer.frame = frame;
        self.layerSizeSliderValueLabel.text = [NSString stringWithFormat:@"%.0f x %.0f", sender.value, sender.value*3];
    }else if (sender.tag == 1) {
        _replicatorLayer.instanceCount = sender.value;
        self.instanceCountSliderValueLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
    }else if (sender.tag == 2) {
        _replicatorLayer.instanceDelay = (CFTimeInterval)sender.value;
        self.instanceDelaySliderValueLabel.text = [NSString stringWithFormat:@"%.2f", sender.value];
        if (sender.value < FLT_EPSILON) {
            _instanceLayer.opacity = 1.0;
            [_instanceLayer removeAnimationForKey:@"FadeAnimation"];
        }else {
            _fadeAnimation.duration = sender.value / _replicatorLayer.instanceCount;
            _instanceLayer.opacity = 0.0;
            [_instanceLayer removeAnimationForKey:@"FadeAnimation"];
            [_instanceLayer addAnimation:_fadeAnimation forKey:@"FadeAnimation"];
        }
    }
}

- (IBAction)switchValueChanged:(UISwitch *)sender {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
