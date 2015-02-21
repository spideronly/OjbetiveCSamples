//
//  SecondCircleSettingViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 1/11/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "SecondCircleSettingViewController.h"
#import "SGRemindersViewController.h"

@interface SecondCircleSettingViewController ()
{
    NSMutableArray *hoursArray;


}
@property(retain, nonatomic) NSMutableArray *hoursArray;

@end

@implementation SecondCircleSettingViewController
@synthesize PVStart,PVEnd,hoursArray,RemindersArray;
@synthesize WeekDay;
@synthesize lblCurrentDate;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadData];


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//========================================================================
#pragma mark - Load Data
//============================================================================
-(void)LoadData


{
    [self LoadTableViewData];
    [self LoadShapAndColors];
    [self LoadText];
    [self LoadSwitchsCase];
    [self LoadTheGestureSwipType];
    [self initilizeHoursArray:25];
    [self SetStarAndEndDates:YES isInSetMode:NO];
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    [self LoadHoursValues:WeekDays ];
    [self SetDates:NO IsWaterSet:NO IsWalkset:NO IsOnTheHourSet:NO];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self LoadTableViewData];
}
-(void)LoadPickerViewsDefulteValues:(NSString *)StartValue EndDateValue:(NSString *)EndValue
{
    NSString *startTime = [[NSUserDefaults standardUserDefaults] objectForKey:StartValue];
    if(!startTime )
    {
        
        startTime=[NSString stringWithFormat:@"8"];
        
    
    }
    [self.PVStart selectRow:[startTime intValue] inComponent:0 animated:YES];

    //
    NSString *endTime = [[NSUserDefaults standardUserDefaults] objectForKey:EndValue];
    if(!endTime )
    {
        
        endTime=[NSString stringWithFormat:@"16"];
        
        
    }
    [self.PVEnd selectRow:[endTime intValue] inComponent:0 animated:YES];
    


    //[self.PVStart selectRow: inComponent:0 animated:YES];


}



-(void)LoadSwitchsCase
{
    
    // On The Hour Switch
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"OnTheHourSwitchStatus"])
    {
        NSLog(@"No");
        
        [_swOnthehour setOn:NO animated:YES];
        [self cancelOnTheHourBeeping];

        
    }
    else
    {
        NSLog(@"Yes");
        
        [_swOnthehour setOn:YES animated:YES];
        [self SetUpOnlyOntheHour];


    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"WaterFlag"])
    {
        NSLog(@"No");
        
        [_swWater setOn:NO animated:YES];
        [self cancelWaterBeeping];
        
        
    }
    else
    {
        NSLog(@"Yes");
        
        [_swWater setOn:YES animated:YES];
        [self SetUpWaterBeeping];
        
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"WalkFlag"])
    {
        NSLog(@"No");
        
        [_swWalk setOn:NO animated:YES];
        [self cancelWalkBeeping];
        
        
    }
    else
    {
        NSLog(@"Yes");
        
        [_swWalk setOn:YES animated:YES];
        [self SetUpWaterBeeping];
        
    }
    
   
}

-(void)LoadShapAndColors
{
    
    
    
    //----------------------------------
    NSData *secondcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderColorData"];
    UIColor *secondolor = [NSKeyedUnarchiver unarchiveObjectWithData:secondcolorData];
    
    //Setup The button Round and Border width
    _btnSecondGroup.layer.borderWidth =12;
    _btnSecondGroup.layer.cornerRadius=_btnSecondGroup.layer.bounds.size.width/2;
    
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"secondSliderColorDataChangeFlag"]) {
        secondolor=[UIColor orangeColor];
    }
    
    
    
    [_btnSecondGroup setTitleColor:secondolor forState:UIControlStateNormal];
    _btnSecondGroup.layer.borderColor =secondolor.CGColor;
    //
    
    
    
}
-(void)LoadText
{
    
    
    NSData *secondTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderTextData"];
    NSString *secondText = [NSKeyedUnarchiver unarchiveObjectWithData:secondTextData];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"secondSliderTextDataChangeFlag"]) {
        
        secondText=@"Work";
        
    }    self.lblSectionName.text=secondText;
    
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
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        
        
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
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        
        
        
        
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
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        
        
        
        
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
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        
        
        
        
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
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        
        
        
        
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
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        
        
        
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
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        
        
        
        
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
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        
        
        
        
    }
    
    
    
    
    
    
}

