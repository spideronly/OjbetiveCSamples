//
//  SuperHourSCalcViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 1/14/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "SuperHourSCalcViewController.h"
#import "EFCircularSlider.h"
@interface SuperHourSCalcViewController () <UIPickerViewDelegate>
{
    //Picker View
    IBOutlet UIPickerView *pickerView;
    NSMutableArray *hoursArray;
    NSTimeInterval interval;
    
    // Defining Some Custom circular Sliders
    EFCircularSlider* FirstGroupSlider;
    EFCircularSlider* SecondGroupSlider;
    EFCircularSlider* ThirdGroupSlider;
    
    // Define Tow Variables for the seek of calculating the the hour  correctly Not Equally
    int HourlableValue;
    int HourlableValueExtra;
    int TheLastSliderMoved;
    
// these Flags TO set up the locking system with the write filters
    
    BOOL isFirstTimeLocked;
    BOOL isSecondTimeLocked;
    BOOL isThirdTimeLocked;
    
    int ValueOfFirstTimeLocked;
    int ValueOfSecondTimeLocked;
    int ValueOfThirdTimeLocked;

    
    //
    
    BOOL isFirstButtonPressed;
    BOOL isSecondButtonPressed;
    BOOL isTHirdButtonPressed;
    BOOL isSlidersChange;

}
@property(retain, nonatomic) NSMutableArray *hoursArray;
@property(retain, nonatomic) NSMutableArray *hoursArrayAfterFirstSelection;

@end
int intialSecondArray;

@implementation SuperHourSCalcViewController
@synthesize lblFirstGroup,lblSecondGroup,lblThirdGroup,lblSuperHour;
//Picker View
@synthesize PVFIrstGroup,PVSecondGroup,PVThirdGroup;
@synthesize hoursArray,hoursArrayAfterFirstSelection;




- (void)viewDidLoad {
    
    [super viewDidLoad];
   // [self HidButtons];
    //[self ShowAllPickerViews];
    [self LoadData];
   // [self TapTwice];

}
#pragma mark load Date


-(void)LoadData
{    [self initilizeHoursArray:25];
     [self LoadNavigationTitle];
     [self SetUpShapAndColors];
     [self LoadText];
     NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
     NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];

     [self LoadHoursValues:WeekDays];
}


-(void)LoadNavigationTitle

