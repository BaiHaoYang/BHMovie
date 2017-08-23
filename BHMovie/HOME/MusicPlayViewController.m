//
//  MusicPlayViewController.m
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/5/17.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import "MusicPlayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MCDownloadManager.h"
#import "HWCircleView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <FSAudioStream.h>
@interface MusicPlayViewController ()<AVAudioPlayerDelegate>
@property (nonatomic,strong) FSAudioStream *audioStream;
@property (strong, nonatomic)  UILabel *controlPanel; //控制面板
@property (strong, nonatomic)  UIProgressView *playProgress;//播放进度
@property (strong, nonatomic)  UILabel *musicSinger; //演唱者
@property (strong, nonatomic)  UIButton *playOrPause; //播放/暂停按钮(如果tag为0认为是暂停状态，1是播放状态)
@property (strong ,nonatomic) NSTimer *timer;//进度更新定时器
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *beginBtn;
@property (nonatomic, strong) UILabel *jinduLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (strong, nonatomic) UIProgressView *progressView;//下载进度
@property (strong, nonatomic) UIView *controlerView;//控制面板界面
@property (strong, nonatomic) UIImageView *proTagView;//控制面板界面
@property (nonatomic ,assign) CGFloat playLength;

@end

@implementation MusicPlayViewController
{
    NSString *downloadUrl;
    UIView *downLoadView;
    NSString *downloadAAC;
    NSString *downloadHigh;
    UILabel *aacDownloadJindu;
    UILabel *highDownloadJindu;
    HWCircleView *jindu;
    UIButton *cancelBtn;
    BOOL isSet;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",self.dataDic);
    [self addCustomBackBarButtonItemWithTarget:self action:@selector(backUp)];
    [self playss];
    [self setupUI];
    [self makeNavigationStyle];
}
-(void)makeNavigationStyle{
    cancelBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, PXChange(48), PXChange(48))];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.center=CGPointMake(ScreenWidth-cancelBtn.width/2.0f-PXChange(20), cancelBtn.height/2.0f+30);
    [self.view addSubview:cancelBtn];
}
/**
 *  初始化UI
 */
