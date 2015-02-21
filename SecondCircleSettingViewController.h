//
//  SecondCircleSettingViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 1/11/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondCircleSettingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnSecondGroup;
@property (weak, nonatomic) IBOutlet UILabel *lblSectionName;
- (IBAction)GoToReminder:(id)sender;
//
@property (nonatomic,strong) NSMutableArray *RemindersArray;

@property (readwrite) IBOutlet UINavigationItem *Navitem;

// On the hour switch
@property (weak, nonatomic) IBOutlet UISwitch *swOnthehour;
- (IBAction)SwOntheHour:(id)sender;
//Water Switch
@property (weak, nonatomic) IBOutlet UISwitch *swWater;
- (IBAction)SwWater:(id)sender;

//Walk Switch
@property (weak, nonatomic) IBOutlet UISwitch *swWalk;
- (IBAction)SwWalk:(id)sender;

@property (strong,nonatomic) NSString *WeekDay;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentDate;

- (IBAction)Done:(id)sender;

// Picker Views

@property (weak, nonatomic) IBOutlet UIPickerView *PVStart;
@property (weak, nonatomic) IBOutlet UIPickerView *PVEnd;
@end