//========================================================================
#pragma mark - UIswitches
//============================================================================
- (IBAction)SwOntheHour:(id)sender {
    
    if (_swOnthehour.isOn==YES) {
        [_swOnthehour setOn:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"OnTheHourSwitchStatus"];
        [self SetUpOnlyOntheHour];
    }
    else
    {
        [_swOnthehour setOn:NO];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"OnTheHourSwitchStatus"];
        // [self cancelOnTheHourBeeping];
    }
    
}
- (IBAction)SwWater:(id)sender {
    if (_swWater.isOn==YES) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WaterFlag"];
        [self SetUpWaterBeeping];
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WaterFlag"];
        [self cancelWaterBeeping];
    }
    
    
    
}
- (IBAction)SwWalk:(id)sender {
    
    if (_swWalk.isOn==YES) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WalkFlag"];
        [self SetUpWalkrBeeping];
    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WalkFlag"];
        [self cancelWalkBeeping];
    }
    
    
    
}



//========================================================================
#pragma mark -Date Methods
//============================================================================

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
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [df dateFromString:stringFromDate];
    
    
    
    //Create a date string in the local timezone
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    
    // My local timezone is: Europe/London (GMT+01:00) offset 3600 (Daylight)
    // prints out: date = 08/12/2013 22:01
    
    // create a calendar
    NSDate *dtTodayPlusDate = [gregorian dateByAddingComponents:Pluscomponent toDate:date options:0];
    
   // NSLog(@"Tomorow------------------------------------------------------: %@", dtTodayPlusDate);
    
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
    [formatter setDateFormat:@"HH"];
    NSString *hour = [formatter stringFromDate:myDate];
    return hour;

}

