//
//  HotMessageModel.h
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/2/21.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HotMessageModel : JSONModel
@property (nonatomic,copy)NSString<Optional> *MovieImage;
@property (nonatomic,copy)NSString<Optional> *MovieName;
@end
