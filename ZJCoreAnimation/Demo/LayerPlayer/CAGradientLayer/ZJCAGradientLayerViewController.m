//
//  ZJCAGradientLayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 9/25/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCAGradientLayerViewController.h"

@interface ZJCAGradientLayerViewController () {
    NSArray *_locations, *_colors;
    CAGradientLayer *_grandientLayer;
}

@property (weak, nonatomic) IBOutlet UIView *gradientLayerView;

@property (weak, nonatomic) IBOutlet UILabel *startPointSliderValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *endPointSliderValueLabel;
@property (strong, nonatomic) IBOutletCollection(UISwitch) NSArray *colorSwitches;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *locationSliders;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *locationSliderValueLabels;

@end

@implementation ZJCAGradientLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    [self initSettingGradientLayer];
}

- (void)initAry {
    _locations = @[@0, @(1/6.0), @(1/3.0), @0.5, @(2/3.0), @(5/6.0), @1.0];
                [self getCGColorWithRed:1 green:1 blue:1];
    
    _colors = @[[self getCGColorWithRed:209.0 green:0.0 blue:0.0],
                [self getCGColorWithRed:255.0 green:102.0 blue:34.0],
                [self getCGColorWithRed:255.0 green:218.0 blue:33.0],
                [self getCGColorWithRed:51.0 green:221.0 blue:0.0],
                [self getCGColorWithRed:17.0 green:51.0 blue:204.0],
                [self getCGColorWithRed:34.0 green:0.0 blue:102.0],
                [self getCGColorWithRed:51.0 green:0.0 blue:68.0]
                ];
    for (int i = 0; i < self.locationSliders.count; i++) {
        UISlider *slider = self.locationSliders[i];
        UILabel *label = self.locationSliderValueLabels[i];
        slider.value = [_locations[i] floatValue];
        label.text = [NSString stringWithFormat:@"%.1f", slider.value];
    }
}

- (id)getCGColorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return (id)[UIColor colorWithRed:red / 255 green:green / 255 blue:blue / 255 alpha:1].CGColor;
}

- (void)initSettingGradientLayer {
    _grandientLayer                      = [CAGradientLayer layer];
    _grandientLayer.frame                = self.gradientLayerView.bounds;
    _grandientLayer.colors               = _colors;
    _grandientLayer.locations            = _locations;
    _grandientLayer.startPoint           = CGPointMake(0.0, 0.0);
    _grandientLayer.endPoint             = CGPointMake(0.5, 1.0);
    [self.gradientLayerView.layer addSublayer:_grandientLayer];

    self.startPointSliderValueLabel.text = [self getPointTextWithPoint:_grandientLayer.startPoint];
    self.endPointSliderValueLabel.text   = [self getPointTextWithPoint:_grandientLayer.endPoint];
}

- (NSString *)getPointTextWithPoint:(CGPoint)point {
    return [NSString stringWithFormat:@"%.1f\n%.1f", point.x, point.y];
}

/*
 *  The start point corresponds to the first gradient
 *  stop, the end point to the last gradient stop
 *  (I.e. [0,0] is the bottom-left
 *  corner of the layer, [1,1] is the top-right corner.) The default values
 *  are [.5,0] and [.5,1] respectively
 */
- (IBAction)startPointSliderChanged:(UISlider *)sender {
    if (sender.tag == 0) {          // startPoint
        _grandientLayer.startPoint = CGPointMake(sender.value, 0.0);
        self.startPointSliderValueLabel.text = [self getPointTextWithPoint:_grandientLayer.startPoint];
    }else if (sender.tag == 1) {    // endPoint
        _grandientLayer.endPoint = CGPointMake(sender.value, 1.0);
        self.endPointSliderValueLabel.text   = [self getPointTextWithPoint:_grandientLayer.endPoint];
    }
}

- (IBAction)colorSwitchChanged:(UISwitch *)sender {
    NSMutableArray *colors = [NSMutableArray array];

    for (int i = 0; i < self.colorSwitches.count; i++) {
        UISwitch *colorSwitch = self.colorSwitches[i];
        UISlider *slider = self.locationSliders[i];
        UILabel *label = self.locationSliderValueLabels[i];

        if (colorSwitch.isOn) {
            [colors addObject:_colors[i]];
            slider.hidden = NO;
            label.hidden = NO;
        }else {
            slider.hidden = YES;
            label.hidden = YES;
        }
    }

    _grandientLayer.colors = colors;
}

- (IBAction)locationSliderChanged:(UISlider *)sender {
    NSMutableArray *locatons = [NSMutableArray array];
    
    for (int i = 0; i < self.colorSwitches.count; i++) {
        UISwitch *colorSwitch = self.colorSwitches[i];
        UISlider *slider = self.locationSliders[i];
        UILabel *label = self.locationSliderValueLabels[i];
        
        if (colorSwitch.isOn) {
            [locatons addObject:[NSNumber numberWithFloat:slider.value]];
            label.text = [NSString stringWithFormat:@"%.1f", slider.value];
        }
    }
    
    _grandientLayer.locations = locatons;
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
