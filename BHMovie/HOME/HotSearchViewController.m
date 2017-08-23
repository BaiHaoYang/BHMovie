//
//  HotSearchViewController.m
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/2/21.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import "HotSearchViewController.h"
#import "HotMessageModel.h"
#import "HotSearchCollectionViewCell.h"
#import "SearchViewController.h"
#import "ViewController.h"
#import "QQDrawerViewController.h"
#import "movieHomePageViewController.h"
@interface HotSearchViewController ()<UITextFieldDelegate,TYTabPagerControllerDataSource,TYTabPagerControllerDelegate>
@property(nonatomic,strong)NSArray *datas;
@property(nonatomic,strong)HotMessageModel *movieModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *NavigationView;
@property(nonatomic,strong)UITextField *searchTextFiled;
@end

@implementation HotSearchViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    [self makeNavigationStyle];
    self.dataSource=self;
    self.delegate=self;
    [self loadData];
//    [self requestDate];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}
- (void)loadData {
    NSMutableArray *datas = [NSMutableArray array];
    [datas addObjectsFromArray:@[@"首页",@"电影",@"电视剧",@"综艺",@"美剧",@"英剧"]];
    _datas = [datas copy];
    [self reloadData];

}

#pragma mark - TYTabPagerControllerDataSource

- (NSInteger)numberOfControllersInTabPagerController {
    return _datas.count;
}

- (UIViewController *)tabPagerController:(TYTabPagerController *)tabPagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
//    return nil;
    if (index == 0) {
        movieHomePageViewController *VC = [[movieHomePageViewController alloc]init];
//        VC.view.backgroundColor=[UIColor yellowColor];
//        VC.title = [@(index) stringValue];
        return VC;
    }else if (index%3 == 1) {
        UIViewController *VC = [[UIViewController alloc]init];
        VC.view.backgroundColor=[UIColor redColor];

        VC.title = [@(index) stringValue];
        return VC;
    }else {
        UIViewController *VC = [[UIViewController alloc]init];
        VC.view.backgroundColor=[UIColor greenColor];
        VC.title = [@(index) stringValue];
        return VC;
    }
}
- (NSString *)tabPagerController:(TYTabPagerController *)tabPagerController titleForIndex:(NSInteger)index {
    NSString *title = _datas[index];
    return title;
}


//-(void)checkUpDate{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    NSString *URLString = [BHTools configUrlWithString:BHMoviehotSearch];
//    NSDictionary *parameters = @{@"action": @"GetIOS",@"phone":@"android"};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData *data=(NSData *)responseObject;
//        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSString *dataStr=[BHTools DecodedBase64Code:[BHTools DecodedBase64Code:str]];
//        NSDictionary *newdic=[BHTools dictionaryWithJsonString:dataStr];
//        [self handelUpdateInfo:newdic];
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败了%@",error);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//}
//-(void)handelUpdateInfo:(NSDictionary *)dict{
//    NSString *UpdateDescribe=[dict objectForKey:@"UpdateDescribe"];
//    NSString *UpdateUrl=[dict objectForKey:@"UpdateUrl"];
//    NSString *Version=[dict objectForKey:@"Version"];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更新提示" message:UpdateDescribe preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UIApplication *app = [UIApplication sharedApplication];
//        [app openURL:[NSURL URLWithString:UpdateUrl]];
//        
//    }];
//    [alertController addAction:otherAction];
//    if([BHM_Version compare:Version]==NSOrderedAscending){
//    [self presentViewController:alertController animated:YES completion:nil];
//    }
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//}
//-(void)requestDate{
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    //前面写服务器给的域名,后面拼接上需要提交的参数，假如参数是key＝1
//    NSString *URLString = [BHTools configUrlWithString:BHMoviehotSearch];
//    NSDictionary *parameters = @{@"action": @"GetHot"};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSData *data=(NSData *)responseObject;
//        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSString *dataStr=[BHTools DecodedBase64Code:[BHTools DecodedBase64Code:str]];
//        NSDictionary *newdic=[BHTools dictionaryWithJsonString:dataStr];
//        self.dataSource=[self handleData:(NSArray *)newdic];
//        [self loadMainUI];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"失败了%@",error);
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }];
//
//}
-(void)makeNavigationStyle{
    [self.navigationController.navigationBar setHidden:YES];
    UIImageView *iconView=[[UIImageView alloc]initWithFrame:CGRectMake(PXChange(22), PXChange(44), PXChange(44), PXChange(44))];
    [iconView sd_setImageWithURL:[NSURL URLWithString:@"http://p3.music.126.net/2GmMfBPH0SscboeO7yiozA==/3433774820978016.jpg"]];
    iconView.layer.cornerRadius=iconView.width/2.0f;
    iconView.clipsToBounds=YES;
    [self.NavigationView addSubview:iconView];
    UIButton *iconBtn=[[UIButton alloc]initWithFrame:iconView.frame];
    [iconBtn addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
    [self.NavigationView addSubview:iconBtn];
    
    
    UIImageView *sosoKuang=[[UIImageView alloc]initWithFrame:CGRectMake(iconView.right+PXChange(22), PXChange(44), PXChange(460), PXChange(44))];
    sosoKuang.image=[UIImage imageNamed:@"homesearchbar_sousuokuang"];
    [self.NavigationView addSubview:sosoKuang];
    self.searchTextFiled.center=sosoKuang.center;
    [self.NavigationView addSubview:self.searchTextFiled];
    
    UIButton *cacheBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, PXChange(100), PXChange(88))];
    [cacheBtn setTitle:@"缓存" forState:UIControlStateNormal];
    [cacheBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cacheBtn addTarget:self action:@selector(iconClick) forControlEvents:UIControlEventTouchUpInside];
    cacheBtn.center=CGPointMake(ScreenWidth-cacheBtn.width/2.0f, iconView.centerY);
    [self.NavigationView addSubview:cacheBtn];
}
-(void)iconClick{
     [[QQDrawerViewController shareDrawerViewController] openDrawerWithOpenDuration:0.2];
}
-(void)loadMainUI{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.collectionView.backgroundColor=[UIColor clearColor];
}
#pragma mark -UITextFiledDelegate
- (BOOL)textFieldShouldClear:(UITextField *)textField             // called when clear button pressed. return NO to ignore (no notifications)
{
    textField.text=@"";
    return YES;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    if(textField.text>0){
    ViewController *vc=[[ViewController alloc]init];
    vc.keyWords=textField.text;
    [self.navigationController pushViewController:vc animated:YES];
    }
    return YES;
}