-(void)setupUI{
    self.title=self.ShowTitle;
    self.view.backgroundColor=[UIColor whiteColor];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    image.center=CGPointMake(ScreenWidth/2.0f, ScreenWidth /2.0f+64);
    UIImage *i=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataDic[@"SingerImg"]]]];
    [image setImageToBlur:i blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];
    [self.view addSubview:image];
    
    UIImageView *bgImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    UIImage * bgImageimage=[BHTools createImageWithColor:[UIColor colorWithHexString:@"#A2B4BA"]];
    [bgImage setImageToBlur:bgImageimage blurRadius:kLBBlurredImageDefaultBlurRadius completionBlock:nil];\
    [self.view addSubview:bgImage];
    self.titleLabel.text=self.ShowTitle;
    [self.titleLabel sizeToFit];
    self.titleLabel.center=CGPointMake(ScreenWidth/2.0f, self.titleLabel.height/2.0f+30);
    
    
    UIImageView *Singerimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, PXChange(300), PXChange(300))];
    Singerimage.center=image.center;
    Singerimage.image=i;
    Singerimage.layer.borderColor=[UIColor whiteColor].CGColor;
    Singerimage.layer.borderWidth=PXChange(4);
    [self.view addSubview:Singerimage];
    
    self.playProgress.center=CGPointMake(ScreenWidth/2.0f, self.playProgress.height/2.0f+image.bottom+PXChange(30));
    self.jinduLabel.text=@"00:00";
    self.totalLabel.text=@"00:00";
    self.jinduLabel.center=CGPointMake(self.jinduLabel.width/2.0f, self.playProgress.centerY);
    self.totalLabel.center=CGPointMake(self.playProgress.right+self.totalLabel.width/2.0f+PXChange(2),self.jinduLabel.centerY);
    self.proTagView.center=CGPointMake(self.playProgress.left, self.playProgress.centerY);
    [self.view bringSubviewToFront:cancelBtn];
    
}
-(NSTimer *)timer{
    if (!_timer) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateProgress) userInfo:nil repeats:true];
    }
    return _timer;
}
-(UIProgressView *)playProgress{
    if(!_playProgress){
        _playProgress=[[UIProgressView alloc]initWithFrame:CGRectMake(PXChange(100), 0, ScreenWidth-PXChange(200), PXChange(6))];
        _playProgress.progressViewStyle= UIProgressViewStyleDefault;
        _playProgress.progress=0.5;
        _playProgress.progressTintColor= [UIColor colorWithHexString:@"#0B6E48"];
        _playProgress.trackTintColor= [UIColor colorWithHexString:@"#A2B4BA"];
        [self.view addSubview:_playProgress];
    }
    return _playProgress;
}
-(UIImageView *)proTagView{
    if(!_proTagView){
        _proTagView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, PXChange(20), PXChange(20))];
        _proTagView.image=[UIImage imageNamed:@"mine_weixuan"];
        [self.view addSubview:_proTagView];
    }
    return _proTagView;
}
-(UILabel *)jinduLabel{
    if(!_jinduLabel){
        _jinduLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, PXChange(100), PXChange(44))];
        _jinduLabel.textColor=[UIColor colorWithHexString:@"#666666"];
        _jinduLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:_jinduLabel];
    }
    return _jinduLabel;
}
-(UILabel *)totalLabel{
    if(!_totalLabel){
        _totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, PXChange(100), PXChange(44))];
        _totalLabel.textColor=[UIColor colorWithHexString:@"#666666"];
        _totalLabel.textAlignment=NSTextAlignmentCenter;
        [self.view addSubview:_totalLabel];
    }
    return _totalLabel;
}
-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.textColor=[UIColor whiteColor];
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}
- (void)playerItemDealloc{
    NSArray *arr = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:_audioStream.configuration.cacheDirectory error:nil];
    for (NSString *file in arr){
        if ([file hasPrefix:@"FSCache-"]) {
            NSString *path = [NSString stringWithFormat:@"%@/%@",_audioStream.configuration.cacheDirectory, file];
            [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
        }
    }
    self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
    [_audioStream stop];
    _audioStream =nil;
}
-(FSAudioStream *)audioStream{
    __weak __typeof__(self) weakSelf = self;;
    if (!_audioStream) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
        _audioStream=[[FSAudioStream alloc]init];
        NSURL *url=[NSURL URLWithString:self.musicUrl];
        [_audioStream playFromURL:url];
        _audioStream.onFailure=^(FSAudioStreamError error,NSString *description){
            NSLog(@"%@", [NSString stringWithFormat:@"播放过程中发生错误，错误信息：%@",description]);
        };
        _audioStream.onCompletion=^(){
            [weakSelf playerItemDealloc];
        };
        [_audioStream setVolume:0.5];//设置声音
    }
    return _audioStream;
}
- (void)closeClick{
    self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
//    [self.audioStream pause];
    [self playerItemDealloc];
//        [[NSNotificationCenter defaultCenter] removeObserver:self name:kAppDidReceiveRemoteControlNotification object:nil];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setNowPlayingInfo{
    NSMutableDictionary *songDict=[NSMutableDictionary dictionary];
    [songDict setObject:self.ShowTitle forKey:MPMediaItemPropertyTitle];
    [songDict setObject:self.dataDic[@"Singer"] forKey:MPMediaItemPropertyArtist];
    [songDict setObject:[NSNumber numberWithDouble:self.playLength] forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //设置歌曲图片
    NSLog(@"%lf",self.audioStream.currentTimePlayed.playbackTimeInSeconds);
    MPMediaItemArtwork *imageItem=[[MPMediaItemArtwork alloc]initWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.dataDic[@"SingerImg"]]]]];
    [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
    [MPNowPlayingInfoCenter defaultCenter];
    if(self.audioStream.currentTimePlayed.playbackTimeInSeconds>0.0f){
    isSet=YES;
    }
}
/**
 *  播放音频
 */
-(void)playss{
    [self playerItemDealloc];
    NSURL *url=[NSURL URLWithString:self.musicUrl];
    [self.audioStream playFromURL:url];
    self.timer.fireDate=[NSDate distantPast];//恢复定时器
    [self setNowPlayingInfo];
    [self playMusic];
}
-(void)playMusic{
//    if (!self.play) {
//        [self.audioStream pause];
//        [self.audioStream play];
//        [self.playBtn setImage:[UIImage imageNamed:@"music_pause"] forState:UIControlStateNormal];
//        self.timer.fireDate=[NSDate distantPast];//恢复定时器
//        self.play=!self.play;
//        //        [self setNowPlayingInfo];
//    }
}
/**
 *  暂停播放
 */
//-(void)pause{
//    if ([self.audioPlayer isPlaying]) {
//        [self.audioPlayer pause];
//        self.timer.fireDate=[NSDate distantFuture];//暂停定时器，注意不能调用invalidate方法，此方法会取消，之后无法恢复
//    }
//}
/**
 *  点击播放/暂停按钮
 *
 *  @param sender 播放/暂停按钮
 */