-(NSDate *)SetUpHourForDate:(NSDate *)myDate WithHour:(int)myhour withMin:(int)myMin
{

    NSDate *oldDate =myDate;
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:oldDate];
    comps.hour   = myhour;
    comps.minute = myMin;
    comps.second = 1;
    NSDate *newDate = [calendar dateFromComponents:comps];
    return newDate;
}
-(void)FireUpWaterAlarm:(NSDate *)firupdate
{
    
    
    //Time 1
    // NSDate *WorkStartTime;
    // NSDate *WorkEndTime;
    
    NSDate *FirstTimewater=[self SetUpHourForDate:firupdate WithHour:10 withMin:20];
    NSLog(@"Tomorow------------------------------------------------------: %@", [NSDate date]);
    //60 seconds
    [self scheduleNotificationForDate:FirstTimewater AlertBody:@"Drink some Water" ActionButtonTitle:@"I Will" NotificationID:@"WaterNotificationID" CustomeSoundName:@"APDD-TimesApp-Drinking Reminder.wav" repeat:2];
    
    //######################################################################################################################################
    
    //Time 2
    NSDate *SecondTimewater=[self SetUpHourForDate:firupdate WithHour:12 withMin:20];
    
    NSLog(@"Tomorow------------------------------------------------------: %@", [NSDate date]);
    //60 seconds
    [self scheduleNotificationForDate:SecondTimewater AlertBody:@"Drink some Water " ActionButtonTitle:@"I Will" NotificationID:@"WaterNotificationID" CustomeSoundName:@"APDD-TimesApp-Drinking Reminder.wav" repeat:2];
    
    //######################################################################################################################################
    
    
    //Time 3
    NSDate *ThirdTimewater=[self SetUpHourForDate:firupdate WithHour:14 withMin:20];
    NSLog(@"Tomorow------------------------------------------------------: %@", [NSDate date]);
    //60 seconds
    [self scheduleNotificationForDate:ThirdTimewater AlertBody:@"Drink some Water " ActionButtonTitle:@"I Will" NotificationID:@"WaterNotificationID" CustomeSoundName:@"APDD-TimesApp-Drinking Reminder.wav" repeat:2];
    //######################################################################################################################################


}
-(void)FireUpWalkAlarm:(NSDate *)firupdate
{
    
    //Time 1
    
    // Creat walk notification alarm
    NSDate *FirstTimeWalk=[self SetUpHourForDate:firupdate WithHour:11 withMin:20];
    
    //60 seconds
    [self scheduleNotificationForDate:FirstTimeWalk AlertBody:@"Take A walk" ActionButtonTitle:@"I Will" NotificationID:@"WalkNotificationID" CustomeSoundName:@"APDD-TimesApp-Walking Reminder.wav" repeat:0];
   // ==================================================================================
    //Time 2
    
    // Creat walk notification alarm
    NSDate *SecondTimeWalk=[self SetUpHourForDate:firupdate WithHour:13 withMin:20];
    
    //60 seconds
    [self scheduleNotificationForDate:SecondTimeWalk AlertBody:@"Take A walk" ActionButtonTitle:@"I Will" NotificationID:@"WalkNotificationID" CustomeSoundName:@"APDD-TimesApp-Walking Reminder.wav" repeat:0];
    
    //Time 3
    
    // Creat walk notification alarm
    NSDate *ThirdTimeWalk=[self SetUpHourForDate:firupdate WithHour:15 withMin:20];
    
    //60 seconds
    [self scheduleNotificationForDate:ThirdTimeWalk AlertBody:@"Take A walk" ActionButtonTitle:@"I Will" NotificationID:@"WalkNotificationID" CustomeSoundName:@"APDD-TimesApp-Walking Reminder.wav" repeat:0];
    
}
-(void)SetDates:(BOOL)HasNotification IsWaterSet:(BOOL)IsWater IsWalkset:(BOOL)IsWalk IsOnTheHourSet:(BOOL)ISOnTheHour
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
    if ([WeekDayName isEqualToString:TodayDayName]) {
        // self.view.backgroundColor=[UIColor greenColor];
        lblCurrentDate.text=[NSString stringWithFormat:@"%@",[NSDate date]];
        if(HasNotification)
        {
            
            if(IsWater)
            {
            // Today Water Notification
                [self FireUpWaterAlarm:[NSDate date]];
              //SetUp THe Cuurent page Date
             [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"CurrentViewDate"];

            }
            if(IsWalk)
            {
                
                
                [self FireUpWalkAlarm:[NSDate date]];
            
            }
    
            if(ISOnTheHour)
            {
                
                
                
                NSDate *currentDate =[NSDate date];
                NSDate *begningOfNextHour=[self nextHourDate:currentDate];
                // Find the Start Date
                // Find The End Date
                
                //SetUp THe Cuurent page Date
                NSString *CurrentViewDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewDate"];
                NSLog(@"current view date %@",CurrentViewDate);
                
                
                [self scheduleNotificationForDate:begningOfNextHour AlertBody:@"One Hour Coming" ActionButtonTitle:@"Enjoy" NotificationID:@"OnlyOnTheHourNotificationID" CustomeSoundName:@"APDD-TimesApp-OnTheHour Reminder.wav" repeat:1];

            
            }
            
        }
        
        
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:1]]) {
        
        // self.view.backgroundColor=[UIColor whiteColor];
        
        lblCurrentDate.text=[NSString stringWithFormat: @"%@",[self GetCurrentDate:1]];
        if(HasNotification==YES)
        {
            if(IsWater)
            {
              [self FireUpWaterAlarm:[self GetCurrentDate:1]];

            //SetUp THe Cuurent page Date
            [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:1] forKey:@"CurrentViewDate"];
            
        }
        if(IsWalk)
        {
            [self FireUpWalkAlarm:[self GetCurrentDate:1]];

            
        }
        
        if(ISOnTheHour)
        {
            
            
            
            
            NSDate *currentDate =[NSDate date];
            NSDate *begningOfNextHour=[self nextHourDate:currentDate];
            // Find the Start Date
            // Find The End Date
            
            //SetUp THe Cuurent page Date
            NSString *CurrentViewDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewDate"];
            NSLog(@"current view date %@",CurrentViewDate);
            
            
            [self scheduleNotificationForDate:begningOfNextHour AlertBody:@"One Hour Coming" ActionButtonTitle:@"Enjoy" NotificationID:@"OnlyOnTheHourNotificationID" CustomeSoundName:@"APDD-TimesApp-OnTheHour Reminder.wav" repeat:1];
  
        }

        
            
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:2]]) {
        //self.view.backgroundColor=[UIColor purpleColor];
        lblCurrentDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:2]];
        if(HasNotification==YES)
        {
            if(IsWater)
            {
                [self FireUpWaterAlarm:[self GetCurrentDate:2]];
            //SetUp THe Cuurent page Date
            [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:2] forKey:@"CurrentViewDate"];
        }
        if(IsWalk)
        {
            [self FireUpWalkAlarm:[self GetCurrentDate:2]];
            
        }
        
        if(ISOnTheHour)
        {
            
            
            
            
            NSDate *currentDate =[NSDate date];
            NSDate *begningOfNextHour=[self nextHourDate:currentDate];
            // Find the Start Date
            // Find The End Date
            
            //SetUp THe Cuurent page Date
            NSString *CurrentViewDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewDate"];
            NSLog(@"current view date %@",CurrentViewDate);
            
            
            [self scheduleNotificationForDate:begningOfNextHour AlertBody:@"One Hour Coming" ActionButtonTitle:@"Enjoy" NotificationID:@"OnlyOnTheHourNotificationID" CustomeSoundName:@"APDD-TimesApp-OnTheHour Reminder.wav" repeat:1];
   
        }
        
        
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:3]]) {
        //self.view.backgroundColor=[UIColor blueColor];
        lblCurrentDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:3]];
        if(HasNotification==YES)
        {
            if(IsWater)
            {
                [self FireUpWaterAlarm:[self GetCurrentDate:3]];
         
            //SetUp THe Cuurent page Date
            [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:3] forKey:@"CurrentViewDate"];

        
        }
        if(IsWalk)
        {
            
            [self FireUpWalkAlarm:[self GetCurrentDate:3]];


            
            
        }
        
        if(ISOnTheHour)
        {
            
            
            
            NSDate *currentDate =[NSDate date];
            NSDate *begningOfNextHour=[self nextHourDate:currentDate];
            // Find the Start Date
            // Find The End Date
            
            //SetUp THe Cuurent page Date
            NSString *CurrentViewDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewDate"];
            NSLog(@"current view date %@",CurrentViewDate);
            
            
            [self scheduleNotificationForDate:begningOfNextHour AlertBody:@"One Hour Coming" ActionButtonTitle:@"Enjoy" NotificationID:@"OnlyOnTheHourNotificationID" CustomeSoundName:@"APDD-TimesApp-OnTheHour Reminder.wav" repeat:1];
   
            
        }

        }
    
    
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:4]]) {
        // self.view.backgroundColor=[UIColor yellowColor];
        lblCurrentDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:4]];
        if(HasNotification==YES)
        {
            if(IsWater)
            {
            // Day 4 Water Notification
                [self FireUpWaterAlarm:[self GetCurrentDate:4]];

            
            //SetUp THe Cuurent page Date
            [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:4] forKey:@"CurrentViewDate"];
        }
        if(IsWalk)
        {
            [self FireUpWalkAlarm:[self GetCurrentDate:4]];

            
        }
        
        if(ISOnTheHour)
        {
            
            
            
            NSDate *currentDate =[NSDate date];
            NSDate *begningOfNextHour=[self nextHourDate:currentDate];
            // Find the Start Date
            // Find The End Date
            
            //SetUp THe Cuurent page Date
            NSString *CurrentViewDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewDate"];
            NSLog(@"current view date %@",CurrentViewDate);
            
            
            [self scheduleNotificationForDate:begningOfNextHour AlertBody:@"One Hour Coming" ActionButtonTitle:@"Enjoy" NotificationID:@"OnlyOnTheHourNotificationID" CustomeSoundName:@"APDD-TimesApp-OnTheHour Reminder.wav" repeat:1];
  
            
        }


        
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:5]]) {
        // self.view.backgroundColor=[UIColor grayColor];
        lblCurrentDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:5]];
        
        if(HasNotification==YES)
        {
            if(IsWater)
            {
            // Day 5 Water Notification
                [self FireUpWaterAlarm:[self GetCurrentDate:5]];
            
            //SetUp THe Cuurent page Date
            [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:5] forKey:@"CurrentViewDate"];
        }
        if(IsWalk)
        {
            [self FireUpWalkAlarm:[self GetCurrentDate:5]];

            
        }
        
        if(ISOnTheHour)
        {
            
            
            
            NSDate *currentDate =[NSDate date];
            NSDate *begningOfNextHour=[self nextHourDate:currentDate];
            // Find the Start Date
            // Find The End Date
            
            //SetUp THe Cuurent page Date
            NSString *CurrentViewDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewDate"];
            NSLog(@"current view date %@",CurrentViewDate);
            
            
            [self scheduleNotificationForDate:begningOfNextHour AlertBody:@"One Hour Coming" ActionButtonTitle:@"Enjoy" NotificationID:@"OnlyOnTheHourNotificationID" CustomeSoundName:@"APDD-TimesApp-OnTheHour Reminder.wav" repeat:1];
 
            
        }


        
        }
        
        
    }
    else if ([WeekDayName isEqualToString:[self GetCurrentWeekDay:6]]) {
        // self.view.backgroundColor=[UIColor purpleColor];
        
        lblCurrentDate.text=[NSString stringWithFormat:@"%@",[self GetCurrentDate:6]];
        
        if(HasNotification==YES)
        {if(IsWater)
        {
            // Day 6 Water Notification
            [self FireUpWaterAlarm:[self GetCurrentDate:6]];

            
            //SetUp THe Cuurent page Date
            [[NSUserDefaults standardUserDefaults] setObject:[self GetCurrentDate:6] forKey:@"CurrentViewDate"];
            
        }
        if(IsWalk)
        {
            [self FireUpWalkAlarm:[self GetCurrentDate:6]];

            
        }
        
        if(ISOnTheHour)
        {
            
            
            
            NSDate *currentDate =[NSDate date];
            NSDate *begningOfNextHour=[self nextHourDate:currentDate];
            // Find the Start Date
            // Find The End Date
            
            //SetUp THe Cuurent page Date
            NSString *CurrentViewDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentViewDate"];
            NSLog(@"current view date %@",CurrentViewDate);
            
            
            [self scheduleNotificationForDate:begningOfNextHour AlertBody:@"One Hour Coming" ActionButtonTitle:@"Enjoy" NotificationID:@"OnlyOnTheHourNotificationID" CustomeSoundName:@"APDD-TimesApp-OnTheHour Reminder.wav" repeat:1];

            
        }

        
        }
    }
    
    
}

