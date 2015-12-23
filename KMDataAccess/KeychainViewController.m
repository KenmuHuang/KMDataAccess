//
//  KeychainViewController.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/18.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "KeychainViewController.h"
#import "UIButton+BeautifulButton.h"
#import "SSKeychain.h"

static NSString *const kService = @"com.kenmu.KMDataAccess"; // 服务名任意；保持存取一致就好
static NSString *const kAccount1 = @"KenmuHuang";
static NSString *const kAccount2 = @"Kenmu";

@interface KeychainViewController ()
- (void)layoutUI;
@end

@implementation KeychainViewController

#pragma mark - UIViewController Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutUI {
    self.navigationItem.title = kTitleOfKeychain;
    
    [_btnWriteTo beautifulButton:nil];
    [_btnReadFrom beautifulButton:[UIColor brownColor]];
}

- (IBAction)btnWriteToPressed:(id)sender {
    /*
     Keychain Services「钥匙串服务」原始代码是非 ARC 的，在 ARC 的环境下操作，需要通过 bridge「桥接」方式把 Core Foundation 对象转换为 Objective-C 对象。
     
     Keychain Services 的存储内容类型，常用的是 kSecClassGenericPassword，像 Apple 官网提供的 KeyChainItemWrapper 工程就是使用 kSecClassGenericPassword。
     同样，第三方库「SSKeychain」也是使用 kSecClassGenericPassword。
     extern const CFStringRef kSecClass;
     
     extern const CFStringRef kSecClassGenericPassword; // 通用密码；「genp」表
     extern const CFStringRef kSecClassInternetPassword; // 互联网密码；「inet」表
     extern const CFStringRef kSecClassCertificate; //证书；「cert」表
     extern const CFStringRef kSecClassKey; //密钥；「keys」表
     extern const CFStringRef kSecClassIdentity; //身份
     */
    
    /*
     SSKeychain.h 公开的方法：
     + (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account;
     + (NSString *)passwordForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;
     + (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account;
     + (BOOL)deletePasswordForService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;
     + (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account;
     + (BOOL)setPassword:(NSString *)password forService:(NSString *)serviceName account:(NSString *)account error:(NSError **)error;
     + (NSArray *)allAccounts;
     + (NSArray *)allAccounts:(NSError *__autoreleasing *)error;
     + (NSArray *)accountsForService:(NSString *)serviceName;
     + (NSArray *)accountsForService:(NSString *)serviceName error:(NSError *__autoreleasing *)error;
     */
    
    NSError * (^setPasswordBlock)(NSString *) = ^(NSString *account){
        // 创建 UUID 字符串作为密码进行测试；最终还是会被加密存储起来的
        CFUUIDRef UUIDPassword = CFUUIDCreate(NULL);
        CFStringRef UUIDPasswordStrRef = CFUUIDCreateString(NULL, UUIDPassword);
        NSString *UUIDPasswordStr = [NSString stringWithFormat:@"%@", UUIDPasswordStrRef];
        NSLog(@"UUIDPasswordStr: %@", UUIDPasswordStr);
        // 释放资源
        CFRelease(UUIDPasswordStrRef);
        CFRelease(UUIDPassword);
        
        NSError *error;
        [SSKeychain setPassword:UUIDPasswordStr
                     forService:kService
                        account:account
                          error:&error];
        
        return error;
    };
    
    // 存储2个用户密码信息，相当于向「genp」表插入2条记录
    NSError *errorOfAccount1 = setPasswordBlock(kAccount1);
    NSError *errorOfAccount2 = setPasswordBlock(kAccount2);
    
    NSMutableString *mStrCustom = [NSMutableString new];
    [mStrCustom appendFormat:@"%@ 写入密码%@\n\n", kAccount1, errorOfAccount1 ? @"失败" : @"成功"];
    [mStrCustom appendFormat:@"%@ 写入密码%@\n", kAccount2, errorOfAccount2 ? @"失败" : @"成功"];
    _txtVDetailInfo.text = mStrCustom;
}

- (IBAction)btnReadFromPressed:(id)sender {
    NSString * (^getPasswordBlock)(NSString *) = ^(NSString *account){
        NSError *error;
        return [SSKeychain passwordForService:kService
                                      account:account
                                        error:&error];
    };
    
    NSString *passwordOfAccount1 = getPasswordBlock(kAccount1);
    NSString *passwordOfAccount2 = getPasswordBlock(kAccount2);
    
    NSMutableString *mStrCustom = [NSMutableString new];
    [mStrCustom appendFormat:@"%@ 读取密码%@: %@\n\n", kAccount1, passwordOfAccount1 ? @"成功" : @"失败", passwordOfAccount1];
    [mStrCustom appendFormat:@"%@ 读取密码%@: %@\n", kAccount2, passwordOfAccount2 ? @"成功" : @"失败", passwordOfAccount2];
    _txtVDetailInfo.text = mStrCustom;
}

@end
