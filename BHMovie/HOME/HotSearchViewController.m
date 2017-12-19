//
//  HotSearchViewController.m
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/2/21.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import "HotSearchViewController.h"
#import "HotMessageModel.h"
#import "ViewController.h"
#import "SearchViewController.h"
#import "QQDrawerViewController.h"
#import "movieHomePageViewController.h"
#import "MoviePlayViewController.h"
#import "ZFDownloadViewController.h"
#import "HYBNetworking.h"
#import "MJRefresh.h"
#import "MainVideoCell.h"
//560  315
@interface HotSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSourceArr;
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)UITextField *ipFiled;
@property(nonatomic,strong)UIButton *Ipbtn;

@end

@implementation HotSearchViewController
{
    NSInteger startPage;
    BOOL isRefresh;
    NSString *ipStr;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    startPage = 0;
    isRefresh = NO;
    ipStr = @"116.196.76.128";
    self.navigationController.navigationBar.translucent=NO;
    [self makeNavigationStyle];
    self.dataSourceArr=[[NSMutableArray alloc]init];
    [self loadDateSource];
    [self.tabView reloadData];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
-(void)loadDateSource{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString * urlString = [@"http://116.196.76.128:3000/spi" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:nil success:^(id response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dic =(NSDictionary *)response;
        NSArray *arr = dic[@"data"];
        NSLog(@"%@",arr);
        if(isRefresh){
        [self.dataSourceArr removeAllObjects];
        }
        [self.dataSourceArr addObjectsFromArray:arr];
        [self.tabView.mj_footer endRefreshing];
        [self.tabView.mj_header endRefreshing];
        [self.tabView reloadData];
        
    } fail:^(NSError *error) {
        [self.tabView.mj_footer endRefreshing];
        [self.tabView.mj_header endRefreshing];
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (UITableView *)tabView{
    CGFloat barheigth = 64;
    if([BHTools isIPhoneX]){
        barheigth = 88;
    }
    if(!_tabView){
        _tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.ipFiled.bottom, ScreenWidth, ScreenHeight-barheigth-self.ipFiled.bottom)];
        _tabView.delegate=self;
        _tabView.dataSource=self;
        _tabView.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
            startPage = 0;
            isRefresh = YES;
            [self loadDateSource];
            
        }];
        _tabView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            startPage ++;
            isRefresh = NO;
            [self loadDateSource];
        }];
        self.tabView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tabView.showsVerticalScrollIndicator = NO;
        [_tabView registerNib:[UINib nibWithNibName:@"MainVideoCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"mainCell"];
        [self.view addSubview:_tabView];
    }
    return _tabView;
}
#pragma mark === tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainVideoCell *cell=(MainVideoCell*)[tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    [cell.covweImg sd_setImageWithURL:[NSURL URLWithString:self.dataSourceArr[indexPath.row][@"imgurl"]] placeholderImage:[UIImage imageNamed:@"logo"]];
    cell.titLab.text = self.dataSourceArr[indexPath.row][@"text"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXChange(400);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *detUrl = self.dataSourceArr[indexPath.row][@"clinkUrl"];
    NSString * urlString = [@"http://116.196.76.128:3000/spi/subPaUrl" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [HYBNetworking postWithUrl:urlString refreshCache:YES params:@{@"detailUrl":detUrl} success:^(id response) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dic =(NSDictionary *)response;
            MoviePlayViewController *mv = [[MoviePlayViewController alloc]init];
            mv.hidesBottomBarWhenPushed = YES;
            mv.MovieUrl = dic[@"key"];
            [self.navigationController pushViewController:mv animated:YES];
        

    } fail:^(NSError *error) {
[MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)makeNavigationStyle{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:BH_Color_Main];
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titlelabel.text = @"好孩子看不见";
    titlelabel.textColor = [UIColor whiteColor];
    [titlelabel sizeToFit];
    self.navigationItem.titleView = titlelabel;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
-(void)iconClick{
    [[QQDrawerViewController shareDrawerViewController] openDrawerWithOpenDuration:0.2];
}
-(void)cacheClick{
    ZFDownloadViewController *zfd=[[ZFDownloadViewController alloc]init];
    [zfd setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:zfd animated:YES];
}

@end
