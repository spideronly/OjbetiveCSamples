//
//  SGRemindersViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 1/20/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "SGRemindersViewController.h"
#import "RecordViewController.h"
#import "ToneTableViewController.h"


@interface SGRemindersViewController ()<UITextFieldDelegate>
{
//  Setup a flag to check out the touch
    BOOL isReminderTimeOnTouch;
    NSString *WhatPage;
    NSString *ReminderFor;

}
@end

@implementation SGRemindersViewController
@synthesize timeToSetOff,txtReminderName,txtReminderNotes;

//========================================================================
#pragma mark - Main Harbor
//============================================================================

- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadData];
    
    txtReminderName.delegate=self;
    txtReminderNotes.delegate=self;
   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self LoadText];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField==txtReminderName)
    [txtReminderName resignFirstResponder];
    if(textField==txtReminderNotes)
      [txtReminderNotes resignFirstResponder];

       return YES;
    
}
//========================================================================
#pragma mark - Loaing our data
//============================================================================
-(void)LoadData
{
    
    
    WhatPage = [[NSUserDefaults standardUserDefaults] objectForKey:@"WhatPage"];
     ReminderFor = [[NSUserDefaults standardUserDefaults] objectForKey:@"ReminderFor"];

    [self LoadShapAndColors];

    [self LoadText];

    [self LoadHoursValues];

     NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"HH:mm a"];
    
    NSString *stringFromDate = [df stringFromDate:timeToSetOff.date];
    _lblReminderTime.text=[NSString stringWithFormat:@"%@",stringFromDate];
    
    
    [timeToSetOff addTarget:self action:@selector(updateDateLabels:) forControlEvents:UIControlEventValueChanged];

}

- (IBAction)updateDateLabels:(id)sender {
    
    NSDate *today1 = timeToSetOff.date;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm a"];
    NSString *dateString11 = [dateFormat stringFromDate:today1];
        _lblReminderTime.text=dateString11;
  }



-(void)LoadShapAndColors
{
    
    if([WhatPage isEqualToString:@"SecondGroup"])
    {
        
    //----------------------------------
    NSData *secondcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderColorData"];
    UIColor *secondolor = [NSKeyedUnarchiver unarchiveObjectWithData:secondcolorData];
    
    //Setup The button Round and Border width
    _lblTotalHours.layer.borderWidth =4;
    _lblTotalHours.layer.cornerRadius=_lblTotalHours.layer.bounds.size.width/2;
    
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"secondSliderColorDataChangeFlag"]) {
        secondolor=[UIColor orangeColor];
    }
    
    _lblTotalHours.textColor=secondolor;
    _lblTotalHours.layer.borderColor =secondolor.CGColor;
    //
    }
    if([WhatPage isEqualToString:@"ThirdGroup"])
    {
    
        NSData *thirdcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdSliderColorData"];
        UIColor *thirdcolor = [NSKeyedUnarchiver unarchiveObjectWithData:thirdcolorData];
        _lblTotalHours.layer.borderWidth =4;
        _lblTotalHours.layer.cornerRadius=_lblTotalHours.layer.bounds.size.width/2;

        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"thirdSliderColorDataChangeFlag"]) {
            thirdcolor=[UIColor greenColor];
        }
        _lblTotalHours.textColor=thirdcolor;
        _lblTotalHours.layer.borderColor =thirdcolor.CGColor;


    
    }
    
    
}

-(void)LoadText
{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"SecondGroup" forKey:@"WhatPage"];

    
    if([WhatPage isEqualToString:@"SecondGroup"])
    {
        
    
    NSData *secondTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderTextData"];
    NSString *secondText = [NSKeyedUnarchiver unarchiveObjectWithData:secondTextData];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"secondSliderTextDataChangeFlag"]) {
        
        secondText=@"Work";
        
    }
    self.lblTitle.text=secondText;
    
    
    // Tone Name
   
    }
    if([WhatPage isEqualToString:@"ThirdGroup"])
    {
        
        
        NSData *thirdTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdSliderTextData"];
        NSString *thirdText = [NSKeyedUnarchiver unarchiveObjectWithData:thirdTextData];
        
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"thirdSliderTextDataChangeFlag"]) {
            thirdText=@"Live";
            
        }
        self.lblTitle.text=thirdText;
        
    }
    
    NSString *ToneName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ToneNameData"];
    
    self.lblToneName.text=ToneName;


}
-(NSString *)LoadHoursValues:(NSString *)indexpath
{
    
    //
    NSData *firstValueData ;
    
    NSData *secondValueData ;
    
    NSData *thirdValueData ;
    
    NSString *firstValue;
    NSString *secondValue;
    NSString *thirdValue;
    NSString *CurrrentValue;
    
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
        
        
        
        
    }
    
    if([WhatPage isEqualToString:@"SecondGroup"])
    {
        CurrrentValue=secondValue;
    }
    if([WhatPage isEqualToString:@"ThirdGroup"])
    {
        CurrrentValue=thirdValue;
    }
    
    
    return CurrrentValue;
    
}
-(void)LoadHoursValues
{
    
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];

    if([WhatPage isEqualToString:@"SecondGroup"])
    {
    
        self.btnRecord.hidden=NO;
        
        _lblTotalHours.text= [self LoadHoursValues:WeekDays];

    }
    if([WhatPage isEqualToString:@"ThirdGroup"])
    {
        [self LoadHoursValues:WeekDays ];

        self.btnRecord.hidden=YES;
        _lblTotalHours.text=[self LoadHoursValues:WeekDays];
        
    
    }
    
    
}

