//
//  ZJCATransform3DTypeTableViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/8/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCATransform3DTypeTableViewController.h"
#import "ZJCATransform3DViewController.h"

@interface ZJCATransform3DTypeTableViewController () {
    NSArray *_titles;
}

@end

static NSString *CELLID = @"cellID";

@implementation ZJCATransform3DTypeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titles = @[@"平移", @"缩放", @"正交投影", @"旋转1", @"旋转2"];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CELLID];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID forIndexPath:indexPath];
    
    cell.textLabel.text = _titles[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < _titles.count - 1) {
        [self performSegueWithIdentifier:@"transform3D" sender:indexPath];
    }else {
        [self performSegueWithIdentifier:@"transform3DRotation2" sender:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"transform3D"]) {
        NSIndexPath *indexPath = sender;
        
        ZJCATransform3DViewController *vc = [segue destinationViewController];
        vc.transformType = indexPath.row;
        vc.title = _titles[indexPath.row];
    }
}


@end
