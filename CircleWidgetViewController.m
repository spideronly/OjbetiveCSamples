//
//  CircleWidgetViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 1/12/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "CircleWidgetViewController.h"

@interface CircleWidgetViewController ()

@end

@implementation CircleWidgetViewController
@synthesize soundFileURLRef;
@synthesize soundFileObject;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self LoadData];



    // [self SetupNavigationButtons];
    _WeekDays= [[NSMutableArray alloc] init];
    //Add items
    //@"Mondays",@"Tuesdays","Wednsdays","Thursdays","Fridays","Satrdays","Sundays"
    
    [_WeekDays  addObject:@"Mondays"];
    [_WeekDays  addObject:@"Tuesdays"];
    [_WeekDays  addObject:@"Tuesdays"];
    
    [_WeekDays  addObject:@"Thursdays"];
    [_WeekDays  addObject:@"Fridays"];
    [_WeekDays  addObject:@"Satrdays"];
    [_WeekDays  addObject:@"Sundays"];


}
-(void)DetermineWeekDay:(NSString *)myString
{
    
    NSData *textData = [NSKeyedArchiver archivedDataWithRootObject:myString];
    [[NSUserDefaults standardUserDefaults] setObject:textData forKey:@"WeekDayPublicLable"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






//========================================================================
#pragma mark - system Sound and vibration
//============================================================================

// In you .h File interface

//bring the native ios alarm tons to set it up for users


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
// Relpace THis in your desired place through the process
//========================================================================
#pragma mark - get week day
//============================================================================

-(NSString *)GetTodayWeekDay
{
    NSDate *currentDate = [NSDate date];
    int DaysFromToday=0;
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
    NSString *WeekDay= [FullDateFormat stringFromDate:dtTodayPlusDate];
    
    return WeekDay;
    
}
//========================================================================
#pragma mark - Load Data
//============================================================================
-(void)LoadData
{

    [self SetUpShapAndColors];
    [self loadFirstLetter];
    //[self LoadHoursValues];
    [self LoadDayName];
}

        
-(void)LoadDayName
{
    //Monday
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"MondayTitleActive"]) {
        _lblDayName.text=@"Mondays";
        
    }
    
    //Tuesdays
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"TuesdayTitleActive"]) {
        _lblDayName.text=@"Tuesdays";
    }
    //Wednsdays
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"WedTitleActive"]) {
        _lblDayName.text=@"Wednesdays";
    }
    //Thursdays
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"ThursTitleActive"]) {
        _lblDayName.text=@"Thursdays";
    }
    //Fridays
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"FriTitleActive"]) {
        _lblDayName.text=@"Fridays";
    }
    //Sutardays
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SutTitleActive"]) {
        _lblDayName.text=@"Saturday";
    }
    //Sundays
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"SUnTitleActive"]) {
        _lblDayName.text=@"Sundays";
    }


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
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
        

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
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
        


    
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
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
        

        
        
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
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
        

        
        
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
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
        

        
        
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
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
        
        
        
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
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
        

        
        
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
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
        

        
        
    }

    
    



}
-(void)SetUpShapAndColors
{
    
    NSData *firstcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSliderColorData"];
    UIColor *firstcolor = [NSKeyedUnarchiver unarchiveObjectWithData:firstcolorData];
    
    NSData *secondcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderColorData"];
    UIColor *secondcolor = [NSKeyedUnarchiver unarchiveObjectWithData:secondcolorData];
    
    NSData *thirdcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdSliderColorData"];
    UIColor *thirdcolor = [NSKeyedUnarchiver unarchiveObjectWithData:thirdcolorData];
    //Setup The button Round and Border width
    _btnFristGroup.layer.borderWidth = 4;
    _btnFristGroup.layer.cornerRadius=_btnFristGroup.layer.bounds.size.width/2;
    _btnSecondGroup.layer.borderWidth = 4;
    _btnSecondGroup.layer.cornerRadius=_btnSecondGroup.layer.bounds.size.width/2;
    _btnThirdGroup.layer.borderWidth =4;
    _btnThirdGroup.layer.cornerRadius=_btnThirdGroup.layer.bounds.size.width/2;
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstSliderColorDataChangeFlag"]) {
        firstcolor=[UIColor blueColor];
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"secondSliderColorDataChangeFlag"]) {
        
        secondcolor=[UIColor orangeColor];
        
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"thirdSliderColorDataChangeFlag"]) {
        thirdcolor=[UIColor greenColor];
        
    }
    [_btnFristGroup setTitleColor:firstcolor forState:UIControlStateNormal];
    _btnFristGroup.layer.borderColor =firstcolor.CGColor;
    //
    [_btnSecondGroup setTitleColor:secondcolor forState:UIControlStateNormal];
    _btnSecondGroup.layer.borderColor =secondcolor.CGColor;
    //
    [_btnThirdGroup setTitleColor:thirdcolor forState:UIControlStateNormal];
    _btnThirdGroup.layer.borderColor = thirdcolor.CGColor;
    
    
    
}
-(void)loadFirstLetter
{
    
    
    NSData *firstTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSliderTextData"];
    NSString *firsttext = [NSKeyedUnarchiver unarchiveObjectWithData:firstTextData];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstSliderTextDataChangeFlag"]) {
        firsttext=@"Sleep";
    }
    
    NSData *secondTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderTextData"];
    NSString *secondText = [NSKeyedUnarchiver unarchiveObjectWithData:secondTextData];
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"secondSliderTextDataChangeFlag"]) {
        
        secondText=@"Work";
        
    }
    
    NSData *thirdTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdSliderTextData"];
    NSString *thirdText = [NSKeyedUnarchiver unarchiveObjectWithData:thirdTextData];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"thirdSliderTextDataChangeFlag"]) {
        thirdText=@"Live";
        
    }
