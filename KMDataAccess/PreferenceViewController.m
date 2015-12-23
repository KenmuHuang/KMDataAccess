//
//  PreferenceViewController.m
//  KMDataAccess
//
//  Created by KenmuHuang on 15/11/18.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "PreferenceViewController.h"
#import "UIButton+BeautifulButton.h"
#import "DateHelper.h"

static NSString *const kNameOfPreference = @"Name";
static NSString *const kIsMaleOfPreference = @"IsMale";
static NSString *const kiPhoneOfPreference = @"iPhone";
static NSString *const kAvatarURLOfPreference = @"AvatarURL";
static NSString *const kFloatValOfPreference = @"FloatVal";
static NSString *const kDoubleValOfPreference = @"DoubleVal";
static NSString *const kMyArrayOfPreference = @"MyArray";
static NSString *const kMyDictionaryOfPreference = @"MyDictionary";

@interface PreferenceViewController ()
- (void)layoutUI;
@end

@implementation PreferenceViewController

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
    self.navigationItem.title = kTitleOfPreference;
    
    [_btnWriteTo beautifulButton:nil];
    [_btnReadFrom beautifulButton:[UIColor brownColor]];
}

- (IBAction)btnWriteToPressed:(id)sender {
    /*
     preference「偏好设置」可以直接进行存取的类型有「NSArray」「NSDictionary」「NSString」「BOOL」「NSInteger」「NSURL」「float」「double」。
     1、偏好设置是专门用来保存 App 的配置信息的，一般不要在偏好设置中保存其他数据。使用场景比如：App 引导页的开启控制，以存储的键值对 appVersion「App 更新后的当前版本」为准，开启条件为 appVersion 不存在或者不为当前版本，这样版本更新后，第一次打开 App 也能正常开启引导页。
     2、修改完数据，如果没有调用 synchronize 来立刻同步数据到文件内，系统会根据 I/O 情况不定时刻地执行保存。
     3、偏好设置实际上也是一个 plist 文件，他保存在沙盒的 Preferences 目录中「Home > Library > Preferences」，文件以 App 包名「Bundle Identifier」来命名，例如本例子就是：com.kenmu.KMDataAccess.plist。
     */
    
    NSURL *URL = [NSURL URLWithString:kBlogImageStr];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"KenmuHuang" forKey:kNameOfPreference];
    [userDefaults setBool:YES forKey:kIsMaleOfPreference];
    [userDefaults setInteger:6 forKey:kiPhoneOfPreference];
    [userDefaults setURL:URL forKey:kAvatarURLOfPreference];
    [userDefaults setFloat:6.5 forKey:kFloatValOfPreference];
    [userDefaults setDouble:7.5 forKey:kDoubleValOfPreference];
    
    NSArray *arrCustom = @[
                           @"KenmuHuang 的博客：\nhttp://www.cnblogs.com/huangjianwu/",
                           [DateHelper localeDate],
                           @6
                           ];
    [userDefaults setObject:arrCustom forKey:kMyArrayOfPreference];
    
    NSDictionary *dicCustom = @{
                                @"Name" : @"KenmuHuang",
                                @"Technology" : @"iOS",
                                @"ModifiedTime" : [DateHelper localeDate],
                                @"iPhone" : @6 // @6 语法糖等价于 [NSNumber numberWithInteger:6]
                                };
    [userDefaults setObject:dicCustom forKey:kMyDictionaryOfPreference];
    //立刻同步
    [userDefaults synchronize];
    _txtVDetailInfo.text = @"写入成功";
}

- (IBAction)btnReadFromPressed:(id)sender {
    NSMutableString *mStrCustom = [NSMutableString new];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [mStrCustom appendFormat:@"%@: %@\n", kNameOfPreference, [userDefaults objectForKey:kNameOfPreference]];
    [mStrCustom appendFormat:@"%@: %@\n", kIsMaleOfPreference, [userDefaults boolForKey:kIsMaleOfPreference] ? @"YES" : @"NO"];
    [mStrCustom appendFormat:@"%@: %ld\n", kiPhoneOfPreference, (long)[userDefaults integerForKey:kiPhoneOfPreference]];
    [mStrCustom appendFormat:@"%@: %@\n", kAvatarURLOfPreference, [userDefaults URLForKey:kAvatarURLOfPreference]];
    [mStrCustom appendFormat:@"%@: %f\n", kFloatValOfPreference, [userDefaults floatForKey:kFloatValOfPreference]];
    [mStrCustom appendFormat:@"%@: %f\n", kDoubleValOfPreference, [userDefaults doubleForKey:kDoubleValOfPreference]];
    
    [mStrCustom appendFormat:@"%@: (\n", kMyArrayOfPreference];
    for (NSObject *obj in [userDefaults objectForKey:kMyArrayOfPreference]) {
        [mStrCustom appendFormat:@"%@", obj];
        if (![obj isKindOfClass:[NSNumber class]]) {
            [mStrCustom appendString:@",\n"];
        } else {
            [mStrCustom appendString:@"\n)\n"];
        }
    }
    [mStrCustom appendFormat:@"%@: %@\n", kMyDictionaryOfPreference, [userDefaults objectForKey:kMyDictionaryOfPreference]];
    
    _txtVDetailInfo.text = mStrCustom;
}

@end
