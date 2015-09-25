//
//  ZJCALayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 9/24/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCALayerViewController.h"
#import "ZJCALayerTableViewController.h"

@interface ZJCALayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *layerView;

@end

@implementation ZJCALayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initSetting];
}

- (void)initSetting {
    _star = [UIImage imageNamed:@"star"].CGImage;
    
    _layer = [CALayer layer];
    _layer.frame = self.layerView.bounds;
    _layer.contents = (__bridge id _Nullable)(_star);
    _layer.contentsGravity = kCAGravityCenter;
    _layer.geometryFlipped = NO;
    _layer.cornerRadius = 100.0;
    _layer.borderWidth = 12.0;
    _layer.borderColor = [UIColor whiteColor].CGColor;
    _layer.backgroundColor = [UIColor colorWithRed:11/255.0 green:86/255.0 blue:14/255.0 alpha:1.0].CGColor;
    _layer.shadowOpacity = 0.75;
    _layer.shadowOffset = CGSizeMake(0, 3);
    _layer.shadowRadius = 3.0;
    _layer.magnificationFilter = kCAFilterLinear;
    
    [self.layerView.layer addSublayer:_layer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DisplayLayerControls"]) {
        ZJCALayerTableViewController *vc = segue.destinationViewController;
        vc.layerController = self;
    }
}


@end
