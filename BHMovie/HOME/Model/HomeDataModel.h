//
//  HomeDataModel.h
//  BHMovie
//
//  Created by mac on 2016/10/25.
//  Copyright © 2016年 XHDAXHK. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface HomeDataModel : JSONModel
@property (nonatomic,copy)NSString<Optional> *MovieImage;
@property (nonatomic,copy)NSString<Optional> *MovieName;
@property (nonatomic,copy)NSString<Optional> *MovieUrl;
@property (nonatomic,copy)NSString<Optional> *Type;
@property (nonatomic,copy)NSString<Optional> *VideoArea;
@property (nonatomic,copy)NSString<Optional> *VideoType;
@property (nonatomic,copy)NSString<Optional> *VideoYear;
@end
