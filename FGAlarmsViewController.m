
//
//  FGAlarmsViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 1/18/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "FGAlarmsViewController.h"
#import "AlarmObject.h"
#import "FirstCircleSettingViewController.h"
#import "RecordViewController.h"
#import "ToneTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <EventKit/EventKit.h>
@interface FGAlarmsViewController ()
{
    BOOL isSleepAlarmOnTouch;
    BOOL isWakeUpAlarmOnTouch;
    
    NSString *SleepHour;
    NSString *SleepMin;
    
    NSString *WakeUpHour;
    NSString *WakeUpMin;
}
@end

@implementation FGAlarmsViewController
@synthesize timeToSetOff,lblAlarmDate,WeekDay;
@synthesize mynotificationID;
// Synthsis the System sound

@synthesize soundFileURLRef;
@synthesize soundFileObject;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
    //[self.timeToSetOff setLocale:locale];
    
    //self.timeToSetOff.hidden=YES;
    [self LoadData];
    [self EditModeValidator];
   // [self TapTwice];
    //[self CallValuesToLables];
}
-(void)CallValuesToLables
{
    
    
    NSData *SleepTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SleepTimeInstiation"];
    NSString *sleepDate = [NSKeyedUnarchiver unarchiveObjectWithData:SleepTextData];
    NSData *WakeupTextDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpTimeInstiation"];
    NSString *WakeupDate = [NSKeyedUnarchiver unarchiveObjectWithData:WakeupTextDate];
    if (sleepDate) {
        self.lblsleepAlarm.text =sleepDate;
        
    }
    if (WakeupDate) {
        self.lblWakeUpAlarm.text=WakeupDate;
        
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)PlaySmoothAlarm
{
    SmoothAlarm = [self setupAudioPlayerWithFile:@"APDD-TimesApp-SmoothSound-01-MORNING COSMIC VICTORY" type:@"wav"];
    [SmoothAlarm play];
}
//========================================================================
#pragma mark - play Audio files
//============================================================================


//Play Audio Method
- (AVAudioPlayer *)setupAudioPlayerWithFile:(NSString *)file type:(NSString *)type
{
    // 1
    NSString *path = [[NSBundle mainBundle] pathForResource:file ofType:type];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    // 2
    NSError *error;
    
    // 3
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    // 4
    if (!audioPlayer) {
        NSLog(@"%@",[error description]);
    }
    
    // 5
    return audioPlayer;
}

//========================================================================
#pragma mark - system Sound and vibration
//============================================================================

// Call This From View DidLoad
-(void)CreateSystemSound
{
    
    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"tap"
                                                withExtension: @"aif"];
    
    // Store the URL as a CFURLRef instance
    self.soundFileURLRef = (__bridge CFURLRef) tapSound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
                                      
                                      soundFileURLRef,
                                      &soundFileObject
                                      );
    
    
    
}

-(void)callrecordvoice
{
    
    
    NSURL *recordSound   = [[NSBundle mainBundle] URLForResource: @"Sleeprecording"
                                                   withExtension: @"m4a"];
    // Store the URL as a CFURLRef instance
    self.soundFileURLRef = (__bridge CFURLRef) recordSound;
    
    // Create a system sound object representing the sound file.
    AudioServicesCreateSystemSoundID (
                                      
                                      soundFileURLRef,
                                      &soundFileObject
                                      );


}

//========================================================================
#pragma mark -Alarm Methods
//============================================================================


-(void)SetAlarmforDAteAndTime
{

    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
    event.title     = @"EVENT TITLE";
    
    NSDateFormatter* df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh-mm -a"];
    NSString *stringFromDate = [df stringFromDate:timeToSetOff.date];
//stringFromDate-30
    event.startDate = [df dateFromString:stringFromDate];
    
    
    NSLog(@"start date is %@",event.startDate);
    event.endDate   = [[NSDate alloc] initWithTimeInterval:600 sinceDate:event.startDate];
    //NSLog(@"end date %@",event.endDate);
    
    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
    //NSLog(@"events are %@",event);
    //NSLog(@"events are %@",eventStore);
    NSError *err;
    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];

}
//========================================================================
#pragma mark - set upnotification
//============================================================================



//GetNotificationDateFromID

-(NSDate *)GetNotificationDateFromIDWithAdd:(NSString *)notificationID{
    
    NSDate *CurrentDate;
    NSDate *datePlusOneMinute;
    
    int minutesBefore;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
    {
        // Snooze is Active
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"isSnoozeActive"])
        {
            
            
            if( [[NSUserDefaults standardUserDefaults] boolForKey:@"isSnoozeFifteen"])
                
            {// Snooze for 3 times in 15 minutes
                minutesBefore=15;
                
            }
            else
                
            {// Snooze for 3 times in 15 minutes
                
                minutesBefore=30;
            }
            
        }
        
        
        
        // empsis thier status
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSmoothActive"];
        
        
    }
    if(!minutesBefore)
    {
        minutesBefore=0;
    
    }
    //Smooth switch
    
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[someNotification.userInfo objectForKey:@"notificationID"] isEqualToString:notificationID]) {
            
            CurrentDate =someNotification.fireDate;
            datePlusOneMinute = [CurrentDate dateByAddingTimeInterval:minutesBefore*60];;
        }
    }
    return datePlusOneMinute;
    
}

//========================================================================
#pragma mark -  Editing Mode
//============================================================================
-(void)EditModeValidator
{
    if (self.editMode)
    {
               //navItem.rightBarButtonItem.image = @"Save";
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *alarmListData = [defaults objectForKey:@"FGSleepAlarm"];
        NSMutableArray *alarmList = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
        AlarmObject * oldAlarmObject = [alarmList objectAtIndex:self.indexOfAlarmToEdit];
        self.label = oldAlarmObject.label;
            //   timeToSetOff.date = oldAlarmObject.timeToSetOff;
      //  self.notificationID = oldAlarmObject.notificationID;
        
    }



}


//========================================================================
#pragma Snooze Methods
//============================================================================

//========================================================================
#pragma mark Load Data
//============================================================================
-(void)LoadData

{
    
    
    
    
    [self LoadDisplay];

    [self SetDates:NO IsSleepSet:NO IsWakeupSet:NO];

    NSLog(@"From Load");
    [self LoadShapAndColors];
    NSLog(@"From LoadShapAndColors");

    [self LoadText];
    NSLog(@"From LoadText");

    [self LoadHoursValues];
    NSLog(@"From LoadHoursValues");

    [self LoadSwitchsCase];
    NSLog(@"From LoadSwitchsCase");

   [self LoadSleepAndWakeUpTime];
    NSLog(@"LoadSleepAndWakeUpTime");
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    [self LoadHoursValues:WeekDays ];
    
    

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    NSDate *today = [cal dateByAddingComponents:components toDate:[[NSDate alloc] init] options:0]; //This variable should now be pointing at a date object that is the start of today (midnight);
    
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
    NSLog(@"%@",yesterday);
    //timeToSetOff.minimumDate=[self GetCurrentDate:0];
    
    [timeToSetOff setDate:[NSDate date]];

    [timeToSetOff addTarget:self action:@selector(updateDateLabels:) forControlEvents:UIControlEventValueChanged];
    NSLog(@"time of set piker value,%@",timeToSetOff.date);
    
    
    
    // Load the current day Date to the lable
    

}
- (IBAction)updateDateLabels:(id)sender {
    
    NSDate *today1 = timeToSetOff.date ;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm a"];
    NSString *dateString11 = [dateFormat stringFromDate:today1];
    NSLog(@"%@",dateString11);
    if(isSleepAlarmOnTouch==YES)
        self.lblsleepAlarm.text=dateString11;
    if(isWakeUpAlarmOnTouch==YES)
        self.lblWakeUpAlarm.text=dateString11;
    
    
}



-(void)LoadSleepAndWakeUpTime
{
    [self SleepTimeDisplay];
    
    [self WakeUpTimeDisplay];
    
}

