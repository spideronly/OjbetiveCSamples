//
//  AppDelegate.m
//  TIMES
//
//  Created by Sami Shamsan on 1/1/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "AppDelegate.h"
#import "WishListEditViewController.h"
#import "WLItem.h"
#import "WLItemStore.h"
#import "AppSettingViewController.h"
#import "HomeViewController.h"
#import "TourLanchViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface AppDelegate ()
{
    UIAlertView * reminderAlert;
    BOOL isWishLuanched;
    int DrinkTimeCounter;

}

@property (assign) BOOL isWishLuanchedDefult;

@end

@implementation AppDelegate

@synthesize isWishLuanchedDefult = _isWishLuanchedDefult;  // creates an ivar myBool_ to back the property myBool.

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // it always Start from the time you wake up
  
   // [self DeleteNotification:@"WakupNotificationIDMonday"];
  // [self DeleteNotification:@"SleepNotificationIDTuesday"];
 //  [self DeleteNotification:@"SleepNotificationIDWednesday"];
 //   [self DeleteNotification:@"SleepNotificationIDThursday"];
   // [self DeleteNotification:@"SleepNotificationIDFriday"];
    //[self DeleteNotification:@"SleepNotificationIDMonday"];

 // [self DeleteNotification:@"SleepNotificationIDSunday"];

    [self LoadDefultValues];
    //==============================================================================================
     // Launch the

    application.applicationIconBadgeNumber = 0;

    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        
        //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Delete those two lines

        //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"HasLaunchedOnce"];
        //[[NSUserDefaults standardUserDefaults] synchronize];

        // app already launched
    }
    else
    {
        // Navigate to UIViewController programaticly inside storyboard
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"TourLanchViewController"];
        [self.window makeKeyAndVisible];

        [self.window.rootViewController presentViewController:vc animated:YES completion:NULL];

       //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Change This To No
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
    }
    
    //==============================================================================================

    //Prevents screen from locking
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (localNotif)
    {
    }
    

     // Notification Setup
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    
    
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
 
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    BOOL success = [[WLItemStore defaultStore] saveChanges];
    if (success) {
        NSLog(@"Items saved successfully");
    }
    else {
        NSLog(@"Error saving the items.ß");
    }

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    
    UIApplication *app=[UIApplication sharedApplication];
    NSArray *oldNotification=[app scheduledLocalNotifications];
    if([oldNotification count] >0 )
    {
        for (int i=0; i<[oldNotification count]; i++)
        {
            UILocalNotification* oneEvent = [oldNotification objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"uid"]];
            if ([uid isEqualToString:@"WaterNotificationID"] || [uid isEqualToString:@"WalkNotificationID"])
            {
              // Go to the beach, or you know what , go inn in out
                // Drink some  water and dont cancel my water and walk notification
            }
            else
            { //Cancelling local notification
                [app cancelLocalNotification:oneEvent];
            break;
            
            }
        }
        //[app cancelAllLocalNotifications];
    }
    
}
-(void)PlayWithUrl:(NSString *)recordName
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:recordName];
    
    NSURL *myUrl = [NSURL fileURLWithPath:filePath];
    UIAlertView  *Alert;
    NSError *error;
    NSLog(@"url is %@",myUrl);
    if (myUrl) {
         self.player= [[AVAudioPlayer alloc] initWithContentsOfURL:myUrl error:&error];
        [self.player play];
        if([recordName isEqualToString:@"SleepRecording.m4a"])
        {
        Alert = [[UIAlertView alloc] initWithTitle:@"Sleep Alarm" message:@" Sleep Time !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [Alert show];
        }
        else if([recordName isEqualToString:@"WakeUpRecording.m4a"])
        {
            Alert = [[UIAlertView alloc] initWithTitle:@"Wakeup Alarm" message:@" Wakeup Time !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [Alert show];
        
        }

    }

    else
    {
       Alert = [[UIAlertView alloc] initWithTitle:@"Record!" message:@"Please Add Record to this Section" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [Alert show];
        
        
    }
    
    
}
-(void)PlaySleepNotificationAlarm
{
         if([[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"])
     {
         
         [self PlayWithUrl:@"SleepRecording.m4a"];

     }
    else
    {
        
        // [[NSUserDefaults standardUserDefaults] setObject:AcualToneFileName forKey:@"SelectedToneActualData"];
        NSString *SLeepToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SleepSelectedToneActualFileNameData"];
        if (!SLeepToneFileName) {
            // This is the 1st run of the app
            [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-Bedtime-Fairy Night" forKey:@"SleepSelectedToneActualFileNameData"];
            SLeepToneFileName=[[NSUserDefaults standardUserDefaults] objectForKey:@"SleepSelectedToneActualFileNameData"];
        }

    NSLog(@"SleepSelectedToneActualFileNameData %@",SLeepToneFileName);
            [self showReminder:@" Sleep" textBody:@"Sleep Time" WithSound:SLeepToneFileName TypeOf:@"wav" HasRecord:YES];
            
    }
}

-(void)PlayWakeupNotificationAlarm
{
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isSmoothActive"])
    {

    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"isRecordActive"])
    {
        [self PlayWithUrl:@"WakeUpRecording.m4a"];
    }
    
    else
    {
            NSString *WakeUpToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpSelectedToneActualFileNameData"];
            NSLog(@"%@",WakeUpToneFileName);
            if (!WakeUpToneFileName) {
                // This is the 1st run of the app
                [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-WakeUpAlarm-Anew" forKey:@"WakeUpSelectedToneActualFileNameData"];
                WakeUpToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpSelectedToneActualFileNameData"];

            }
            [self showReminder:@" WakeUp" textBody:@"WakeUp Time" WithSound:WakeUpToneFileName TypeOf:@"wav" HasRecord:YES];
    
    }
    }else
    {
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        NSError *setCategoryError = nil;
        BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        if (!success) { /* handle the error condition */ }
        
        NSError *activationError = nil;
        success = [audioSession setActive:YES error:&activationError];
        if (!success) { /* handle the error condition */ }
     [self showReminder:@" WakeUp" textBody:@"WakeUp Time" WithSound:@"APDD-TimesApp-SmoothSound-01-MORNING COSMIC VICTORY" TypeOf:@"wav" HasRecord:YES];
    
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //Vibarte for every notification
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSString *notif=[notification.userInfo objectForKey:@"notificationID"];

    NSLog(@"did recived %@",[notification.userInfo objectForKey:@"notificationID"]);
    if([notif isKindOfClass:[NSString class]])
    {
    
    
    // WATER
    if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WaterNotificationID"])
    {    NSLog(@"did in ");

        
        if(DrinkTimeCounter<=5){
            DrinkTimeCounter=DrinkTimeCounter+1;
            NSUserDefaults *defaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.appadeedoo.Times"];
            NSString* ReminderlableText=[NSString stringWithFormat:@"Drink %i Cups Of Water.",DrinkTimeCounter];
            [defaults setObject:ReminderlableText forKey:@"save"];
            
            [defaults setInteger:DrinkTimeCounter forKey:@"DrinkTimeCounter"];
            
            
            [defaults synchronize];
        }
        else
            
        {        NSUserDefaults *defaults = [[NSUserDefaults alloc]initWithSuiteName:@"group.appadeedoo.Times"];
            
            [defaults setInteger:0 forKey:@"DrinkTimeCounter"];
            
        }

        
        [self showReminder:@" Water" textBody:@"Water Time" WithSound:@"APDD-TimesApp-Drinking Reminder" TypeOf:@"wav" HasRecord:YES];
        
    }
    
    // WALK
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WalkNotificationID"])
    {
        
        [self showReminder:@" Walk" textBody:@"Walk Time" WithSound:@"APDD-TimesApp-Walking Reminder" TypeOf:@"wav" HasRecord:YES];
        
        
    }
    
    
    //######################################################################################################################################
    // ONLY ON THE HOUR
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"OnlyOnTheHourNotificationID"])
    {
        
        [self showReminder:@"One the Hour" textBody:@"One Hour Has Just Come!" WithSound:@"APDD-TimesApp-OnTheHour Reminder" TypeOf:@"wav" HasRecord:YES];
        
    }
    
    //DURING THE DAY REMINDER
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"DuringDayReminderID"])
    {
        
        NSString *ToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"DayReminderSelectedToneFileNameData"];
        NSLog(@"%@",ToneFileName);
        if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SelectedToneActualFlag"]) {
            ToneFileName=@"APDD-TimesApp-General-01.wav";
        }
        
        NSString *myTitle;
        NSString *mytextBody;
        myTitle= [[NSUserDefaults standardUserDefaults] objectForKey:@"txtReminderName"];
        if(!myTitle)
        {   myTitle=@"Day Reminder";
        }
        mytextBody= [[NSUserDefaults standardUserDefaults] objectForKey:@"txtReminderNotes"];
        if(!mytextBody)
        {
            
            mytextBody=@"Alarm You set up";
            
        }
        [self showReminder:myTitle textBody:mytextBody WithSound:ToneFileName TypeOf:@"wav" HasRecord:YES];
        
    }
    
    //######################################################################################################################################
    
    // GAB HOURS
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"FirstTwoHoursNotificationID"])
    {
        NSString *FirstTwoHoursToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"DayReminderSelectedToneFileNameData"];
        NSLog(@"%@",FirstTwoHoursToneFileName);
        if (!FirstTwoHoursToneFileName) {
            // This is the 1st run of the app
            [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-General-01" forKey:@"DayReminderSelectedToneFileNameData"];
        }
        NSString *myTitle;
        NSString *mytextBody;
        myTitle= [[NSUserDefaults standardUserDefaults] objectForKey:@"txtReminderName"];
        if(!myTitle)
        {   myTitle=@"Day Reminder";
        }
        mytextBody= [[NSUserDefaults standardUserDefaults] objectForKey:@"txtReminderNotes"];
        if(!mytextBody)
        {
            
            mytextBody=@"Alarm You set up";
            
        }
        
        [self showReminder:myTitle textBody:mytextBody WithSound:FirstTwoHoursToneFileName TypeOf:@"wav" HasRecord:YES];
    }
    
    //######################################################################################################################################
    // REST OF HOURS
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"RestOfHoursNotificationID"])
    {
        NSString *RestOfHoursToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"DayReminderSelectedToneFileNameData"];
        NSLog(@"%@",RestOfHoursToneFileName);
        if (!RestOfHoursToneFileName) {
            // This is the 1st run of the app
            [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-WakeUpAlarm-Anew" forKey:@"DayReminderSelectedToneFileNameData"];
        }
        NSString *myTitle;
        NSString *mytextBody;
        myTitle= [[NSUserDefaults standardUserDefaults] objectForKey:@"txtReminderName"];
        if(!myTitle)
        {   myTitle=@"Day Reminder";
        }
        mytextBody= [[NSUserDefaults standardUserDefaults] objectForKey:@"txtReminderNotes"];
        if(!mytextBody)
        {
            
            mytextBody=@"Alarm You set up";
            
        }
        
        [self showReminder:myTitle textBody:mytextBody WithSound:RestOfHoursToneFileName TypeOf:@"wav" HasRecord:YES];
    }
    
    
    
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"SleepNotificationIDMonday"])
    {
        [self PlaySleepNotificationAlarm];
    }
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"SleepNotificationIDTuesday"])
    {
        [self PlaySleepNotificationAlarm];
    }
    
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"SleepNotificationIDWednesday"])
    {
        [self PlaySleepNotificationAlarm];
        
    }
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"SleepNotificationIDThursday"])
    {
        [self PlaySleepNotificationAlarm];
    }
    
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"SleepNotificationIDFriday"])
    {
        [self PlaySleepNotificationAlarm];
    }
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"SleepNotificationIDSaturday"])
    {
        [self PlaySleepNotificationAlarm];
    }
    
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"SleepNotificationIDSunday"])
    {
        [self PlaySleepNotificationAlarm];
        NSLog(@"do nothing");
    }
    
    //=====================================
    
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WakupNotificationIDMonday"])
    {
        [self PlayWakeupNotificationAlarm];
    }
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WakupNotificationIDTuesday"])
    {
        [self PlayWakeupNotificationAlarm];
    }
    
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WakupNotificationIDWednesday"])
    {
        [self PlayWakeupNotificationAlarm];
        
    }
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WakupNotificationIDThursday"])
    {
        [self PlayWakeupNotificationAlarm];
    }
    
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WakupNotificationIDFriday"])
    {
        [self PlayWakeupNotificationAlarm];
    }
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WakupNotificationIDSaturday"])
    {
        [self PlayWakeupNotificationAlarm];
    }
    
    
    else if ([[notification.userInfo objectForKey:@"notificationID"] isEqualToString:@"WakupNotificationIDSunday"])
    {
        [self PlayWakeupNotificationAlarm];
        
    }
    
    //====================================
    
    else  {
        /*
        NSScanner *scan = [NSScanner scannerWithString: resultingString];
        
        BOOL isNumeric = [scan scanDouble: &holder] && [scan isAtEnd];
        
        if (isNumeric) {
            
            [self.detailItem setValue:number forKey:kValueDouble];
        }
        */
        NSLog(@"inside");
        
        [self showReminder:@" Alarm" textBody:@"Day Alarms" WithSound:@"APDD-TimesApp-WakeUpAlarm-Anew" TypeOf:@"wav" HasRecord:YES];
        
        
    }
    
    }
    else  {
        //NSNumber *myNum =[notification.userInfo objectForKey:@"notificationID"];
        
        
       // NSString*str=[myNum stringValue];
        NSLog(@"%@",notification.soundName);
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        NSError *setCategoryError = nil;
        BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        if (!success) { /* handle the error condition */ }
        
        NSError *activationError = nil;
        success = [audioSession setActive:YES error:&activationError];
        
        [self showReminder:@"Personal Alarm" textBody:notification.alertBody WithSound:notification.soundName TypeOf:@"wav" HasRecord:YES];
        
        
    }
    



}

