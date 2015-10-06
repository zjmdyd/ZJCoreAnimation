//
//  ZJCAShapeLayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/6/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCAShapeLayerViewController.h"

NS_ENUM(NSInteger, FillRule) {
    NonZero,
    EvenOdd
};

NS_ENUM(NSInteger, LineCap) {
    Butt,
    Round,
    Square,
    Cap
};

NS_ENUM(NSInteger, LineJoin) {
    JoinMiter,
    JoinRound,
    JoinBevel
};

@interface ZJCAShapeLayerViewController () {
    CAShapeLayer *_shapeLayer;
    UIBezierPath *_openPath, *_closePath;
    UIColor *_color;
    enum LineCap _lineCap;
    enum FillRule _fillRule;
}

@property (weak, nonatomic) IBOutlet UIView *shapeLayerView;

@property (weak, nonatomic) IBOutlet UISegmentedControl *fillRuleSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *lineCapSegmentedControl;

@property (weak, nonatomic) IBOutlet UISlider *colorSlider;
@property (weak, nonatomic) IBOutlet UISlider *lineWidthSlider;

@property (weak, nonatomic) IBOutlet UISwitch *closePathSwith;
@property (weak, nonatomic) IBOutlet UISwitch *fillSwitch;

@end

@implementation ZJCAShapeLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    [self setupPath];
    [self setupShapeLayer];
}

- (void)setupPath {
    _openPath = [UIBezierPath bezierPath];
    [_openPath moveToPoint:CGPointMake(30, 196)];
    [_openPath addCurveToPoint:CGPointMake(112.0, 12.5) controlPoint1:CGPointMake(110.56, 13.79) controlPoint2:CGPointMake(112.07, 13.01)];
    [_openPath addCurveToPoint:CGPointMake(194, 196) controlPoint1:CGPointMake(111.9, 11.81) controlPoint2:CGPointMake(194, 196)];
    [_openPath addLineToPoint:CGPointMake(30.0, 85.68)];
    [_openPath addLineToPoint:CGPointMake(194.0, 48.91)];
    [_openPath addLineToPoint:CGPointMake(30, 196)];

    _closePath = [UIBezierPath bezierPath];
    _closePath.CGPath = CGPathCreateMutableCopy(_openPath.CGPath);
    [_closePath closePath];
}

- (void)setupShapeLayer {
    _lineCap = Butt;
    self.colorSlider.value = 129;
    self.lineWidthSlider.value = 10;
    
    _color = [UIColor colorWithHue:self.colorSlider.value / 359.0 saturation:1.0 brightness:0.4 alpha:1.0];
    
    _shapeLayer = [CAShapeLayer layer];
    _shapeLayer.path = _openPath.CGPath;
    _shapeLayer.fillColor = nil;
    _shapeLayer.fillRule = kCAFillRuleNonZero;
    _shapeLayer.lineCap = kCALineCapButt;
    _shapeLayer.lineDashPattern = nil;
    _shapeLayer.lineDashPhase = 0.0;
    _shapeLayer.lineJoin = kCALineJoinMiter;
    _shapeLayer.lineWidth = self.lineWidthSlider.value;
    _shapeLayer.miterLimit = 4.0;
    _shapeLayer.strokeColor = _color.CGColor;
    [self.shapeLayerView.layer addSublayer:_shapeLayer];
}

- (IBAction)switchValueChange:(UISwitch *)sender {
    NSInteger selectIndex = -1;

    if (sender.tag == 0) {
        if (sender.isOn) {
            selectIndex = UISegmentedControlNoSegment;
            _shapeLayer.path = _closePath.CGPath;
        }else {
            _shapeLayer.path = _openPath.CGPath;
            switch ((int)_lineCap) {
                case Butt:
                    selectIndex = 0;
                    break;
                case Round:
                    selectIndex = 1;
                    break;
                case Square:
                    selectIndex = 2;
                    break;
            }
        }
        self.lineCapSegmentedControl.selectedSegmentIndex = selectIndex;
    }else if (sender.tag == 1) {
        if (sender.isOn) {
            _shapeLayer.lineDashPattern = @[@50, @50];
            _shapeLayer.lineDashPhase = 25.0;
        }else {
            _shapeLayer.lineDashPattern = nil;
            _shapeLayer.lineDashPhase = 0;
        }
    }else if (sender.tag == 2) {
        if (sender.isOn) {
            _shapeLayer.fillColor = _color.CGColor;
            switch (_fillRule) {
                case NonZero:
                    selectIndex = 0;
                    break;
                case EvenOdd:
                    selectIndex = 1;
                    break;
            }
        }else {
            _shapeLayer.fillColor = nil;
            selectIndex = UISegmentedControlNoSegment;
        }
        self.fillRuleSegmentedControl.selectedSegmentIndex = selectIndex;
    }
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    if (sender.tag == 0) {
        _color = [UIColor colorWithHue:sender.value/359.0 saturation:1.0 brightness:0.4 alpha:1.0];
        _shapeLayer.strokeColor = _color.CGColor;
        _shapeLayer.fillColor = self.fillSwitch.isOn ? _color.CGColor : nil;
    }else if (sender.tag == 1) {
        _shapeLayer.lineWidth = sender.value;
    }
}

- (IBAction)segmentedControlValueChange:(UISegmentedControl *)sender {
    if (sender.tag == 0) {
        if (!self.fillSwitch.isOn) {
            self.fillSwitch.on = YES;
            _shapeLayer.fillColor = _color.CGColor;
        }
        if (sender.selectedSegmentIndex == NonZero) {
            _shapeLayer.fillRule = kCAFillRuleNonZero;
        }else if (sender.selectedSegmentIndex == EvenOdd) {
            _shapeLayer.fillRule = kCAFillRuleEvenOdd;
        }
        _fillRule = sender.selectedSegmentIndex;
    }else if (sender.tag == 1) {
        if (self.closePathSwith.isOn) {
            self.closePathSwith.on = NO;
            _shapeLayer.path = _openPath.CGPath;
        }
        
        if (sender.selectedSegmentIndex == Butt) {
            _shapeLayer.lineCap = kCALineCapButt;
        }else if (sender.selectedSegmentIndex == Round) {
            _shapeLayer.lineCap = kCALineCapRound;
        }else if (sender.selectedSegmentIndex == Square) {
            _shapeLayer.lineCap = kCALineCapSquare;
        }
        _lineCap = sender.selectedSegmentIndex;
    }else if (sender.tag == 2) {
        if (sender.selectedSegmentIndex == JoinMiter) {
            _shapeLayer.lineJoin = kCALineJoinMiter;
        }else if (sender.selectedSegmentIndex == JoinRound) {
            _shapeLayer.lineJoin = kCALineJoinRound;
        }else if (sender.selectedSegmentIndex == JoinBevel) {
            _shapeLayer.lineJoin = kCALineJoinBevel;
        }
    }
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