-(void)SleepTimeDisplay
{
    
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    
    if([WeekDays isEqualToString:@"0"])
    {
        if([self GetNotificationDateFromID:@"SleepNotificationIDMonday"])
        {
            // Format the date
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"SleepNotificationIDMonday"]];
            //unless ARC is active
            [self.lblsleepAlarm setText:stringFromDate];
            
            NSLog(@" w0 %@",[self GetNotificationDateFromID:@"SleepNotificationIDMonday"]);
            
        }
    }
    else if([WeekDays isEqualToString:@"1"])
    {
        if([self GetNotificationDateFromID:@"SleepNotificationIDTuesday"])
        {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"SleepNotificationIDTuesday"]];
                        //unless ARC is active
            [self.lblsleepAlarm setText:stringFromDate];
        }
        
        NSLog(@" w1 %@",[self GetNotificationDateFromID:@"SleepNotificationIDTuesday"]);
        
        
    }
    else if([WeekDays isEqualToString:@"2"])
    {
        if([self GetNotificationDateFromID:@"SleepNotificationIDWednesday"])
        {
            
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"SleepNotificationIDWednesday"]];
                        [self.lblsleepAlarm setText:stringFromDate];
        }
        NSLog(@" w2 %@",[self GetNotificationDateFromID:@"SleepNotificationIDWednesday"]);
        
        
    }
    else if([WeekDays isEqualToString:@"3"])
    {
        if([self GetNotificationDateFromID:@"SleepNotificationIDThursday"])
        {
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"SleepNotificationIDThursday"]];
            [self.lblsleepAlarm setText:stringFromDate];
            
        }        NSLog(@" w3 %@",[self GetNotificationDateFromID:@"SleepNotificationIDThursday"]);
        
        
    }
    else if([WeekDays isEqualToString:@"4"])
    {
        
        if([self GetNotificationDateFromID:@"SleepNotificationIDFriday"])
        {
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"SleepNotificationIDFriday"]];
            [self.lblsleepAlarm setText:stringFromDate];
            
        }
        NSLog(@" w4 %@",[self GetNotificationDateFromID:@"SleepNotificationIDFriday"]);
        
    }
    
    else if([WeekDays isEqualToString:@"5"])
    {
        
        if([self GetNotificationDateFromID:@"SleepNotificationIDSaturday"])
        {
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"hh:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"SleepNotificationIDSaturday"]];
            [self.lblsleepAlarm setText:stringFromDate];
        }
      
        NSLog(@" w5 %@",[self GetNotificationDateFromID:@"SleepNotificationIDSaturday"]);
        
    }
    else if([WeekDays isEqualToString:@"6"])
    {
        
        if([self GetNotificationDateFromID:@"SleepNotificationIDSunday"])
        {
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"SleepNotificationIDSunday"]];
            [self.lblsleepAlarm setText:stringFromDate];
        }
        //SleepNotificationIDMonday
        //SleepNotificationIDTuesday
        //SleepNotificationIDWednesday
        //SleepNotificationIDThursday
        //SleepNotificationIDFriday
        //SleepNotificationIDSutarday
        //SleepNotificationIDSunday
        NSLog(@" w6 %@",[self GetNotificationDateFromID:@"SleepNotificationIDSunday"]);
        
    }
    else
    {
        if([self GetNotificationDateFromID:@"SleepNotificationIDSunday"])
        {
            // Format the date
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"SleepNotificationIDSunday"]];
           
            [self.lblsleepAlarm setText:stringFromDate];
            
        }
        
        
    }
    
    
}

-(void)WakeUpTimeDisplay
{
    
    
    
    
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    
    if([WeekDays isEqualToString:@"0"])
    {
        if([self GetNotificationDateFromID:@"WakupNotificationIDMonday"])
        {
            // Format the date
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate;
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
            {
            stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromIDWithAdd:@"WakupNotificationIDMonday"]];
            }
            else
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"WakupNotificationIDMonday"]];

            
            }
            //unless ARC is active
            
            self.lblWakeUpAlarm.text=stringFromDate;

//            [self.lblWakeUpAlarm setText:stringFromDate];
            
            NSLog(@" w0 %@",[self GetNotificationDateFromID:@"WakupNotificationIDMonday"]);
            
        }
    }
    else if([WeekDays isEqualToString:@"1"])
    {
        if([self GetNotificationDateFromID:@"WakupNotificationIDTuesday"])
        {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate;
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromIDWithAdd:@"WakupNotificationIDTuesday"]];
            }
            else
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"WakupNotificationIDTuesday"]];
                
            }
            
            //unless ARC is active
            self.lblWakeUpAlarm.text=stringFromDate;

            //[self.lblWakeUpAlarm setText:stringFromDate];
        }
        
        NSLog(@" w1 %@",[self GetNotificationDateFromID:@"WakupNotificationIDTuesday"]);
        
        
    }
    else if([WeekDays isEqualToString:@"2"])
    {
        if([self GetNotificationDateFromID:@"WakupNotificationIDWednesday"])
        {
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate;
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromIDWithAdd:@"WakupNotificationIDWednesday"]];
            }
            else
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"WakupNotificationIDWednesday"]];
                
            }

            self.lblWakeUpAlarm.text=stringFromDate;

            //[self.lblWakeUpAlarm setText:stringFromDate];
        }
        NSLog(@" w2 %@",[self GetNotificationDateFromID:@"WakupNotificationIDWednesday"]);
        
        
    }
    else if([WeekDays isEqualToString:@"3"])
    {
        if([self GetNotificationDateFromID:@"WakupNotificationIDThursday"])
        {
            
           
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate;

            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromIDWithAdd:@"WakupNotificationIDThursday"]];
            }
            else
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"WakupNotificationIDThursday"]];
                
            }
            self.lblWakeUpAlarm.text=stringFromDate;

           // [self.lblWakeUpAlarm setText:stringFromDate];
            
        }
        NSLog(@" w3 %@",[self GetNotificationDateFromID:@"WakupNotificationIDThursday"]);
        
        
    }
    else if([WeekDays isEqualToString:@"4"])
    {
        
        if([self GetNotificationDateFromID:@"WakupNotificationIDFriday"])
        {
           
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate;
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromIDWithAdd:@"WakupNotificationIDFriday"]];
            }
            else
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"WakupNotificationIDFriday"]];
                
            }

            
            self.lblWakeUpAlarm.text=stringFromDate;

            //[self.lblWakeUpAlarm setText:stringFromDate];
            
            
        }
        NSLog(@" w4 %@",[self GetNotificationDateFromID:@"WakupNotificationIDFriday"]);
        
    }
    
    else if([WeekDays isEqualToString:@"5"])
    {
        
        if([self GetNotificationDateFromID:@"WakupNotificationIDSaturday"])
        {
            
            
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"hh:mm a"];
            NSString *stringFromDate;
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromIDWithAdd:@"WakupNotificationIDSaturday"]];
            }
            else
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"WakupNotificationIDSaturday"]];
                
            }

            self.lblWakeUpAlarm.text=stringFromDate;

            //[self.lblWakeUpAlarm setText:stringFromDate];
        }
        NSLog(@" w5 %@",[self GetNotificationDateFromID:@"WakupNotificationIDSaturday"]);
        
    }
    else if([WeekDays isEqualToString:@"6"])
    {
        
        if([self GetNotificationDateFromID:@"WakupNotificationIDSunday"])
        {
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate;

            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromIDWithAdd:@"WakupNotificationIDSunday"]];
            }
            else
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"WakupNotificationIDSunday"]];
                
            }
            //[self.lblWakeUpAlarm setText:stringFromDate];
            self.lblWakeUpAlarm.text=stringFromDate;

        
        }
        NSLog(@" w6 %@",[self GetNotificationDateFromID:@"WakupNotificationIDSunday"]);
        
    }
    else
    {
        if([self GetNotificationDateFromID:@"WakupNotificationIDSunday"])
        {
            // Format the date
            // Format the date
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm a"];
            NSString *stringFromDate;
            
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromIDWithAdd:@"WakupNotificationIDSunday"]];
            }
            else
            {
                stringFromDate = [formatter stringFromDate:[self GetNotificationDateFromID:@"WakupNotificationIDSunday"]];
                
            }

          
            self.lblWakeUpAlarm.text=stringFromDate;

            //  [self.lblWakeUpAlarm setText:stringFromDate];
            
        }
        
        
    }
    
}
-(void)LoadDisplay
{
    NSString *WhatButton = [[NSUserDefaults standardUserDefaults] objectForKey:@"WhatButton"];

    if([WhatButton isEqualToString:@"Sleep"])
    {
        [self sleepDisplay];

    
    }
    else if([WhatButton isEqualToString:@"WakeUp"])
    {
        [self WakeUpDisplay];
        
        
    }
 
}


