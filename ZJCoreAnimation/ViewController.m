//
//  ViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 15/7/23.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ViewController.h"

#import "ZJFrameBoundsViewController.h"
#import "ZJAnchorPointViewController.h"
#import "ZJCALayerFirstViewController.h"

// Demo篇
#import "ZJFlipAnimationViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_sectionTitles, *_titles, *_vcs;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *CELLID = @"cellID";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    _sectionTitles = @[@"基础知识篇", @"Demo篇"];
    
    NSArray *s1 = @[@"FrameAndBounds", @"AnchoPoint", @"CALayer"];
    NSArray *s2 = @[@"FlipAnimation", @"CALayerPlayer"];
    _titles = @[s1, s2];
    
    NSArray *s0VC = @[
                      [ZJFrameBoundsViewController new],
                      [ZJAnchorPointViewController new],
                      [ZJCALayerFirstViewController new],
                      ];
    
    NSArray *s1VC = @[
                      [ZJFlipAnimationViewController new],
                      @"ZJCALayerPlayer",
                      ];
    _vcs = @[s0VC, s1VC];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _sectionTitles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titles[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.textLabel.text = _titles[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id vc = _vcs[indexPath.section][indexPath.row];
    
    if ([vc isKindOfClass:[UIViewController class]]) {
        ((UIViewController *)vc).view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self performSegueWithIdentifier:vc sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
