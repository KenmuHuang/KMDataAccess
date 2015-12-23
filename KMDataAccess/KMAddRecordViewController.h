//
//  KMAddRecordViewController.h
//  
//
//  Created by KenmuHuang on 15/10/3.
//
//

#import <UIKit/UIKit.h>
#import "EnumKMDataAccessFunction.h"
#import "KMDatePicker.h"

@interface KMAddRecordViewController : UIViewController <KMDatePickerDelegate, UIAlertViewDelegate>
@property (assign, nonatomic) KMDataAccessFunction dataAccessFunction;
@property (strong, nonatomic) NSNumber *ID;

@property (strong, nonatomic) IBOutlet UITextField *txtFAvatarImageStr;
@property (strong, nonatomic) IBOutlet UITextField *txtFName;
@property (strong, nonatomic) IBOutlet UITextView *txtVText;
@property (strong, nonatomic) IBOutlet UITextField *txtFLink;
@property (strong, nonatomic) IBOutlet UITextField *txtFCreatedAt;
@property (strong, nonatomic) IBOutlet UIButton *btnSave;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@end