-(void)WakeUpDisplay
{
    
    
    //self.timeToSetOff.hidden=NO;
    [self.lblsleepAlarm setFont: [UIFont fontWithName:@"Arial" size:17.0f]];
    [self.lblWakeUpAlarm setFont: [UIFont fontWithName:@"Arial" size:20.0f]];
    [self.lblWakeUpAlarm setTextColor:[UIColor greenColor]];
    [self.lblsleepAlarm setTextColor:[UIColor grayColor]];
    
    isSleepAlarmOnTouch=NO;
    isWakeUpAlarmOnTouch=YES;
    AudioServicesPlaySystemSound (soundFileObject);
    //  [self saveAlarm];
    
}
-(void)sleepDisplay
{
    
    //self.timeToSetOff.hidden=NO;
    
    [self.lblsleepAlarm setFont: [UIFont fontWithName:@"Arial" size:20.0f]];
    [self.lblWakeUpAlarm setFont: [UIFont fontWithName:@"Arial" size:17.0f]];
    [self.lblsleepAlarm setTextColor:[UIColor greenColor]];
    [self.lblWakeUpAlarm setTextColor:[UIColor grayColor]];
    
    //cahnge button property
    self.btnReminderIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btnReminderIcon setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.btnReminderIcon.backgroundColor = [UIColor redColor];
    self.btnReminderIcon.layer.borderColor = [UIColor blackColor].CGColor;
    self.btnReminderIcon.layer.borderWidth = 0.5f;
    self.btnReminderIcon.layer.cornerRadius = 10.0f;
    
    
    // Save the alarm
    
    
    isSleepAlarmOnTouch=YES;
    isWakeUpAlarmOnTouch=NO;
    //[self BringAlarmTons];
    //[self saveAlarm];
    
    AudioServicesPlaySystemSound (soundFileObject);
    
}
-(void)LoadSwitchsCase
{

    // Snooze Switch
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
    {
     // Snooze is Active
        [self.swSnoozeType setThumbTintColor:[UIColor blackColor]];

        if([[NSUserDefaults standardUserDefaults] boolForKey:@"isSnoozeActive"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"isSnoozeFifteen"] )
        {
            // Snooze for 3 times in 15 minutes

            //[self SnoozeThreeInFifteen];

            [_swSnoozeType setOn:NO animated:YES];
            
        }
        else
        {
            // Snooze for 3 times in 30 minutes

           // [self SnoozeThreeInThirty];

            [_swSnoozeType setOn:YES animated:YES];
            
        }
        
        
        // empsis thier status
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSmoothActive"];

        [_swPlaySmoothAlarm setOn:NO animated:YES];
        
    }
   //Smooth switch
    else
    {
        
        //Set Up THe Outlet and triggers
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSmoothActive"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSnoozeActive"];
        [_swPlaySmoothAlarm setOn:YES animated:YES];
        [_swSnoozeType setOn:NO animated:YES];


       

    }

}

-(void)LoadText
{
    NSData *firstTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSliderTextData"];
    NSString *firsttext = [NSKeyedUnarchiver unarchiveObjectWithData:firstTextData];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstSliderTextDataChangeFlag"]) {
        firsttext=@"Sleep";
    }
    self.lblTitle.text=firsttext;
    
    
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isSleepRecordActive"]) {
        self.lblSleepToneTone.text=@"Record!";
        
    }
    else
    {
        NSString *SleepyTone=[[NSUserDefaults standardUserDefaults] objectForKey:@"SleepSelectedToneFileNameData"];
        if(!SleepyTone)
            SleepyTone=@"Not Set Yet";
        
        self.lblSleepToneTone.text=SleepyTone;
    }
   
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isWakeUpRecordActive"]) {
        self.lblwakeUpTone.text=@"Record!";
        
    }
    else
    {
        NSString *WakeUpyTone= [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpSelectedToneFileNameData"];
        if(!WakeUpyTone)
            WakeUpyTone=@"Not Set Yet";
        self.lblwakeUpTone.text=WakeUpyTone;
        
    }
  

}
-(void)LoadShapAndColors
{
    
    NSData *firstcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSliderColorData"];
    UIColor *firstdolor = [NSKeyedUnarchiver unarchiveObjectWithData:firstcolorData];
    
    //Setup The Lable Round and Border width
    _lblTotalHours.layer.borderWidth = 4;
    _lblTotalHours.layer.cornerRadius=_lblTotalHours.layer.bounds.size.width/2;
    
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstSliderColorDataChangeFlag"]) {
        firstdolor=[UIColor blueColor];
    }
    
    _lblTotalHours.textColor=firstdolor;
    _lblTotalHours.layer.borderColor =firstdolor.CGColor;
    //
 
}
-(void)LoadHoursValues:(NSString *)indexpath
{
    
    //
    NSData *firstValueData ;
    
    NSData *secondValueData ;
    
    NSData *thirdValueData ;
    
    NSString *firstValue;
    NSString *secondValue;
    NSString *thirdValue;
    
    //NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    //  NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    
    //Monday
    if([indexpath isEqualToString:@"0"])
    {
        firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MondayfirstValueData"];
        secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MondaysecondValueData"];
        thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"MondaythirdValueData"];
        firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
        secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
        thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"MondayfirstValueDataChangeFlag"]) {
            firstValue=@"8";
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"MondaysecondValueDataChangeFlag"]) {
            
            secondValue=@"8";
            
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"MondaythirdValueDataChangeFlag"]) {
            thirdValue=@"8";
            
        }
        [_lblTotalHours setText:firstValue];
        
        
    }
    else if ([indexpath isEqualToString:@"1"])
    {
        firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"TuesdayfirstValueData"];
        secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"TuesdaysecondValueData"];
        thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"TuesdaythirdValueData"];
        firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
        secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
        thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"TuesdayfirstValueDataChangeFlag"]) {
            firstValue=@"8";
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"TuesdaysecondValueDataChangeFlag"]) {
            
            secondValue=@"8";
            
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"TuesdaythirdValueDataChangeFlag"]) {
            thirdValue=@"8";
            
        }
        [_lblTotalHours  setText:firstValue];
        
        
        
        
    }
    else if ([indexpath isEqualToString:@"2"])
    {
        firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WendsadayfirstValueData"];
        secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WendsadaysecondValueData"];
        thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WendsadaythirdValueData"];
        firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
        secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
        thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"WendsadayfirstValueDataChangeFlag"]) {
            firstValue=@"8";
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"WendsadaysecondValueDataChangeFlag"]) {
            
            secondValue=@"8";
            
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"WendsadaythirdValueDataChangeFlag"]) {
            thirdValue=@"8";
            
        }
        [_lblTotalHours  setText:firstValue];
        
        
        
        
    }
    
    else if ([indexpath isEqualToString:@"3"])
    {
        firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThursdayfirstValueData"];
        secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThursdaysecondValueData"];
        thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThursdaythirdValueData"];
        firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
        secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
        thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"ThursdayfirstValueDataChangeFlag"]) {
            firstValue=@"8";
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"ThursdaysecondValueDataChangeFlag"]) {
            
            secondValue=@"8";
            
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"ThursdaythirdValueDataChangeFlag"]) {
            thirdValue=@"8";
            
        }
        [_lblTotalHours  setText:firstValue];
        
        
        
        
    }
    
    
    else if ([indexpath isEqualToString:@"4"])
    {
        firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FridayfirstValueData"];
        secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FridaysecondValueData"];
        thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"FridaythirdValueData"];
        firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
        secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
        thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"FridayfirstValueDataChangeFlag"]) {
            firstValue=@"8";
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"FridaysecondValueDataChangeFlag"]) {
            
            secondValue=@"8";
            
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"FridaythirdValueDataChangeFlag"]) {
            thirdValue=@"8";
            
        }
        [_lblTotalHours  setText:firstValue];
        
        
        
        
    }
    
    else if ([indexpath isEqualToString:@"5"])
    {
        firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SutardayfirstValueData"];
        secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SutardaysecondValueData"];
        thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SutardaythirdValueData"];
        firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
        secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
        thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SutardayfirstValueDataChangeFlag"]) {
            firstValue=@"8";
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SutardaysecondValueDataChangeFlag"]) {
            
            secondValue=@"8";
            
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SutardaythirdValueDataChangeFlag"]) {
            thirdValue=@"8";
            
        }
        [_lblTotalHours  setText:firstValue];
        
        
        
    }
    else if ([indexpath isEqualToString:@"6"])
    {
        firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SundayfirstValueData"];
        secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SundaysecondValueData"];
        thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SundaythirdValueData"];
        firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
        secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
        thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SundayfirstValueDataChangeFlag"]) {
            firstValue=@"8";
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SundaysecondValueDataChangeFlag"]) {
            
            secondValue=@"8";
            
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SundaythirdValueDataChangeFlag"]) {
            thirdValue=@"8";
            
        }
        [_lblTotalHours  setText:firstValue];
        
        
        
        
    }
    
    else     {
        
        firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstValueData"];
        secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondValueData"];
        thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdValueData"];
        firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
        secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
        thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstValueDataChangeFlag"]) {
            firstValue=@"8";
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"secondValueDataChangeFlag"]) {
            
            secondValue=@"8";
            
        }
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"thirdSValueDataChangeFlag"]) {
            thirdValue=@"8";
            
        }
        [_lblTotalHours  setText:firstValue];
        
        
        
        
    }
    
    
    
    
    
    
}
-(void)LoadHoursValues
{
    
    
    NSData *firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstValueData"];
    NSString *firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstValueDataChangeFlag"]) {
        firstValue=@"8";
    }
    _lblTotalHours.text=firstValue;
    
    
    
}

