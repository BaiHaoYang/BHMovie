//
//  MusicPlayViewController.h
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/5/17.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicPlayViewController : UIViewController
@property(nonatomic,copy)NSString *ShowTitle;
@property(nonatomic,copy)NSString *musicUrl;
@property(nonatomic,copy)NSDictionary *dataDic;
@property(nonatomic,assign)NSInteger type;//1.本地 其他网络
@end