//========================================================================
#pragma mark - Play And Cancel Notification
//============================================================================

//###################################   Find the begning of next Hour ###############################################################

// Find the begning of next Hour
- (NSDate*) nextHourDate:(NSDate*)inDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components: NSCalendarUnitEra|NSCalendarUnitYear| NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate: inDate];
    [comps setHour: [comps hour]+1]; // Here you may also need to check if it's the last hour of the day
    return [calendar dateFromComponents:comps];
}
//########################################## SetUpOnlyOntheHour ##########################################################

-(void)SetUpOnlyOntheHour
{    [self CancelExistingNotification:@"OnlyOnTheHourNotificationID"];

    
    [self SetDates:YES IsWaterSet:NO IsWalkset:NO IsOnTheHourSet:YES];

   


}

    //########################################## SetUpWaterBeeping #################################################################


-(void)SetUpWaterBeeping
{    // Create Water Notification alarm
    [self CancelExistingNotification:@"WaterNotificationID"];
    [self SetDates:YES IsWaterSet:YES IsWalkset:NO IsOnTheHourSet:NO];
    
    
}

//############################################################# SetUpWalkrBeeping ##############################################

-(void)SetUpWalkrBeeping
{
    
    [self CancelExistingNotification:@"WalkNotificationID"];
    [self SetDates:YES IsWaterSet:NO IsWalkset:YES IsOnTheHourSet:NO];

    

    
}
//#########################################################cancelWaterBeeping###################################################################