//========================================================================
#pragma mark - Double Tap To Exit

//============================================================================

-(void)TapTwice
{
    
    //Recognize the number of touch in the screen as well
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    // Set the Super hour lable in the front to skip hirarcy problems

}
- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
       // Save The Alarms
       // [self saveAlarm];
        // Exit
            [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
     //Shaing when Dismiss
        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);

    }
}





//========================================================================
#pragma mark -  UiSwitches
//============================================================================
- (IBAction)SWPlaySnoozeType:(id)sender {
    [self.swSnoozeType setThumbTintColor:[UIColor blackColor]];
    [self.swPlaySmoothAlarm setOn:NO animated:YES];
    
    if (_swSnoozeType.isOn) {
        // delay reminder
        [SmoothAlarm stop];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSmoothActive"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSnoozeActive"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSnoozeFifteen"];
        [self SetDates:YES IsSleepSet:NO IsWakeupSet:YES];
    }
    
    else
    {

        [SmoothAlarm stop];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSmoothActive"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSnoozeActive"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSnoozeFifteen"];
        [self SetDates:YES IsSleepSet:NO IsWakeupSet:YES];

    }
}
- (IBAction)SWPlaySmothAlarm:(id)sender {


    if(_swPlaySmoothAlarm.isOn)
    {
        
    [self.swSnoozeType setThumbTintColor:[UIColor whiteColor]];
    
   // [self PlaySmoothAlarm];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSmoothActive"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSnoozeActive"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSnoozeFifteen"];
        
}
    else
    {
        [self.swSnoozeType setThumbTintColor:[UIColor blackColor]];

        [SmoothAlarm stop];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSmoothActive"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSnoozeActive"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSnoozeFifteen"];

    }

}
//========================================================================
#pragma mark -  Gesture Actions
//============================================================================
-(IBAction)SingleTapSleepTone:(UITapGestureRecognizer *) recgnizer
{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Sleep" forKey:@"ComingFromData"];

    //self.view.backgroundColor=[UIColor blueColor];
    
    // Navigate to UIViewController programaticly inside storyboard

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"ToneTableViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
-(IBAction)SingleTapWakeUpTone:(UITapGestureRecognizer *) recgnizer
{
    [[NSUserDefaults standardUserDefaults] setObject:@"WakeUp" forKey:@"ComingFromData"];
    
    //self.view.backgroundColor=[UIColor blueColor];
    
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"ToneTableViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

-(IBAction)LongPressedOnSleepAlarm:(UILongPressGestureRecognizer *) recgnizer
{
    
    
    isSleepAlarmOnTouch=YES;
    isWakeUpAlarmOnTouch=NO;
    //[self BringAlarmTons];
   // [self saveAlarm];
    
    AudioServicesPlaySystemSound (soundFileObject);
}
-(IBAction)LongPressedOnWakeUpAlarm:(UILongPressGestureRecognizer *) recgnizer
{
    isSleepAlarmOnTouch=NO;
    isWakeUpAlarmOnTouch=YES;
    AudioServicesPlaySystemSound (soundFileObject);
    //[self saveAlarm];
    
}
//========================================================================
#pragma mark - UiButton Action
//============================================================================


- (IBAction)btnSleepAction:(id)sender {
    
   
    [self sleepDisplay];

    

}

- (IBAction)btnwakeupAction:(id)sender {
    [self WakeUpDisplay];

    

}
- (void)setDate:(NSDate *)date
       animated:(BOOL)animated
{


}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // making up an IBOutlet called someLabel
    // making up a model method (description) that returns a string representing your model
    [self LoadText];

    
}
- (IBAction)BtnSaveAlarm:(id)sender {
    

    NSLog(@"%@",timeToSetOff.date);


    /////==================================           Alarm Sound System         ===============================================

    /////=====================================

    //[self saveAlarm];
    if(isWakeUpAlarmOnTouch==YES)
    {
       WakeUpHour= [self GetHourForDate:timeToSetOff.date];
    WakeUpMin= [self GetMinForDate:timeToSetOff.date];
        NSString *AmPm=[self GetAmPmForDate:timeToSetOff.date];
        NSLog(@"WakeUpHour set up is %@",WakeUpHour);
        NSLog(@"min set up is %@",WakeUpMin);

        [[NSUserDefaults standardUserDefaults] setObject:WakeUpHour forKey:@"WakeUpHour"];
        [[NSUserDefaults standardUserDefaults] setObject:WakeUpMin forKey:@"WakeUpMin"];
        [[NSUserDefaults standardUserDefaults] setObject:AmPm forKey:@"AmPm"];
        

        [[NSUserDefaults standardUserDefaults] setObject:timeToSetOff.date forKey:@"WakeUpTimeInstiation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WakeUpTimeInstiationFlag"];
        [self SetDates:YES IsSleepSet:NO IsWakeupSet:YES];

   }
    
    if(isSleepAlarmOnTouch==YES)
    {
        
        
     
        SleepHour= [self GetHourForDate:timeToSetOff.date];
        SleepMin= [self GetMinForDate:timeToSetOff.date];
        NSLog(@"sleep hour set up is %@",SleepHour);
        NSLog(@"sleep min set up is %@",SleepMin);
        
        [[NSUserDefaults standardUserDefaults] setObject:SleepHour forKey:@"SleepHour"];
        [[NSUserDefaults standardUserDefaults] setObject:SleepMin forKey:@"SleepMin"];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:timeToSetOff.date forKey:@"SleepTimeInstiation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SleepTimeInstiationFlag"];
        [self SetDates:YES IsSleepSet:YES IsWakeupSet:NO];

        /*
        NSString *WakeUpToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpSelectedToneFileNameData"];
        if (!WakeUpToneFileName) {
            // This is the 1st run of the app
            [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-WakeUpAlarm-Creation" forKey:@"WakeUpSelectedToneFileNameData"];
        
        
        
        }
        
        
        
        WakeUpToneFileName=[NSString stringWithFormat:@"%@.wav",WakeUpToneFileName];

        
 [self scheduleNotificationForDate:timeToSetOff.date AlertBody:@"Sleep Time" ActionButtonTitle:@"Ok" NotificationID:@"SleepNotificationID" CustomeSoundName:WakeUpToneFileName repeat:2];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:timeToSetOff.date forKey:@"SleepTimeInstiation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SleepTimeInstiationFlag"];
        

        */
    }
         
   // FirstCircleSettingViewController *myController=[[FirstCircleSettingViewController alloc] init];
   // [myController LoadText];
    
    
    FirstCircleSettingViewController *contrller=[[FirstCircleSettingViewController alloc] init];
    [[contrller view] setNeedsDisplay];
    [contrller.lblsleepAlarm setNeedsDisplay];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}

