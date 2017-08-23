//
//  MusicShowTableViewCell.m
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/5/18.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import "MusicShowTableViewCell.h"

@implementation MusicShowTableViewCell
{
    UILabel *songNameLabel;
    UILabel *singerLabel;
    UIImageView *songimage;
    UIButton *playBtn;
    UIButton *downBtn;
    NSDictionary *dicss;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        songimage=[[UIImageView alloc]initWithFrame:CGRectMake(PXChange(30), PXChange(30), PXChange(100), PXChange(100))];
        songimage.layer.borderColor=[UIColor colorWithHexString:@"#8a8a8a"].CGColor;
        songimage.layer.borderWidth=1;
        songimage.layer.cornerRadius=songimage.width/2.0f;
        songimage.layer.masksToBounds=YES;
        [self addSubview:songimage];
        
        songNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(songimage.right+PXChange(20), songimage.top, ScreenWidth-songimage.right-PXChange(20), PXChange(34))];
        
        songNameLabel.textColor=[UIColor colorWithHexString:@"#1296db"];
        songNameLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:PXChange(34)];
        [self addSubview:songNameLabel];
        
        singerLabel=[[UILabel alloc]initWithFrame:CGRectMake(songimage.right+PXChange(20), songNameLabel.bottom+PXChange(18), PXChange(1), PXChange(1))];
        singerLabel.textColor=[UIColor colorWithHexString:@"#bfbfbf"];
        singerLabel.font=[UIFont fontWithName:@"PingFangSC-Regular" size:PXChange(30)];
        [self addSubview:singerLabel];
        
        playBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, PXChange(44),PXChange(44))];
        [playBtn setImage:[UIImage imageNamed:@"play_cell"] forState:UIControlStateNormal];
        [playBtn addTarget:self action:@selector(playClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playBtn];
        
        downBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, PXChange(44),PXChange(44))];
        [downBtn setImage:[UIImage imageNamed:@"down_cell"] forState:UIControlStateNormal];
        [downBtn addTarget:self action:@selector(downLoadClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downBtn];
    }
    return self;
}
- (void)loadWithDic:(NSDictionary *)dic{
    dicss=dic;
    [songimage sd_setImageWithURL:[NSURL URLWithString:dic[@"SingerImg"]]];
    songNameLabel.text=dic[@"SongName"];
    singerLabel.text=dic[@"Singer"];
    [singerLabel sizeToFit];
    playBtn.center=CGPointMake(ScreenWidth-PXChange(118), singerLabel.centerY);
    downBtn.center=CGPointMake(ScreenWidth-PXChange(50), playBtn.centerY);
}
- (void)awakeFromNib {
    [super awakeFromNib];
}
- (void)playClick{
    self.playBlock(dicss);
}
- (void)downLoadClick{
    self.downLoadBlock(dicss);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
