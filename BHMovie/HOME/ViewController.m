//
//  ViewController.m
//  BHMovie
//
//  Created by mac on 2016/10/25.
//  Copyright © 2016年 XHDAXHK. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "HomeDataModel.h"
#import "UIImageView+WebCache.h"
#import "MoviePlayViewController.h"
#import "ZFPlayerView.h"
#import "MoviePlayViewController.h"
#define btnTag 200
@interface ViewController ()<ZFPlayerDelegate>
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)HomeDataModel *movieModel;
@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIScrollView *middleView;
@property (nonatomic,copy)NSString *movieName;
@property (nonatomic,copy)NSString *MovieImage;
@property (nonatomic,copy)NSString *VideoType;
@property (nonatomic,strong)ZFPlayerView *playerView;
@end

@implementation ViewController
{
    NSInteger _total;
    NSString *_PlayUrl;
    NSString *_DownUrl;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self.navigationController  setNavigationBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
}
- (void)viewDidLoad {
    self.title=self.keyWords;
    [super viewDidLoad];
    [self addCustomBackBarButtonItemWithTarget:self action:@selector(backUp)];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadData];}
-(void)loadData{
    self.movieModel=[HomeDataModel new];
    //前面写服务器给的域名,后面拼接上需要提交的参数，假如参数是key＝1
    NSString *URLString = [BHTools configUrlWithString:BHSearchMovieByKeyWords];
    NSDictionary *parameters = @{@"action": @"OnlyBmob", @"keyWord": self.keyWords,@"phone":@"android"};
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
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    self.topView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, PXChange(320))];
    [self.view addSubview:self.topView];
//    PlayerViewController *player = [[PlayerViewController alloc] init];
//    player.hidesBottomBarWhenPushed = YES;
//    player.video = @{@"title":@"视频一",
//                     @"image":@"http://wimg.spriteapp.cn/picture/2016/0309/56df7b64b4416_wpd.jpg",
//                     @"video":[NSURL URLWithString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"]};
//    [player.player player];
//    [self.view addSubview:player.player];
    // 视频资源路径
//    [playView setUrlString:@"http://v1.mukewang.com/a45016f4-08d6-4277-abe6-bcfd5244c201/L.mp4"];
    // 播放器显示位置（竖屏时）
    
//    UIImageView *movieImage=[[UIImageView alloc]initWithFrame:CGRectMake(PXChange(20), PXChange(20), PXChange(200), PXChange(260))];
//    [movieImage sd_setImageWithURL:[NSURL URLWithString:[self decodeFromPercentEscapeString:self.movieModel.MovieImage]]];
//    [self.topView addSubview:movieImage];
//    
//    
//    NSString *names=[BHTools decodeFromPercentEscapeString:self.movieModel.MovieName];
//    NSArray *array = [names componentsSeparatedByString:@"第"]; //从字符A中分隔成2个元素的数组
//    UILabel *nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(PXChange(40)+CGRectGetMaxX(movieImage.frame), PXChange(20)+PXChange(120), ScreenWidth-PXChange(40)-CGRectGetMaxX(movieImage.frame), PXChange(200))];
//    
//    nameLabel.textColor=[UIColor colorWithHexString:@"#828282"];
//    [nameLabel setFont:[UIFont systemFontOfSize:14]];
//    nameLabel.text=[NSString stringWithFormat:@"片名:%@",[array firstObject]];
//    nameLabel.numberOfLines=0;
//    [nameLabel sizeToFit];
//    [self.topView addSubview:nameLabel];
//    
    UILabel *lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 400, ScreenWidth, PXChange(2))];
    lineLabel.backgroundColor=[UIColor grayColor];
    [self.topView addSubview:lineLabel];
    self.middleView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), ScreenWidth, ScreenHeight-PXChange(320))];
    self.middleView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight-PXChange(320));
    [self.view addSubview:self.middleView];
    
    CGFloat btnWidth=(ScreenWidth-PXChange(90))/8.0f;
    for (NSInteger i=0; i<self.dataSource.count; i++) {
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake((i%8)*(btnWidth+PXChange(10))+PXChange(10), (i/8)*(btnWidth+PXChange(10))+PXChange(10), btnWidth, btnWidth)];
        btn.clipsToBounds=YES;
        btn.tag=btnTag+i;
        btn.layer.borderColor=[UIColor grayColor].CGColor;
        btn.layer.borderWidth=1;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[NSString stringWithFormat:@"%zd",i+1] forState:UIControlStateNormal];
        [self.middleView addSubview:btn];
        if(i==self.dataSource.count-1){
            [self.middleView setContentSize:CGSizeMake(ScreenWidth, CGRectGetMaxY(btn.frame)+PXChange(150))];
            
        }
    }
    
}
-(void)removeUnKnowMovie{
    BmobQuery *bmobQuery = [[BmobQuery alloc] init];
    NSString *bql = @"select * from UNSearchMovieList where Name = ?";
    NSArray *placeholderArray = @[self.keyWords];
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
    NSArray *placeholderArray = @[self.keyWords];
    [bmobQuery queryInBackgroundWithBQL:bql pvalues:placeholderArray block:^(BQLQueryResult *result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            if (result) {
                if(result.resultsAry.count == 0){
                    BmobObject *UnKnowMovie = [BmobObject objectWithClassName:@"UNSearchMovieList"];
                    [UnKnowMovie setObject:self.keyWords forKey:@"Name"];
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
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClick:(UIButton *)btn{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSInteger i=btn.tag-btnTag;
    NSString *movieurl=self.dataSource[i];
    NSString *URLString = @"https://www.hcc11.cn/Movie/SearchHandler.ashx";
    NSDictionary *parameters = @{@"action": @"video", @"keyWord": movieurl,@"phone":@"android",@"token":@"3A02B8D7F7B341C481298685E26CCB64"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data=(NSData *)responseObject;
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *dataStr=[BHTools DecodedBase64Code:[BHTools DecodedBase64Code:str]];
        NSLog(@"%@",dataStr);
        NSArray *arr=[self stringToJSON:dataStr];
        if (arr.count>0) {
            NSDictionary *dict=[arr firstObject];
            [self handleUrlData:dict];
//            [self playMovieWithUrlWithIndex:btn.tag-btnTag];
        }
        else{
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了");
    }];
}
//-(void)playMovieWithUrlWithIndex:(NSInteger)index{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    MoviePlayViewController *mv=[[MoviePlayViewController alloc]init];
//    mv.MovieUrl=_PlayUrl;
//    mv.MovieName=[NSString stringWithFormat:@"%@---%zd",self.title,index+1];
//    [self presentViewController:mv animated:YES completion:nil];
//}
#pragma mark 工具类
- (void)handleUrlData:(NSDictionary *)dict{
    NSString *str=[dict objectForKey:@"PlayUrl"];
    _PlayUrl=[BHTools decodeFromPercentEscapeString:str];
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
- (void)addCustomBackBarButtonItemWithTarget:(id)target action:(SEL)action {
    if (!target) {
        target = self;
        action = @selector(cancelAction:);
    }
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