//========================================================================
#pragma mark - Reocrd Navigaation
//============================================================================
- (IBAction)SleepReord:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSleepRecord"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isWakupRecord"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDayReminderRecord"];
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"First" forKey:@"WhatPage"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Sleep" forKey:@"RecordFor"];
    [self CallTheChildComponents];
    
}

- (IBAction)WakeupRecord:(id)sender {
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isWakupRecord"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSleepRecord"];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isDayReminderRecord"];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"First" forKey:@"WhatPage"];
    [[NSUserDefaults standardUserDefaults] setObject:@"WakeUp" forKey:@"RecordFor"];
    
    [self CallTheChildComponents];
}

-(void)CallTheChildComponents
{
  
    RecordViewController *VoiceRecordView=[[RecordViewController alloc]init ];
    
    VoiceRecordView.view.frame=self.view.bounds;
    [self.view addSubview:VoiceRecordView.view];
    [self addChildViewController:VoiceRecordView];
    [VoiceRecordView didMoveToParentViewController:self];
      /*
    RecordViewController *addController = [[RecordViewController alloc]
                                              init];
    
    // Configure the RecipeAddViewController. In this case, it reports any
    // changes to a custom delegate object.
   // addController.delegate = self;
    
    // Create the navigation controller and present it.
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:addController];
    navigationController.view.backgroundColor=[UIColor clearColor];
    [self presentViewController:navigationController animated:YES completion: nil];
    */
}

// Method to close the child view
- (void)RecordViewControllerClose:(UIViewController *)childController;
{
    [childController willMoveToParentViewController:nil];
    [childController.view removeFromSuperview];
    [childController removeFromParentViewController];
}
-(void)ChangeToDateMode
{
    timeToSetOff.datePickerMode=UIDatePickerModeDate;
    
    NSDate *FullDate=timeToSetOff.date;
    NSDateFormatter *FullDateFormat = [[NSDateFormatter alloc] init];
    [FullDateFormat setDateFormat:@"YYYY-MM-DD HH:MM:SS ±HHMM "];
    NSString *FulldateString = [FullDateFormat stringFromDate:FullDate];
    NSLog(@"Full Date%@",FulldateString);
    
    
    self.lblAlarmDate.text=FulldateString;


}
- (IBAction)ShowDate:(id)sender {
    [self ChangeToDateMode];
}




//========================================================================
#pragma mark - Set Alarms Seperatly
//============================================================================
-(NSDate *)GetSelectedDate:(int)Days
{

    
    NSDate *currentDate = timeToSetOff.date;
    
    
    if ([currentDate compare:[NSDate date]] == NSOrderedAscending) {
        
        // Current Date is later than Now date
        Days=Days+1;

        NSLog(@"date1 is later than date2");
        NSLog(@"Did Plus");

    }
   
    int DaysFromToday=Days;
    // or 60 :-)
    // set up date components
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Set Compnents
    NSDateComponents *Pluscomponent = [[NSDateComponents alloc] init];
    [Pluscomponent setDay:DaysFromToday];
    
    
    /// Set Up the Time Zone
    
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
    NSString *stringFromDate = [df stringFromDate:currentDate];
    
  
    //Create the date assuming the given string is in GMT
    // df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    //Create a date string in the local timezone
    
    // df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    NSDate *date = [df dateFromString:stringFromDate];
    
    
    
    
    // create a calendar
    NSDate *dtTodayPlusDate = [gregorian dateByAddingComponents:Pluscomponent toDate:date options:0];
    
    
    // Display Moinitor for development purpose
    NSLog(@"Tomorow------------------------------------------------------: %@", dtTodayPlusDate);

    NSDateFormatter *mydf = [NSDateFormatter new];
    [mydf setDateFormat:@"EEEE"];
    NSString *mycurrentweekday = [mydf stringFromDate:dtTodayPlusDate];
    NSLog(@"current day date %@",dtTodayPlusDate);
    
    NSLog(@"current week day %@",mycurrentweekday);
    return dtTodayPlusDate;
    

}

-(NSDate *)GetCurrentDate:(int)Days
{
    NSDate *currentDate = [NSDate date];
    
    
    int DaysFromToday=Days;
    // or 60 :-)
    // set up date components
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Set Compnents
    NSDateComponents *Pluscomponent = [[NSDateComponents alloc] init];
    [Pluscomponent setDay:DaysFromToday];
    
    
    /// Set Up the Time Zone
    
    
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd/MM/yyyy HH:mm"];
    
    NSString *stringFromDate = [df stringFromDate:currentDate];
    //Create the date assuming the given string is in GMT
   // df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    //Create a date string in the local timezone

   // df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];

    NSDate *date = [df dateFromString:stringFromDate];
    
    
    
    
    // create a calendar
    NSDate *dtTodayPlusDate = [gregorian dateByAddingComponents:Pluscomponent toDate:date options:0];
    
    NSLog(@"Tomorow------------------------------------------------------: %@", dtTodayPlusDate);
    
    return dtTodayPlusDate;
    
}

-(NSString *)GetCurrentWeekDay:(int)Days
{
    NSDate *currentDate = [NSDate date];
    int DaysFromToday=Days;
    // or 60 :-)
    // set up date components
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    // Set Compnents
    NSDateComponents *Pluscomponent = [[NSDateComponents alloc] init];
    [Pluscomponent setDay:DaysFromToday];
    
    
    
    // create a calendar
    NSDate *dtTodayPlusDate = [gregorian dateByAddingComponents:Pluscomponent toDate:currentDate options:0];
    
    NSDateFormatter *FullDateFormat = [[NSDateFormatter alloc] init];
    [FullDateFormat setDateFormat:@"EEEE"];
    WeekDay= [FullDateFormat stringFromDate:dtTodayPlusDate];
    
    return WeekDay;
    
}
-(NSString *)GetMinForDate:(NSDate *)myDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm"];
    NSString *min = [formatter stringFromDate:myDate];
    return min;
    
}


-(NSString *)GetHourForDate:(NSDate *)myDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh"];
    NSString *hour = [formatter stringFromDate:myDate];
    return hour;
    
}
-(NSString *)GetAmPmForDate:(NSDate *)myDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"a"];
    NSString *hour = [formatter stringFromDate:myDate];
    return hour;
    
}

-(NSDate *)SetUpHourForDate:(NSDate *)myDate WithHour:(int)myhour withMin:(int)myMin
{
    
    
    
    // format
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"dd-MM-yyyy HH:mm a"];
    
    NSString *stringFromDate = [df stringFromDate:myDate];
    //Create the date assuming the given string is in GMT
//df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
//df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];

    NSDate *date = [df dateFromString:stringFromDate];

    //
    
    
    NSDate *oldDate =date;
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:oldDate];
    comps.hour   = myhour;
    comps.minute = myMin;
    comps.second = 1;
    
 
    
    //Create a date string in the local timezone
    
 
    NSDate *newDate = [calendar dateFromComponents:comps];
    NSLog(@"newDate %@",newDate);
    return newDate;
}
/*
-(void)DeleteNotification:(NSString *)notificationID
{
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[someNotification.userInfo objectForKey:@"notificationID"] isEqualToString:notificationID ]) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:someNotification];

        }
    }


}
*/
-(NSDate *)GetNotificationDateFromID:(NSString *)notificationID{
    
    NSDate *CurrentDate;
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[someNotification.userInfo objectForKey:@"notificationID"] isEqualToString:notificationID]) {
            
        CurrentDate =someNotification.fireDate;
            
        }
    }
    return CurrentDate;

}
//========================================================================
#pragma mark - Notification Setting For Both Modes
//============================================================================


