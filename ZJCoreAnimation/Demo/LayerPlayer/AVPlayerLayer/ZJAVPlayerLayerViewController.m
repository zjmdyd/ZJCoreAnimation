//
//  ZJAVPlayerLayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 9/25/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJAVPlayerLayerViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZJAVPlayerLayerViewController () {
    AVPlayerLayer *_playerLayer;
    AVPlayer *_player;
}

@property (weak, nonatomic) IBOutlet UIView *playerLayerView;
@property (weak, nonatomic) IBOutlet UIButton *playControlButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegmentedControl;
@property (weak, nonatomic) IBOutlet UISwitch *playModeSwitch;

@end

NS_ENUM(NSInteger, RATE) {
    SlowForward,
    Normal,
    FastForward
};

@implementation ZJAVPlayerLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSettingPlayerLayer];
    [self initSettingPlayer];
    
}

- (void)initSettingPlayerLayer {
    _playerLayer = [AVPlayerLayer layer];
    _playerLayer.frame = self.playerLayerView.bounds;
    [self.playerLayerView.layer addSublayer:_playerLayer];
}

- (void)initSettingPlayer {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"colorfulStreak" ofType:@"m4v"];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [AVPlayer playerWithURL:url];
    _playerLayer.player = _player;

    [self.rateSegmentedControl setSelectedSegmentIndex:Normal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (IBAction)playControl:(UIButton *)sender {
    [sender setTitle:_player.rate < __FLT_EPSILON__ ? @"Pause" : @"Play" forState:UIControlStateNormal];
    
    if (_player.rate < __FLT_EPSILON__) {
        [_player play];
    }else {
        [_player pause];
    }
}

- (IBAction)playRateControl:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == SlowForward) {
        _player.rate = .5;
    }else if (sender.selectedSegmentIndex == Normal) {
        _player.rate = 1.0;
    }else if (sender.selectedSegmentIndex == FastForward) {
        _player.rate = 2.0;
    }
}

- (IBAction)playVolumControl:(UISlider *)sender {
    _player.volume = sender.value;
}

- (IBAction)playerModeSwitch:(UISwitch *)sender {
    if (sender.isOn) {
        _player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    }else {
        _player.actionAtItemEnd = AVPlayerActionAtItemEndPause;
    }
}

- (void)handleDidPlayToEnd:(NSNotification *)noti {
    AVPlayerItem *playerItem = noti.object;
    [playerItem seekToTime:kCMTimeZero];
    
    if (self.playModeSwitch.isOn) {
        [_player play];
    }else {
        [self.playControlButton setTitle:@"Play" forState:UIControlStateNormal];
    }
}

- (void)dealloc {    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
