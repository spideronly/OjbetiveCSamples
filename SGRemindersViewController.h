//
//  SGRemindersViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 1/20/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGRemindersViewController : UIViewController




///Alarm Settings
@property (nonatomic, strong) IBOutlet UIDatePicker *timeToSetOff;
@property (nonatomic, assign) NSInteger indexOfAlarmToEdit;
@property(nonatomic,assign) BOOL editMode;
@property(nonatomic,assign) int notificationID;
@property(atomic,strong) NSString *label;

- (IBAction)AddReminder:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *btnRecord;

// UI Controlls
@property (weak, nonatomic) IBOutlet UILabel *lblReminderTime;
@property (weak, nonatomic) IBOutlet UITextField *txtReminderName;
@property (weak, nonatomic) IBOutlet UITextField *txtReminderNotes;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalHours;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblToneName;


- (IBAction)btnRecord:(id)sender;

- (IBAction)Back:(id)sender;


@end
