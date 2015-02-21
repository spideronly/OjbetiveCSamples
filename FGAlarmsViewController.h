 //
//  FGAlarmsViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 1/18/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface FGAlarmsViewController : UIViewController
{
    AVAudioPlayer *SmoothAlarm;


    CFURLRef		soundFileURLRef;
    SystemSoundID	soundFileObject;

}
- (IBAction)SWPlaySnoozeType:(id)sender;
- (IBAction)SWPlaySmothAlarm:(id)sender;

//ios  Native System Alert Soun

@property (readwrite)	CFURLRef		soundFileURLRef;
@property (readonly)	SystemSoundID	soundFileObject;


- (IBAction)ShowDate:(id)sender;

//Alarm Settings

// Time Picker
@property (nonatomic, strong) IBOutlet UIDatePicker *timeToSetOff;
@property (nonatomic, assign) NSInteger indexOfAlarmToEdit;
@property(nonatomic,assign) BOOL editMode;
@property(nonatomic,assign) int mynotificationID;
@property(atomic,strong) NSString *label;
//
@property (readwrite) IBOutlet UINavigationItem *Navitem;

//outlet fro my button icons
@property (weak, nonatomic) IBOutlet UIButton *btnReminderIcon;
@property (weak, nonatomic) IBOutlet UIButton *btnwakeup;
// this is sleep reminder btn icon
// this is wake up reminder btn icone
- (IBAction)btnSleepAction:(id)sender;

- (IBAction)btnwakeupAction:(id)sender;

//Other UIAction Controllers
@property (weak, nonatomic) IBOutlet UILabel *lblsleepAlarm;
//
@property (weak, nonatomic) IBOutlet UILabel *lblAlarmDate;

@property (strong,nonatomic) NSString *WeekDay;


//
@property (weak, nonatomic) IBOutlet UILabel *lblWakeUpAlarm;
@property (weak, nonatomic) IBOutlet UILabel *lblwakeUpTone;
@property (weak, nonatomic) IBOutlet UILabel *lblSleepToneTone;


@property (weak, nonatomic) IBOutlet UILabel *lblTotalHours;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

- (IBAction)SleepReord:(id)sender;
- (IBAction)WakeupRecord:(id)sender;

//switches
@property (weak, nonatomic) IBOutlet UISwitch *swSnoozeType;

@property (weak, nonatomic) IBOutlet UISwitch *swPlaySmoothAlarm;


- (IBAction)BtnSaveAlarm:(id)sender;

-(void)LoadText;

@end
