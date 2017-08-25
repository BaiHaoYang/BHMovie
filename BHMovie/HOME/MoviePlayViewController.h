//
//  MoviePlayViewController.h
//  BHMovie
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 XHDAXHK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeDataModel.h"
@interface MoviePlayViewController : UIViewController
@property (nonatomic,copy)NSString *MovieUrl;
@property (nonatomic,copy)NSString *MovieDownUrl;
@property (nonatomic,copy)NSString *MovieName;
@property (nonatomic,copy)NSURL *MovieUrlForLoacl;
@property (nonatomic,assign)NSInteger playType;//等于1的时候是播放本地视频
@end
