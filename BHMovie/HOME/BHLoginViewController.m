//
//  BHLoginViewController.m
//  BHMovie
//
//  Created by BAIHAOYANG on 2017/8/15.
//  Copyright © 2017年 XHDAXHK. All rights reserved.
//

#import "BHLoginViewController.h"
#import "KeychainHelper.h"
#import "ZYKeyboardUtil.h"
#import "Bmob.h"
#define kColor_BaseBGColor @"#f7f7f7"
#define kColor_BlueBGColor @"#566785"
#define kColor_BaseTitleBGColor @"#566785"
#define kColor_BaseMainTitleColor @"#666666"
#define kColor_MAIN @"#12b7f5"
#define KColor_lineColor @"#e5e5e5"
#define kColor_TotalLineColor @"#c8c7cc"
#define kFont_AlternateGothic2BT @"AlternateGothic2 BT"
#define kFont_PingFangSC @"PingFang SC"
#define kFont_PingFangSCSemibold @"PingFangSC-Semibold"
#define MARGIN_KEYBOARD 15
enum {
    UILoginTextFieldTagUser=500,//这是登录页面的Textfiled的Tag值 下面的以此加1
    UILoginTextFieldTagPassword,
} UILoginTextFieldTag;
@interface BHLoginViewController () <UITextFieldDelegate>
@property (nonatomic, strong) UITextField *userTextFiled;//用户名输入框
@property (nonatomic, strong) UITextField *passwordTextFiled;//密码输入框
@property (nonatomic, assign) CGFloat originY;
@property (strong, nonatomic) ZYKeyboardUtil *keyboardUtil;
@end

@implementation BHLoginViewController
{
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self configerKetBoard];
    [self LoadMainUI];
}
- (void)configerKetBoard{
    __weak BHLoginViewController *weakSelf = self;
    self.keyboardUtil = [[ZYKeyboardUtil alloc] initWithKeyboardTopMargin:MARGIN_KEYBOARD];
    [_keyboardUtil setAnimateWhenKeyboardAppearAutomaticAnimBlock:^(ZYKeyboardUtil *keyboardUtil) {
        [keyboardUtil adaptiveViewHandleWithController:weakSelf adaptiveView:weakSelf.userTextFiled,weakSelf.passwordTextFiled,nil];
    }];
}
- (void)LoadMainUI{
    NSString *usn=[KeychainHelper load:@"usn"];
    NSString *psd=[KeychainHelper load:@"psd"];
    NSLog(@"---->>>%@---->>>%@",usn,psd);
    UIImageView *iconViews = [[UIImageView alloc]initWithFrame:CGRectMake(PXChange(0), PXChange(142), PXChange(250),PXChange(268))];
    iconViews.center=CGPointMake(ScreenWidth/2.0f,iconViews.height/2.0f+PXChange(112));
    iconViews.image=[UIImage imageNamed:@"logo"];
    [self.view addSubview:iconViews];
    
    //用户名模块
    UIView *userInPutViewLine=[[UIView alloc]initWithFrame:CGRectMake(PXChange(46), iconViews.bottom+PXChange(144), ScreenWidth-PXChange(92), PXChange(88))];
    userInPutViewLine.backgroundColor=[UIColor clearColor];
    [self.view addSubview:userInPutViewLine];
    
    UIView *userInputView=[[UIView alloc]initWithFrame:CGRectMake(1, 1, userInPutViewLine.width-2, userInPutViewLine.height-2)];
    userInputView.backgroundColor=[UIColor clearColor];
    [userInPutViewLine addSubview:userInputView];
    
    UIImageView *phoneimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, PXChange(10), PXChange(28), PXChange(46))];
    phoneimage.image=[UIImage imageNamed:@"login_phone"];
    phoneimage.centerY=userInputView.height/2.0f;
    [userInputView addSubview:phoneimage];
    
    self.userTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(PXChange(54), PXChange(10), userInputView.width-PXChange(46), userInputView.height-10)];
    self.userTextFiled.placeholder = @"手机号";
    self.userTextFiled.keyboardType = UIKeyboardTypeNumberPad;
    //    self.userTextFiled.clearsOnBeginEditing = YES;
    self.userTextFiled.tag = UILoginTextFieldTagUser;
    self.userTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.userTextFiled.delegate = self;
    [self.userTextFiled addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    self.userTextFiled.textColor=[UIColor colorWithHexString:@"#4f5356"];
    [userInputView addSubview:self.userTextFiled];
    
    UILabel *phoneline=[[UILabel alloc]initWithFrame:CGRectMake(0, userInPutViewLine.height-PXChange(2), userInPutViewLine.width, 0.5)];
    phoneline.backgroundColor=[UIColor colorWithHexString:kColor_TotalLineColor];
    [userInputView addSubview:phoneline];
    
    //验证码部分
    UIView *CodeInPutViewLine=[[UIView alloc]initWithFrame:CGRectMake(PXChange(46), userInPutViewLine.bottom+PXChange(48), ScreenWidth-PXChange(92), PXChange(88))];
    CodeInPutViewLine.backgroundColor=[UIColor clearColor];
    [self.view addSubview:CodeInPutViewLine];
    
    UIView *CodeInputView=[[UIView alloc]initWithFrame:CGRectMake(1, 1, CodeInPutViewLine.width-2, CodeInPutViewLine.height-2)];
    CodeInputView.backgroundColor=[UIColor clearColor];
    [CodeInPutViewLine addSubview:CodeInputView];
    
    
    UIImageView *codeimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, PXChange(10), PXChange(30), PXChange(40))];
    codeimage.image=[UIImage imageNamed:@"login_lock"];
    codeimage.centerY=CodeInputView.height/2.0f;
    [CodeInputView addSubview:codeimage];
    
    self.passwordTextFiled=[[UITextField alloc]initWithFrame:CGRectMake(PXChange(54), PXChange(10), CodeInPutViewLine.width-PXChange(46)-PXChange(46)-PXChange(184), CodeInPutViewLine.height-10)];
    self.passwordTextFiled.placeholder=@"输入验证码";
    self.passwordTextFiled.keyboardType=UIKeyboardTypeNumberPad;
    self.passwordTextFiled.tag = UILoginTextFieldTagUser;
    self.passwordTextFiled.clearsOnBeginEditing = YES;
    self.passwordTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextFiled.textColor=[UIColor colorWithHexString:@"#4f5356"];
    [CodeInputView addSubview:self.passwordTextFiled];
    
    UILabel *codeline=[[UILabel alloc]initWithFrame:CGRectMake(0, CodeInPutViewLine.height-PXChange(2), CodeInPutViewLine.width, 0.5)];
    codeline.backgroundColor=[UIColor colorWithHexString:kColor_TotalLineColor];
    [CodeInputView addSubview:codeline];
    
    UIButton *loginbtn=[[UIButton alloc]initWithFrame:CGRectMake(PXChange(30), CodeInPutViewLine.bottom+PXChange(110), ScreenWidth-PXChange(60), PXChange(98))];
