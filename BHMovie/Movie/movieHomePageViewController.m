//
//  movieHomePageViewController.m
//  BHMovie
//
//  Created by BHY on 2017/8/23.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import "movieHomePageViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "HotMessageModel.h"
#import "ViewController.h"
#import "HotSearchCollectionViewCell.h"
#import "HomeCollectionReusableViewHeadCell.h"
#define Width [UIScreen mainScreen].bounds.size.width
@interface movieHomePageViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  轮播图
 */
@property (nonatomic, strong) NewPagedFlowView *pageFlowView;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)HotMessageModel *movieModel;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation movieHomePageViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self requestDate];
}
-(void)requestDate{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //前面写服务器给的域名,后面拼接上需要提交的参数，假如参数是key＝1
    NSString *URLString = [BHTools configUrlWithString:BHMoviehotSearch];
    NSDictionary *parameters = @{@"action": @"GetHot"};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data=(NSData *)responseObject;
        NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSString *dataStr=[BHTools DecodedBase64Code:[BHTools DecodedBase64Code:str]];
        NSDictionary *newdic=[BHTools dictionaryWithJsonString:dataStr];
        NSLog(@"%@",newdic);
        self.dataSource=[self handleData:(NSArray *)newdic];
        [self loadMainUI];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败了%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
-(void)loadMainUI{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.collectionView.backgroundColor=[UIColor clearColor];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}
//设置sectionHeader | sectionFoot
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collettionSectionHeader" forIndexPath:indexPath];
//        view.frame=CGRectMake(0, 0, ScreenWidth, PXChange(200));
//        view.backgroundColor=[UIColor yellowColor];
        return view;
    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
//        UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collettionSectionFoot forIndexPath:indexPath];
//        return view;
//    }
    else{
        return nil;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(ScreenWidth, PXChange(50));
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

- (void)setupUI {
    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 8, Width, Width * 9 / 16)];
    pageFlowView.backgroundColor = [UIColor whiteColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.4;
    pageFlowView.orginPageCount = self.imageArray.count;
    pageFlowView.isOpenAutoScroll = YES;
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, pageFlowView.frame.size.height - 24, Width, 8)];
    pageFlowView.pageControl = pageControl;
    [pageFlowView addSubview:pageControl];
    //    [self.view addSubview:pageFlowView];
    /****************************
     使用导航控制器(UINavigationController)
     如果控制器中不存在UIScrollView或者继承自UIScrollView的UI控件
     请使用UIScrollView作为NewPagedFlowView的容器View,才会显示正常,如下
     *****************************/
    UIScrollView *bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [pageFlowView reloadData];
    [bottomScrollView addSubview:pageFlowView];
    [self.view addSubview:bottomScrollView];
    [bottomScrollView addSubview:pageFlowView];
    self.pageFlowView = pageFlowView;
    //添加到主view上
}
//处理请求下来的数据
- (NSMutableArray *)handleData:(NSArray *)array{
    NSMutableArray *tempArr=[[NSMutableArray alloc]init];
        for (NSDictionary *dict in array) {
            HotMessageModel *model=[[HotMessageModel alloc]initWithDictionary:dict error:nil];
            [tempArr addObject:model];
        }
    return tempArr;
}
-(NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource=[[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark NewPagedFlowView Delegate
- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return 5;
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, Width, Width * 9 / 16)];
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    
    //在这里下载网络图片
    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic5.nipic.com/20091227/2167235_043916212987_2.jpg"] placeholderImage:[UIImage imageNamed:@"icon"]];
//    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
//    NSLog(@"TestViewController 滚动到了第%ld页",pageNumber);
}

#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc]init];
    }
    return _imageArray;
}
-(UICollectionView *)collectionView{
    if(!_collectionView){
        //1.初始化layout
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //设置item大小
//        flowLayout.itemSize = CGSizeMake(ScreenWidth / 4 + PXChange(20), ((ScreenWidth / 4 - PXChange(20))/3.0f)*4.0f+PXChange(20));
        flowLayout.itemSize = CGSizeMake(PXChange(280), PXChange(200));
        //设置滑动方向
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置最小间距
        flowLayout.minimumLineSpacing = PXChange(10);
        _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(PXChange(20), self.pageFlowView.bottom+PXChange(20), ScreenWidth-PXChange(40), ScreenHeight-64-49-self.pageFlowView.height-PXChange(70)) collectionViewLayout:flowLayout];
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerNib:[UINib nibWithNibName:@"HotSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hotSearchCell"];
//        [_collectionView registerNib:[UINib nibWithNibName:collectionViewCell bundle:nil] forCellWithReuseIdentifier:collectionViewCell];
        [_collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionReusableViewHeadCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collettionSectionHeader"];
//        [_collectionView registerNib:[UINib nibWithNibName:collettionSectionFoot bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:collettionSectionFoot];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark --旋转屏幕改变newPageFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        [coordinator animateAlongsideTransition:^(id context) { [self.pageFlowView reloadData]; } completion:NULL];
    }
}

- (void)dealloc {
    
    /****************************
     在dealloc或者返回按钮里停止定时器
     ****************************/
    
    [self.pageFlowView stopTimer];
}

@end