-(void)cancelWaterBeeping
{
    
    [self CancelExistingNotification:@"WaterNotificationID"];
}
//##################################################################cancelWalkBeeping##########################################################

-(void)cancelWalkBeeping
{
    
    [self CancelExistingNotification:@"WalkNotificationID"];
    
}

//#######################################################cancelOnTheHourBeeping####################################################################

-(void)cancelOnTheHourBeeping
{
    
    [self CancelExistingNotification:@"OnlyOnTheHourNotificationID"];
}

//========================================================================
#pragma mark - Set and Cancel Notification
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
    if(hasRepeat==2)
        localNotification.repeatInterval=NSCalendarUnitDay;
    else
        localNotification.repeatInterval=0;

    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:notificationID forKey:@"notificationID"];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


- (void)CancelExistingNotification:(NSString *)CurrenrtNotificationID
{
    
    
    //+++++++++ get The right
    NSData *NotificationIDtData = [[NSUserDefaults standardUserDefaults] objectForKey:CurrenrtNotificationID];
    NSString *myNotificationID = [NSKeyedUnarchiver unarchiveObjectWithData:NotificationIDtData];
    
    
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
        if ([uid isEqualToString:[NSString stringWithFormat:@"%@",myNotificationID]])
        {
            //Cancelling local notification
            
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}

//========================================================================
#pragma mark - Piker View Section

//============================================================================





//Method to define how many columns/dials to show
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


// Method to define the numberOfRows in a component using the array.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent :(NSInteger)component
{
    return [hoursArray count];
    
}


// Method to show the title of row for a component.
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [hoursArray objectAtIndex:row];
    
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    
 // Do Nothing , Just to set up the picker view
    
}

