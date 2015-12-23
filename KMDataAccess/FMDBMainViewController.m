//
//  FMDBMainViewController.m
//  
//
//  Created by KenmuHuang on 15/10/3.
//
//

#import "FMDBMainViewController.h"
#import "KMAddRecordViewController.h"
#import "GlobalInfoModel.h"
#import "FMDBGlobalInfoService.h"
#import "KMTableView.h"

@interface FMDBMainViewController ()
@property (strong, nonatomic) KMTableView *tableView;

- (void)addRecord:(UIBarButtonItem *)sender;
- (void)layoutUI;
- (void)reloadData;
@end

@implementation FMDBMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // popViewControllerAnimated 回来的本视图不会执行 viewDidLoad 方法，而会执行 viewWillAppear: 方法，所以在这里进行刷新加载数据
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addRecord:(UIBarButtonItem *)sender {
    KMAddRecordViewController *addRecordVC = [KMAddRecordViewController new];
    addRecordVC.dataAccessFunction = _dataAccessFunction;
    [self.navigationController pushViewController:addRecordVC animated:YES];
}

- (void)layoutUI {
    self.navigationItem.title = kTitleOfFMDB;
    
    UIBarButtonItem *barButtonAddRecord = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                           target:self
                                           action:@selector(addRecord:)];
    self.navigationItem.rightBarButtonItem = barButtonAddRecord;
    
    NSMutableArray *mArrGlobalInfo = [[FMDBGlobalInfoService sharedService] getGlobalInfoGroup];
    CGRect frame = CGRectMake(5.0, 0.0, kWidthOfMainScreen - 10.0, kHeightOfMainScreen);
    
    __weak typeof(self)weakSelf = self;
    // 结合 block 操作来分离 dataSource 和 delegate
    _tableView = [[KMTableView alloc] initWithGlobalInfoArray:mArrGlobalInfo
                                                        frame:frame
                                           cellConfigureBlock:^(KMTableViewCell *cell,
                                                                GlobalInfoModel *globalInfo) {
                                               // 覆盖 cell 的默认配置
                                               cell.text = [NSString stringWithFormat:@"Text: %@", globalInfo.text];
                                           }
                                            didSelectRowBlock:^(NSInteger row, GlobalInfoModel *globalInfo) {
                                                NSLog(@"selectedRowIndex: %ld", (long)row);
                                                NSLog(@"globalInfo: %@", globalInfo);
                                            }
                                            didModifyRowBlock:^(NSNumber *ID) {
                                                KMAddRecordViewController *addRecordVC = [KMAddRecordViewController new];
                                                addRecordVC.dataAccessFunction = weakSelf.dataAccessFunction;
                                                addRecordVC.ID = ID;
                                                [weakSelf.navigationController pushViewController:addRecordVC animated:YES];
                                            }
                                            didDelectRowBlock:^(NSNumber *ID){
                                                [[FMDBGlobalInfoService sharedService] deleteGlobalInfoByID:ID];
                                            }];
    [self.view addSubview:_tableView];
}

- (void)reloadData {
    _tableView.mArrGlobalInfo = [[FMDBGlobalInfoService sharedService] getGlobalInfoGroup];
    [_tableView reloadData];
}

@end