//    [loginbtn setBackgroundImage:[UIImage imageNamed:@"login_btnbg"] forState:UIControlStateNormal];
    [loginbtn setBackgroundColor:[UIColor colorWithHexString:kColor_MAIN]];
    [loginbtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginbtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [loginbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [loginbtn addTarget:self action:@selector(LoginClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbtn];
}
- (void)LoginClick:(UIButton *)btn{
    if((self.userTextFiled.text.length>0)&&(self.passwordTextFiled.text.length>0)){
        NSLog(@"正在写入");
        //去空格
        NSString *phoneStr = [self.userTextFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        [self insertUserName:phoneStr AndPassWord:self.passwordTextFiled.text];
    }else{
        NSLog(@"不能为空");
    }
        
}
- (void)insertUserName:(NSString *)Username AndPassWord:(NSString *)password{
    
    NSString *psd=[BHTools encodeBase64String:password];
    NSLog(@"---->%@",psd);
    NSString *depsd=[BHTools DecodedBase64Code:psd];
    NSLog(@"---->%@",depsd);
//    BmobUser *bUser = [[BmobUser alloc] init];
//    [bUser setUsername:Username];
//    [bUser setPassword:password];
////    [bUser setObject:@18 forKey:@"age"];
//    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
//    if (isSuccessful){
//        NSLog(@"Sign up successfully");
//    } else {
//        NSLog(@"%@",error);
//    }
//}];
//
//    [KeychainHelper save:@"usn" data:Username];
//    [KeychainHelper save:@"psd" data:password];
//    NSLog(@"保存成功");
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark ==== UITextFiled协议相关=====
- (void)textFieldEditingChanged:(UITextField *)textField
    {
    //限制手机账号长度（有两个空格）
    if (textField.text.length > 13) {
        textField.text = [textField.text substringToIndex:13];
    }
    
    NSUInteger targetCursorPosition = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    NSString *currentStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *preStr = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //正在执行删除操作时为0，否则为1
    char editFlag = 0;
    if (currentStr.length <= preStr.length) {
        editFlag = 0;
    }
    else {
        editFlag = 1;
    }
    
    NSMutableString *tempStr = [NSMutableString new];
    
    int spaceCount = 0;
    if (currentStr.length < 3 && currentStr.length > -1) {
        spaceCount = 0;
    }else if (currentStr.length < 7 && currentStr.length > 2) {
        spaceCount = 1;
    }else if (currentStr.length < 12 && currentStr.length > 6) {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++) {
        if (i == 0) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(0, 3)], @" "];
        }else if (i == 1) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(3, 4)], @" "];
        }else if (i == 2) {
            [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
        }
    }
    
    if (currentStr.length == 11) {
        [tempStr appendFormat:@"%@%@", [currentStr substringWithRange:NSMakeRange(7, 4)], @" "];
    }
    if (currentStr.length < 4) {
        [tempStr appendString:[currentStr substringWithRange:NSMakeRange(currentStr.length - currentStr.length % 3, currentStr.length % 3)]];
    }else if(currentStr.length > 3 && currentStr.length <12) {
        NSString *str = [currentStr substringFromIndex:3];
        [tempStr appendString:[str substringWithRange:NSMakeRange(str.length - str.length % 4, str.length % 4)]];
        if (currentStr.length == 11) {
            [tempStr deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    textField.text = tempStr;
    // 当前光标的偏移位置
    NSUInteger curTargetCursorPosition = targetCursorPosition;
    
    if (editFlag == 0) {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4) {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }else {
        //添加
        if (currentStr.length == 8 || currentStr.length == 4) {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument] offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition toPosition :targetPosition]];
    }
    
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
    {
//    previousTextFieldContent = textField.text;
//    previousSelection = textField.selectedTextRange;
    
    return YES;
    }
    
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
    
- (void)keyboardWillShow:(id)sender {
    
    CGFloat orignY=self.originY;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setOrigin:CGPointMake(self.view.frame.origin.x, orignY-100)];
    }];
}
    
- (void)keyboardWillHide:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setOrigin:CGPointMake(self.view.frame.origin.x, self.originY+64)];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
