//
//  MusicShowTableViewCell.h
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/5/18.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicShowTableViewCell : UITableViewCell

@property(strong, nonatomic) void (^playBlock)(NSDictionary *dic);
@property(strong, nonatomic) void (^downLoadBlock)(NSDictionary *dic);
- (void)loadWithDic:(NSDictionary *)dic;

@end