- (void)showReminder:(NSString *)text  textBody:(NSString *)mybodytext WithSound:(NSString *)str TypeOf:(NSString *)soundType HasRecord:(BOOL)isRecored
{//Show the Text
    
    
    //NSLog(@"hi from inside the show remonder");
    reminderAlert = [[UIAlertView alloc] initWithTitle:text message:mybodytext delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [reminderAlert show];
    
    //Play The Audio
    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:soundType];
    
    NSURL *file = [[NSURL alloc] initFileURLWithPath:path];
    /*
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasSleepRecord"]) {
        file=recorder.url;// with Sleep
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasWorkRecord"]) {
        file=recorder.url;//with work
    }
     */
    self.player =[[AVAudioPlayer alloc] initWithContentsOfURL:file error:nil];
    [self.player prepareToPlay];
    [self.player play];
    

}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}
-(void)LoadDefultValues
{

    
    //============================================================================================
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isParkingSelected"];

    //==============================================================================================
    //Intiate the Selected Tone name
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"fromSleep"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FromWakup"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FromDayReminder"];

    NSString *ComingFrom = [[NSUserDefaults standardUserDefaults] objectForKey:@"ToneNameData"];
    if (!ComingFrom) {
        // This is the 1st run of the app
        [[NSUserDefaults standardUserDefaults] setObject:@"Nowhere" forKey:@"ComingFromData"];
    }
    
    // selected Display name
    NSString *ToneName = [[NSUserDefaults standardUserDefaults] objectForKey:@"ToneNameData"];
    if (!ToneName) {
        // This is the 1st run of the app
        [[NSUserDefaults standardUserDefaults] setObject:@"Ring" forKey:@"ToneNameData"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ToneNameFlag"];
    }
    
    // Slected File Name
    NSString *ToneFileName = [[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedToneActualData"];
    if (!ToneFileName) {
        // This is the 1st run of the app
        [[NSUserDefaults standardUserDefaults] setObject:@"APDD-TimesApp-General-01" forKey:@"SelectedToneActualData"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SelectedToneActualFlag"];
    }
    //==============================================================================================
    //Intiate the Time Interval Data
    // Active Time
    NSString *ActiveTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"ActiveTimeInstiation"];
    if (!ActiveTime) {
        // This is the 1st run of the app
        [[NSUserDefaults standardUserDefaults] setObject:@"10" forKey:@"ActiveTimeInstiation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ActiveTimeInstiationFlag"];
    }
    
    NSString *IdleTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"IdleTimeInstiation"];
    
    if (!IdleTime) {
        // This is the 1st run of the app
        [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:@"IdleTimeInstiation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IdleTimeInstiationFlag"];
    }
    
    NSString *Loop = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoopInstiation"];
    
    if (!Loop) {
        // This is the 1st run of the app
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"LoopInstiation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoopInstiationFlag"];
    }
    
    //==============================================================================================
    
    // Intiate the sleep and wakup time
    
    NSDate *SleepDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"SleepTimeInstiation"];
    if (!SleepDate) {
        // This is the 1st run of the app
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm a"];
        SleepDate = [dateFormatter dateFromString: @"11:00 pm"];
        [[NSUserDefaults standardUserDefaults] setObject:SleepDate forKey:@"SleepTimeInstiation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SleepTimeInstiationFlag"];
    }
    
    // Defulte Wakeup Time
    NSDate *wakeupdate = [[NSUserDefaults standardUserDefaults] objectForKey:@"WakeUpTimeInstiation"];
    if (!wakeupdate) {
        // This is the 1st run of the app
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm a"];
        wakeupdate = [dateFormatter dateFromString: @"07:30 am"];
        [[NSUserDefaults standardUserDefaults] setObject:wakeupdate forKey:@"WakeUpTimeInstiation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WakeUpTimeInstiationFlag"];
    }

    NSDate *TodayDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"TodayDate"];
    if (!TodayDate) {
        // This is the 1st run of the app
        
        TodayDate=[NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:TodayDate forKey:@"TodayDate"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TodayDateIsExist"];
    }
    

}

-(void)DeleteNotification:(NSString *)notificationID
{
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[someNotification.userInfo objectForKey:@"notificationID"] isEqualToString:notificationID ]) {
            
            [[UIApplication sharedApplication] cancelLocalNotification:someNotification];
            
        }
    }
    
    
}

@end