- (void)pickerView:(UIPickerView *)ThepickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //[PVFIrstGroup resignFirstResponder];
   
    
    
    
    NSString *valueStart = [hoursArray objectAtIndex:[PVStart selectedRowInComponent:0]];
    NSString *valueEnd = [hoursArray objectAtIndex:[PVEnd selectedRowInComponent:0]];
    int Start=[valueStart intValue];
    int End=[valueEnd intValue];
    int totalHours=[_btnSecondGroup.titleLabel.text intValue];
    int SumStart=Start+totalHours;
    int SubstractStart=totalHours-Start;
    int SumEnd=totalHours+End;
    int SubtractEnd=End-totalHours;

    if(ThepickerView==PVStart)
    {
        if(SumStart>0)
        {[PVEnd selectRow:SumStart inComponent:0 animated:YES];}
        else
        {[PVEnd selectRow:SubstractStart inComponent:0 animated:YES];}

    }
    if(ThepickerView==PVEnd)
    {
        if (SubtractEnd>0) {
            [PVStart selectRow:SubtractEnd inComponent:0 animated:YES];

        }
        else
        {
            [PVStart selectRow:SumEnd inComponent:0 animated:YES];
        }
    }

}
//========================================================================
#pragma mark -Assistance Mehtod
//============================================================================
-(void)initilizeHoursArray:(int)Length
{
    // Check if Its 24 Hours
    
    //initialize arrays
    hoursArray = [[NSMutableArray alloc] init];
    NSString *strVal = [[NSString alloc] init];
    
    for(int i=1; i<62; i++)
    {
        strVal = [NSString stringWithFormat:@"%d", i];
        
        //NSLog(@"strVal: %@", strVal);
        
        //Create array with 0-12 hours
        if (i < Length)
        {
            [hoursArray addObject:strVal];
        }
        
        //create arrays with 0-60 secs/mins
        
    }
    
    
    NSLog(@"[hoursArray count]: %lu", (unsigned long)[hoursArray count]);
    
}
- (IBAction)PopUpStartTimePicker:(id)sender {
    UIPickerView *smallPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 120.0)];
    [self.view addSubview:smallPicker];
    
}