- (void)SetNotificationForDate:(NSDate *)FireUpDate WeekDay:(NSString *)myWeekDay  withSoundName:(NSString *)mysound isWakeUp:(BOOL)IsWakeUpNotify isSleep:(BOOL)IsSleepNotify InterVal:(int)minutesBefore{
    //loop through all scheduled notifications and cancel the one we're looking for
    
    
    
    
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WakeUpTimeInstiationFlag"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm a"];
    NSString *stringFromDate = [formatter stringFromDate:FireUpDate];
    NSString *stringFromDateDefulte = [formatter stringFromDate:[NSDate date]];
    
    NSString *wakeupTimeForWeekDate=[NSString stringWithFormat:@"WakupNotificationID%@",myWeekDay];
    
    NSString *sleepTimeForWeekDate=[NSString stringWithFormat:@"SleepNotificationID%@",myWeekDay];
    
    
    if(FireUpDate)
        [[NSUserDefaults standardUserDefaults] setObject:stringFromDate forKey:wakeupTimeForWeekDate];
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:stringFromDateDefulte forKey:sleepTimeForWeekDate];
        [[NSUserDefaults standardUserDefaults] setObject:stringFromDateDefulte forKey:wakeupTimeForWeekDate];
        
    }
    
    if([self GetNotificationDateFromID:wakeupTimeForWeekDate])
    {//[self DeleteNotification:wakeupTimeForWeekDate];
        
        [self DeleteNotification:wakeupTimeForWeekDate];
        [self scheduleNotificationForDate:FireUpDate AlertBody:@"WakeUp Time" ActionButtonTitle:@"Ok" NotificationID:wakeupTimeForWeekDate CustomeSoundName:mysound  repeat:3 InterVal:minutesBefore ];
    }
    else
    {
        

        [self scheduleNotificationForDate:FireUpDate AlertBody:@"WakeUp Time" ActionButtonTitle:@"Ok" NotificationID:wakeupTimeForWeekDate CustomeSoundName:mysound  repeat:3 InterVal:minutesBefore ];
        
        
    }
    
    
    
    
    
    
}
-(void) scheduleNotificationForDate:(NSDate *)date AlertBody:(NSString *)alertBody ActionButtonTitle:(NSString *)actionButtonTitle NotificationID:(NSString *)notificationID CustomeSoundName:(NSString *)CustomeSound repeat:(int)hasRepeat InterVal:(int)minutesBefore{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSLog(@"this is from inside the  schedual sami  %@",date);
    
    localNotification.fireDate = [date dateByAddingTimeInterval:-minutesBefore*60];
    
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = alertBody;
    localNotification.alertAction = actionButtonTitle;
    localNotification.soundName = CustomeSound;
    if(hasRepeat==1)
        localNotification.repeatInterval=NSCalendarUnitHour;
    else if (hasRepeat==2)
        localNotification.repeatInterval=NSCalendarUnitDay;
    else if(hasRepeat==3)
        localNotification.repeatInterval=NSCalendarUnitWeekday;
    else
        localNotification.repeatInterval=0;
    
    
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:notificationID forKey:@"notificationID"];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
-(void) scheduleNotificationForDate:(NSDate *)date AlertBody:(NSString *)alertBody ActionButtonTitle:(NSString *)actionButtonTitle NotificationID:(NSString *)notificationID CustomeSoundName:(NSString *)CustomeSound repeat:(int)hasRepeat{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    NSLog(@"this is from inside the  schedual sami Notification ID  %@",notificationID);
    NSLog(@"this is from inside the  schedual sami Date  %@",date);
    
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    NSLog(@" localNotification timezone%@",localNotification.timeZone);
    localNotification.alertBody = alertBody;
    localNotification.alertAction = actionButtonTitle;
    localNotification.soundName = CustomeSound;
    NSLog(@"CustomeSound %@",localNotification.soundName);
    if(hasRepeat==1)
        localNotification.repeatInterval=NSCalendarUnitHour;
    else if (hasRepeat==2)
        localNotification.repeatInterval=NSCalendarUnitDay;
    else if (hasRepeat==3)
        localNotification.repeatInterval=NSCalendarUnitWeekday;
    else
        localNotification.repeatInterval=0;
    
    
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:notificationID forKey:@"notificationID"];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)SetNotificationForDate:(NSDate *)FireUpDate WeekDay:(NSString *)myWeekDay withSoundName:(NSString *)mysound isWakeUp:(BOOL)IsWakeUpNotify isSleep:(BOOL)IsSleepNotify{
    //loop through all scheduled notifications and cancel the one we're looking for
   
    NSLog(@"myWeekDay %@",myWeekDay);

    NSLog(@"fireup exact %@",FireUpDate);

    
             if(IsWakeUpNotify)
               {
                    NSString *wakeupTimeForWeekDate=[NSString stringWithFormat:@"WakupNotificationID%@",myWeekDay];
                   
                   // set it for public
                   
                   
                   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:wakeupTimeForWeekDate];
                   
                   [[NSUserDefaults standardUserDefaults] setObject:FireUpDate forKey:wakeupTimeForWeekDate];
                   
                   [[NSUserDefaults standardUserDefaults] synchronize];
                   


                   [[NSUserDefaults standardUserDefaults] setObject:FireUpDate forKey:wakeupTimeForWeekDate];
                //[self DeleteNotification:wakeupTimeForWeekDate];

                   if([self GetNotificationDateFromID:wakeupTimeForWeekDate])
                   {
                       
                       //[self DeleteNotification:wakeupTimeForWeekDate];
                         if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"]) {
                       [self scheduleNotificationForDate:FireUpDate AlertBody:@"WakeUp Time" ActionButtonTitle:@"Ok" NotificationID:wakeupTimeForWeekDate CustomeSoundName:mysound repeat:3];
                         }
                       else
                       {
                           //SleepRecording.m4a
                           //WakeUpRecording.m4a

                        [self scheduleNotificationForDate:FireUpDate AlertBody:@"WakeUp Time" ActionButtonTitle:@"Ok" NotificationID:wakeupTimeForWeekDate CustomeSoundName:@"../Documents/WakeUpRecording.m4a" repeat:3];
                       
                       }
                   }
                   else
                   {
                        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"]) {
                            
                            
                       [self scheduleNotificationForDate:FireUpDate AlertBody:@"WakeUp Time" ActionButtonTitle:@"Ok" NotificationID:wakeupTimeForWeekDate CustomeSoundName:mysound repeat:3];
                        }
                       else
                       {
                       [self scheduleNotificationForDate:FireUpDate AlertBody:@"WakeUp Time" ActionButtonTitle:@"Ok" NotificationID:wakeupTimeForWeekDate CustomeSoundName:@"../Documents/WakeUpRecording.m4a" repeat:3];
                       }
                       
                   }
                    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WakeUpTimeInstiationFlag"];
                
                }
                if(IsSleepNotify)
                {
                    NSString *sleepDateForWeekDate=[NSString stringWithFormat:@"SleepNotificationID%@",myWeekDay];
                    NSLog(@"SleepNotificationID for the day  %@",sleepDateForWeekDate);

                   // [self DeleteNotification:sleepDateForWeekDate];

                    //Cancel All The Notification WIth The Same ID
                    if([self GetNotificationDateFromID:sleepDateForWeekDate])
                    {
                       [self DeleteNotification:sleepDateForWeekDate];
               if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"]) {
                        [self scheduleNotificationForDate:FireUpDate AlertBody:@"sleep Time" ActionButtonTitle:@"Ok" NotificationID:sleepDateForWeekDate CustomeSoundName:mysound repeat:3];
                      }
               else{
                [self scheduleNotificationForDate:FireUpDate AlertBody:@"sleep Time" ActionButtonTitle:@"Ok" NotificationID:sleepDateForWeekDate CustomeSoundName:@"../Documents/SleepRecording.m4a" repeat:3];
               
               }
                    }
                    else
                    {
                        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"]) {

                        [self scheduleNotificationForDate:FireUpDate AlertBody:@"sleep Time" ActionButtonTitle:@"Ok" NotificationID:sleepDateForWeekDate CustomeSoundName:mysound repeat:3];
                        }
                        else
                        {
                        
                         [self scheduleNotificationForDate:FireUpDate AlertBody:@"sleep Time" ActionButtonTitle:@"Ok" NotificationID:sleepDateForWeekDate CustomeSoundName:@"../Documents/SleepRecording.m4a" repeat:3];
                        }
                    
                    }
                }

  
}


