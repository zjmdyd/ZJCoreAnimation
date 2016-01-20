//
//  ZJCATiledImageLayerViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/5/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCATiledImageLayerViewController.h"
#import "ZJTiledVIewForLoadImage.h"

@interface ZJCATiledImageLayerViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet ZJTiledVIewForLoadImage *tilediew;

@end

@implementation ZJCATiledImageLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView.contentSize = CGSizeMake(5120, 3200);
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