- (IBAction)GoToReminder:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"SGRemindersViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
-(void)SetStarAndEndDates:(BOOL)isLoad isInSetMode:(BOOL)isSet
{
    NSInteger rowPVStart;
    NSInteger rowPVend;
    
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    
    if([WeekDays isEqualToString:@"0"])
    {
        if(isLoad)
        {
        
            [self LoadPickerViewsDefulteValues:@"StartWorkTimeMonday" EndDateValue:@"EndWorkTimeMonday"];
        
        }
        if(isSet)
        {rowPVStart = [PVStart selectedRowInComponent:0];
            NSString *startSelectedValue = [hoursArray objectAtIndex:rowPVStart];
            //NSLog(@" selected %@",startSelectedValue);
            //
            [[NSUserDefaults standardUserDefaults] setObject:startSelectedValue forKey:@"StartWorkTimeMonday"];
            
            
            rowPVend = [PVEnd selectedRowInComponent:0];
            NSString *endSelectedValue = [hoursArray objectAtIndex:rowPVend];
            
         //   NSLog(@" selected %@",endSelectedValue);
            [[NSUserDefaults standardUserDefaults] setObject:endSelectedValue forKey:@"EndWorkTimeMonday"];
            
        }
    }
    
    else if([WeekDays isEqualToString:@"1"])
    {
        if(isLoad)
        {
            
            [self LoadPickerViewsDefulteValues:@"StartWorkTimeTuesday" EndDateValue:@"EndWorkTimeTuesday"];
            
        }
    
        if(isSet)
        {
        rowPVStart = [PVStart selectedRowInComponent:0];
        NSString *startSelectedValue = [hoursArray objectAtIndex:rowPVStart];
        NSLog(@" selected %@",startSelectedValue);
        //
        [[NSUserDefaults standardUserDefaults] setObject:startSelectedValue forKey:@"StartWorkTimeTuesday"];
        
        
        rowPVend = [PVEnd selectedRowInComponent:0];
        NSString *endSelectedValue = [hoursArray objectAtIndex:rowPVend];
        
        NSLog(@" selected %@",endSelectedValue);
        [[NSUserDefaults standardUserDefaults] setObject:endSelectedValue forKey:@"EndWorkTimeTuesday"];
        
        }
        
    }
    else if([WeekDays isEqualToString:@"2"])
    {
        if(isLoad)
        {
            
            [self LoadPickerViewsDefulteValues:@"StartWorkTimeWednesday" EndDateValue:@"EndWorkTimeWednesday"];
          
        }
        if(isSet)
        {
        rowPVStart = [PVStart selectedRowInComponent:0];
        NSString *startSelectedValue = [hoursArray objectAtIndex:rowPVStart];
        NSLog(@" selected %@",startSelectedValue);
        //
        [[NSUserDefaults standardUserDefaults] setObject:startSelectedValue forKey:@"StartWorkTimeWednesday"];
        
        
        rowPVend = [PVEnd selectedRowInComponent:0];
        NSString *endSelectedValue = [hoursArray objectAtIndex:rowPVend];
        
        NSLog(@" selected %@",endSelectedValue);
        [[NSUserDefaults standardUserDefaults] setObject:endSelectedValue forKey:@"EndWorkTimeWednesday"];
        }
        
        
    }
    else if([WeekDays isEqualToString:@"3"])
    {
        if(isLoad)
        {
            
            [self LoadPickerViewsDefulteValues:@"StartWorkTimeThursday" EndDateValue:@"EndWorkTimeThursday"];
           
        }
        if(isSet)
        {
        rowPVStart = [PVStart selectedRowInComponent:0];
        NSString *startSelectedValue = [hoursArray objectAtIndex:rowPVStart];
        NSLog(@" selected %@",startSelectedValue);
        //
        [[NSUserDefaults standardUserDefaults] setObject:startSelectedValue forKey:@"StartWorkTimeThursday"];
        
        
        rowPVend = [PVEnd selectedRowInComponent:0];
        NSString *endSelectedValue = [hoursArray objectAtIndex:rowPVend];
        
        NSLog(@" selected %@",endSelectedValue);
        [[NSUserDefaults standardUserDefaults] setObject:endSelectedValue forKey:@"EndWorkTimeThursday"];
        
        }
        
    }
    else if([WeekDays isEqualToString:@"4"])
    {if(isLoad)
    {
        
        [self LoadPickerViewsDefulteValues:@"StartWorkTimeFriday" EndDateValue:@"EndWorkTimeFriday"];
        
    }
        if(isSet)
        {
        rowPVStart = [PVStart selectedRowInComponent:0];
        NSString *startSelectedValue = [hoursArray objectAtIndex:rowPVStart];
        NSLog(@" selected %@",startSelectedValue);
        //
        [[NSUserDefaults standardUserDefaults] setObject:startSelectedValue forKey:@"StartWorkTimeFriday"];
        
        
        rowPVend = [PVEnd selectedRowInComponent:0];
        NSString *endSelectedValue = [hoursArray objectAtIndex:rowPVend];
        
        NSLog(@" selected %@",endSelectedValue);
        [[NSUserDefaults standardUserDefaults] setObject:endSelectedValue forKey:@"EndWorkTimeFriday"];
        }
        
        
    }
    else if([WeekDays isEqualToString:@"5"])
    {
        if(isLoad)
        {
            [self LoadPickerViewsDefulteValues:@"StartWorkTimeSaturday" EndDateValue:@"EndWorkTimeSaturday"];
        
        }
        if(isSet)
        {
        rowPVStart = [PVStart selectedRowInComponent:0];
        NSString *startSelectedValue = [hoursArray objectAtIndex:rowPVStart];
        NSLog(@" selected %@",startSelectedValue);
        //
        [[NSUserDefaults standardUserDefaults] setObject:startSelectedValue forKey:@"StartWorkTimeSaturday"];
        
        
        rowPVend = [PVEnd selectedRowInComponent:0];
        NSString *endSelectedValue = [hoursArray objectAtIndex:rowPVend];
        
        NSLog(@" selected %@",endSelectedValue);
        [[NSUserDefaults standardUserDefaults] setObject:endSelectedValue forKey:@"EndWorkTimeSaturday"];
        
        }
        
    }
    else if([WeekDays isEqualToString:@"6"])
    {
     

        if(isLoad)
        {
          
            [self LoadPickerViewsDefulteValues:@"StartWorkTimeSunday" EndDateValue:@"EndWorkTimeSunday"];
            
        }
        if(isSet)
        {
        rowPVStart = [PVStart selectedRowInComponent:0];
        NSString *startSelectedValue = [hoursArray objectAtIndex:rowPVStart];
        NSLog(@" selected %@",startSelectedValue);
        //
        [[NSUserDefaults standardUserDefaults] setObject:startSelectedValue forKey:@"StartWorkTimeSunday"];
        
        
        rowPVend = [PVEnd selectedRowInComponent:0];
        NSString *endSelectedValue = [hoursArray objectAtIndex:rowPVend];
        
        NSLog(@" selected %@",endSelectedValue);
        [[NSUserDefaults standardUserDefaults] setObject:endSelectedValue forKey:@"EndWorkTimeSunday"];
        
        }
        
    }
    

}
// Swipe Gesture with the whole four direction


