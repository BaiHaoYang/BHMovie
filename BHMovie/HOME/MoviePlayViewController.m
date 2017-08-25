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
    if(self.playType!=1){
    [self requestDate];
    }else{
     [self.playerView play];
    }
}
- (void)requestDate{
    self.movieModel=[HomeDataModel new];
    //前面写服务器给的域名,后面拼接上需要提交的参数，假如参数是key＝1
    NSString *URLString = [BHTools configUrlWithString:BHSearchMovieByKeyWords];
    NSDictionary *parameters = @{@"action": @"OnlyBmob", @"keyWord": self.MovieName,@"phone":@"android"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data=(NSData *)responseObject;
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *dataStr=[self DecodedBase64Code:[self DecodedBase64Code:str]];
        if(str.length==0){
            [self loadFailMainUI];
        }else{
            NSDictionary *newdic=[BHTools dictionaryWithJsonString:dataStr];
            self.dataSource=[self handleData:(NSArray *)newdic];
            [self loadSuccessMainUI];
            [self removeUnKnowMovie];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
//加载成功的UI
-(void)loadSuccessMainUI{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    CGFloat imgHeigth=PXChange(100);
    CGFloat imgWidth=imgHeigth*3.0f/4.0f;
    UIImageView *movieImage=[[UIImageView alloc]initWithFrame:CGRectMake(PXChange(20), PXChange(20)+self.movieFatherView.bottom, imgWidth ,imgWidth)];
    [movieImage sd_setImageWithURL:[NSURL URLWithString:[self decodeFromPercentEscapeString:self.movieModel.MovieImage]] placeholderImage:[UIImage imageNamed:@"Movie"]];
    movieImage.layer.masksToBounds=YES;
    movieImage.layer.cornerRadius=imgWidth/2.0f;
    movieImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:movieImage];
    
    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(PXChange(40)+CGRectGetMaxX(movieImage.frame), PXChange(20)+PXChange(120), ScreenWidth-PXChange(40)-CGRectGetMaxX(movieImage.frame), PXChange(200))];
    nameLabel.textColor=[UIColor colorWithHexString:@"#CBCBC9"];
    [nameLabel setFont:[UIFont systemFontOfSize:14]];
    nameLabel.text=[NSString stringWithFormat:@"片名:%@",self.MovieName];
    nameLabel.numberOfLines=0;
    [nameLabel sizeToFit];
    nameLabel.centerY=movieImage.centerY-PXChange(20);
    [self.view addSubview:nameLabel];
    
    UILabel *totalLabel=[[UILabel alloc]initWithFrame:CGRectMake(PXChange(40)+CGRectGetMaxX(movieImage.frame), PXChange(20)+PXChange(120), ScreenWidth-PXChange(40)-CGRectGetMaxX(movieImage.frame), PXChange(200))];
    totalLabel.textColor=[UIColor colorWithHexString:@"#CBCBC9"];
    [totalLabel setFont:[UIFont systemFontOfSize:14]];
    totalLabel.text=[NSString stringWithFormat:@"剧集:共%zd集",self.dataSource.count];
    totalLabel.numberOfLines=0;
    [totalLabel sizeToFit];
    totalLabel.centerY=nameLabel.bottom+totalLabel.height/2.0f+PXChange(10);
    [self.view addSubview:totalLabel];
    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, movieImage.bottom+PXChange(20), ScreenWidth, PXChange(2))];
    lineLabel.backgroundColor=[UIColor colorWithHexString:@"#CBCBC9"];
    [self.view addSubview:lineLabel];
    self.middleView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lineLabel.frame), ScreenWidth, ScreenHeight-PXChange(320))];
    self.middleView.pagingEnabled=YES;
    self.middleView.contentSize = CGSizeMake(ScreenWidth*self.dataSource.count/16, 0);
    [self.view addSubview:self.middleView];
    
    CGFloat btnWidth=(ScreenWidth-PXChange(90))/8.0f;
    NSInteger j=-1;
    NSInteger jy=1;
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        if(i%8==0){
            jy=1;
            if(i%16==0){
                j++;
                jy=0;
            }
        }
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake((i%8)*(btnWidth+PXChange(10))+PXChange(10)+ScreenWidth*j, jy*(btnWidth+PXChange(10))+PXChange(20), btnWidth, btnWidth)];
        btn.clipsToBounds=YES;
        btn.tag=btnTag+i;
        btn.layer.borderColor=[UIColor grayColor].CGColor;
        btn.layer.borderWidth=1;
        btn.layer.cornerRadius=btnWidth/2.0f;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#fd7852"] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithHexString:@"#CBCBC9"] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[NSString stringWithFormat:@"%zd",i+1] forState:UIControlStateNormal];
        [self.middleView addSubview:btn];
        [self.btnArray addObject:btn];
        if(i==self.dataSource.count-1){
                self.middleView.contentSize = CGSizeMake(ScreenWidth*ceil(self.dataSource.count/16.0f), 0);
        }
    }
    
}
-(void)removeUnKnowMovie{
    BmobQuery *bmobQuery = [[BmobQuery alloc] init];
    NSString *bql = @"select * from UNSearchMovieList where Name = ?";
    NSArray *placeholderArray = @[self.MovieName];
    [bmobQuery queryInBackgroundWithBQL:bql pvalues:placeholderArray block:^(BQLQueryResult *result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            if (result) {
                if(result.resultsAry.count > 0){
                    BmobQuery *bquery = [BmobQuery queryWithClassName:@"UNSearchMovieList"];
                    for (BmobObject *object in result.resultsAry) {
                        [bquery getObjectInBackgroundWithId:object.objectId block:^(BmobObject *object, NSError *error){
                            if (!error) {
                                if (object) {
                                    //异步删除object
                                    [object deleteInBackground];
                                }
                            }
                        }];
                    }
                }
            }
        }
    }];
}
//加载失败的UI
-(void)loadFailMainUI{
    //把一些未找到的电影上报到Bmob上
    BmobQuery *bmobQuery = [[BmobQuery alloc] init];
    NSString *bql = @"select * from UNSearchMovieList where Name = ?";
    NSArray *placeholderArray = @[self.MovieName];
    [bmobQuery queryInBackgroundWithBQL:bql pvalues:placeholderArray block:^(BQLQueryResult *result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            if (result) {
                if(result.resultsAry.count == 0){
                    BmobObject *UnKnowMovie = [BmobObject objectWithClassName:@"UNSearchMovieList"];
                    [UnKnowMovie setObject:self.MovieName forKey:@"Name"];
                    [UnKnowMovie saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        if(isSuccessful){
                            [BHTools showAlertView:@"暂时没有找到该剧集，已上报至服务器，我们将及时更新，QQ群：128931211" ];
                        }else{
                            [BHTools showAlertView:@"暂时没有找到该剧集，上报服务器失败，请稍后再试" ];
                        }
                    }];
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [BHTools showAlertView:@"暂时没有找到该剧集，已上报至服务器，我们将及时更新，QQ群：128931211" ];
                }
            }
        }
    }];
    
    
}
-(void)backUp{
    [self.view removeAllSubviews];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClick:(UIButton *)btn{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for(UIButton *btnSS in self.btnArray){
        [btnSS setSelected:NO];
        [btnSS setBackgroundColor:[UIColor clearColor]];
    }
    [btn setSelected:YES];
    [btn setBackgroundColor:[UIColor colorWithHexString:@"#CBCBC9"]];
    NSInteger i=btn.tag-btnTag;
    NSString *movieurl=self.dataSource[i];
    NSString *URLString = @"https://www.hcc11.cn/Movie/SearchHandler.ashx";
    NSDictionary *parameters = @{@"action": @"video", @"keyWord": movieurl,@"phone":@"android",@"token":@"3A02B8D7F7B341C481298685E26CCB64"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSData *data=(NSData *)responseObject;
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *dataStr=[BHTools DecodedBase64Code:[BHTools DecodedBase64Code:str]];
        NSLog(@"%@",dataStr);
        NSArray *arr=[self stringToJSON:dataStr];
        if (arr.count>0) {
            NSDictionary *dict=[arr firstObject];
            [self handleUrlData:dict];
            [self playNewVideoWithTag:btn.tag-btnTag];
        }
        else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了");
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
#pragma mark 工具类
- (void)handleUrlData:(NSDictionary *)dict{
    
    NSString *str=[dict objectForKey:@"PlayUrl"];
    NSString *dowlstr=[dict objectForKey:@"DownUrl"];
    _PlayUrl=[BHTools decodeFromPercentEscapeString:str];
    _DownUrl=[BHTools decodeFromPercentEscapeString:dowlstr];
    NSLog(@"%@",_PlayUrl);
    NSLog(@"%@",_DownUrl);
}
- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@""
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0,[outputStr length])];
    
    return
    
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

//base64解码
- (NSString *)DecodedBase64Code:(NSString *)data{
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:data options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    return decodedString;
}

//处理请求下来的数据
- (NSMutableArray *)handleData:(NSArray *)array{
    
    //    NSLog(@"%@",array);
    NSMutableArray *dataSource=[[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in array) {
        HomeDataModel *model=[[HomeDataModel alloc]initWithDictionary:dict error:nil];
        self.movieModel=model;
        NSLog(@"%@",model);
        [dataSource addObject:model.MovieUrl];
    }
    //    NSLog(@"%zd",dataSource.count);
    return dataSource;
}
- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
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
        _movieFatherView=[[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenWidth/16.0*9.0)];
        _movieFatherView.backgroundColor=[UIColor clearColor];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        label.backgroundColor=[UIColor colorWithHexString:@"#fd7852"];
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
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
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
        _playerView.hasDownload    = YES;
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

- (void)playNewVideoWithTag:(NSInteger )Tag {
    self.playerModel.title            = [NSString stringWithFormat:@"%@-%zd集",self.MovieName,Tag+1];
    self.playerModel.videoURL         = [NSURL URLWithString:_PlayUrl];
    // 设置网络封面图
    self.playerModel.placeholderImageURLString = @"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg";
    // 从xx秒开始播放视频
    // self.playerModel.seekTime         = 15;
    [self.playerView resetToPlayNewVideo:self.playerModel];
    [self.playerView play];
}


@end
