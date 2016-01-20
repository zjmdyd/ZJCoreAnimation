//
//  ZJSearchingView.h
//  Test
//
//  Created by ZJ on 1/19/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSearchingView : UIView

@property (nonatomic, getter=isSearching) BOOL searching;


@property (nonatomic, assign) CGFloat angleSpan;
@property (nonatomic, assign) CGFloat lineWidth;

- (void)startSearching;

- (void)stopSearching;

@end
