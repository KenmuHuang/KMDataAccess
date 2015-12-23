//
//  ViewController.m
//  KMDataAccess:（数据存取）（扩展知识：模糊背景效果和密码保护功能）
//
//  Created by KenmuHuang on 15/10/1.
//  Copyright (c) 2015年 Kenmu. All rights reserved.
//

#import "ViewController.h"
#import "EnumKMDataAccessFunction.h"
#import "PListViewController.h"
#import "PreferenceViewController.h"
#import "NSKeyedArchiverViewController.h"
#import "KeychainViewController.h"
#import "SQLiteMainViewController.h"
#import "CoreDataMainViewController.h"
#import "FMDBMainViewController.h"
#import "RootTableView.h"

@interface ViewController ()
@property (strong, nonatomic) RootTableView *tableView;

- (void)layoutUI;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithSampleNameArray:(NSArray *)arrSampleName {
    if (self = [super init]) {
        self.navigationItem.title = @"数据存储";
        self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];

        _arrSampleName = arrSampleName;
    }
    return self;
}

- (void)layoutUI {
    // 结合 block 操作来分离 dataSource 和 delegate
    _tableView = [[RootTableView alloc] initWithSampleNameArray:_arrSampleName
                                                          frame:self.view.frame
                                             cellConfigureBlock:^(UITableViewCell *cell, NSString *sampleName) {
                                                 // 覆盖 cell 的默认配置
                                                 cell.textLabel.text = sampleName;
                                             }
                                              didSelectRowBlock:^(NSInteger row) {
                                                  switch (row) {
                                                      case KMDataAccessFunctionPList: {
                                                          PListViewController *PListVC = [PListViewController new];
                                                          [self.navigationController pushViewController:PListVC animated:YES];
                                                          break;
                                                      }
                                                      case KMDataAccessFunctionPreference: {
                                                          PreferenceViewController *PreferenceVC =
                                                          [PreferenceViewController new];
                                                          [self.navigationController pushViewController:PreferenceVC
                                                                                               animated:YES];
                                                          break;
                                                      }
                                                      case KMDataAccessFunctionNSKeyedArchiver: {
                                                          NSKeyedArchiverViewController *NSKeyedArchiverVC =
                                                          [NSKeyedArchiverViewController new];
                                                          [self.navigationController pushViewController:NSKeyedArchiverVC
                                                                                               animated:YES];
                                                          break;
                                                      }
                                                      case KMDataAccessFunctionKeychain: {
                                                          KeychainViewController *KeychainVC = [KeychainViewController new];
                                                          [self.navigationController pushViewController:KeychainVC
                                                                                               animated:YES];
                                                          break;
                                                      }
                                                      case KMDataAccessFunctionSQLite: {
                                                          SQLiteMainViewController *SQLiteMainVC =
                                                          [SQLiteMainViewController new];
                                                          SQLiteMainVC.dataAccessFunction = KMDataAccessFunctionSQLite;
                                                          [self.navigationController pushViewController:SQLiteMainVC
                                                                                               animated:YES];
                                                          break;
                                                      }
                                                      case KMDataAccessFunctionCoreData: {
                                                          CoreDataMainViewController *CoreDataMainVC =
                                                          [CoreDataMainViewController new];
                                                          CoreDataMainVC.dataAccessFunction = KMDataAccessFunctionCoreData;
                                                          [self.navigationController pushViewController:CoreDataMainVC
                                                                                               animated:YES];
                                                          break;
                                                      }
                                                      case KMDataAccessFunctionFMDB: {
                                                          FMDBMainViewController *FMDBMainVC = [FMDBMainViewController new];
                                                          FMDBMainVC.dataAccessFunction = KMDataAccessFunctionFMDB;
                                                          [self.navigationController pushViewController:FMDBMainVC
                                                                                               animated:YES];
                                                          break;
                                                      }
                                                      default:
                                                          break;
                                                  }
                                              }];
    [self.view addSubview:_tableView];
}

@end
