//
//  ZJTiledVIewForLoadImage.m
//  ZJCALayerSample
//
//  Created by YunTu on 15/3/27.
//  Copyright (c) 2015年 YunTu. All rights reserved.
//

#import "ZJTiledVIewForLoadImage.h"

@interface ZJTiledVIewForLoadImage () {
    NSString *_cachePath;
    CGImageRef _srcImageRef;
    NSFileManager *_fileManager;
}

@end

static CGFloat sideLength = 640.0;
static NSString *fileName = @"windingRoad";

@implementation ZJTiledVIewForLoadImage

- (void)drawRect:(CGRect)rect {
    NSInteger firstColumn = (NSInteger)CGRectGetMinX(rect) / sideLength;
    NSInteger lastColumn = (NSInteger)CGRectGetMaxX(rect) / sideLength;
    NSInteger firstRow = (NSInteger)CGRectGetMinY(rect) / sideLength;
    NSInteger lastRow = (NSInteger)CGRectGetMaxY(rect) / sideLength;

    for (int row = firstRow; row <= lastRow; row++) {
         for (int column = firstColumn; column <= lastColumn; column++) {
             CGFloat x = sideLength * column;
             CGFloat y = sideLength * row;
             CGRect rect = CGRectMake(x, y, sideLength, sideLength);
             rect = CGRectIntersection(self.bounds, rect);
             UIImage *image = [self imageForTileAtColum:column withRow:row withRect:rect];
             if (image) {
                [image drawInRect:rect];
             }
        }
    }
}

- (UIImage *)imageForTileAtColum:(NSInteger)column withRow:(NSInteger)row withRect:(CGRect)rect {
    NSString *filePath = [_cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d_%d.jpg", fileName, column, row]];
    
    if ([_fileManager fileExistsAtPath:filePath]) {
        return [UIImage imageWithContentsOfFile:filePath];
    }else {
        CGImageRef tileImageRef = CGImageCreateWithImageInRect(_srcImageRef, rect);
        UIImage *img = [UIImage imageWithCGImage:tileImageRef];
        NSData *imageData = UIImageJPEGRepresentation(img, 1);
        [imageData writeToFile:filePath atomically:NO];
        
        return img;
    }
}

+ (Class)layerClass {
    return [CATiledLayer class];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _fileManager = [NSFileManager defaultManager];
        _srcImageRef = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", fileName]].CGImage;
        
        _cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        CATiledLayer *layer = (CATiledLayer *)self.layer;
        layer.contentsScale = UIScreen.mainScreen.scale;
        layer.tileSize = CGSizeMake(sideLength, sideLength);
    }
    return self;
}

@end
