//
//  ScrollingView.m
//  ZJCALayerSample
//
//  Created by YunTu on 15/3/24.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ScrollingView.h"

@interface ScrollingView ()

@end

@implementation ScrollingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}
*/

+ (Class)layerClass {
    return [CAScrollLayer class];
}

@end
