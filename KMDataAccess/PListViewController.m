//
//  PListViewController.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/18.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "PListViewController.h"
#import "UIButton+BeautifulButton.h"
#import "DateHelper.h"

@interface PListViewController ()
- (void)layoutUI;
@end

@implementation PListViewController

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
    self.navigationItem.title = kTitleOfPList;
    
    [_btnWriteTo beautifulButton:nil];
    [_btnReadFrom beautifulButton:[UIColor brownColor]];
    
    _imgVDetailInfo.layer.masksToBounds = YES;
    _imgVDetailInfo.layer.cornerRadius = 10.0;
    _imgVDetailInfo.hidden = YES;
}

- (IBAction)btnWriteToPressed:(id)sender {
    /*
     序列化操作：可以直接进行文件存取的类型有「NSArray」「NSDictionary」「NSString」「NSData」。
     1、plist 文件「属性列表」内容是以 XML 格式存储的，在写入文件操作中，「NSArray」和「NSDictionary」可以正常识别，而对于「NSString」有中文的情况由于进行编码操作所以无法正常识别，最终「NSString」和「NSData」一样只能作为普通文件存储。无论普通文件还是 plist 文件，他们都是可以进行存取操作的。
     2、plist 文件中，「NSArray」和「NSDictionary」的元素可以是 NSArray、NSDictionary、NSString、NSDate、NSNumber，所以一般常见的都是以「NSArray」和「NSDictionary」来作为文件存取的类型。
     3、由于他存取都是整个文件覆盖操作，所以他只适合小数据量的存取。
     */
    
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:kPListName];
    
    [self NSDataWriteTo:filePath];
    _txtVDetailInfo.text = @"写入成功";
}

- (IBAction)btnReadFromPressed:(id)sender {
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:kPListName];
    
    NSData *dataCustom = [self NSDataReadFrom:filePath];
    _imgVDetailInfo.image = [UIImage imageWithData:dataCustom scale:1.0];
    _imgVDetailInfo.hidden = NO;
    _txtVDetailInfo.text = [NSString stringWithFormat:@"文件大小：%lu字节", (unsigned long)dataCustom.length];
}

#pragma mark - 序列化操作：可以直接进行文件存取的类型有「NSArray」「NSDictionary」「NSString」「NSData」
- (void)NSArrayWriteTo:(NSString *)filePath {
    NSArray *arrCustom = @[
                           @"KenmuHuang 的博客：\nhttp://www.cnblogs.com/huangjianwu/",
                           [DateHelper localeDate],
                           @6
                           ];
    [arrCustom writeToFile:filePath atomically:YES];
}

- (NSArray *)NSArrayReadFrom:(NSString *)filePath {
    return [NSArray arrayWithContentsOfFile:filePath];
}

- (void)NSDictionaryWriteTo:(NSString *)filePath {
    NSDictionary *dicCustom = @{
                                @"Name" : @"KenmuHuang",
                                @"Technology" : @"iOS",
                                @"ModifiedTime" : [DateHelper localeDate],
                                @"iPhone" : @6 // @6 语法糖等价于 [NSNumber numberWithInteger:6]
                                };
    [dicCustom writeToFile:filePath atomically:YES];
}

- (NSDictionary *)NSDictionaryReadFrom:(NSString *)filePath {
    return [NSDictionary dictionaryWithContentsOfFile:filePath];
}

- (BOOL)NSStringWriteTo:(NSString *)filePath {
    NSString *strCustom = @"KenmuHuang 的博客：\nhttp://www.cnblogs.com/huangjianwu/";
    NSError *error;
    // 当字符串内容有中文时，通过编码操作写入，无法作为正常的 plist 文件打开，只能作为普通文件存储
    [strCustom writeToFile:filePath
                atomically:YES
                  encoding:NSUTF8StringEncoding
                     error:&error];
    return error != nil;
}

- (NSString *)NSStringReadFrom:(NSString *)filePath {
    NSError *error;
    NSString *strCustom = [NSString stringWithContentsOfFile:filePath
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
    return error ? @"" : strCustom;
}

- (void)NSDataWriteTo:(NSString *)filePath {
    NSURL *URL = [NSURL URLWithString:kBlogImageStr];
    NSData *dataCustom = [[NSData alloc] initWithContentsOfURL:URL];
    // 数据类型写入，无法作为正常的 plist 文件打开，只能作为普通文件存储
    [dataCustom writeToFile:filePath atomically:YES];
    _imgVDetailInfo.hidden = YES;
}

- (NSData *)NSDataReadFrom:(NSString *)filePath {
    return [NSData dataWithContentsOfFile:filePath];
}

@end
