//
//  PlayViewController.m
//  BHMovie
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 XHDAXHK. All rights reserved.
//

#import "PlayViewController.h"
#import "MRVLCPlayer.h"
@interface PlayViewController ()

@end

@implementation PlayViewController


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor=[UIColor blackColor];
}

@end
