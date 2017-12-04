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
#import "ZFPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Masonry/Masonry.h>
#import <ZFDownload/ZFDownloadManager.h>
#import "ZFPlayer.h"
#import "UIImageView+LBBlurredImage.h"
#import "UINavigationController+ZFFullscreenPopGesture.h"
#define btnTag 200
@interface MoviePlayViewController ()<ZFPlayerDelegate,ZFPlayerControlViewDelagate>
@property(nonatomic,strong)ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong)NSMutableArray *btnArray;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic,strong) UIView *movieFatherView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)HomeDataModel *movieModel;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIScrollView *middleView;
@property (nonatomic,copy)NSString *movieName;
@property (nonatomic,copy)NSString *MovieImage;
@property (nonatomic,copy)NSString *VideoType;
@end

@implementation MoviePlayViewController
{
    NSString *_DownUrl;
    NSString *_PlayUrl;
}
- (void)dealloc {
    NSLog(@"%@释放了",self.class);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        //        [self.playerView pause];
        self.playerView.playerPushedOrPresented = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zf_prefersNavigationBarHidden = YES;
     self.view.backgroundColor=[UIColor colorWithHexString:@"#2F2725"];
    UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.movieFatherView.bottom, ScreenWidth, ScreenHeight-self.movieFatherView.bottom)];
    UIImage *i=[UIImage imageNamed:@"moviePlayBgView"];
    [imgView setImageToBlur:i blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    [self.view addSubview:imgView];
    [self playNewVideo];
}

-(void)backUp{
    [self.view removeAllSubviews];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  setGet方法
- (NSMutableArray *)dataSource {
    if (!_dataSource){
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (HomeDataModel *)movieModel {
    if (!_movieModel){
        _movieModel = [[HomeDataModel alloc]init];
    }
    return _movieModel;
}

#pragma mark - 定制返回
// 返回值要必须为NO
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    // 这里设置横竖屏不同颜色的statusbar
    // if (ZFPlayerShared.isLandscape) {
    //    return UIStatusBarStyleDefault;
    // }
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return ZFPlayerShared.isStatusBarHidden;
}

#pragma mark - ZFPlayerDelegate

- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)zf_playerDownload:(NSString *)url {
    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
    NSString *name = self.playerModel.title;
    [[ZFDownloadManager sharedDownloadManager] downFileUrl:_PlayUrl filename:name fileimage:nil];
    //    // 设置最多同时下载个数（默认是3）
    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
}

- (void)zf_playerControlViewWillShow:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        //        self.backBtn.alpha = 0;
    }];
}

- (void)zf_playerControlViewWillHidden:(UIView *)controlView isFullscreen:(BOOL)fullscreen {
    //    self.backBtn.hidden = fullscreen;
    [UIView animateWithDuration:0.25 animations:^{
        //        self.backBtn.alpha = !fullscreen;
    }];
}

#pragma mark - Getter
-(UIView *)movieFatherView{
    if(!_movieFatherView){
        CGFloat heigth = 20;
        if([BHTools isIPhoneX]){
            heigth = 44;
        }
        _movieFatherView=[[UIView alloc]initWithFrame:CGRectMake(0, heigth, ScreenWidth, ScreenHeight-heigth)];
        _movieFatherView.backgroundColor=[UIColor clearColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, heigth)];
        label.backgroundColor=[UIColor colorWithHexString:BH_Color_Main];
        [self.view addSubview:label];
        [self.view addSubview:_movieFatherView];
    }
    return _movieFatherView;
}
- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = self.MovieName;
        if(self.playType==1){
            _playerModel.videoURL=self.MovieUrlForLoacl;
        }else{
        _playerModel.videoURL         = [NSURL URLWithString:self.MovieUrl];
        }
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView     =self.movieFatherView;
        // _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        // @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        // 设置代理
        _playerView.delegate = self;
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
//        _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = NO;
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}
- (NSMutableArray *)btnArray{
    if(!_btnArray){
        _btnArray=[[NSMutableArray alloc]init];
    }
    return _btnArray;
}
#pragma mark - Action

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)playNewVideo {
    self.playerModel.videoURL         = [NSURL URLWithString:@"http://p06aj8gat.bkt.clouddn.com/tumblr_okq0suX4lT1qc940m.mp4"];
    NSLog(@"%@",self.MovieUrl);
    // 设置网络封面图
    self.playerModel.placeholderImageURLString = @"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg";
    // 从xx秒开始播放视频
    // self.playerModel.seekTime         = 15;
    [self.playerView resetToPlayNewVideo:self.playerModel];
    [self.playerView play];
}


@end
