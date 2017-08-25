//
//  SearchViewController.m
//  BHMovie
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 XHDAXHK. All rights reserved.
//

#import "SearchViewController.h"
#import "ViewController.h"
@interface SearchViewController ()
@end

@implementation SearchViewController
{
    UITextField *_keyWorlds;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"搜一搜";
    self.view.backgroundColor=[UIColor whiteColor];
    [self loadMainView];
}
-(void)loadMainView{
    UILabel *titlelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    titlelabel.textColor=[UIColor colorWithHexString:@"#828282"];
    titlelabel.text=@"请输入电影或者电视剧全名";
    [titlelabel setFont:[UIFont systemFontOfSize:PXChange(30)]];
    [titlelabel sizeToFit];
    titlelabel.center=CGPointMake(ScreenWidth/2.0f, PXChange(100));
    [self.view addSubview:titlelabel];
    
    _keyWorlds=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-PXChange(100), 44)];
    _keyWorlds.borderStyle=UITextBorderStyleNone;
    _keyWorlds.layer.borderWidth=0.5;
    _keyWorlds.layer.borderColor=[UIColor colorWithHexString:@"#a7a7a7"].CGColor;
    _keyWorlds.layer.cornerRadius=15;
    _keyWorlds.textAlignment=NSTextAlignmentCenter;
    _keyWorlds.textColor=[UIColor colorWithHexString:@"#a7a7a7"];
    _keyWorlds.clipsToBounds=YES;
    _keyWorlds.center=CGPointMake(ScreenWidth/2.0f, CGRectGetMaxY(titlelabel.frame)+PXChange(100));
    [self.view addSubview:_keyWorlds];
    
    UIButton *SearchBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, PXChange(200), 44)];
    [SearchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [SearchBtn setTitleColor:[UIColor colorWithHexString:@"#12b7f5"] forState:UIControlStateNormal];
    [SearchBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    SearchBtn.layer.borderColor=[UIColor colorWithHexString:@"#12b7f5"].CGColor;
    SearchBtn.layer.borderWidth=0.5;
    SearchBtn.layer.cornerRadius=12;
    SearchBtn.clipsToBounds=YES;
    SearchBtn.backgroundColor=[UIColor whiteColor];
    [SearchBtn addTarget:self action:@selector(searchMovie) forControlEvents:UIControlEventTouchUpInside];
    SearchBtn.center=CGPointMake(ScreenWidth/2.0f, CGRectGetMaxY(_keyWorlds.frame)+PXChange(100));
    [self.view addSubview:SearchBtn];
}
- (void)searchMovie{
    if(_keyWorlds.text.length==0){
        return;
    }
    ViewController *vc=[[ViewController alloc]init];
    vc.keyWords=_keyWorlds.text;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)backUp{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