{
    
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    if([WeekDays isEqualToString:@"0"])
    {
        self.Navitem.title=@"Mondays";
        
    }
    else if([WeekDays isEqualToString:@"1"])
    {
        //
        self.Navitem.title=@"Tuesdays";
    }
    else if([WeekDays isEqualToString:@"2"])
    {
        //
        self.Navitem.title=@"Wendsdays";
        
    }
    else if([WeekDays isEqualToString:@"3"])
    {
        //
        self.Navitem.title=@"Thursdays";
        
    }
    
    else if([WeekDays isEqualToString:@"4"])
    {
        //
        self.Navitem.title=@"Fridays";
        
        
    }
    else if([WeekDays isEqualToString:@"5"])
    {
        //
        self.Navitem.title=@"Sutardays";
        
    }
    else if([WeekDays isEqualToString:@"6"])
    {
        //
        
        self.Navitem.title=@"Sundays";
        
    }
    else
    {
        self.Navitem.title=@"Non";
        
        self.Navitem.title=@"SuperHour";
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
    
    
    lblSuperHour.layer.borderWidth = 4;
    lblSuperHour.layer.borderWidth = 4;
    lblSuperHour.layer.borderColor =[UIColor grayColor].CGColor;

    lblSuperHour.layer.cornerRadius=lblSuperHour.layer.bounds.size.width/2;
    
}
-(void)LoadText
{
    
    NSData *firstTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSliderTextData"];
    NSString *firsttext = [NSKeyedUnarchiver unarchiveObjectWithData:firstTextData];
    
    NSData *secondTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderTextData"];
    NSString *secondText = [NSKeyedUnarchiver unarchiveObjectWithData:secondTextData];
    
    NSData *thirdTextData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdSliderTextData"];
    NSString *thirdText = [NSKeyedUnarchiver unarchiveObjectWithData:thirdTextData];
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstSliderTextDataChangeFlag"]) {
        firsttext=@"Sleep";
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"secondSliderTextDataChangeFlag"]) {
        
        secondText=@"Work";
        
    }
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"thirdSliderTextDataChangeFlag"]) {
        thirdText=@"Live";
        
    }
    lblFirstGroup.text=firsttext;
    
    lblSecondGroup.text=secondText;
    lblThirdGroup.text=thirdText;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // making up an IBOutlet called someLabel
    // making up a model method (description) that returns a string representing your model
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    
    [self LoadHoursValues:WeekDays];

    
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
    
    
    
    
    NSInteger FirstselectedRow;
   // NSInteger SecondselectedRow ;
    //NSInteger ThirdselectedRow;
    
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
        NSLog(@"first Value row %@",firstValue);
        
        NSLog(@"second Value row %@",secondValue);
        NSLog(@"Third Value row %@",thirdValue);
        
        
       [PVFIrstGroup selectRow:[firstValue intValue] inComponent:0 animated:YES];
        
        [PVSecondGroup selectRow:[secondValue intValue] inComponent:0 animated:YES];
        
        [PVThirdGroup selectRow:[thirdValue intValue] inComponent:0 animated:YES];
        

        
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
  [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
         [lblSuperHour setText:thirdValue];
        
        
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
        NSLog(@"first Value row %@",firstValue);

        NSLog(@"second Value row %@",secondValue);
        NSLog(@"Third Value row %@",thirdValue);

        [PVFIrstGroup selectRow:[firstValue intValue] inComponent:0 animated:YES];
        [PVSecondGroup selectRow:[secondValue intValue] inComponent:0 animated:YES];
        [PVThirdGroup selectRow:[thirdValue intValue] inComponent:0 animated:YES];
        
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
         [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
         [lblSuperHour setText:thirdValue];        
        
       
        
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
        
        NSLog(@"first Value row %@",firstValue);
        
        NSLog(@"second Value row %@",secondValue);
        NSLog(@"Third Value row %@",thirdValue);
        
        [PVFIrstGroup selectRow:[firstValue intValue] inComponent:0 animated:YES];
        [PVSecondGroup selectRow:[secondValue intValue] inComponent:0 animated:YES];
        [PVThirdGroup selectRow:[thirdValue intValue] inComponent:0 animated:YES];
        

        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
        [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
         [lblSuperHour setText:thirdValue];        
        
        
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
        
        NSLog(@"first Value row %@",firstValue);
        
        NSLog(@"second Value row %@",secondValue);
        NSLog(@"Third Value row %@",thirdValue);
        
        FirstselectedRow = [hoursArray indexOfObject:firstValue ];
        NSLog(@"selected row %li",(long)FirstselectedRow);
        [PVFIrstGroup selectRow:[firstValue intValue] inComponent:0 animated:YES];
        [PVSecondGroup selectRow:[secondValue intValue] inComponent:0 animated:YES];
        [PVThirdGroup selectRow:[thirdValue intValue] inComponent:0 animated:YES];
        
        
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
  [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
         [lblSuperHour setText:thirdValue];        
        
        
        
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
        NSLog(@"first Value row %@",firstValue);
        
        NSLog(@"second Value row %@",secondValue);
        NSLog(@"Third Value row %@",thirdValue);
        
        [PVFIrstGroup selectRow:[firstValue intValue] inComponent:0 animated:YES];
        [PVSecondGroup selectRow:[secondValue intValue] inComponent:0 animated:YES];
        [PVThirdGroup selectRow:[thirdValue intValue] inComponent:0 animated:YES];
        
        
        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
  [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
         [lblSuperHour setText:thirdValue];        
        
        
        
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
        
        NSLog(@"first Value row %@",firstValue);
        
        NSLog(@"second Value row %@",secondValue);
        NSLog(@"Third Value row %@",thirdValue);
        
        [PVFIrstGroup selectRow:[firstValue intValue] inComponent:0 animated:YES];
        [PVSecondGroup selectRow:[secondValue intValue] inComponent:0 animated:YES];
        [PVThirdGroup selectRow:[thirdValue intValue] inComponent:0 animated:YES];
        
        

        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
  [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
         [lblSuperHour setText:thirdValue];        
        
        
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
        
        NSLog(@"first Value row %@",firstValue);
        
        NSLog(@"second Value row %@",secondValue);
        NSLog(@"Third Value row %@",thirdValue);
        [PVFIrstGroup selectRow:[firstValue intValue] inComponent:0 animated:YES];
        [PVSecondGroup selectRow:[secondValue intValue] inComponent:0 animated:YES];
        [PVThirdGroup selectRow:[thirdValue intValue] inComponent:0 animated:YES];

        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
  [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
         [lblSuperHour setText:thirdValue];        
        
        
        
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
        
        NSLog(@"first Value row %@",firstValue);
        
        NSLog(@"second Value row %@",secondValue);
        NSLog(@"Third Value row %@",thirdValue);
        
        [PVFIrstGroup selectRow:[firstValue intValue] inComponent:0 animated:YES];
        [PVSecondGroup selectRow:[secondValue intValue] inComponent:0 animated:YES];
        [PVThirdGroup selectRow:[thirdValue intValue] inComponent:0 animated:YES];

        [_btnFristGroup setTitle:firstValue forState:UIControlStateNormal];
        [_btnSecondGroup setTitle:secondValue forState:UIControlStateNormal];
  [_btnThirdGroup setTitle:thirdValue forState:UIControlStateNormal];
         [lblSuperHour setText:thirdValue];        
        
        
        
    }
    

    
    
    
    
    
    
}
//========================================================================
#pragma mark - Saving Values TO Public

//============================================================================

// setting the text to the public
-(void)setFirstGroupValue:(NSString *)mytext
{
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
   //Monday
    if([WeekDays isEqualToString:@"0"])
    { NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MondayfirstValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"MondayfirstValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Tuesday
   else if([WeekDays isEqualToString:@"1"])
    {
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];

        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TuesdayfirstValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"TuesdayfirstValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Wendsday
   else if([WeekDays isEqualToString:@"2"])
   {
       
       NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
       
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WendsadayfirstValueDataChangeFlag"];
       
       [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"WendsadayfirstValueData"];
       
       [[NSUserDefaults standardUserDefaults] synchronize];
   }
    //Thursday
   else if([WeekDays isEqualToString:@"3"])
   {
       
       NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
       
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ThursdayfirstValueDataChangeFlag"];
       
       [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"ThursdayfirstValueData"];
       
       [[NSUserDefaults standardUserDefaults] synchronize];
   }
    //Firday
   else if([WeekDays isEqualToString:@"4"])
   {
       NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
       
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FridayfirstValueDataChangeFlag"];
       
       [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"FridayfirstValueData"];
       
       [[NSUserDefaults standardUserDefaults] synchronize];}
   //Sutarday
   else if([WeekDays isEqualToString:@"5"])
   {
       NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
       
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SutardayfirstValueDataChangeFlag"];
       
       [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"SutardayfirstValueData"];
       
       [[NSUserDefaults standardUserDefaults] synchronize];}
   //Sunday
   else if([WeekDays isEqualToString:@"6"])
   {
       
       NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
       
       [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SundayfirstValueDataChangeFlag"];
       
       [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"SundayfirstValueData"];
       
       [[NSUserDefaults standardUserDefaults] synchronize];
   }
    else
    {
    NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstValueDataChangeFlag"];
    
    [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"firstValueData"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
-(void)setSecondGroupValue:(NSString *)mytext
{
    
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    //Monday
    if([WeekDays isEqualToString:@"0"])
    { NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MondaysecondValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"MondaysecondValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Tuesday
    else if([WeekDays isEqualToString:@"1"])
    {
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TuesdaysecondValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"TuesdaysecondValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Wendsday
    else if([WeekDays isEqualToString:@"2"])
    {
        
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WendsadaysecondValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"WendsadaysecondValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Thursday
    else if([WeekDays isEqualToString:@"3"])
    {
        
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ThursdaysecondValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"ThursdaysecondValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Firday
    else if([WeekDays isEqualToString:@"4"])
    {
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FridaysecondValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"FridaysecondValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];}
    //Sutarday
    else if([WeekDays isEqualToString:@"5"])
    {
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SutardaysecondValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"SutardaysecondValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];}
    //Sunday
    else if([WeekDays isEqualToString:@"6"])
    {
        
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SundaysecondValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"SundaysecondValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"secondValueDataChangeFlag"];
    
    [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"SecondValueData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setThirdGroupValue:(NSString *)mytext
{
    
    NSData *WeekDaysData = [[NSUserDefaults standardUserDefaults] objectForKey:@"WeekDayPublicLable"];
    NSString *WeekDays = [NSKeyedUnarchiver unarchiveObjectWithData:WeekDaysData];
    //Monday
    if([WeekDays isEqualToString:@"0"])
    { NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"MondaythirdValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"MondaythirdValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Tuesday
    else if([WeekDays isEqualToString:@"1"])
    {
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TuesdaythirdValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"TuesdaythirdValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Wendsday
    else if([WeekDays isEqualToString:@"2"])
    {
        
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WendsadaythirdValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"WendsadaythirdValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Thursday
    else if([WeekDays isEqualToString:@"3"])
    {
        
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ThursdaythirdValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"ThursdaythirdValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    //Firday
    else if([WeekDays isEqualToString:@"4"])
    {
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FridaythirdValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"FridaythirdValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];}
    //Sutarday
    else if([WeekDays isEqualToString:@"5"])
    {
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SutardaythirdValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"SutardaythirdValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];}
    //Sunday
    else if([WeekDays isEqualToString:@"6"])
    {
        
        NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SundaythirdValueDataChangeFlag"];
        
        [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"SundaythirdValueData"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
  
    NSData *valueData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"thirdSValueDataChangeFlag"];
    
    [[NSUserDefaults standardUserDefaults] setObject:valueData forKey:@"ThirdValueData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
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

-(NSString *)AutamticView:(NSString *)first withSecondValue:(NSString *)second withThirdValue:(NSString *)third

{
    int Subsum=[first intValue]+[second intValue]+[third intValue];
    int myremain;
    if(Subsum<=24)
    {
        if(Subsum>=0)
        {
        myremain=24-Subsum;
        int newTirdValue=[third intValue]+myremain;
        NSString *NewThirdValueString=[NSString stringWithFormat:@"%i",newTirdValue];
        [_btnThirdGroup setTitle:NewThirdValueString forState:(UIControlStateNormal)];
            [lblSuperHour setText:NewThirdValueString];

        [self setThirdGroupValue:NewThirdValueString];
        third=NewThirdValueString;
        }
        
    }
    else
    {
        myremain=Subsum-24;
        NSLog(@"my remain %i",myremain);
        int newTirdValue=[third intValue]- myremain;
        NSString *NewThirdValueString=[NSString stringWithFormat:@"%i",newTirdValue];
        [_btnThirdGroup setTitle:NewThirdValueString forState:(UIControlStateNormal)];
        [lblSuperHour setText:NewThirdValueString];

        [self setThirdGroupValue:NewThirdValueString];
        third=NewThirdValueString;
        
    
    }
    return third;
}
- (void)pickerView:(UIPickerView *)ThepickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //[PVFIrstGroup resignFirstResponder];
    
    int Sum;
    NSString *valueOne = [hoursArray objectAtIndex:[PVFIrstGroup selectedRowInComponent:0]];
    NSString *valueTwo = [hoursArray objectAtIndex:[PVSecondGroup selectedRowInComponent:0]];
    NSString *valueThree = [hoursArray objectAtIndex:[PVThirdGroup selectedRowInComponent:0]];
    NSString *FirstChanged=valueOne;
    NSString *SecondChanged=valueTwo;
    NSString *ThirdChanged=valueThree;

    Sum=[valueOne intValue]+[valueTwo intValue]+[valueThree intValue];
    NSLog(@"sum %i",Sum);
    NSString *myStr;
    if(ThepickerView==PVFIrstGroup)
    {
       myStr=[self AutamticView:FirstChanged withSecondValue:SecondChanged withThirdValue:ThirdChanged];
        if([myStr intValue] <0)
        {
            //[PVThirdGroup selectRow:0 inComponent:0 animated:YES];
            NSRange range = [myStr rangeOfString:@"-"];
            
            NSString *newString = [myStr substringFromIndex:range.location+1];

            int remain=[newString intValue];
            int result=[valueOne intValue]-remain;
            NSLog(@"Resulte is %i",result);
            [PVFIrstGroup selectRow:result inComponent:0 animated:YES];
            FirstChanged=[hoursArray objectAtIndex:result];
            [_btnFristGroup setTitle:[hoursArray objectAtIndex:result] forState:(UIControlStateNormal)];
            [PVThirdGroup selectRow:0 inComponent:0 animated:YES];

            ThirdChanged=@"0";
            [_btnThirdGroup setTitle:@"0" forState:(UIControlStateNormal)];
            
            [lblSuperHour setText:@"0"];
            [self setFirstGroupValue:FirstChanged];
            [self setSecondGroupValue:SecondChanged];
            [self setThirdGroupValue:ThirdChanged];

        }
        else
        {
            [PVThirdGroup selectRow:[myStr intValue] inComponent:0 animated:YES];

        [_btnThirdGroup setTitle:myStr forState:(UIControlStateNormal)];

        [_btnFristGroup setTitle:[hoursArray objectAtIndex:row] forState:(UIControlStateNormal)];
        
           FirstChanged=[hoursArray objectAtIndex:row];
            ThirdChanged=[hoursArray objectAtIndex:[PVThirdGroup selectedRowInComponent:0]];
            
            [lblSuperHour setText:myStr];
            [self setFirstGroupValue:FirstChanged];
            [self setSecondGroupValue:SecondChanged];
            [self setThirdGroupValue:ThirdChanged];
        }
    }
    if (ThepickerView==PVSecondGroup)
    {
        myStr= [self AutamticView:FirstChanged withSecondValue:SecondChanged withThirdValue:ThirdChanged];
        
        if([myStr intValue] <0)
        {
            //[PVThirdGroup selectRow:0 inComponent:0 animated:YES];
            NSRange range = [myStr rangeOfString:@"-"];
            
            NSString *newString = [myStr substringFromIndex:range.location+1];
            
            int remain=[newString intValue];
            int result=[valueTwo intValue]-remain;
            [PVSecondGroup selectRow:result inComponent:0 animated:YES];
            
            SecondChanged=[hoursArray objectAtIndex:result];

            [_btnSecondGroup setTitle:[hoursArray objectAtIndex:result] forState:(UIControlStateNormal)];
            ThirdChanged=@"0";
            [PVThirdGroup selectRow:0 inComponent:0 animated:YES];

            [_btnThirdGroup setTitle:@"0" forState:(UIControlStateNormal)];
            [lblSuperHour setText:@"0"];

            [self setFirstGroupValue:FirstChanged];
            [self setSecondGroupValue:SecondChanged];
            [self setThirdGroupValue:ThirdChanged];
        }
        else{
            [PVThirdGroup selectRow:[myStr intValue] inComponent:0 animated:YES];

         [_btnThirdGroup setTitle:myStr forState:(UIControlStateNormal)];
            [lblSuperHour setText:myStr];

         [_btnSecondGroup setTitle:[hoursArray objectAtIndex:row] forState:(UIControlStateNormal)];
            SecondChanged=[hoursArray objectAtIndex:row];

            ThirdChanged=[hoursArray objectAtIndex:[PVThirdGroup selectedRowInComponent:0]];

            //SecondChanged=[hoursArray objectAtIndex:row];
            [self setFirstGroupValue:FirstChanged];
            [self setSecondGroupValue:SecondChanged];
            [self setThirdGroupValue:ThirdChanged];
        }
    }
   
    /*else
    {
        [_btnThirdGroup setTitle:[hoursArray objectAtIndex:row] forState:(UIControlStateNormal)];
        [self setThirdGroupValue:[hoursArray objectAtIndex:row]];
            ThirdChanged=[hoursArray objectAtIndex:row];
        
        

    }*/
    int SumAfterChoose=[FirstChanged intValue]+[SecondChanged intValue]+[ThirdChanged intValue];
    if(SumAfterChoose==24)
    {
        //Save Data
        [self setFirstGroupValue:FirstChanged];
        [self setSecondGroupValue:SecondChanged];
        [self setThirdGroupValue:ThirdChanged];
        
    }
 
    
    
}
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    
   //
    
    // You must to Developt an agent for the selected row
    
    
    
}
-(void)calculateTimeFromPicker
{
    
    NSString *hoursStr = [NSString stringWithFormat:@"%@",[hoursArray objectAtIndex:[pickerView selectedRowInComponent:0]]];
    

    
    int hoursInt = [hoursStr intValue];
    
    
    
    NSLog(@" %d ", hoursInt);
    
}
-(void)initilizeHoursArray:(int)Length
{

    
    //initialize arrays
    hoursArray = [[NSMutableArray alloc] init];
    NSString *strVal = [[NSString alloc] init];
    
    for(int i=0; i<61; i++)
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

//========================================================================
#pragma mark - Other methods
//============================================================================


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Taps methods

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
        self.EditingView.hidden=YES;
        [self ShowButtons];
        [self HideLables];
        [self HideAllPickerViews];
       // [FirstGroupSlider removeFromSuperview];
       // [FirstGroupSlider setHidden:YES];
        NSLog(@"double tap");

    
    }
}

#pragma mark SLider Creation
-(void)CreateSLideWithValue
{
    /*
    NSData *firstGroupValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"secondSliderValueData"];
    int *firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstGroupValueData];
    

    [self CreateCircle:@"FirstGroupSlider" XValue: YValue:113 WithColor:myFirstSliderColor WithSliderID:1];
    [self CreateCircle:SecondGroupSlider XValue:115 YValue:113  WithColor:mySecondSliderColor WithSliderID:2];
    [self CreateCircle:ThirdGroupSlider XValue:220 YValue:113  WithColor:myThirdSliderColor WithSliderID:3];
    */


}
// Create and configure the Circles
-(void) CreateCircle: (EFCircularSlider *) CircleName XValue:(float)CircleX YValue:(float)CircleY WithColor:(UIColor *)CircleColor WithSliderID:(int)SliderID CurrentValue:(float)MyCurrentValue

{
    CGRect MySliderFrame = CGRectMake(CircleX, CircleY, 100, 100);
    CircleName = [[EFCircularSlider alloc] initWithFrame:MySliderFrame];
    CircleName.snapToLabels=YES;
    CircleName.unfilledColor =CircleColor;
    //Monday1stGroupSlider.unfilledColor = [UIColor colorWithRed:23/255.0f green:47/255.0f blue:70/255.0f alpha:1.0f];
    CircleName.filledColor = [UIColor whiteColor];
    //[Monday1stGroupSlider setInnerMarkingLabels:@[@"1", @"2", @"3", @"4", @"5"]];
    CircleName.labelFont = [UIFont systemFontOfSize:14.0f];
    CircleName.lineWidth = 6;
    CircleName.minimumValue = 0;
    CircleName.maximumValue = 24;
    CircleName.currentValue=MyCurrentValue;
    CircleName.sliderID=SliderID;
    CircleName.labelColor = [UIColor colorWithRed:76/255.0f green:123/255.0f blue:137/255.0f alpha:1.0f];
    CircleName.handleType = CircularSliderHandleTypeDoubleCircleWithClosedCenter;
    CircleName.handleColor = CircleName.filledColor;
    [self.EditingView addSubview:CircleName];
    [CircleName addTarget:self  action:@selector(HoursDidChange:) forControlEvents:UIControlEventValueChanged ];
    
}
-(void)RemoveSlider:(EFCircularSlider*)SliderName withID:(int)mySlideID
{

    [SliderName removeFromSuperview];


}
// Changing the values of lables
-(void)ChangeRelevantSlidersValues:(int)CurrentSliderID WithCurrentValue:(int)CurrentSliderValue
{
    isSlidersChange=YES;
    _btnFristGroup.userInteractionEnabled=NO;
    _btnSecondGroup.userInteractionEnabled=NO;
    _btnThirdGroup.userInteractionEnabled=NO;

    // Odd and Even Numbers adjasment
    int temp = (24-CurrentSliderValue);
    if (temp % 2) {
        HourlableValue = (temp-1)/2;
        HourlableValueExtra= (HourlableValue+1);
        
    }
    else
    {HourlableValue= temp/2;
        HourlableValueExtra= temp/2;
        
    }
    // Write the right amount of Hours calculated per every lable
    
    switch (CurrentSliderID) {
        case 1:
            TheLastSliderMoved=1;
           
                _lblFirstGroupValue.text = [NSString stringWithFormat:@"%d", CurrentSliderValue];
                _lblSecondGroupValue.text = [NSString stringWithFormat:@"%d",HourlableValue];
                _lblThirdGroupValue.text = [NSString stringWithFormat:@"%d", HourlableValueExtra];
                lblSuperHour.text = [NSString stringWithFormat:@"%d", HourlableValueExtra];

            
            break;
        case 2:
            TheLastSliderMoved=2;
            _lblSecondGroupValue.text = [NSString stringWithFormat:@"%d", CurrentSliderValue];
              _lblFirstGroupValue.text = [NSString stringWithFormat:@"%d",HourlableValue];
            
            _lblThirdGroupValue.text= [NSString stringWithFormat:@"%d", HourlableValueExtra];
            lblSuperHour.text = [NSString stringWithFormat:@"%d", HourlableValueExtra];
            
            break;
        case 3:
            TheLastSliderMoved=3;
           _lblThirdGroupValue.text = [NSString stringWithFormat:@"%d", CurrentSliderValue];
           _lblSecondGroupValue.text = [NSString stringWithFormat:@"%d",HourlableValueExtra];
             _lblFirstGroupValue.text = [NSString stringWithFormat:@"%d", HourlableValue];
            lblSuperHour.text = [NSString stringWithFormat:@"%d", CurrentSliderValue];
            
            break;
        default:
            break;
    }
    
}
//----------------------------------------
-(void)HoursDidChange:(EFCircularSlider*)slider {
    
    int newVal = (int)slider.currentValue ? (int)slider.currentValue : 24;
    switch (newVal) {
        case 1:
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 2:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 3:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 4:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 5:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            
            break;
        case 6:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            
            break;
        case 7:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 8:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 9:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            break;
        case 10:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            break;
        case 11:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 12:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 13:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            
            break;
        case 14:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 15:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
            
        case 16:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 17:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            break;
        case 18:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 19:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            
            break;
        case 20:
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            break;
        case 21:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 22:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 23:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            break;
        case 24:
            
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            
            break;
            
        default:
            [self ChangeRelevantSlidersValues:slider.sliderID WithCurrentValue:newVal];
            
            
            break;
    }
    
}
//------------
//---------------------------------------------

//========================================================================
#pragma mark - Show And HidHide
//============================================================================
//Show
-(void)ShowAllPickerViews
{
    PVSecondGroup.hidden=NO ;
    PVFIrstGroup.hidden=NO;
    PVThirdGroup.hidden=NO;
    

    
}
-(void)ShowFirstPickerViews
{
        PVFIrstGroup.hidden=NO;
    
}
-(void)ShowSecondPickerViews
{
    PVSecondGroup.hidden=NO ;
    
    
}
-(void)ShowThirdPickerViews
{
   
    PVThirdGroup.hidden=NO;
    
    
    
}
// Hide
-(void)HideAllPickerViews
{  PVSecondGroup.hidden=YES ;
    PVFIrstGroup.hidden=YES;
    PVThirdGroup.hidden=YES;
    
    
}
-(void)HideFirstPickerViews
{
    PVFIrstGroup.hidden=YES;
   
    
}
-(void)HideSecondPickerViews
{
    PVSecondGroup.hidden=YES;
    
    
}

-(void)HideThirdPickerViews
{
    PVThirdGroup.hidden=YES;
    
    
}



-(void)HideLables
{  _lblFirstGroupValue.hidden=YES ;
    _lblSecondGroupValue.hidden=YES;
    _lblThirdGroupValue.hidden=YES;
    
}
-(void)ShowLables
{
    _lblFirstGroupValue.hidden=NO;
    _lblSecondGroupValue.hidden=NO;
    _lblThirdGroupValue.hidden=NO;

}
-(void)HidButtons
{
    _btnFristGroup.hidden=YES;
    _btnSecondGroup.hidden=YES;
    _btnThirdGroup.hidden=YES;

}
-(void)ShowButtons
{
    _btnFristGroup.hidden=NO;
    _btnSecondGroup.hidden=NO;
    _btnThirdGroup.hidden=NO;
    _btnFristGroup.userInteractionEnabled=YES;
    _btnSecondGroup.userInteractionEnabled=YES;
    _btnThirdGroup.userInteractionEnabled=YES;

}
//========================================================================
#pragma mark - Buttona Action
//============================================================================
-(void)AfterButtonPressedValueInvestigator
{

    isFirstTimeLocked=NO;
    isSecondTimeLocked=NO;
    [hoursArray removeAllObjects];
    [self initilizeHoursArray:25];
    [self.PVFIrstGroup reloadAllComponents];
    [self.PVSecondGroup reloadAllComponents];
    [self.PVThirdGroup reloadAllComponents];


}


- (IBAction)btnFirstGroup:(id)sender forEvent:(UIEvent *)event {
    UITouch* touch = [[event allTouches] anyObject];
    NSString *currentFirstvalueToSave=_btnFristGroup.currentTitle;
    NSString *currentSecondvalueToSave=_btnSecondGroup.currentTitle;

    NSString *currentThirdvalueToSave=_btnThirdGroup.currentTitle;

    float CurrentFirstValue=[currentFirstvalueToSave floatValue];
    float CurrentSecondtValue=[currentSecondvalueToSave floatValue];
    float CurrentThirdValue=[currentThirdvalueToSave floatValue];
    [self HidButtons];
    [self ShowLables];
    [self ShowAllPickerViews];
    self.EditingView.hidden=NO;
    if (touch.tapCount == 1) {
 
        NSData *firstcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSliderColorData"];
        UIColor *firstcolor = [NSKeyedUnarchiver unarchiveObjectWithData:firstcolorData];
        NSData *secondcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderColorData"];
        UIColor *secondcolor = [NSKeyedUnarchiver unarchiveObjectWithData:secondcolorData];
        
        NSData *thirdcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdSliderColorData"];
        UIColor *thirdcolor = [NSKeyedUnarchiver unarchiveObjectWithData:thirdcolorData];
        
        //float btnX=(_btnFristGroup.frame.origin.x)-7;
        //float btnY=(_btnFristGroup.frame.origin.y)-7;
        [self CreateCircle:FirstGroupSlider XValue:5 YValue:5 WithColor:firstcolor WithSliderID:1 CurrentValue:CurrentFirstValue];
         [self CreateCircle:SecondGroupSlider XValue:100 YValue:5 WithColor:secondcolor WithSliderID:2 CurrentValue:CurrentSecondtValue];
         [self CreateCircle:FirstGroupSlider XValue:205 YValue:5 WithColor:thirdcolor WithSliderID:3 CurrentValue:CurrentThirdValue];
        //
       [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstMadeFixed"];
        
        
    
    }

    
    //Call The Lable Picker to pick up Value
    [self calculateTimeFromPicker];
    
    //show lables
    
    // Call Value Investigator
    [self AfterButtonPressedValueInvestigator];
  }

- (IBAction)btnSecondGroup:(id)sender forEvent:(UIEvent *)event {
    
    UITouch* touch = [[event allTouches] anyObject];
    NSString *currentFirstvalueToSave=_btnFristGroup.currentTitle;
    NSString *currentSecondvalueToSave=_btnSecondGroup.currentTitle;
    
    NSString *currentThirdvalueToSave=_btnThirdGroup.currentTitle;
    
    float CurrentFirstValue=[currentFirstvalueToSave floatValue];
    float CurrentSecondtValue=[currentSecondvalueToSave floatValue];
    float CurrentThirdValue=[currentThirdvalueToSave floatValue];
    [self HidButtons];
    [self ShowAllPickerViews];

    self.EditingView.hidden=NO;
    if (touch.tapCount == 1) {
        
        NSData *firstcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSliderColorData"];
        UIColor *firstcolor = [NSKeyedUnarchiver unarchiveObjectWithData:firstcolorData];
        NSData *secondcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderColorData"];
        UIColor *secondcolor = [NSKeyedUnarchiver unarchiveObjectWithData:secondcolorData];
        
        NSData *thirdcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdSliderColorData"];
        UIColor *thirdcolor = [NSKeyedUnarchiver unarchiveObjectWithData:thirdcolorData];
        
        //float btnX=(_btnFristGroup.frame.origin.x)-7;
        //float btnY=(_btnFristGroup.frame.origin.y)-7;
        [self CreateCircle:FirstGroupSlider XValue:5 YValue:0 WithColor:firstcolor WithSliderID:1 CurrentValue:CurrentFirstValue];
        [self CreateCircle:SecondGroupSlider XValue:100 YValue:0 WithColor:secondcolor WithSliderID:2 CurrentValue:CurrentSecondtValue];
        [self CreateCircle:FirstGroupSlider XValue:205 YValue:0 WithColor:thirdcolor WithSliderID:3 CurrentValue:CurrentThirdValue];
        //
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstMadeFixed"];
        
        
        
    }
    // Call Value Investigator
    [self AfterButtonPressedValueInvestigator];
}

- (IBAction)btnThirdGroup:(id)sender forEvent:(UIEvent *)event {\
    UITouch* touch = [[event allTouches] anyObject];
    NSString *currentFirstvalueToSave=_btnFristGroup.currentTitle;
    NSString *currentSecondvalueToSave=_btnSecondGroup.currentTitle;
    
    NSString *currentThirdvalueToSave=_btnThirdGroup.currentTitle;
    
    float CurrentFirstValue=[currentFirstvalueToSave floatValue];
    float CurrentSecondtValue=[currentSecondvalueToSave floatValue];
    float CurrentThirdValue=[currentThirdvalueToSave floatValue];
    [self HidButtons];
    [self ShowAllPickerViews];

    self.EditingView.hidden=NO;
    if (touch.tapCount == 1) {
        
        NSData *firstcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstSliderColorData"];
        UIColor *firstcolor = [NSKeyedUnarchiver unarchiveObjectWithData:firstcolorData];
        NSData *secondcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondSliderColorData"];
        UIColor *secondcolor = [NSKeyedUnarchiver unarchiveObjectWithData:secondcolorData];
        
        NSData *thirdcolorData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdSliderColorData"];
        UIColor *thirdcolor = [NSKeyedUnarchiver unarchiveObjectWithData:thirdcolorData];
        
        //float btnX=(_btnFristGroup.frame.origin.x)-7;
        //float btnY=(_btnFristGroup.frame.origin.y)-7;
        [self CreateCircle:FirstGroupSlider XValue:5 YValue:1 WithColor:firstcolor WithSliderID:1 CurrentValue:CurrentFirstValue];
        [self CreateCircle:SecondGroupSlider XValue:100 YValue:1 WithColor:secondcolor WithSliderID:2 CurrentValue:CurrentSecondtValue];
        [self CreateCircle:FirstGroupSlider XValue:205 YValue:1 WithColor:thirdcolor WithSliderID:3 CurrentValue:CurrentThirdValue];
        //
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstMadeFixed"];
        
        
        
    }
    // Call Value Investigator
    [self AfterButtonPressedValueInvestigator];

}
//========================================================================
#pragma mark - Long Press Gestures Methods
//============================================================================
-(void)UpdateArrays
{

    isFirstTimeLocked=YES;
    
    if(isFirstTimeLocked==YES)
    {
        if(isSecondTimeLocked==YES)
        {
            
            ValueOfSecondTimeLocked=[self.btnFristGroup.titleLabel.text   intValue];
            
            if(hoursArray>=0)
            {
                intialSecondArray=(intialSecondArray-ValueOfSecondTimeLocked)+1;
            }
            else
                
            {
                ValueOfThirdTimeLocked=0;
            
            }
            isSecondTimeLocked=NO;
            
            if(isThirdTimeLocked==YES)
            {
                if(hoursArray>=0)
                    intialSecondArray=(intialSecondArray-ValueOfSecondTimeLocked)+1;
                else
                    ValueOfThirdTimeLocked=0;
                
                
                
            }
        }
        // If Not
        else
        {
            if(hoursArray.count>23)
            {
                isSecondTimeLocked=NO;
            }
            else
            {
                
                isSecondTimeLocked=YES;
                ValueOfSecondTimeLocked=[self.btnFristGroup.titleLabel.text   intValue];
                intialSecondArray=((24-ValueOfFirstTimeLocked))+1;
                
                // intialSecondArray=(24-(ValueOfFirstTimeLocked+ValueOfSecondTimeLocked))+1;
                
            }
            // ValueOfFirstTimeLocked=[self.btnFristGroup.titleLabel.text   intValue];
            
            
        }
    }
    
    [hoursArray removeAllObjects];
    [self initilizeHoursArray:intialSecondArray];
    [self.PVFIrstGroup reloadAllComponents];
    [self.PVSecondGroup reloadAllComponents];
    [self.PVThirdGroup reloadAllComponents];


}

//IBAction For Long Pressed Gesture
-(IBAction)TapOnFristGroup:(UITapGestureRecognizer *) recgnizer
{
    [self HideFirstPickerViews];
    //Show Button
    _btnFristGroup.hidden=NO;
    
    // Set Up the lenghth of current array
    [self UpdateArrays];
    [self setFirstGroupValue:_btnFristGroup.titleLabel.text];
}
-(IBAction)TapOnSecondGroup:(UITapGestureRecognizer *) recgnizer
{
    [self HideSecondPickerViews];
    //Show Button
    _btnSecondGroup.hidden=NO;
    // SetUp Our Conditions and filter of the values between the Locked and Unloaced Mood
    [self UpdateArrays];
    [self setFirstGroupValue:_btnSecondGroup.titleLabel.text];

}
-(IBAction)TapOnThirdGroup:(UITapGestureRecognizer *) recgnizer
{
    [self HideThirdPickerViews];
    //Show Button
    _btnThirdGroup.hidden=NO;
    // SetUp Our Conditions and filter of the values between the Locked and Unloaced Mood
    [self UpdateArrays];
    [self setFirstGroupValue:_btnThirdGroup.titleLabel.text];

}
- (IBAction)Done:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];

}
@end