-(void)FireUpWakeUpAlarm:(NSDate *)firupdate WeekDay:(NSString *)myweekDay
{
  //  NSString *wakeupHour = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpHour"];
    //NSString *wakeupMin = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpMin"];
   // [self Smooth:firupdate WeekDy:myweekDay];

    
     NSLog(@"firupdate  %@",firupdate);
    
    NSDate *wakeupDateWithExactTime=[self SetUpHourForDate:firupdate WithHour:[WakeUpHour intValue] withMin:[WakeUpMin intValue]];
    NSLog(@"%@",wakeupDateWithExactTime);

    [self FireUpWakeUpMode:firupdate WeekDay:myweekDay];

    /*
    NSLog(@"wakeupDateWithExactTime  %@",wakeupDateWithExactTime);
    NSString *WakeUpToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpSelectedToneFileNameData"];
    
    if (!WakeUpToneFileName) {
        // This is the 1st run of the app
        [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-WakeUpAlarm-Creation" forKey:@"WakeUpSelectedToneFileNameData"];
        
    }
    
    

    WakeUpToneFileName=[NSString stringWithFormat:@"%@.wav",WakeUpToneFileName];
    if(wakeupDateWithExactTime)
    {
        //
        
        // We need the weekday here to add it to the the notification ID : for instance : Monday Wake Up notification ID will be WakupNotificationIDMonday
            [self SetNotificationForDate:wakeupDateWithExactTime WeekDay:myweekDay  withSoundName:WakeUpToneFileName isWakeUp:YES isSleep:NO];

     
    }
*/
    //

}
-(void)FireUpSleepAlarm:(NSDate *)fireupdate weekday:(NSString *)myWeekDay
{
    
   // NSString *sleepHour = [[NSUserDefaults standardUserDefaults] objectForKey:@"sleepHour"];
  //  NSString *sleepMin = [[NSUserDefaults standardUserDefaults] objectForKey:@"sleepMinute"];
    NSLog(@"sleepHour  %@",SleepHour);
    NSLog(@"sleepMin  %@",SleepMin);

    NSLog(@"firupdate  %@",fireupdate);
    
    NSDate *sleepDateWithExactTime=[self SetUpHourForDate:fireupdate WithHour:[SleepHour intValue] withMin:[SleepMin intValue]];
    NSLog(@"wakeupDateWithExactTime  %@",sleepDateWithExactTime);
    
    
    
    
    NSString *sleepToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SleepSelectedToneActualFileNameData"];
    if (!sleepToneFileName) {
        // This is the 1st run of the app
        [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-Bedtime-Fairy Night" forKey:@"SleepSelectedToneActualFileNameData"];
        
        
        
    }
    
    
    
    sleepToneFileName=[NSString stringWithFormat:@"%@.mp3",sleepToneFileName];
    if(sleepDateWithExactTime)
    {
       
        NSLog(@"notification Sound %@",sleepToneFileName);
        [self SetNotificationForDate:fireupdate WeekDay:myWeekDay  withSoundName:sleepToneFileName isWakeUp:NO isSleep:YES];


    
    }
    
    
}


-(void)SetDates:(BOOL)HasNotification IsSleepSet:(BOOL)IsSleep IsWakeupSet:(BOOL)IsWakeup
{
    NSDate *TodayDate=[NSDate date];
    
    NSDateFormatter *FullDateFormat = [[NSDateFormatter alloc] init];
    [FullDateFormat setDateFormat:@"EEEE"];
    NSString *TodayDayName= [FullDateFormat stringFromDate:TodayDate];
    NSLog(@"Week Day From Formater %@",TodayDayName);
    
    
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    NSString *WeekDayName;
    if([WeekDays isEqualToString:@"0"])
    {
        //
        self.Navitem.title=@"Monday";
        
        WeekDayName=[NSString stringWithFormat:@"Monday"];
    }
    else if([WeekDays isEqualToString:@"1"])
    {
        //
        self.Navitem.title=@"Tuesday";
        
        WeekDayName=[NSString stringWithFormat:@"Tuesday"];
        
    }
    else if([WeekDays isEqualToString:@"2"])
    {
        //
        self.Navitem.title=@"Wednesday";
        
        WeekDayName=[NSString stringWithFormat:@"Wednesday"];
        
    }
    else if([WeekDays isEqualToString:@"3"])
    {
        //
        self.Navitem.title=@"Thursday";
        
        WeekDayName=[NSString stringWithFormat:@"Thursday"];
        
    }
    
    else if([WeekDays isEqualToString:@"4"])
    {
        //
        self.Navitem.title=@"Friday";
        
        WeekDayName=[NSString stringWithFormat:@"Friday"];
        
    }
    else if([WeekDays isEqualToString:@"5"])
    {
        //
        self.Navitem.title=@"Saturday";
        
        WeekDayName=[NSString stringWithFormat:@"Saturday"];
        
    }
    else if([WeekDays isEqualToString:@"6"])
    {
        //
        self.Navitem.title=@"Sunday";
        
        WeekDayName=[NSString stringWithFormat:@"Sunday"];
        
    }
    else
    {
        //
        self.Navitem.title=@"Sunday";
        
        WeekDayName=[NSString stringWithFormat:@"Sunday"];
        
        
    }
    
    // Compare the current day
    if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:0]]) {
        // self.view.backgroundColor=[UIColor greenColor];
        lblAlarmDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:0]];
        if(HasNotification)
        {
            
            if(IsSleep)
            {
                // Today Water Notification
                [self FireUpSleepAlarm:[self GetSelectedDate:0] weekday:WeekDay];
                //SetUp THe Cuurent page Date
             //   [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"CurrentViewDate"];
                
            }
            if(IsWakeup)
            {
                
                
                [self FireUpWakeUpAlarm:[self GetSelectedDate:0] WeekDay:WeekDay];
                
            }
            
        }
        
        
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:1]]) {
        
        // self.view.backgroundColor=[UIColor whiteColor];
        
        lblAlarmDate.text=[NSString stringWithFormat: @"%@",[self GetCurrentDate:1]];
        if(HasNotification==YES)
        {
            if(IsSleep)
            {
                [self FireUpSleepAlarm:[self GetSelectedDate:1] weekday:WeekDay];
                NSLog(@" date from get current%@",[self GetCurrentDate:1]);
                //SetUp THe Cuurent page Date
               // [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:1] forKey:@"CurrentViewDate"];
                
            }
            if(IsWakeup)
            {
                [self FireUpWakeUpAlarm:[self GetSelectedDate:1] WeekDay:WeekDay];
                
                
            }
            
            
            
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:2]]) {
        //self.view.backgroundColor=[UIColor purpleColor];
        lblAlarmDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:2]];
        if(HasNotification==YES)
        {
            if(IsSleep)
            {
                [self FireUpSleepAlarm:[self GetSelectedDate:2] weekday:WeekDay];
                //SetUp THe Cuurent page Date
               // [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:2] forKey:@"CurrentViewDate"];
            }
            if(IsWakeup)
            {
                [self FireUpWakeUpAlarm:[self GetSelectedDate:2] WeekDay:WeekDay];
                
            }
            
            
            
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:3]]) {
        //self.view.backgroundColor=[UIColor blueColor];
        lblAlarmDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:3]];
        if(HasNotification==YES)
        {
            if(IsSleep)
            {
                [self FireUpSleepAlarm:[self GetSelectedDate:3] weekday:WeekDay];
                
                //SetUp THe Cuurent page Date
                //[[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:3] forKey:@"CurrentViewDate"];
                
                
            }
            if(IsWakeup)
            {
                
                [self FireUpWakeUpAlarm:[self GetSelectedDate:3] WeekDay:WeekDay];
                
                
                
                
            }
            
            
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:4]]) {
        // self.view.backgroundColor=[UIColor yellowColor];
        lblAlarmDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:4]];
        if(HasNotification==YES)
        {
            if(IsSleep)
            {
                // Day 4 Water Notification
                [self FireUpSleepAlarm:[self GetSelectedDate:4] weekday:WeekDay];
                
                
                //SetUp THe Cuurent page Date
                //[[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:4] forKey:@"CurrentViewDate"];
            }
            if(IsWakeup)
            {
                [self FireUpWakeUpAlarm:[self GetSelectedDate:4] WeekDay:WeekDay];
                
                
            }
            
            
            
            
            
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:5]]) {
        // self.view.backgroundColor=[UIColor grayColor];
        lblAlarmDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:5]];
        
        if(HasNotification==YES)
        {
            if(IsSleep)
            {
                // Day 5 Water Notification
                [self FireUpSleepAlarm:[self GetSelectedDate:5] weekday:WeekDay];
                
                //SetUp THe Cuurent page Date
                //[[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:5] forKey:@"CurrentViewDate"];
            }
            if(IsWakeup)
            {
                [self FireUpWakeUpAlarm:[self GetSelectedDate:5] WeekDay:WeekDay];
                
                
            }
            
            
            
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:6]]) {
        // self.view.backgroundColor=[UIColor purpleColor];
        
        lblAlarmDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:6]];
        
        if(HasNotification==YES)
        {if(IsSleep)
        {
            // Day 6 Water Notification
            [self FireUpSleepAlarm:[self GetSelectedDate:6]weekday:WeekDay];
            
            
            //SetUp THe Cuurent page Date
           // [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:6] forKey:@"CurrentViewDate"];
            
        }
            if(IsWakeup)
            {
                [self FireUpWakeUpAlarm:[self GetSelectedDate:6] WeekDay:WeekDay];
                
                
            }
            
        }
    }
    
    
}
//========================================================================
#pragma mark -    WakeUp Mode  ( Snooze - Somth System)
//============================================================================


