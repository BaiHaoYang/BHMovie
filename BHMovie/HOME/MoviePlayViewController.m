//
//  MoviePlayViewController.m
//  BHMovie
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 XHDAXHK. All rights reserved.
//

#import "MoviePlayViewController.h"
#import "HomeDataModel.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "PlayViewController.h"
#import "MRVLCPlayer.h"
#import "ZFPlayerView.h"

@interface MoviePlayViewController ()<ZFPlayerDelegate,ZFPlayerControlViewDelagate>
@property(nonatomic,strong)ZFPlayerView *playerView;
@end

@implementation MoviePlayViewController
{
    NSString *_DownUrl;
    NSString *_PlayUrl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self playWithURL];
}
- (void)playWithURL{
    __weak __typeof__(self) weakSelf = self;
    [self.navigationController.navigationBar setHidden:YES];
    self.navigationController.navigationBar.translucent=YES;
    self.playerView = [[ZFPlayerView alloc] init];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20);
        make.left.right.equalTo(self.view);
        // 这里宽高比16：9，可以自定义视频宽高比
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    // 初始化控制层view(可自定义)
    ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
    controlView.backBlock=^(){
        [weakSelf dismissViewControllerAnimated:YES completion:^{            
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }];
    };
    // 初始化播放模型
    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
    playerModel.videoURL = [NSURL URLWithString:self.MovieUrl];
    playerModel.title = self.MovieName;
    playerModel.fatherView=self.view;
    [self.playerView playerControlView:controlView playerModel:playerModel];
    // 设置代理
    self.playerView.delegate = self;
    // 自动播放
    [self.playerView autoPlayTheVideo];
    self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    [controlView HiddController];
}
- (void)zf_controlView:(UIView *)controlView backAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)zf_playerDownload:(NSString *)url{
    NSLog(@"123132ddddfr");
}
@end
