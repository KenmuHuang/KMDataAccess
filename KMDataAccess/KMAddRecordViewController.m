//
//  KMAddRecordViewController.m
//  
//
//  Created by KenmuHuang on 15/10/3.
//
//

#import "KMAddRecordViewController.h"
#import "UIButton+BeautifulButton.h"
#import "GlobalInfoModel.h"
#import "SQLiteGlobalInfoService.h"
#import "CoreDataGlobalInfoService.h"
#import "FMDBGlobalInfoService.h"
#import "DateHelper.h"

@interface KMAddRecordViewController ()
- (void)layoutUI;
- (void)showAlertView:(NSString *)message;
@end

@implementation KMAddRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)layoutUI {
    self.navigationItem.title = _ID ? @"修改记录" : @"添加记录";
    
    CGRect rect = [[UIScreen mainScreen] bounds];
    rect = CGRectMake(0.0, 0.0, rect.size.width, 216.0);
    //年月日时分
    KMDatePicker *datePicker = [[KMDatePicker alloc]
                                initWithFrame:rect
                                delegate:self
                                datePickerStyle:KMDatePickerStyleYearMonthDayHourMinute];
    _txtFCreatedAt.inputView = datePicker;
    
    [_btnSave beautifulButton:[UIColor blackColor]];
    [_btnCancel beautifulButton:[UIColor brownColor]];
    
    [self setValueFromGlobalInfo];
}

- (void)setValueFromGlobalInfo {
    if (_ID) {
        GlobalInfoModel *globalInfo;
        switch (_dataAccessFunction) {
            case KMDataAccessFunctionSQLite: {
                globalInfo = [[SQLiteGlobalInfoService sharedService] getGlobalInfoByID:_ID];
                break;
            }
            case KMDataAccessFunctionCoreData: {
                globalInfo = [[CoreDataGlobalInfoService sharedService] getGlobalInfoByID:_ID];
                break;
            }
            case KMDataAccessFunctionFMDB: {
                globalInfo = [[FMDBGlobalInfoService sharedService] getGlobalInfoByID:_ID];
                break;
            }
            default: {
                break;
            }
        }
        
        if (globalInfo) {
            _txtFAvatarImageStr.text = globalInfo.avatarImageStr;
            _txtFName.text = globalInfo.name;
            _txtVText.text = globalInfo.text;
            _txtFLink.text = globalInfo.link;
            _txtFCreatedAt.text = [DateHelper dateToString:globalInfo.createdAt
                                                withFormat:nil];
        }
    } else {
        NSDate *localeDate = [DateHelper localeDate];
        _txtFCreatedAt.text = [DateHelper dateToString:localeDate
                                            withFormat:nil];
        _txtFName.text =
            [NSString stringWithFormat:@"anthonydali22 (%@)",
                                       [DateHelper dateToString:localeDate
                                                     withFormat:@"yyyyMMddHHmmss"]];
    }
}

- (void)showAlertView:(NSString *)message {
    // iOS (8.0 and later)
    /*
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示信息"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              if ([message hasSuffix:@"成功"]) {
                                                                  [self.navigationController popViewControllerAnimated:YES];
                                                              }
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
     */
    
    // iOS (2.0 and later)
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                     message:message
                                                    delegate:self
                                           cancelButtonTitle:nil
                                           otherButtonTitles:@"确定", nil];
    [alertV show];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [_txtFAvatarImageStr resignFirstResponder];
//    [_txtFName resignFirstResponder];
//    [_txtVText resignFirstResponder];
//    [_txtFLink resignFirstResponder];
//    [_txtFCreatedAt resignFirstResponder];
    
    [self.view endEditing:YES];
}

- (IBAction)save:(id)sender {
    NSString *avatarImageStr = [_txtFAvatarImageStr text];
    NSString *name = [_txtFName text];
    NSString *text = [_txtVText text];
    NSString *link = [_txtFLink text];
    NSDate *createdAt = [DateHelper dateFromString:[_txtFCreatedAt text]
                                        withFormat:nil];
    
    GlobalInfoModel *globalInfo = [[GlobalInfoModel alloc] initWithAvatarImageStr:avatarImageStr
                                                                             name:name
                                                                             text:text
                                                                             link:link
                                                                        createdAt:createdAt
                                                                               ID:_ID];
    BOOL isSuccess;
    NSString *message;
    //NSLog(@"KMDataAccessFunction: %lu", (unsigned long)_dataAccessFunction);
    switch (_dataAccessFunction) {
        case KMDataAccessFunctionSQLite: {
            if (_ID) {
                isSuccess = [[SQLiteGlobalInfoService sharedService] updateGlobalInfo:globalInfo];
            } else {
                isSuccess = [[SQLiteGlobalInfoService sharedService] insertGlobalInfo:globalInfo];
            }
            break;
        }
        case KMDataAccessFunctionCoreData: {
            if (_ID) {
                isSuccess = [[CoreDataGlobalInfoService sharedService] updateGlobalInfo:globalInfo];
            } else {
                globalInfo.ID = [self getIdentityNumber];
                isSuccess = [[CoreDataGlobalInfoService sharedService] insertGlobalInfo:globalInfo];
            }
            break;
        }
        case KMDataAccessFunctionFMDB: {
            if (_ID) {
                isSuccess = [[FMDBGlobalInfoService sharedService] updateGlobalInfo:globalInfo];
            } else {
                isSuccess = [[FMDBGlobalInfoService sharedService] insertGlobalInfo:globalInfo];
            }
            break;
        }
        default: {
            break;
        }
    }
    
    message = [NSString stringWithFormat:@"%@%@", _ID ? @"修改" : @"添加",
               isSuccess ? @"成功" : @"失败"];
    [self showAlertView:message];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSNumber *)getIdentityNumber {
    NSNumber *identityNumber;
    
    // 用于 CoreData 操作数据库新增记录时，自增长标示值
    NSString *const kIdentityValOfCoreData = @"identityValOfCoreData";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger identityVal = [userDefaults integerForKey:kIdentityValOfCoreData];
    identityVal = identityVal == 0 ? 1 : ++identityVal; //当键值对不存在时，identityVal 的默认值为0
    [userDefaults setInteger: identityVal forKey:kIdentityValOfCoreData];
    identityNumber = @(identityVal);
    return identityNumber;
}

#pragma mark - KMDatePickerDelegate
- (void)datePicker:(KMDatePicker *)datePicker didSelectDate:(KMDatePickerDateModel *)datePickerDate {
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",
                         datePickerDate.year,
                         datePickerDate.month,
                         datePickerDate.day,
                         datePickerDate.hour,
                         datePickerDate.minute
                         ];
    _txtFCreatedAt.text = dateStr;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 如果有提醒对话框有多个按钮，可以根据 buttonIndex 判断点击了哪个按钮
    if ([alertView.message hasSuffix:@"成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end