#pragma mark- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotSearchCell" forIndexPath:indexPath];
    HotMessageModel *model=self.dataSource[indexPath.item];
    NSString *movieImage=[BHTools decodeFromPercentEscapeString:model.MovieImage];
    [cell.movieImage sd_setImageWithURL:[NSURL URLWithString:movieImage] placeholderImage:[UIImage imageNamed:@"Movie"]];
    cell.movieName.text=[BHTools decodeFromPercentEscapeString:model.MovieName];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    HotMessageModel *model=self.dataSource[indexPath.item];
    ViewController *vc=[[ViewController alloc]init];
    vc.keyWords=[BHTools decodeFromPercentEscapeString:model.MovieName];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)searchClick{
    SearchViewController *search=[[SearchViewController alloc]init];
    [search setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:search animated:YES];
}
//处理请求下来的数据
- (NSMutableArray *)handleData:(NSArray *)array{
//    for (NSDictionary *dict in array) {
//        HotMessageModel *model=[[HotMessageModel alloc]initWithDictionary:dict error:nil];
//        [self.dataSource addObject:model];
//    }
    return nil;
}
//-(NSMutableArray *)dataSource{
//    if(!_dataSource){
//        _dataSource=[[NSMutableArray alloc]init];
//    }
//    return _dataSource;
//}
-(UIView *)NavigationView{
    if(!_NavigationView){
        _NavigationView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
        _NavigationView.backgroundColor=[UIColor colorWithHexString:@"#fd7852"];
        [self.view addSubview:_NavigationView];
    }
    return _NavigationView;
}
-(UITextField *)searchTextFiled{
    if(!_searchTextFiled){
        _searchTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, PXChange(440), PXChange(44))];
        _searchTextFiled.placeholder=@"搜索你想看的电影或电视";
        _searchTextFiled.delegate=self;
    }
    return _searchTextFiled;

}
-(UICollectionView *)collectionView{
    if(!_collectionView){
        //1.初始化layout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置item大小
        flowLayout.itemSize = CGSizeMake(ScreenWidth / 4 - PXChange(20), ((ScreenWidth / 4 - PXChange(20))/3.0f)*4.0f+PXChange(30));
        //设置滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置最小间距
        flowLayout.minimumLineSpacing = PXChange(10);
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(PXChange(40), self.NavigationView.bottom, ScreenWidth-PXChange(80), ScreenHeight-64-49) collectionViewLayout:flowLayout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"HotSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hotSearchCell"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
@end
