//
//  MusicSearchViewController.m
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/5/18.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import "MusicSearchViewController.h"
#import "MusicPlayViewController.h"
#import "MCDownloadManager.h"
#import "MusicShowTableViewCell.h"
@interface MusicSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tabView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation MusicSearchViewController
{
    UITextField *musicTextFiled;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"音乐搜索";
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadMainView];
}
- (void)loadMainView{
    musicTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, PXChange(300), PXChange(44))];
    musicTextFiled.keyboardType=UIKeyboardTypeDefault;
    musicTextFiled.borderStyle=UITextBorderStyleNone;
    musicTextFiled.center=CGPointMake(ScreenWidth/2.0f, musicTextFiled.height/2.0f+PXChange(44));
    musicTextFiled.layer.borderColor=[UIColor colorWithHexString:@"#1296db"].CGColor;
    musicTextFiled.layer.borderWidth=0.5;
    musicTextFiled.layer.cornerRadius=PXChange(12);
    musicTextFiled.text=@"小幸运";
    [self.view addSubview:musicTextFiled];
    UIButton *Searchbtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, PXChange(100),PXChange(88))];
    Searchbtn.center=CGPointMake(Searchbtn.width/2.0f+musicTextFiled.right+PXChange(20), musicTextFiled.centerY);
    [Searchbtn setTitle:@"搜索" forState:UIControlStateNormal];
    [Searchbtn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    [Searchbtn setTitleColor:[UIColor colorWithHexString:@"#d81e06"] forState:UIControlStateNormal];
    [self.view addSubview:Searchbtn];
    [self tabView];
}
- (void)searchClick{
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *URLString = @"https://www.hcc11.cn/Music/MusicApi.ashx";
    NSLog(@"%@",musicTextFiled.text);
    NSDictionary *parameters = @{@"Action": @"search",@"key":musicTextFiled.text};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.dataSource removeAllObjects];
        NSData *data=(NSData *)responseObject;
        NSArray *newArr=[BHTools toArrayOrNSDictionary:data];
        [self.dataSource addObjectsFromArray:newArr];
        [self.dataSource removeLastObject];
        [self.tabView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (UITableView *)tabView{
    if(!_tabView){
        _tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, musicTextFiled.bottom+PXChange(20), ScreenWidth, ScreenHeight-49-64-musicTextFiled.bottom-PXChange(20)) style:UITableViewStylePlain];
        _tabView.delegate=self;
        _tabView.dataSource=self;
        _tabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tabView registerClass:[MusicShowTableViewCell class] forCellReuseIdentifier:@"musicCell"];
        [self.view addSubview:_tabView];
    }
    return _tabView;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicShowTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"musicCell"];
    NSDictionary *dict=self.dataSource[indexPath.row];
    [cell loadWithDic:dict];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXChange(160);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataSource[indexPath.row];
    MusicPlayViewController *musicPlay=[[MusicPlayViewController alloc]init];
    musicPlay.ShowTitle=dic[@"SongName"];
    musicPlay.musicUrl=dic[@"AAcUrl"];
    musicPlay.dataDic=dic;
    [self.navigationController presentViewController:musicPlay animated:YES completion:nil];
//    [musicPlay setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:musicPlay animated:YES];
}
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