//========================================================================
#pragma mark - Gesture Actions
//============================================================================
-(IBAction)SingleTap:(UITapGestureRecognizer *) recgnizer
{
 /*
    [[NSUserDefaults standardUserDefaults] setObject:@"DayReminder" forKey:@"ComingFromData"];
NSString *ToneName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ToneNameData"];
    if([ToneName isEqualToString:@"Record!"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"JustShowPlay"];

        RecordViewController *VoiceRecordView=[[RecordViewController alloc]init ];
        VoiceRecordView.view.frame=self.view.bounds;
        [self.view addSubview:VoiceRecordView.view];
        [self addChildViewController:VoiceRecordView];

    
    }
    else{
        */
     // Navigate to UIViewController programaticly inside storyboard
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"FromDayReminder" forKey:@"ComingFromData"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"ToneTableViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
-(IBAction)LongPressReminderTime:(UILongPressGestureRecognizer *) recgnizer
{
    
    self.view.backgroundColor=[UIColor yellowColor];
    isReminderTimeOnTouch=YES;
    
}





//========================================================================
#pragma mark - set upnotification
//============================================================================

-(void) scheduleNotificationForDate:(NSDate *)date AlertBody:(NSString *)alertBody ActionButtonTitle:(NSString *)actionButtonTitle NotificationID:(NSString *)notificationID CustomeSoundName:(NSString *)CustomeSound repeat:(int)hasRepeat{
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = alertBody;
    localNotification.alertAction = actionButtonTitle;
    localNotification.soundName = CustomeSound;
    if(hasRepeat==1)
        localNotification.repeatInterval=NSCalendarUnitHour;
    else if (hasRepeat==2)
        localNotification.repeatInterval=NSCalendarUnitDay;
    else
        localNotification.repeatInterval=0;
    
    
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:notificationID forKey:@"notificationID"];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
-(void)FilterAndCreateNotificationWithCertainSou
{
    NSString* notificationBody=@"Just Body Test";
    
    NSString *toneName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedToneData"];
    //1=======
    if ([toneName isEqualToString:@"Ring"]) {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-General-01.wav" repeat:2];
    }
    //2=======
    else if ([toneName isEqualToString:@"iDea"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-General-01.wav" repeat:2];
        
        
    }
    //3=======
    else if ([toneName isEqualToString:@"On The Hour"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-OnTheHour Reminder.wav" repeat:2];
        
        
    }
    //4=========
    else if ([toneName isEqualToString:@"Walking"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-Walking Reminder.wav" repeat:2];
        
        
    }
    //5=======
    else if ([toneName isEqualToString:@"Drinking"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-Drinking Reminder.wav" repeat:2];
        
        
    }
    //6=========
    else if ([toneName isEqualToString:@"Magic Night"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-Bedtime-Magic Night.wav" repeat:2];
        
        
    }
    //7=========
    else if ([toneName isEqualToString:@"Fairy Night"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-Bedtime-Fairy Night.wav" repeat:2];
        
        
    }
    //8
    else if ([toneName isEqualToString:@"MORNING COSMIC VICTORY"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-SmoothSound-01-MORNING COSMIC VICTORY.wav" repeat:2];
        
        
    }
    //9
    else if ([toneName isEqualToString:@"Search"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-WakeUpAlarm-Search.wav" repeat:2];
        
        
    }
    //10=========
    else if ([toneName isEqualToString:@"PlayFul"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-WakeUpAlarm-Playful.wav" repeat:2];
        
        
    }
    //11======
    else if ([toneName isEqualToString:@"Mystery"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-WakeUpAlarm-Mystery.wav" repeat:2];
        
        
    }
    //12========
    else if ([toneName isEqualToString:@"Lazy"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-WakeUpAlarm-Lazy.wav" repeat:2];
        
        
    }
    //13============
    else if ([toneName isEqualToString:@"Epic"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-WakeUpAlarm-Epic.wav" repeat:2];
        
        
    }
    //14
    else if ([toneName isEqualToString:@"Creation"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-WakeUpAlarm-Creation.wav" repeat:2];
        
        
    }
    //15
    else if ([toneName isEqualToString:@"Anew"])
    {
        [self scheduleNotificationForDate:timeToSetOff.date AlertBody:notificationBody ActionButtonTitle:@"Ok" NotificationID:@"WakupNotificationID" CustomeSoundName:@"APDD-TimesApp-WakeUpAlarm-Anew.wav" repeat:2];
        
        
    }


}

-(void)CallTheChildComponents
{
    
    RecordViewController *VoiceRecordView=[[RecordViewController alloc]init ];
    
    VoiceRecordView.view.frame=self.view.bounds;
    [self.view addSubview:VoiceRecordView.view];
    [self addChildViewController:VoiceRecordView];
    
}

//========================================================================
#pragma mark - Ui Action
//============================================================================
- (IBAction)AddReminder:(id)sender {
  
    if(txtReminderName.text.length==0 || txtReminderNotes.text.length==0)
    {
        UIAlertView *reminderAlert = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Enter Reminder Info" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [reminderAlert show];

    }else
    {
    NSString *ToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedToneActualData"];

      if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SelectedToneActualFlag"]) {
        ToneFileName=@"APDD-TimesApp-General-01.wav";
    }

    // No repeat
    
    NSString *title;
    NSString *NotifyBody;
        [[NSUserDefaults standardUserDefaults] setObject:timeToSetOff.date forKey:@"SelectedToneData"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SelectedToneFlag"];
  
    if(txtReminderName.text)
    
    {
        title=txtReminderName.text;
        [[NSUserDefaults standardUserDefaults] setObject:txtReminderName.text forKey:@"txtReminderName"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsTxtReminderName"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsTxtReminderName"];
        
        title=@"Day Reminder";

    }
    if(txtReminderName.text)
        
    {
        NotifyBody=txtReminderNotes.text;
    [[NSUserDefaults standardUserDefaults] setObject:txtReminderNotes.text forKey:@"txtReminderNotes"];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsTxtReminderNotes"];
    
    }
    else
    {NotifyBody=@"Plain Reminder";
        
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsTxtReminderNotes"];

    
    }
    
    if([WhatPage isEqualToString:@"SecondGroup"])
    {

        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"]) {
              [self scheduleNotificationForDate:timeToSetOff.date AlertBody:NotifyBody ActionButtonTitle:@"ok" NotificationID:@"DuringDayReminderID" CustomeSoundName:[NSString stringWithFormat:@"%@.wav",ToneFileName] repeat:0];
        }
        else
        {
        
         [self scheduleNotificationForDate:timeToSetOff.date AlertBody:NotifyBody ActionButtonTitle:@"ok" NotificationID:@"DuringDayReminderID" CustomeSoundName:@"DayReminderRecording.m4a" repeat:0];
        }
  
    }
    if([WhatPage isEqualToString:@"ThirdGroup"])
    {   if([ReminderFor isEqualToString:@"FirstTwoHoursTime"])
         {
             if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"]) {

             [self scheduleNotificationForDate:timeToSetOff.date AlertBody:NotifyBody ActionButtonTitle:@"ok" NotificationID:@"FirstTwoHoursNotificationID" CustomeSoundName:[NSString stringWithFormat:@"%@.wav",ToneFileName] repeat:0];
             }
             else
             {
             
                 [self scheduleNotificationForDate:timeToSetOff.date AlertBody:NotifyBody ActionButtonTitle:@"ok" NotificationID:@"FirstTwoHoursNotificationID" CustomeSoundName:@"SleepWorkGabRecording.m4a" repeat:0];

             
             }
    
          }
        if([ReminderFor isEqualToString:@"RestOfHoursTime"])
        {
            if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"]) {

            [self scheduleNotificationForDate:timeToSetOff.date AlertBody:NotifyBody ActionButtonTitle:@"ok" NotificationID:@"RestOfHoursNotificationID" CustomeSoundName:[NSString stringWithFormat:@"%@.wav",ToneFileName] repeat:0];
            }
            else
            {
            
                    [self scheduleNotificationForDate:timeToSetOff.date AlertBody:NotifyBody ActionButtonTitle:@"ok" NotificationID:@"RestOfHoursNotificationID" CustomeSoundName:@"RestOfHoursRecording.m4a" repeat:0];
            }
            
        }

        
        
    }
        [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    }
    
    }

- (IBAction)btnRecord:(id)sender {
    
    // Callling the recording system
    [[NSUserDefaults standardUserDefaults] setObject:@"Second" forKey:@"WhatPage"];

    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"JustShowPlay"];
    [self CallTheChildComponents];
    

}

- (IBAction)Back:(id)sender {
    
    
    if([WhatPage isEqualToString:@"SecondGroup"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"SecondCircleSettingViewController"];
        
        [self presentViewController:vc animated:NO completion:nil];

        
    }
   else if([WhatPage isEqualToString:@"ThirdGroup"])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"ThirdCircleSettingViewController"];
        
        [self presentViewController:vc animated:NO completion:nil];
        
        
    }

    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"SecondCircleSettingViewController"];
        
        [self presentViewController:vc animated:NO completion:nil];
        

    }
    }
@end
