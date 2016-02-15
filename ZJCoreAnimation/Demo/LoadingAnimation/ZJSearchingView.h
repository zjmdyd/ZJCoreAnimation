//
//  ZJSearchingView.h
//  Test
//
//  Created by ZJ on 1/19/16.
//  Copyright © 2016 ZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJSearchingView : UIView

- (nullable instancetype)initWithFrame:(CGRect)frame content:(nullable id)content;

/**
 *  显示在图层中间的内容  typically a CGImageRef
 */
@property(nullable, strong) id contents;

@property (nonatomic, getter=isSearching) BOOL searching;

/**
 *  是否顺时针
 */
@property (nonatomic, getter=isClosewise) BOOL clockwise;

/**
 *  角度范围, 表示弧线的长度
 */
@property (nonatomic, assign) CGFloat angleSpan;

@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  弧线旋转一圈需要的时间,默认为1,
 */
@property (nonatomic, assign) CGFloat duration;

- (void)startSearching;

- (void)stopSearching;

@end
