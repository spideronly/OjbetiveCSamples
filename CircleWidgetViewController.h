//
//  CircleWidgetViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 1/12/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CircleWidgetViewController : UIViewController
{
 
    
    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;
    
}

//System Sound
@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;

//array for reprsting the week days
@property (nonatomic,strong) NSMutableArray *WeekDays;
@property (readwrite) NSString *CellID;

@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIButton *btnFristGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnSecondGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnThirdGroup;
@property (weak, nonatomic) IBOutlet UIButton *BtnGoFSuperHourSetting;
-(void)LoadHoursValues:(NSString *)indexpath;
-(NSString *)GetTodayWeekDay;



@property (weak, nonatomic) IBOutlet UILabel *lblFirstGroupLetter;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondGroupLetter;
@property (weak, nonatomic) IBOutlet UILabel *lblThirdGroupLetter;
@property (weak, nonatomic) IBOutlet UILabel *lblDayName;
- (IBAction)BtnGoFSuperHourSettingh:(id)sender;



- (IBAction)btnFirstGroup:(id)sender;
- (IBAction)btnSecondGroup:(id)sender;
- (IBAction)btnThirdGroup:(id)sender;

// Uiswitches
- (IBAction)SwiSchedulAndCancelNotification:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *swSchesulAndCancelNotification;

@end
