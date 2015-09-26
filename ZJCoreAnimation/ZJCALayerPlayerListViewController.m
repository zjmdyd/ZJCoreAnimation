//
//  ZJCALayerPlayerListViewController.m
//  ZJCoreAnimation
//
//  Created by YunTu on 9/23/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJCALayerPlayerListViewController.h"

@interface ZJCALayerPlayerListViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSArray *_titles, *_vcs;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *LAYERCELLID = @"cellID";

@implementation ZJCALayerPlayerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAry];
}

- (void)initAry {
    _titles = @[@[@"CALayer", @"Manage and animate visual content"],
                @[@"CAScrollLayer", @"Display portion of a scrollable layer"],
                @[@"CATextLayer", @"Render plain text or attributed strings"],
                @[@"AVPlayerLayer", @"Display an AV player "],
                @[@"CAGradientLayer", @"Apply a color gradient over the background"],
                @[@"CAReplicatorLayer", @"Duplicate a source layer"],
                @[@"CATiledLayer", @"Asynchronously draw layer content in tiles"],
                @[@"CAShapeLayer", @"Draw using scalable vector paths"],
                @[@"CAEAGLLayer", @"Draw OpenGL content"],
                @[@"CATransformLayer", @"Draw 3D structures"],
                @[@"CAEmitterLayer", @"Render animated particles"]
                ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LAYERCELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:LAYERCELLID];
    }
    NSArray *titles = _titles[indexPath.row];
    cell.textLabel.text = titles.firstObject;
    cell.detailTextLabel.text = titles.lastObject;
    cell.imageView.image = [UIImage imageNamed:titles.firstObject];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.separatorInset = UIEdgeInsetsMake(0, -44, 0, 0);
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *titles = _titles[indexPath.row];
    @try {
        @try {
            [self performSegueWithIdentifier:titles.firstObject sender:nil];
        }
        @catch (NSException *exception) {
            @throw exception;
        }
        @finally {
            NSLog(@"内层@finally");
        }
    }
    @catch (NSException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"此功能尚未实现" message:@"革命尚未成功,同志仍需努力" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        NSLog(@"exception : %@, %@", exception.name, exception.reason);
    }
    @finally {
        NSLog(@"外层@finally");

    }
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