if(firsttext)
{
    self.lblFirstGroupLetter.text=[self ExtractFirstCharacter:firsttext];
}
    if(secondText)
    {
    self.lblSecondGroupLetter.text=[self ExtractFirstCharacter:secondText];
    }
    if(thirdText)
    {
    self.lblThirdGroupLetter.text=[self ExtractFirstCharacter:thirdText];
    }


}
-(NSString *)ExtractFirstCharacter:(NSString *)mystring
{    NSString *myfirstLetter;

    if(mystring.length>0)
    {
        myfirstLetter = [mystring substringToIndex:1];
    myfirstLetter=[myfirstLetter uppercaseString];
    }
    
        return myfirstLetter;

}

- (IBAction)btnFirstGroup:(id)sender{
    
    
    
    if (_btnFristGroup.tag==0) {
        [self DetermineWeekDay:@"0"];
    }
    else if (_btnFristGroup.tag==1)
    {
        [self DetermineWeekDay:@"1"];
    }
    else if (_btnFristGroup.tag==2)
    {
        [self DetermineWeekDay:@"2"];
    }
    else if (_btnFristGroup.tag==3)
    {
        [self DetermineWeekDay:@"3"];
    }
    else if (_btnFristGroup.tag==4)
    {
        [self DetermineWeekDay:@"4"];
    }

    else if (_btnFristGroup.tag==5)
    {
        [self DetermineWeekDay:@"5"];
    }

    else if (_btnFristGroup.tag==6)
    {
        [self DetermineWeekDay:@"6"];
    }

    AudioServicesPlaySystemSound (soundFileObject);


    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"FirstCircleSettingViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)btnSecondGroup:(id)sender{
    AudioServicesPlaySystemSound (soundFileObject);
    if (_btnFristGroup.tag==0) {
        [self DetermineWeekDay:@"0"];
    }
    else if (_btnFristGroup.tag==1)
    {
        [self DetermineWeekDay:@"1"];
    }
    else if (_btnFristGroup.tag==2)
    {
        [self DetermineWeekDay:@"2"];
    }
    else if (_btnFristGroup.tag==3)
    {
        [self DetermineWeekDay:@"3"];
    }
    else if (_btnFristGroup.tag==4)
    {
        [self DetermineWeekDay:@"4"];
    }
    
    else if (_btnFristGroup.tag==5)
    {
        [self DetermineWeekDay:@"5"];
    }
    
    else if (_btnFristGroup.tag==6)
    {
        [self DetermineWeekDay:@"6"];
    }

    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"SecondCircleSettingViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];

}
- (IBAction)btnThirdGroup:(id)sender{
    if (_btnFristGroup.tag==0) {
        [self DetermineWeekDay:@"0"];
    }
    else if (_btnFristGroup.tag==1)
    {
        [self DetermineWeekDay:@"1"];
    }
    else if (_btnFristGroup.tag==2)
    {
        [self DetermineWeekDay:@"2"];
    }
    else if (_btnFristGroup.tag==3)
    {
        [self DetermineWeekDay:@"3"];
    }
    else if (_btnFristGroup.tag==4)
    {
        [self DetermineWeekDay:@"4"];
    }
    
    else if (_btnFristGroup.tag==5)
    {
        [self DetermineWeekDay:@"5"];
    }
    
    else if (_btnFristGroup.tag==6)
    {
        [self DetermineWeekDay:@"6"];
    }

    AudioServicesPlaySystemSound (soundFileObject);

    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"ThirdCircleSettingViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}



- (IBAction)BtnGoFSuperHourSettingh:(id)sender
{// Put the CircleWidgetViewCOntroller object . btn.tag =index path in row for index
    // Set Up the Value here And Call From Where Ever You Want
    if (_btnFristGroup.tag==0) {
        [self DetermineWeekDay:@"0"];
    }
    else if (_btnFristGroup.tag==1)
    {
        [self DetermineWeekDay:@"1"];
    }
    else if (_btnFristGroup.tag==2)
    {
        [self DetermineWeekDay:@"2"];
    }
    else if (_btnFristGroup.tag==3)
    {
        [self DetermineWeekDay:@"3"];
    }
    else if (_btnFristGroup.tag==4)
    {
        [self DetermineWeekDay:@"4"];
    }
    
    else if (_btnFristGroup.tag==5)
    {
        [self DetermineWeekDay:@"5"];
    }
    
    else if (_btnFristGroup.tag==6)
    {
        [self DetermineWeekDay:@"6"];
    }
    AudioServicesPlaySystemSound (soundFileObject);

    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"SuperHourSCalcViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];


}

- (void)cancelLocalNotification:(NSString*)notificationID withDate:(NSDate *)NotificationDate {
    //loop through all scheduled notifications and cancel the one we're looking for
    UILocalNotification *cancelThisNotification = nil;
    BOOL hasNotification = NO;
    
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if(someNotification.fireDate ==NotificationDate) {
            cancelThisNotification = someNotification;
            hasNotification = YES;
            break;
        }
    }
    if (hasNotification == YES) {
        NSLog(@"%@ ",cancelThisNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:cancelThisNotification];
    }
}


- (IBAction)SwiSchedulAndCancelNotification:(id)sender {
    if(self.swSchesulAndCancelNotification.isOn==NO)
    self.view.backgroundColor=[UIColor grayColor];
    else
        self.view.backgroundColor=[UIColor whiteColor];

}
@end
