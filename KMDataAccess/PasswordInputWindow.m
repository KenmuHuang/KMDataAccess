//
//  PasswordInputWindow.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/16.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "PasswordInputWindow.h"
#import "FXBlurView.h"

static NSString *const isLoginedStr = @"IsLogined";

@implementation PasswordInputWindow {
    UITextField *_txtFPassword;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 模糊背景效果
        // 早上、黄昏、午夜、黎明；这里随机选择某张图片作为背景
        // 当然其他做法如：根据当前时间归属一天的某个时间段，选择对应相关的图片作为背景也是可以的
        NSArray *arrBlurImageName = @[ @"blur_morning",
                                       @"blur_nightfall",
                                       @"blur_midnight",
                                       @"blur_midnight_afternoon" ];
        NSInteger randomVal = arc4random() % [arrBlurImageName count];
        UIImage *img = [UIImage imageNamed:arrBlurImageName[randomVal]];
        // 这里使用 FXBlurView 库对于 UIImage 的分类扩展方法 blurredImageWithRadius:，
        // blurredImageWithRadius: 模糊效果半径范围
        // iterations: 重复渲染迭代次数；最低次数值需要为1，值越高表示质量越高
        // tintColor: 原图混合颜色效果；可选操作，注意颜色的透明度会自动被忽略
        img = [img blurredImageWithRadius:5.0
                               iterations:1
                                tintColor:nil];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:kFrameOfMainScreen];
        imgV.image = img;
        [self addSubview:imgV];
        
        // 密码输入文本框
        CGPoint pointCenter = CGPointMake(CGRectGetMidX(kFrameOfMainScreen), CGRectGetMidY(kFrameOfMainScreen));
        
        _txtFPassword = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 40.0)];
        _txtFPassword.center = pointCenter;
        _txtFPassword.borderStyle = UITextBorderStyleRoundedRect;
        _txtFPassword.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _txtFPassword.placeholder = @"请输入密码";
        _txtFPassword.secureTextEntry = YES;
        _txtFPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_txtFPassword];
        
        // 确定按钮
        UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 300.0, 40.0)];
        pointCenter.y += 50.0;
        btnOK.center = pointCenter;
        [btnOK setTitle:@"确定" forState:UIControlStateNormal];
        [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btnOK.backgroundColor = [UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000];
        [btnOK addTarget:self
                  action:@selector(btnOKPressed:)
        forControlEvents:UIControlEventTouchUpInside];
        btnOK.layer.borderColor = [UIColor colorWithRed:0.354 green:0.707 blue:0.883 alpha:1.000].CGColor;
        btnOK.layer.borderWidth = 1.0;
        btnOK.layer.masksToBounds = YES;
        btnOK.layer.cornerRadius = 5.0;
        [self addSubview:btnOK];
        
        // 点击手势控制隐藏键盘
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}

- (void)btnOKPressed:(UIButton *)btnOK {
    if ([_txtFPassword.text isEqualToString:@"123"]) {
        _txtFPassword.text = @"";
        [_txtFPassword resignFirstResponder];
        [self resignKeyWindow];
        self.hidden = YES;
        
        [self loginIn];
    } else {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                         message:@"密码错误，正确密码是123"
                                                        delegate:nil
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"确定", nil];
        [alertV show];
    }
}

- (void)hideKeyboard:(id)sender {
    // 多个控件的情况下，可以用 [self endEditing:YES];
    [_txtFPassword resignFirstResponder];
}

+ (PasswordInputWindow *)sharedInstance {
    static PasswordInputWindow *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PasswordInputWindow alloc] initWithFrame:kFrameOfMainScreen];
    });
    
    return sharedInstance;
}

- (void)show {
    /*
     // 窗口层级；层级值越大，越上层，就是覆盖在上面；可以设置的层级值不止以下三种，因为 UIWindowLevel 其实是 CGFloat 类型
     self.windowLevel = UIWindowLevelAlert;
     
     typedef CGFloat UIWindowLevel;
     UIKIT_EXTERN const UIWindowLevel UIWindowLevelNormal; // 默认配置；值为0.0
     UIKIT_EXTERN const UIWindowLevel UIWindowLevelAlert; // 弹出框；值为2000.0
     UIKIT_EXTERN const UIWindowLevel UIWindowLevelStatusBar __TVOS_PROHIBITED; // 状态栏；值为1000.0
     */
    
    [self makeKeyWindow];
    self.hidden = NO;
}

#pragma mark - NSUserDefaults
- (BOOL)isHaveLogined {
    //使用偏好设置判断「是否已经登录」
    return [[NSUserDefaults standardUserDefaults] boolForKey:isLoginedStr];
}

- (void)loginIn {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:isLoginedStr];
}

- (void)loginOut {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLoginedStr];
}

@end