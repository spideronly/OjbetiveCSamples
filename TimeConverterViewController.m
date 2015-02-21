//
//  TimeConverterViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 2/10/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "TimeConverterViewController.h"
#import "SWRevealViewController.h"

@interface TimeConverterViewController ()
{
    NSString *FirstFullCity;
    NSString *SecondFullCity;
    
    


}
@end

@implementation TimeConverterViewController
@synthesize FirstPlaceTime,SecondPlaceTime;
@synthesize lblFirstPlaceDate,lblSecondPlaceDate,lblFirstCity,lblSecondCity,lblIs;

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self startImageViewAnimation];
    [self SlideMenu];
    
   
    [FirstPlaceTime addTarget:self action:@selector(firstChange:) forControlEvents:UIControlEventValueChanged];
    [SecondPlaceTime addTarget:self action:@selector(secondChange:) forControlEvents:UIControlEventValueChanged];
    //Setup The button Round and Border width
    lblIs.layer.borderWidth =2;
    lblIs.layer.cornerRadius=lblIs.layer.bounds.size.width/2;
 

}
-(void)GoToHome
{
    
    UIImage* image3 = [UIImage imageNamed:@"home-2-32.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self  action:@selector(GoHome:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *HomeButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=HomeButton;
    
    
}
- (void)GoHome:(UIBarButtonItem *)sender{
    
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
-(void)SlideMenu
{
    
    UIImage* image3 = [UIImage imageNamed:@"Slidericone2.png"];
    CGRect frameimg = CGRectMake(0, 0, image3.size.width, image3.size.height);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self.revealViewController  action:@selector(revealToggle:)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *slidebutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.leftBarButtonItem=slidebutton;
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // making up an IBOutlet called someLabel
    // making up a model method (description) that returns a string representing your model
    [self LoadText];
    
    FirstFullCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFullFirstCity"];
    SecondFullCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFullSecondCity"];
    
    
    // Set The time zone
    FirstPlaceTime.timeZone = [NSTimeZone timeZoneWithName:FirstFullCity];
    SecondPlaceTime.timeZone = [NSTimeZone timeZoneWithName:SecondFullCity];

    
}
//========================================================================
#pragma mark - Converter
//============================================================================

- (IBAction)firstChange:(id)sender {
    
    
    
    NSDate *myDate = FirstPlaceTime.date;

    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    lblFirstPlaceDate.text = prettyVersion;
    NSString *FirstCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFirstCity"];
    NSString *SecondCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedSecondCity"];

    if(FirstCity && SecondCity)
    {
        
        NSDateFormatter *dt1 = [[NSDateFormatter alloc] init];
        [dt1 setDateFormat:@"cccc, MMM d, hh:mm aa"];
        NSTimeZone *timeZone1 = [NSTimeZone timeZoneWithName:FirstFullCity];
        [dt1 setTimeZone:timeZone1];
        NSString *stringFromDate1 = [dt1 stringFromDate:myDate];
        lblFirstPlaceDate.text = stringFromDate1;

        
        NSDateFormatter *dt2 = [[NSDateFormatter alloc] init];
        [dt2 setDateFormat:@"cccc, MMM d, hh:mm aa"];
        NSTimeZone *timeZone2 = [NSTimeZone timeZoneWithName:SecondFullCity];
        [dt2 setTimeZone:timeZone2];
        NSString *stringFromDate2 = [dt2 stringFromDate:myDate];
        lblSecondPlaceDate.text = stringFromDate2;
        SecondPlaceTime.date= [dt2 dateFromString:stringFromDate2];
        
    
    
    }
    else
    {
       UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Enter Cities" message:@"PLease Enter Cities To compare !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [Alert show];

    
    }


}
- (IBAction)secondChange:(id)sender {
    
    
    
    NSDate *myDate = SecondPlaceTime.date;
    
    // Fill the Lable
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    lblSecondPlaceDate.text = prettyVersion;
    
    
    //Fetch The City Name For Display
    NSString *FirstCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFirstCity"];
    NSString *SecondCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedSecondCity"];
   

    if(FirstCity && SecondCity)
    {
        
        NSDateFormatter *dt2 = [[NSDateFormatter alloc] init];
        [dt2 setDateFormat:@"cccc, MMM d, hh:mm aa"];
        NSTimeZone *timeZone2 = [NSTimeZone timeZoneWithName:SecondFullCity];
        [dt2 setTimeZone:timeZone2];
        NSString *stringFromDate2 = [dt2 stringFromDate:myDate];
        lblSecondPlaceDate.text = stringFromDate2;
        
        NSDateFormatter *dt1 = [[NSDateFormatter alloc] init];
        [dt1 setDateFormat:@"cccc, MMM d, hh:mm aa"];
        NSTimeZone *timeZone1 = [NSTimeZone timeZoneWithName:FirstFullCity];
        [dt1 setTimeZone:timeZone1];
        NSString *stringFromDate1 = [dt1 stringFromDate:myDate];
        lblFirstPlaceDate.text = stringFromDate1;
        FirstPlaceTime.date= [dt1 dateFromString:stringFromDate1];
        
    }
    else
    {
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"Enter Cities" message:@"PLease Enter Cities To compare !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [Alert show];
        
        
    }

}
//========================================================================
#pragma mark - Load Data
//============================================================================
-(void)LoadText
{
    
    NSString *FirstCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedFirstCity"];
    if(!FirstCity)
        FirstCity=@"Not Set Yet";
    
    lblFirstCity.text=FirstCity;
    
    NSString *SecondCity=[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedSecondCity"];
    if(!SecondCity)
        SecondCity=@"Not Set Yet";
    
    lblSecondCity.text=SecondCity;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//========================================================================
#pragma mark -  Fetch the Cities
//============================================================================

-(IBAction)SingleTapFirstCity:(UITapGestureRecognizer *) recgnizer
{
   

    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"First" forKey:@"WhichCity"];
    
    //self.view.backgroundColor=[UIColor blueColor];
    
    // Navigate to UIViewController programaticly inside storyboard
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"WorlCitiesViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

-(IBAction)SingleTapSecondCity:(UITapGestureRecognizer *) recgnizer
{
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Second" forKey:@"WhichCity"];
    
    //self.view.backgroundColor=[UIColor blueColor];
    
    // Navigate to UIViewController programaticly inside storyboard
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"WorlCitiesViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}


@end
