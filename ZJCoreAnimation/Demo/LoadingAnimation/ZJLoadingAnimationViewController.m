//
//  ZJLoadingAnimationViewController.m
//  ZJCoreAnimation
//
//  Created by ZJ on 1/20/16.
//  Copyright © 2016 YunTu. All rights reserved.
//

#import "ZJLoadingAnimationViewController.h"
#import "ZJSearchingView.h"

@interface ZJLoadingAnimationViewController ()

@end

@implementation ZJLoadingAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ZJSearchingView *searchView = [[ZJSearchingView alloc] initWithFrame:CGRectMake(100, 100, 150, 150)];
    [self.view addSubview:searchView];
    
    [searchView startSearching];
}

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
