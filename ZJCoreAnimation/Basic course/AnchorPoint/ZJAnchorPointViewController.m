//
//  ZJAnchorPointViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 15/7/23.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJAnchorPointViewController.h"

@interface ZJAnchorPointViewController ()

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *frontView;

@end

@implementation ZJAnchorPointViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        view.center = self.view.center;
        if (i == 0) {
            view.backgroundColor = [UIColor redColor];
            self.bgView = view;
        }else if (i == 1) {
            view.backgroundColor = [UIColor blueColor];
            self.frontView = view;
            self.frontView.alpha = 0.5;
        }
        [self.view addSubview:view];
    }
    
    /*
        锚点的范围:(0, 1)
        默认值:(0.5, 0.5) --> 中心位置
        锚点改变,中心点不会改变,中心点其实就是锚点在视图中的位置坐标,所以锚点不管怎么改变,改变之后视图都将钉在默认的锚点位置,所以center不会改变
        看锚点变后的位置关键是参照默认锚点位置
     */
    NSLog(@"center = %@, anchor = %@", NSStringFromCGPoint(self.bgView.center), NSStringFromCGPoint(self.bgView.layer.anchorPoint));
    NSLog(@"frame = %@", NSStringFromCGRect(self.bgView.frame));

/*
    self.bgView.layer.anchorPoint = CGPointMake(0, 0);
    NSLog(@"center = %@, anchor = %@", NSStringFromCGPoint(self.bgView.center), NSStringFromCGPoint(self.bgView.layer.anchorPoint));
    NSLog(@"frame = %@", NSStringFromCGRect(self.bgView.frame));
    // center = {160, 284}, anchor = {0, 0}
    // frame = {{160, 284}, {200, 200}}
*/
    self.bgView.layer.anchorPoint = CGPointMake(0.8, 0.5);
    NSLog(@"center = %@, anchor = %@", NSStringFromCGPoint(self.bgView.center), NSStringFromCGPoint(self.bgView.layer.anchorPoint));
    NSLog(@"frame = %@", NSStringFromCGRect(self.bgView.frame));
    // 改变锚点，center不会改变
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
