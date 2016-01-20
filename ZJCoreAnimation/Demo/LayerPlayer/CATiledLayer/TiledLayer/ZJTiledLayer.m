//
//  ZJTiledLayer.m
//  ZJCoreAnimation
//
//  Created by YunTu on 10/5/15.
//  Copyright © 2015 YunTu. All rights reserved.
//

#import "ZJTiledLayer.h"

static CFTimeInterval adjustableFadeDuration = 0.25;

@implementation ZJTiledLayer

/*
    修改getter方法
 */
+ (CFTimeInterval)fadeDuration {
    return adjustableFadeDuration;
}

+ (void)setFadeDuration:(CFTimeInterval)duration {
    adjustableFadeDuration = duration;
}

@end
