//
//  UIColor+Addons.m
//  Shangyi
//
//  Created by Lvwy on 15/6/12.
//  Copyright (c) 2015年 liuyue. All rights reserved.
//

#import "UIColor+Addons.h"

@implementation UIColor (Addons)

#pragma mark - HexColors

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    return [[self colorWithHexString:hexString] colorWithAlphaComponent:alpha];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#"
                                                     withString: @""];
    
    if ([hexString length] < 6) {
        return nil;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-fA-F|0-9]" options:0 error:NULL];
    NSUInteger match = [regex numberOfMatchesInString:hexString options:NSMatchingReportCompletion range:NSMakeRange(0, [hexString length])];
    if (match != 0) {
        return nil;
    }
    
    NSRange range = NSMakeRange(0, 2);
    unsigned int val = 0;
    NSString *component = [hexString substringWithRange:range];
    [[NSScanner scannerWithString:component] scanHexInt:&val];
    float rRetVal = val / 255.f;
    
    range.location += 2;
    component = [hexString substringWithRange:range];
    [[NSScanner scannerWithString:component] scanHexInt:&val];
    float gRetVal = val / 255.f;
    
    range.location += 2;
    component = [hexString substringWithRange:range];
    [[NSScanner scannerWithString:component] scanHexInt:&val];
    float bRetVal = val / 255.f;
    
    return [UIColor colorWithRed:rRetVal green:gRetVal blue:bRetVal alpha:1.0f];
}

- (NSString *)hexValues {
    if (self == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    int redDec = (int)(red * 255);
    int greenDec = (int)(green * 255);
    int blueDec = (int)(blue * 255);
    
    NSString *returnString = [NSString stringWithFormat:@"%02x%02x%02x", (unsigned int)redDec, (unsigned int)greenDec, (unsigned int)blueDec];
    
    return returnString;
}

@end