-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"ThirdCircleSettingViewController"];
    
    [self presentViewController:vc animated:NO completion:nil];
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"FirstCircleSettingViewController"];
    
    [self presentViewController:vc animated:NO completion:nil];
    
}
-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
}

-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    
    
}
-(void)LoadTheGestureSwipType
{
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    
}
- (IBAction)Done:(id)sender {
    [self SetStarAndEndDates:NO isInSetMode:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];

    
}

//========================================================================
#pragma mark - Load  TableView Data
//============================================================================

-(void)LoadTableViewData
{
    
    
    
    NSString *ReminderTime;
    NSString * ReminderText;
    NSString *mystring;
    NSDate *CurrentDate;
    RemindersArray = [[NSMutableArray alloc]init];
    [RemindersArray addObject:@"Add Reminder"];
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if([[someNotification.userInfo objectForKey:@"notificationID"] isEqualToString:@"DuringDayReminderID"]) {
            
            CurrentDate =someNotification.fireDate;
            
            //Create the dateformatter object
            
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            
            //Set the required date format
            
            [formatter setDateFormat:@"hh:mm a"];
            
            //Get the string date
            
            ReminderTime= [formatter stringFromDate:CurrentDate];
            
            ReminderText=someNotification.alertBody;
            mystring=[NSString stringWithFormat:@"%@ | %@",ReminderTime,ReminderText];
            [RemindersArray addObject:mystring];
        }
        
    }
    if([RemindersArray count]<2)
        [RemindersArray addObject:@"No Reminders Yet"];

    
}

//========================================================================
#pragma mark - Ui table View Section
//============================================================================


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"CellIdentifier";

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [RemindersArray objectAtIndex:indexPath.row];
    
    
    UIImage *originalImage =[UIImage imageNamed:@"addremindericopn.png"];
    
    // Resize the image
    /*
    CGSize cellViewSize = CGSizeMake(46.0, 46.0);
    CGRect cellViewRect = [WLImageStore rectForImage:originalImage withSize:cellViewSize];
    UIGraphicsBeginImageContext(cellViewSize);
    [originalImage drawInRect:cellViewRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    */
    [[cell imageView] setImage:originalImage];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

if(indexPath.row==0)
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"SGRemindersViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"SecondGroup" forKey:@"WhatPage"];
    //[[NSUserDefaults standardUserDefaults] setObject:@"Day" forKey:@"ReminderFor"];

}
    else
    {
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"RemindersTableViewController"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}
-(IBAction)SingleTap:(UITapGestureRecognizer *) recgnizer
{
    [[NSUserDefaults standardUserDefaults] setObject:@"SecondGroup" forKey:@"WhatPage"];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"RemindersTableViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    

}

@end
