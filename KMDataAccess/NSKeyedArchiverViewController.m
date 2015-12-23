//
//  NSKeyedArchiverViewController.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/18.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "NSKeyedArchiverViewController.h"
#import "UIButton+BeautifulButton.h"
#import "GlobalInfoModel.h"
#import "DateHelper.h"

@interface NSKeyedArchiverViewController ()
- (void)layoutUI;
@end

@implementation NSKeyedArchiverViewController

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
    self.navigationItem.title = kTitleOfNSKeyedArchiver;
    
    [_btnWriteTo beautifulButton:nil];
    [_btnReadFrom beautifulButton:[UIColor brownColor]];
}

- (IBAction)btnWriteToPressed:(id)sender {
    /*
     NSKeyedArchiver「归档」属于序列化操作，遵循并实现 NSCoding 协议的对象都可以通过他实现序列化。绝大多数支持存储数据的 Foundation 和 Cocoa Touch 类都遵循了 NSCoding 协议，因此，对于大多数类来说，归档相对而言还是比较容易实现的。
     1、遵循并实现 NSCoding 协议中的归档「encodeWithCoder:」和解档「initWithCoder:」方法。
     2、如果需要归档的类是某个自定义类的子类时，就需要在归档和解档之前先实现父类的归档和解档方法。
     3、存取的文件扩展名可以任意。
     4、跟 plist 文件存取类似，由于他存取都是整个文件覆盖操作，所以他只适合小数据量的存取。
     */
    
    NSDictionary *dicGlobalInfoModel = @{
                                         kID : @1,
                                         kAvatarImageStr : kBlogImageStr,
                                         kName : @"KenmuHuang",
                                         kText : @"Say nothing...",
                                         kLink : @"http://www.cnblogs.com/huangjianwu/",
                                         kCreatedAt : [DateHelper localeDate]
                                         };
    GlobalInfoModel *globalInfoModel = [[GlobalInfoModel alloc] initWithDictionary:dicGlobalInfoModel];

    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:kNSKeyedArchiverName];
    // 归档
    [NSKeyedArchiver archiveRootObject:globalInfoModel toFile:filePath];
    _txtVDetailInfo.text = @"写入成功";
}

- (IBAction)btnReadFromPressed:(id)sender {
    NSString *documentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentsDir stringByAppendingPathComponent:kNSKeyedArchiverName];
    // 解档
    GlobalInfoModel *globalInfoModel = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    NSMutableString *mStrCustom = [NSMutableString new];
    if (globalInfoModel) {
        [mStrCustom appendFormat:@"%@: %@\n", kID, globalInfoModel.ID];
        [mStrCustom appendFormat:@"%@: %@\n", kAvatarImageStr, globalInfoModel.avatarImageStr];
        [mStrCustom appendFormat:@"%@: %@\n", kName, globalInfoModel.name];
        [mStrCustom appendFormat:@"%@: %@\n", kText, globalInfoModel.text];
        [mStrCustom appendFormat:@"%@: %@\n", kLink, globalInfoModel.link];
        [mStrCustom appendFormat:@"%@: %@\n", kCreatedAt, globalInfoModel.createdAt];
        [mStrCustom appendFormat:@"%@: %@\n", kHaveLink, globalInfoModel.haveLink ? @"YES" : @"NO"];
    }
    _txtVDetailInfo.text = mStrCustom;
}

@end