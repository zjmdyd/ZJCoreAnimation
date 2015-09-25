//
//  ZJCAScrollLayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 9/24/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCAScrollLayerViewController.h"
#import "ScrollingView.h"

@interface ZJCAScrollLayerViewController () {
    CAScrollLayer *_scrollingViewLayer;
}

@property (weak, nonatomic) IBOutlet ScrollingView *scrollingView;
@property (weak, nonatomic) IBOutlet UISwitch *horizontalScrollingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *verticalScrollingSwitch;

@end

@implementation ZJCAScrollLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollingViewLayer = (CAScrollLayer *)self.scrollingView.layer;
    _scrollingViewLayer.scrollMode = kCAScrollBoth;
    
    self.scrollingView.layer.borderWidth = 2.0;
    self.scrollingView.layer.borderColor = [UIColor yellowColor].CGColor;
    
    CALayer *layer = self.scrollingView.layer.sublayers.firstObject;
    layer.borderColor = [UIColor redColor].CGColor;
    layer.borderWidth = 2.0;
    
    NSLog(@"layer = %@", self.scrollingView.layer);                             //  <CAScrollLayer: 0x14e73ed0>
    NSLog(@"subLayers = %@", self.scrollingView.layer.sublayers.firstObject);   // <CALayer: 0x14e7b370>
    [_scrollingViewLayer scrollToPoint:CGPointMake(0, -30)];
}

- (IBAction)scrollingSwitchChanged:(UISwitch *)sender {
    if (self.horizontalScrollingSwitch.isOn && self.verticalScrollingSwitch.isOn) {
        _scrollingViewLayer.scrollMode = kCAScrollBoth;
    }else if (self.horizontalScrollingSwitch.isOn && !self.verticalScrollingSwitch.isOn) {
        _scrollingViewLayer.scrollMode = kCAScrollHorizontally;
    }else if (!self.horizontalScrollingSwitch.isOn && self.verticalScrollingSwitch.isOn) {
        _scrollingViewLayer.scrollMode = kCAScrollVertically;
    }else if (!self.horizontalScrollingSwitch.isOn && !self.verticalScrollingSwitch.isOn) {
        _scrollingViewLayer.scrollMode = kCAScrollNone;
    }
}

- (IBAction)panRecognized:(UIPanGestureRecognizer *)sender {
    CGPoint newPoint = self.scrollingView.bounds.origin;    // bounds是根据layer的frame来确定的,当向上滚动,layer在原frame的上方,所以newPoint为正,向下滚动则反之
    NSLog(@"newPoint1 = %@", NSStringFromCGPoint(newPoint));
    NSLog(@"bounds = %@", NSStringFromCGRect(self.scrollingView.bounds));
    NSLog(@"frame = %@", NSStringFromCGRect(self.scrollingView.frame));
    NSLog(@"location = %@", NSStringFromCGPoint([sender translationInView:self.scrollingView]));

    newPoint.x -= [sender translationInView:self.scrollingView].x;  // 为什是减,因为滚动视图向上滚动时的偏移量增加
    newPoint.y -= [sender translationInView:self.scrollingView].y;
    
    NSLog(@"newPoint2 = %@", NSStringFromCGPoint(newPoint));
    
    [sender setTranslation:CGPointZero inView:self.scrollingView];
    [_scrollingViewLayer scrollToPoint:newPoint]; //
    
    NSLog(@"\n\n");
}
/*

 2015-09-24 18:31:08.562 ZJCoreAnimation[1743:394092] newPoint1 = {0, 0}    // 初始为0
 2015-09-24 18:31:08.565 ZJCoreAnimation[1743:394092] location = {0, -0.5}  // 相对scrollingView的坐标(在向上滚动为负)
 2015-09-24 18:31:08.566 ZJCoreAnimation[1743:394092] newPoint2 = {0, 0.5}  // newPoint减去location的坐标 解释:
 
 2015-09-24 18:31:08.579 ZJCoreAnimation[1743:394092] newPoint1 = {0, 0.5}  // bounds是根据layer的frame来确定的, 上次改变了layer的frame,为正代表上次是向上滚动
 2015-09-24 18:31:08.580 ZJCoreAnimation[1743:394092] location = {0, -3}
 2015-09-24 18:31:08.581 ZJCoreAnimation[1743:394092] newPoint2 = {0, 3.5}
 
 */

/*
 The translation of the pan gesture in the coordinate system of the specified view.
 
 Return Value
 A point identifying the new location of a view in the coordinate system of its designated superview.
 字面理解是：
 在指定的视图坐标系统中转换(拖动？) pan gesture
 返回参数：返回一个明确的新的坐标位置，在指定的父视图坐标系统中
 简单的理解就是
 该方法返回在横坐标上、纵坐标上拖动了多少像素
 因为拖动起来一直是在递增，所以每次都要用setTranslation:方法制0这样才不至于不受控制般滑动出视图
 */

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
