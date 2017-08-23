//
//  HotSearchCollectionViewCell.h
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/2/21.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotSearchCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UILabel *movieName;
@property (weak, nonatomic) IBOutlet UILabel *movieActior;
@property (weak, nonatomic) IBOutlet UILabel *movieRespose;
@end
