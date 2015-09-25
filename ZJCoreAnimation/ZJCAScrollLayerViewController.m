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
    
    NSLog(@"layer = %@", self.scrollingView.layer);
    NSLog(@"subLayers = %@", self.scrollingView.layer.sublayers.firstObject);
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
    CGPoint newPoint = self.scrollingView.bounds.origin;    // bounds是根据layer的frame来确定的,当向上滚动,layer在原frame的上方,newPoint为正,向下反之
    NSLog(@"newPoint1 = %@", NSStringFromCGPoint(newPoint));
    
    NSLog(@"location = %@", NSStringFromCGPoint([sender translationInView:self.scrollingView]));

    newPoint.x -= [sender translationInView:self.scrollingView].x;
    newPoint.y -= [sender translationInView:self.scrollingView].y;
    
    NSLog(@"newPoint2 = %@", NSStringFromCGPoint(newPoint));
    
    [sender setTranslation:CGPointZero inView:self.scrollingView];
    [_scrollingViewLayer scrollPoint:newPoint]; //
}
/*

 2015-09-24 18:31:08.562 ZJCoreAnimation[1743:394092] newPoint1 = {0, 0}    // 初始为0
 2015-09-24 18:31:08.565 ZJCoreAnimation[1743:394092] location = {0, -0.5}  // 相对scrollingView的坐标(在向上滚动为负)
 2015-09-24 18:31:08.566 ZJCoreAnimation[1743:394092] newPoint2 = {0, 0.5}  // newPoint减去location的坐标 解释:
 
 2015-09-24 18:31:08.579 ZJCoreAnimation[1743:394092] newPoint1 = {0, 0.5}  // bounds是根据layer的frame来确定的, 上次改变了layer的frame,为正代表上次是向上滚动
 2015-09-24 18:31:08.580 ZJCoreAnimation[1743:394092] location = {0, -3}
 2015-09-24 18:31:08.581 ZJCoreAnimation[1743:394092] newPoint2 = {0, 3.5}
 
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
