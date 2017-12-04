//
//  BHMusicViewController.m
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/5/17.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import "BHMusicViewController.h"
#import "MusicPlayViewController.h"
#import "MCDownloadManager.h"
#import "MusicSearchViewController.h"
#import "MusicShowTableViewCell.h"
#import "HotSearchCollectionViewCell.h"
#import <AVFoundation/AVFoundation.h>
@interface BHMusicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *tabdataSource;
@property(nonatomic,strong)UITableView *tabView;
@end

@implementation BHMusicViewController
{
    UITextField *musicTextFiled;
    UIView *playView;
    NSString *musicUrl;
    UIImageView *Singerimage;
    UILabel *SingerName;
    UIImageView *SingerimageOne;
    UILabel *SongName;
    UIButton *playBtn;
    UILabel *titleLabelMiddle;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    [self requestDate];
    [self makeNavigationStyle];
}
-(void)requestDate{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString = [BHTools configUrlWithString:BHMusicTop];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data=(NSData *)responseObject;
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *newdic=[BHTools dictionaryWithJsonString:str];
        NSArray *arr=(NSArray *)newdic;
        self.dataSource=[NSMutableArray arrayWithArray:arr];
        NSDictionary *dic=self.dataSource[0];
        self.tabdataSource=[NSMutableArray arrayWithArray:dic[@"ListMusic"]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self loadMainUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)makeNavigationStyle{
    UIBarButtonItem *SearchButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchClick)];
    self.navigationItem.rightBarButtonItem = SearchButton;
}
-(void)searchClick{
    MusicSearchViewController *searchMC=[[MusicSearchViewController alloc]init];
    [searchMC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:searchMC animated:YES];
}
-(void)loadMainUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    titleLabelMiddle=[[UILabel alloc]initWithFrame:CGRectMake(0, self.collectionView.bottom, ScreenWidth, PXChange(40))];
    NSDictionary *dic=self.dataSource[0];
    titleLabelMiddle.text=dic[@"TopTitle"];
    titleLabelMiddle.textAlignment=NSTextAlignmentCenter;
    titleLabelMiddle.textColor=[UIColor colorWithHexString:@"#666666"];
    [self.view addSubview:titleLabelMiddle];
    [self.tabView reloadData];
}
#pragma mark- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotSearchCell1" forIndexPath:indexPath];
    if(!cell){
        cell = [[HotSearchCollectionViewCell alloc] init];
    }
    NSDictionary *model=self.dataSource[indexPath.item];
    NSString *movieImage=model[@"TopListImg"];
    cell.movieImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:movieImage]]];
    cell.movieName.text=model[@"TopTitle"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *model=self.dataSource[indexPath.item];
    titleLabelMiddle.text=model[@"TopTitle"];
    NSArray *arr=model[@"ListMusic"];
    [self.tabdataSource removeAllObjects];
    [self.tabdataSource addObjectsFromArray:arr];
    [self.tabView reloadData];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth / 4 - PXChange(20), ((ScreenWidth / 4 - PXChange(20))/3.0f)*4.0f+PXChange(30));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,10,0,10);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tabdataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXChange(100);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:3 reuseIdentifier:@"cell"];
    }
    NSDictionary *dic=self.tabdataSource[indexPath.row];
    cell.textLabel.text=dic[@"SongName"];
    cell.detailTextLabel.text=dic[@"Singer"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=self.tabdataSource[indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString = @"https://www.hcc11.cn/Music/MusicApi.ashx";
    NSDictionary *postDic=@{@"SongId":dic[@"SongId"],@"st":dic[@"SourceType"],@"SongIdOne":dic[@"SongIdBackUp"]};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:postDic progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSData *data=(NSData *)responseObject;
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *newdic=[BHTools dictionaryWithJsonString:str];
        MusicPlayViewController *mvc=[[MusicPlayViewController alloc]init];
        mvc.dataDic=dic;
        mvc.ShowTitle=dic[@"SongName"];
        mvc.musicUrl=newdic[@"AAcUrl"];
        [mvc setHidesBottomBarWhenPushed:YES];
        [self.navigationController presentViewController:mvc animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
-(NSMutableArray *)tabdataSource{
    if(!_tabdataSource){
        _tabdataSource=[[NSMutableArray alloc]init];
    }
    return _tabdataSource;
}
-(UICollectionViewFlowLayout *)flowLayout{
    if(!_flowLayout){
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置滑动方向
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.minimumLineSpacing = PXChange(20);
    }
    return _flowLayout;
    
}
-(UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,PXChange(240)) collectionViewLayout:self.flowLayout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentSize=CGSizeMake(ScreenWidth*3.0f/2.0f, PXChange(300));
        [_collectionView registerNib:[UINib nibWithNibName:@"HotSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hotSearchCell1"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
-(UITableView *)tabView{
    if(!_tabView){
        _tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, titleLabelMiddle.bottom, ScreenWidth, ScreenHeight-titleLabelMiddle.bottom-64-49) style:UITableViewStylePlain];
        _tabView.delegate=self;
        _tabView.dataSource=self;
        [self.view addSubview:_tabView];
    }
    return _tabView;
}

@end
