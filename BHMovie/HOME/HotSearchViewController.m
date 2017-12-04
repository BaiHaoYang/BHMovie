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
@interface HotSearchViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSourceArr;
@property(nonatomic,strong)UITableView *tabView;
@end

@implementation HotSearchViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    [self makeNavigationStyle];
    self.dataSourceArr=[NSMutableArray arrayWithArray:@[@{@"urls":@"https://vt.tumblr.com/tumblr_okq0suX4lT1qc940m.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nr3bkvlRRz1rtxgiz.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_omkaisF8aS1vuqiyl.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_okc8ibDFLY1vhcets.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_obgwhy3RKp1ukc4w5.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_oj2jqvmeLs1rn3g8s.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nwn5z44Kyi1u62q77.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_oih4f5P6OH1rlu5fi.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_obk6vrR2K61qan9eo.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o5mq7rR4Ni1s78x4w.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_ociydxksiW1vvszfa.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_oeohppXtDy1r3uvu0.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o04nhzMFiO1uyasup.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nts1api7EE1uru22y.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_obaj6aPnmd1tlfnhc.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_oaupc5BV941uak2p6.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_oa606co6YA1r704qp.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o9axh32cNY1ui0tpn.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o91el84AuV1se36jd.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o8xu3fqs2u1rf8paa.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o2gjghAWHz1uwpmxr.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o0v2v7AQLp1s6lnsw.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o64b6tPssL1r4fz9p.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o2z0dlr5RH1r9s07o.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o4m3mwGfuT1rv66hv.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o37u8t59tu1uvpgt2.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o5189ryTD21rv66hv.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o472thy1A91tkixie.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o3kuye5SZH1r5zq6a.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_np86enaBnP1twni2p.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_o06ouk2TKC1sb4rif.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nyb8m4RxJj1utnnz4.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nzns5dcnto1r3uvu0.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nzp0yxxPO91rf8paa.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nnwbrxldkw1rt6jag.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nz3rb2C1uN1utgjsg.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nnkwacv99E1u9q4f1.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_ntrak3ABKG1tkwfb5.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nu8mku3tBP1s7cyoa.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nufoxizlj11rf1m2k.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_noz50o2WGW1u46sz3.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nstom3EGCj1r3uvu0.mp4"},
    @{@"urls":@"https://vt.tumblr.com/tumblr_nt5rmdsBeS1s044y0.mp4"}]];
    [self.tabView reloadData];

}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
- (UITableView *)tabView{
    CGFloat barheigth = 64;
    if([BHTools isIPhoneX]){
        barheigth = 88;
    }
    if(!_tabView){
        _tabView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-barheigth)];
        _tabView.delegate=self;
        _tabView.dataSource=self;
        _tabView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tabView];
    }
    return _tabView;
}
#pragma mark === tableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.textColor=[UIColor colorWithHexString:BH_Color_Main];
    cell.textLabel.text = self.dataSourceArr[indexPath.row][@"urls"];
    cell.textLabel.font = [UIFont systemFontOfSize:PXChange(18)];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return PXChange(88);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MoviePlayViewController *mplayer = [[MoviePlayViewController alloc]init];
    mplayer.MovieUrl = self.dataSourceArr[indexPath.row][@"urls"];
    mplayer.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mplayer animated:YES];
}
-(void)makeNavigationStyle{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:BH_Color_Main];
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titlelabel.text = @"好孩子看不见";
    titlelabel.textColor = [UIColor whiteColor];
    [titlelabel sizeToFit];
    self.navigationItem.titleView = titlelabel;
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