-(void)FireUpWakeUpMode:(NSDate *)mydate WeekDay:(NSString *)myweekDay

{
    
    // reconizing which mode we are in and call the fuctions needed to excute the condition
    // Snooze Switch
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
    {
        // Snooze is Active
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"isSnoozeActive"])
        {
            NSString *WakeUpToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpSelectedToneActualFileNameData"];
            
            if (!WakeUpToneFileName) {
                // This is the 1st run of the app
                [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-WakeUpAlarm-Creation" forKey:@"WakeUpSelectedToneActualFileNameData"];
                
            }
             WakeUpToneFileName=[NSString stringWithFormat:@"%@.mp3",WakeUpToneFileName];
            if( [[NSUserDefaults standardUserDefaults] boolForKey:@"isSnoozeFifteen"])
                
            {// Snooze for 3 times in 15 minutes
                
                [self SnoozeThreeInFifteen:WakeUpToneFileName inDate:mydate WeekDy:myweekDay];
                
            }
            else
                
            {// Snooze for 3 times in 15 minutes
                
                [self SnoozeThreeInThirty:WakeUpToneFileName inDate:mydate WeekDy:myweekDay];
                
            }
            
        }
        
        
        
        // empsis thier status
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSmoothActive"];
        
        
    }
    //Smooth switch
    else
    {
        [self Smooth:mydate WeekDy:myweekDay];
        //Set Up THe Outlet and triggers
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isSmoothActive"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSnoozeActive"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isSnoozeFifteen"];
        
        
        
        
    }
    
}
//====================================================================================//==
//=========================================================

-(void)DeleteNotification:(NSString *)notificationID
{
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[someNotification.userInfo objectForKey:@"notificationID"] isEqualToString:notificationID ]) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:someNotification];
            
        }
    }
    
    
}
-(void)SnoozeThreeInFifteen:(NSString *)SnoozeSound inDate:(NSDate *)myDate WeekDy:(NSString *)myweekDay
{
    
    //SetUp Date interval 3 in Fifiteen minute
    //time1
    //time2
    //time3
    // interval in 5 minutes
    NSString *CurrentDayWakeUpNotification=[NSString stringWithFormat:@"WakupNotificationID%@",myweekDay];
    [self DeleteNotification:CurrentDayWakeUpNotification];
    [self SetNotificationForDate:myDate WeekDay:myweekDay  withSoundName:SnoozeSound isWakeUp:YES isSleep:NO InterVal:5];
    
    [self SetNotificationForDate:myDate WeekDay:myweekDay  withSoundName:SnoozeSound isWakeUp:YES isSleep:NO InterVal:10];
    
    [self SetNotificationForDate:myDate WeekDay:myweekDay  withSoundName:SnoozeSound isWakeUp:YES isSleep:NO InterVal:15];
    
    
    
}
-(void)SnoozeThreeInThirty:(NSString *)SnoozeSound inDate:(NSDate *)myDate WeekDy:(NSString *)myweekDay
{
    //SetUp Date interval 3 in Fifiteen minute
    //time1
    //time2
    //time3
    // interval in 10 minutes
    NSString *CurrentDayWakeUpNotification=[NSString stringWithFormat:@"WakupNotificationID%@",myweekDay];
    [self DeleteNotification:CurrentDayWakeUpNotification];
    
    [self SetNotificationForDate:myDate WeekDay:myweekDay  withSoundName:SnoozeSound isWakeUp:YES isSleep:NO InterVal:10];
    
    [self SetNotificationForDate:myDate WeekDay:myweekDay   withSoundName:SnoozeSound isWakeUp:YES isSleep:NO InterVal:20];
    
    [self SetNotificationForDate:myDate WeekDay:myweekDay   withSoundName:SnoozeSound isWakeUp:YES isSleep:NO InterVal:30];
    
    
    
}
-(void)Smooth:(NSDate *)myDate WeekDy:(NSString *)myweekDay
{
    //SetUp Date interval 3 in Fifiteen minute
    //time1
    //time2
    //time3
    // interval in 10 minutes
    /*

     
     You can not play a sound more than 30 seconds when your notification arrives while your app is in the background (e.g. user closes the app before going to sleep).
     
     To play a longer sound, you must tell your user to leave the alarm app in the foreground before going to sleep, then in didReceiveLocalNotification you implement playing a longer sound manually.
     */
     UIAlertView  *Alert = [[UIAlertView alloc] initWithTitle:@"Apple Guidance" message:@"To Play Smooth Sound please keep the App Opened" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [Alert show];
    

    NSString *CurrentDayWakeUpNotification=[NSString stringWithFormat:@"WakupNotificationID%@",myweekDay];
    [self DeleteNotification:CurrentDayWakeUpNotification];
    
    [self SetNotificationForDate:myDate WeekDay:myweekDay  withSoundName:@"APDD-TimesApp-SmoothSound-01-MORNING COSMIC VICTORY SHORT.mp3" isWakeUp:YES isSleep:NO];
    
    //[self SetNotificationForDate:myDate WeekDay:myweekDay   withSoundName:@"APDD-TimesApp-SmoothSound-01-MORNING COSMIC VICTORY SHORT.mp3" isWakeUp:YES isSleep:NO ];
    
  //  [self SetNotificationForDate:myDate WeekDay:myweekDay   withSoundName:@"APDD-TimesApp-SmoothSound-01-MORNING COSMIC VICTORY SHORT.mp3" isWakeUp:YES isSleep:NO ];
    
    
    
}

-(IBAction)SingleTapTable:(UITapGestureRecognizer *) recgnizer
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"FirstGroup" forKey:@"WhatPage"];
    //[[NSUserDefaults standardUserDefaults] setObject:@"SLeep" forKey:@"ReminderFor"];
    
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"RemindersTableViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

@end
