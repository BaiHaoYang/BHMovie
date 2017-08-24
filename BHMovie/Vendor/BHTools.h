//
//  BHTools.h
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/2/21.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHTools : NSObject
+ (NSString *)decodeFromPercentEscapeString: (NSString *) input; //解析URL解码
+ (NSString *)DecodedBase64Code:(NSString *)data;//解析json字符
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;//把json字符串转换为Json字典
+ (id)toArrayOrNSDictionary:(NSData *)jsonData;
+(BOOL)isNull:(id)object;//判断字符串是否为null
+ (void)showAlertView:(NSString *)string;
+(UIImage*) createImageWithColor:(UIColor*)color;
+ (NSString *)base64DecodeString:(NSString *)string;
+ (NSString *)encodeBase64String:(NSString *)string;
+ (NSString *)configUrlWithString:(NSString *)subStr;
+(NSString *)findTrueMovieUrl:(NSString *)url;
@end
