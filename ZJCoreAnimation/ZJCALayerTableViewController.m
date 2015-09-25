//
//  ZJCALayerTableViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 9/24/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCALayerTableViewController.h"
#import "UIViewExt.h"

@interface ZJCALayerTableViewController () <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *_contentsGravityValues;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *contentsGravityLabel;

@property (weak, nonatomic) IBOutlet UILabel *borderColorSlidersValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *backgroundColorSlidersValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *shadowOffsetSlidersValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *shadowColorSlidersValueLabel;

@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *borderColorSliders;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *bgColorSliders;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *shadowOffsetSliders;
@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *shadowColorSliders;

@end

NS_ENUM(NSInteger, ROW) {
    ContentsGravity,
    ContentsGravityPicker,
    DisplayContents,
    GeometryFlipped,
    Hidden,
    Opacity,
    CornerRadius,
    BorderWidth,
    BorderColor,
    BackgroundColor,
    ShadowOpacity,
    ShadowOffset,
    ShadowRadius,
    ShadowColor,
    MagnificationFilter
};

NS_ENUM(NSInteger, Switch) {
    DisplayContentsSwitch,
    GeometryFlippedSwitch,
    HiddenSwitch,
};

NS_ENUM(NSInteger, Slider) {
    OpacitySlider,
    CornerRadiusSlider,
    BorderWidthSlider,
    ShadowOpacitySlider,
    ShadowRadiusSlider,
};

@implementation ZJCALayerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
    self.pickerView.hidden = YES;
}

- (void)initAry {
    _contentsGravityValues = @[kCAGravityCenter, kCAGravityTop, kCAGravityBottom, kCAGravityLeft, kCAGravityRight, kCAGravityTopLeft, kCAGravityTopRight, kCAGravityBottomLeft, kCAGravityBottomRight, kCAGravityResize, kCAGravityResizeAspect, kCAGravityResizeAspectFill];
}

- (IBAction)switchChanged:(UISwitch *)sender {
    if (sender.tag == DisplayContentsSwitch) {
        self.layerController.layer.contents = (__bridge id _Nullable)(sender.isOn ? self.layerController.star : nil);
    }else if(sender.tag == GeometryFlippedSwitch) {
        self.layerController.layer.geometryFlipped = sender.isOn;
    }else if (sender.tag == HiddenSwitch) {
        self.layerController.layer.hidden = sender.isOn;
    }
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (sender.tag == OpacitySlider) {
        self.layerController.layer.opacity = sender.value;
    }else if(sender.tag == CornerRadiusSlider) {
        self.layerController.layer.cornerRadius = sender.value;
    }else if (sender.tag == BorderWidthSlider) {
        self.layerController.layer.borderWidth = sender.value;
    }else if (sender.tag == ShadowOpacitySlider) {
        self.layerController.layer.shadowOpacity = sender.value;
    }else if (sender.tag == ShadowRadiusSlider) {
        self.layerController.layer.shadowRadius = sender.value;
    }
}

- (NSDictionary *)getColorWithSliders:(NSArray *)sliders {
    CGFloat red = ((UISlider *)sliders[0]).value;
    CGFloat green = ((UISlider *)sliders[1]).value;
    CGFloat blue = ((UISlider *)sliders[2]).value;
    
    UIColor *color = [UIColor colorWithRed:red / 255 green:green / 255 blue:blue / 255 alpha:1];
    NSString *text = [NSString stringWithFormat:@"RGB:%.0f,%.0f,%.0f", red, green, blue];
    
    return @{@"color" : color, @"text" : text};
}

- (IBAction)borderColorSliderValueChanged:(UISlider *)sender {
    NSDictionary *dic = [self getColorWithSliders:self.borderColorSliders];
    UIColor *color = dic[@"color"];
    
    self.layerController.layer.borderColor = color.CGColor;
    self.borderColorSlidersValueLabel.text = dic[@"text"];
}

- (IBAction)bgColorSliderValueChanged:(UISlider *)sender {
    NSDictionary *dic = [self getColorWithSliders:self.bgColorSliders];
    UIColor *color = dic[@"color"];
    
    self.layerController.layer.backgroundColor = color.CGColor;
    self.backgroundColorSlidersValueLabel.text = dic[@"text"];
}

- (IBAction)shadowOffsetSliderValueChanged:(UISlider *)sender {
    CGFloat width = ((UISlider *)(self.shadowOffsetSliders[0])).value;
    CGFloat height = ((UISlider *)(self.shadowOffsetSliders[1])).value;
    self.layerController.layer.shadowOffset = CGSizeMake(width, height);
    self.shadowOffsetSlidersValueLabel.text = [NSString stringWithFormat:@"Width:%.0f,Height:%.0f", width, height];
}

- (IBAction)shadowColorSliderValueChanged:(UISlider *)sender {
    NSDictionary *dic = [self getColorWithSliders:self.shadowColorSliders];
    UIColor *color = dic[@"color"];
    
    self.layerController.layer.shadowColor = color.CGColor;
    self.shadowColorSlidersValueLabel.text = dic[@"text"];
}

//
- (IBAction)magnificationFilterSegmentedControlChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.layerController.layer.magnificationFilter = kCAFilterLinear;       // 线
    }else if (sender.selectedSegmentIndex == 1) {
        self.layerController.layer.magnificationFilter = kCAFilterNearest;      // 最近的
    }else if (sender.selectedSegmentIndex == 2) {
        self.layerController.layer.magnificationFilter = kCAFilterTrilinear;    // 三线的
    }
}

- (void)hiddenPickerView {
    [UIView animateWithDuration:.25 animations:^{
        [self.tableView beginUpdates];
        self.pickerView.alpha = 0;
    } completion:^(BOOL finished) {
        self.pickerView.hidden = YES;
        [self.tableView endUpdates];
    }];
}

- (void)showPickerView {
    self.pickerView.hidden = NO;
    [UIView animateWithDuration:.25 animations:^{
        [self.tableView beginUpdates];
        self.pickerView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.tableView endUpdates];
    }];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ContentsGravityPicker) {
        return self.pickerView.isHidden ? 0 : self.pickerView.height;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == ContentsGravity) {
        if (self.pickerView.isHidden) {
            [self showPickerView];
        }else {
            [self hiddenPickerView];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _contentsGravityValues.count;
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _contentsGravityValues[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.contentsGravityLabel.text = _contentsGravityValues[row];
    
    self.layerController.layer.contentsGravity = _contentsGravityValues[row];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
