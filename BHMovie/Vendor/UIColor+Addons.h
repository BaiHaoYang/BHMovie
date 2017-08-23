//
//  UIColor+Addons.h
//  Shangyi
//
//  Created by Lvwy on 15/6/12.
//  Copyright (c) 2015年 liuyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addons)

#pragma mark - HexColors

+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

- (NSString *)hexValues;

@end
