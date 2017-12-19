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
@interface BHMusicViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
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
    [self makeNavigationStyle];
    [self requestDate];
    
    
}
-(void)makeNavigationStyle{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:BH_Color_Main];
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titlelabel.text = @"音乐";
    titlelabel.textColor = [UIColor whiteColor];
    [titlelabel sizeToFit];
    self.navigationItem.titleView = titlelabel;
    self.navigationController.navigationBar.translucent = NO;
}

-(void)requestDate{
    NSString * urlString = [@"http://116.196.76.128:3000/sql/img" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:nil success:^(id response) {
        NSArray *arr = (NSArray *)response;
        NSLog(@"%@",arr);
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:arr];
        [self.collectionView reloadData];
//        if(isRefresh){
//            [self.dataSourceArr removeAllObjects];
//        }
//        [self.dataSourceArr addObjectsFromArray:arr];
//        [self.tabView.mj_footer endRefreshing];
//        [self.tabView.mj_header endRefreshing];
//        [self.tabView reloadData];
    } fail:^(NSError *error) {
//        [self.tabView.mj_footer endRefreshing];
//        [self.tabView.mj_header endRefreshing];
        NSLog(@"%@",error);
    }];
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
    NSString *movieImage=model[@"urls"];
    [cell.movieImage sd_setImageWithURL:[NSURL URLWithString:movieImage] placeholderImage:[UIImage imageNamed:@"icon"]];
    cell.movieName.text=model[@"imgid"];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *model=self.dataSource[indexPath.item];
//    titleLabelMiddle.text=model[@"TopTitle"];
//    NSArray *arr=model[@"ListMusic"];
//    [self.tabdataSource removeAllObjects];
//    [self.tabdataSource addObjectsFromArray:arr];
//    [self.tabView reloadData];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(ScreenWidth / 3 - PXChange(30), ((ScreenWidth / 3 + PXChange(20))/4.0f)*4.0f+PXChange(30));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10,10,0,10);
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
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumLineSpacing = PXChange(20);
    }
    return _flowLayout;
    
}
-(UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64) collectionViewLayout:self.flowLayout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentSize=CGSizeMake(ScreenWidth/2.0f, PXChange(700));
        [_collectionView registerNib:[UINib nibWithNibName:@"HotSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hotSearchCell1"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}
@end