-(void)playClick:(UIButton *)sender {
//    if(sender.tag){
//        sender.tag=0;
//        [sender setImage:[UIImage imageNamed:@"playing_btn_play_n"] forState:UIControlStateNormal];
//        [sender setTitle:@"播放" forState:UIControlStateNormal];
//        [self pause];
//    }else{
//        sender.tag=1;
//        [sender setImage:[UIImage imageNamed:@"playing_btn_pause_n"] forState:UIControlStateNormal];
//        [sender setTitle:@"暂停" forState:UIControlStateNormal];
//        [self play];
//    }
}
-(void)updateProgress{
    FSStreamPosition cur =self.audioStream.currentTimePlayed;
    CGFloat playbackTime =cur.playbackTimeInSeconds/1.0f;
    CGFloat totalTime =playbackTime/cur.position;
    self.playLength=totalTime;
        if(!isSet){
            [self setNowPlayingInfo];
        }
//    CGFloat curTime = totalTime-playbackTime;
    if ([[NSString stringWithFormat:@"%f",totalTime]isEqualToString:@"nan"]) {
        self.jinduLabel.text =@"00:00";
    }else{
        double minutesElapsed =floor(fmod(totalTime/60.0,60.0));
        double secondsElapsed =floor(fmod(totalTime,60.0));
        double minutesElapsed1 =floor(fmod(playbackTime/60.0,60.0));
        double secondsElapsed1 =floor(fmod(playbackTime,60.0));
        self.jinduLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutesElapsed1, secondsElapsed1];
        self.totalLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutesElapsed, secondsElapsed];
        CGFloat po=playbackTime/totalTime;
        self.playProgress.progress=po;
        self.proTagView.center=CGPointMake(self.playProgress.left+po*self.playProgress.width, self.playProgress.centerY);
    }
   

}
-(void)downLoadClick{
    NSLog(@"%@",self.dataDic[@"SongUrl320"]);
    downloadAAC=self.dataDic[@"AAcUrl"];
    downloadHigh=self.dataDic[@"SongUrl320"];
    if(![BHTools isNull:self.dataDic[@"SongUrl320"]]){
        [self showDownLoadView:1];
    }else{
        [self showDownLoadView:0];
    }
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString *URLString = @"http://www.hcc11.cn/Music/Download.ashx";
//    NSDictionary *parameters = @{@"file":self.dataDic[@"SongUrl320"],@"mname":self.dataDic[@"SongName"]};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData *data=(NSData *)responseObject;
//        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",str);
//        NSArray *array = [str componentsSeparatedByString:@".replace('"]; //从字符A中分隔成2个元素的数组
//        NSArray *newArr = [array[1] componentsSeparatedByString:@"')</script>"];
//        downloadUrl=newArr[0];
//        [self showDownLoadView:downloadUrl];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败了%@",error);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
}
- (void)showDownLoadView:(NSInteger)flag{
   downLoadView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-PXChange(300), ScreenWidth, PXChange(400))];
    downLoadView.backgroundColor=[UIColor colorWithHexString:@"#1296db"];
    [self.view addSubview:downLoadView];
    [UIView animateWithDuration:0.5 animations:^{
        downLoadView.center=CGPointMake(ScreenWidth/2.0f, ScreenHeight-downLoadView.height/2.0f);
    }];
    UIButton *downBtnAAC=[[UIButton alloc]initWithFrame:CGRectMake(PXChange(45), PXChange(45), PXChange(200), PXChange(44))];
    [downBtnAAC setTitle:@"试听音质" forState:UIControlStateNormal];
    downBtnAAC.tag=440;
    [downBtnAAC setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downBtnAAC addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    [downLoadView addSubview:downBtnAAC];
    
    jindu = [[HWCircleView alloc] initWithFrame:CGRectMake(220, 100, PXChange(100), PXChange(100))];
    [downLoadView addSubview:jindu];
    jindu.center=CGPointMake(ScreenWidth-jindu.width/2.0f-PXChange(40), downBtnAAC.centerY);
    
    UIButton *downBtn320k=[[UIButton alloc]initWithFrame:CGRectMake(PXChange(45),downBtnAAC.bottom+PXChange(45), PXChange(200), PXChange(44))];
    [downBtn320k setTitle:@"320k音质" forState:UIControlStateNormal];
    downBtn320k.tag=441;
    [downBtn320k setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [downBtn320k addTarget:self action:@selector(download:) forControlEvents:UIControlEventTouchUpInside];
    [downLoadView addSubview:downBtn320k];
    
//    highDownloadJindu=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    highDownloadJindu.textColor=[UIColor whiteColor];
//    highDownloadJindu.text=@"35.9%";
//    [highDownloadJindu sizeToFit];
//    [highDownloadJindu setHidden:YES];
//    highDownloadJindu.center=CGPointMake(ScreenWidth-aacDownloadJindu.width/2.0f-PXChange(40), downBtn320k.centerY);
//    [downLoadView addSubview:highDownloadJindu];
    
    if(flag==1){
        [downBtn320k setHidden:YES];
        
    }
}
- (void)download:(UIButton *)Sender{
    NSInteger index=Sender.tag-440;
    downloadUrl=self.dataDic[@"AAcUrl"];
    if(index==1){
     downloadUrl=self.dataDic[@"SongUrl320"];
    }
    [[MCDownloadManager defaultInstance] downloadFileWithURL:downloadUrl
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
                                                        
                                                        if ([receipt.url isEqualToString:downloadUrl]) {
                                                            
                                                            if(index==0){
                                                                //AAC品质
//                                                                [aacDownloadJindu setHidden:NO];
//                                                                aacDownloadJindu.text=[NSString stringWithFormat:@"%0.2fM/%0.2fM", downloadProgress.completedUnitCount/1024.0/1024, downloadProgress.totalUnitCount/1024.0/1024];
//                                                                [aacDownloadJindu sizeToFit];
                                                                jindu.center=CGPointMake(ScreenWidth-jindu.width/2.0f-PXChange(40), jindu.height/2.0f+PXChange(45));
                                                                jindu.progress=downloadProgress.fractionCompleted;
                                                                
                                                            }else{
//                                                                [highDownloadJindu setHidden:NO];
//                                                                highDownloadJindu.text=[NSString stringWithFormat:@"%0.2fm/%0.2fm", downloadProgress.completedUnitCount/1024.0/1024, downloadProgress.totalUnitCount/1024.0/1024];
//                                                                 highDownloadJindu.center=CGPointMake(ScreenWidth-aacDownloadJindu.width/2.0f-PXChange(40), highDownloadJindu.height/2.0f+PXChange(45));
//                                                                [highDownloadJindu sizeToFit];
                                                            }
//                                                            self.progressView.progress = downloadProgress.fractionCompleted ;
//                                                            self.bytesLable.text = [NSString stringWithFormat:@"%0.2fm/%0.2fm", downloadProgress.completedUnitCount/1024.0/1024, downloadProgress.totalUnitCount/1024.0/1024];
//                                                            self.speedLable.text = [NSString stringWithFormat:@"%@/s", receipt.speed];
                                                        }
                                                    }
                                                 destination:nil
                                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
                                                         
                                                         NSString *cachePatch = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
                                                         NSString *musicPlistPath = [cachePatch stringByAppendingPathComponent:@"music.plist"];
                                                         NSMutableArray *products = [NSMutableArray arrayWithContentsOfFile:musicPlistPath];
                                                         NSMutableDictionary *mudic=[NSMutableDictionary dictionary];
                                                         [mudic setValue:downloadUrl forKey:@"urls"];
                                                         [mudic setValue:self.ShowTitle forKey:@"SongName"];
                                                         [mudic setValue:self.dataDic[@"Singer"] forKey:@"Singer"];
                                                         [mudic setValue:self.dataDic[@"SingerImg"] forKey:@"SingerImg"];
                                                         [products addObject:mudic];
                                                         NSArray *writeArr=[NSArray arrayWithArray:products];
                                                         if([writeArr writeToFile:musicPlistPath atomically:YES]){
                                                         [BHTools showAlertView:@"下载完成"];
                                                         }else{
                                                         [BHTools showAlertView:@"下载失败"];
                                                         }
                                                     }
                                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         NSLog(@"下载失败");
                                                     }];


}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        downLoadView.center=CGPointMake(ScreenWidth/2.0f, ScreenHeight+PXChange(300));
    }];
}
-(UIView *)controlerView{
    if(!_controlerView){
        _controlerView=[[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight-64-PXChange(100), ScreenWidth, PXChange(100))];
        _controlerView.backgroundColor=[UIColor colorWithHexString:@"#04DD98"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            ];
        [self.view addSubview:_controlerView];
    }
    return _controlerView;

}
#pragma mark - 播放器代理方法
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"音乐播放完成...");
}
#pragma mark - 定制返回
- (void)backUp{
   
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addCustomBackBarButtonItemWithTarget:(id)target action:(SEL)action {
    self.navigationItem.leftBarButtonItem = [self buttonWithImage:[[UIImage imageNamed:@"regsiter_btn_back_default"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                 highlightedImage:[[UIImage imageNamed:@"regsiter_btn_back_default"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]
                                                           target:target
                                                           action:action];
    
}
- (UIBarButtonItem *)buttonWithImage:(UIImage *)image
                    highlightedImage:(UIImage *)highlightedImage
                              target:(id)target
                              action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, PXChange(44), PXChange(44))];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
