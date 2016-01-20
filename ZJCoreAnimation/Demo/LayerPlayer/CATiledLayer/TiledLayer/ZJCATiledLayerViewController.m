//
//  ZJCATiledLayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/5/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCATiledLayerViewController.h"
#import "ZJTiledView.h"
#import "ZJTiledLayer.h"

@interface ZJCATiledLayerViewController ()<UIScrollViewDelegate> {
    CATiledLayer *_tiledLayer;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet ZJTiledView *tiledView;

@property (weak, nonatomic) IBOutlet UISlider *zoomSlider;

@property (weak, nonatomic) IBOutlet UILabel *fadeDurationLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelsOfDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailBiasLabel;
@property (weak, nonatomic) IBOutlet UILabel *zoomScaleLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *sliderValueLables;

@end

@implementation ZJCATiledLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSetting];
}

- (void)initSetting {
    _tiledLayer = (CATiledLayer *)self.tiledView.layer;
    
    self.fadeDurationLabel.text = [NSString stringWithFormat:@"%.2f", [ZJTiledLayer fadeDuration]];
    self.titleSizeLabel.text = [NSString stringWithFormat:@"%.0f", _tiledLayer.tileSize.width];
    self.levelsOfDetailLabel.text = [NSString stringWithFormat:@"%ld", _tiledLayer.levelsOfDetail];
    self.detailBiasLabel.text = [NSString stringWithFormat:@"%ld", _tiledLayer.levelsOfDetailBias];
    self.zoomScaleLabel.text = [NSString stringWithFormat:@"%.1f", self.scrollView.zoomScale];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if (sender.tag == 0) {
        [ZJTiledLayer setFadeDuration:sender.value];
        _tiledLayer.contents = nil;
        [_tiledLayer setNeedsDisplayInRect:_tiledLayer.bounds];
    }else if (sender.tag == 1) {
        _tiledLayer.tileSize = CGSizeMake(sender.value, sender.value);
    }else if (sender.tag == 2) {
        _tiledLayer.levelsOfDetail = sender.value;
    }else if (sender.tag == 3) {
        _tiledLayer.levelsOfDetailBias = sender.value;
    }else if (sender.tag == 4) {
        self.scrollView.zoomScale = sender.value;
    }
    [self adjustSliderValueLabelWithValue:sender];
}

- (void)adjustSliderValueLabelWithValue:(UISlider *)sender {
    for (int i = 0; i < self.sliderValueLables.count; i++) {
        if (i == sender.tag) {
            UILabel *label = self.sliderValueLables[i];
            if (i < 1) {
                label.text = [NSString stringWithFormat:@"%.2f", sender.value];
            }else if(i < self.sliderValueLables.count - 1) {
                label.text = [NSString stringWithFormat:@"%.0f", sender.value];
            }else {
                label.text = [NSString stringWithFormat:@"%.1f", sender.value];
            }
        }
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.tiledView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    self.zoomSlider.value = self.scrollView.zoomScale;
    self.zoomScaleLabel.text = [NSString stringWithFormat:@"%.1f", self.scrollView.zoomScale];
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
