//
//  ParkingMemoryViewController.m
//  TIMES
//
//  Created by Sami Shamsan on 1/3/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "ParkingMemoryViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SWRevealViewController.h"

@interface ParkingMemoryViewController ()
{
//Button Animated
    BOOL isAnimated;
    BOOL isRemembering;
    NSString * GeneralTimeParked;
    NSString * GeneralParkedFor;
    NSString * GenealNotesAboutPatking;
    NSTimeInterval MyTimeInterval;
    int mins;
    NSTimer *ParkedFortimer;
    CustomAnnotation *item;
    float Parkinglatitude ;
    float Parkinglongitude;
    
    NSString *ParkedForTimerValue;
    
    NSTimer *silenceTimer;

    NSDate *timerDate;
}
@end

@implementation ParkingMemoryViewController

@synthesize mymapview,lblParkingCheckin ,lblCountUpParkingTimer,lblnotesAboutParking,lblParkedFor,lblTimeParked, txtNoteAboutParking,silenceTimer;

#pragma mark -  Data Fill Functions

//--------------------------------------------------------------------------------------------
// Answer the question: What time i parked
-(void)SetTimeParked
{
   
    // Set up the time we parked out in and show it to the lable
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm a"];
    
    //Write it out to the user
    lblTimeParked.text = [formatter stringFromDate:[NSDate date]];
   GeneralTimeParked = [formatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsParkingNow"];
    
    [[NSUserDefaults standardUserDefaults] setObject:GeneralTimeParked forKey:@"ParkingFor"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    
    if(!txtNoteAboutParking.text)
    {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isParkNote"];

    [[NSUserDefaults standardUserDefaults] setObject:@"No Notes." forKey:@"ParkNote"];


    }
    else{
    
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isParkNote"];
        
        [[NSUserDefaults standardUserDefaults] setObject:txtNoteAboutParking.text forKey:@"ParkNote"];
    
    }
    

}


// Answer the question: How long i have been parking in the current parking
-(void)SetParkedFor
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"IsParkingNow"]) {
    }
   /*
    else
    {
        
        
        NSDate *TimerOldFireDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"TimerStartSince"];
        NSDate *TimerNewFiredate=[NSDate date];
        // Assuming you have fistDate and secondDate
        // FInd the DIfference
        int myHour;
        int myMin;
        int mySec;
        NSDateFormatter *Oldformatter = [[NSDateFormatter alloc] init];
        [Oldformatter setDateFormat:@"hh"];
        NSString *OldHour = [Oldformatter stringFromDate:TimerOldFireDate];
        [Oldformatter setDateFormat:@"mm"];
        NSString *OldMin = [Oldformatter stringFromDate:TimerOldFireDate];
        [Oldformatter setDateFormat:@"ss"];
        NSString *OldSec= [Oldformatter stringFromDate:TimerOldFireDate];
        
        NSDateFormatter *Newformatter = [[NSDateFormatter alloc] init];
        [Newformatter setDateFormat:@"hh"];
        NSString *NewHour = [Newformatter stringFromDate:TimerNewFiredate];
        [Newformatter setDateFormat:@"mm"];
        NSString *NewMin= [Newformatter stringFromDate:TimerNewFiredate];
        [Newformatter setDateFormat:@"ss"];
        NSString *NewSec = [Newformatter stringFromDate:TimerNewFiredate];
        
        if([OldHour isEqualToString:NewHour])
        {
            // Do Nothing
            // Check the minute if diffrent
            if([OldMin isEqualToString:NewMin])
            {
                // Do Nothing
                if([OldSec isEqualToString:NewSec])
                {
                    
                    // Do Nothing
                }
                else
                {
                    
                    mySec=[OldSec intValue]-[NewSec intValue];
                }
            }
            else{
                
                myMin=[OldMin intValue]-[NewMin intValue];
                
            }
            
        }
        else
        {
            myHour=[OldHour intValue]-[NewHour intValue];
            
            
        }
        
        
        
        
        // Create date from the elapsed time
        NSDate *FinalDate =[self SetUpHourForDate:TimerNewFiredate WithHour:myHour withMin:myMin withSec:mySec];
        
        self.startDate=FinalDate;
    
    }
    */
    self.startDate = [NSDate date];

    [[NSUserDefaults standardUserDefaults] setObject:self.startDate forKey:@"TimerStartSince"];

    // Create the stop watch timer that fires every 100 ms
    self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                           target:self
                                                         selector:@selector(updateTimer)
                                                         userInfo:nil
                                                          repeats:YES];
    NSLog(@"stopWatchTimer%@",self.stopWatchTimer);

}

-(void)SetLablesVisble
{
    lblParkingCheckin.hidden=NO;
    //lblnotesAboutParking.hidden=NO;
    lblCountUpParkingTimer.hidden=NO;
    //
    lblTimeParked.hidden=NO;
    lblParkedFor.hidden=NO;
    
    txtNoteAboutParking.hidden=NO;
    
}

-(void)SetLablesInvisble
{
    txtNoteAboutParking.hidden=YES;
    
    lblParkingCheckin.hidden=YES;
    lblnotesAboutParking.hidden=YES;
    lblCountUpParkingTimer.hidden=YES;
    //
    //lblTimeParked.hidden=YES;
    lblParkedFor.hidden=YES;
    txtNoteAboutParking.hidden=NO;
    
}

#pragma mark - Assistance Methods


-(void)updateTimer
{

    // Create date from the elapsed time
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:self.startDate];
    timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // use this if you need it with milisecound
    // [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    
    //[dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setDateFormat:@"mm:ss"];

    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    lblParkedFor.text = timeString;

}
//Animate Remeber Button
-(void)AnimateTheButton
{
    
    
    [self.animatedView setTitle: @"Parking Spot" forState:UIControlStateNormal];
    [self.animatedView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.shadowAnimation = [JTSlideShadowAnimation new];
    self.shadowAnimation.animatedView = self.animatedView;
    self.shadowAnimation.shadowWidth = 40.;
    
}

//Use Vibrant Loading methdology

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [txtNoteAboutParking resignFirstResponder];
    //txtNoteAboutParking.text=@"";
    txtNoteAboutParking.hidden=YES;
    lblnotesAboutParking.text=txtNoteAboutParking.text;
    GenealNotesAboutPatking=txtNoteAboutParking.text;
    lblnotesAboutParking.hidden=NO;
    [[NSUserDefaults standardUserDefaults] setObject:txtNoteAboutParking.text forKey:@"ParkNote"];

    return YES;

}



//========================================================================
#pragma mark -Main Harbor
//============================================================================
//---------------------------------------------------------------------------------------------
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
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
    
    [self LoadData];
     [self updateTimer];
    [self SetLableRound];
    
    isRemembering = false;
    txtNoteAboutParking.delegate=self;
    //1- Use Vibrant Loading methdology
    //2-Animate the Main Button (Remeber / Forget)
    [self AnimateTheButton];
   // [self GoToHome];
   
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

//========================================================================
#pragma mark - Load Data
//============================================================================

-(void)LoadData
{
    
    
    [self loadMap];
    
if([ParkedFortimer isValid])
{
    // Create a date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // use this if you need it with milisecound
    // [dateFormatter setDateFormat:@"HH:mm:ss.SSS"];
    
    //[dateFormatter setDateFormat:@"HH:mm:ss"];
    [dateFormatter setDateFormat:@"mm:ss"];
    
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    
    // Format the elapsed time and set it to the label
    NSString *timeString = [dateFormatter stringFromDate:timerDate];
    lblParkedFor.text = timeString;
}
    [self LoadTheTimeParkedFor];
    [self LoadNote];
  //  [self LoadAndFireParkerFor];
    
    
    UIBackgroundTaskIdentifier bgTask;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    self.silenceTimer = [NSTimer scheduledTimerWithTimeInterval:300 target:self
                                                       selector:@selector(statLocationManager) userInfo:nil repeats:YES];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    isAnimated = YES;
    [self.shadowAnimation start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)loadMap
{
    // Settting The Map View
    self.mymapview.delegate=self;
    //Map Type
    [mymapview setMapType:MKMapTypeStandard];
    //
    //  [self statLocationManager];
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [mymapview setShowsUserLocation:YES];
        [mymapview setZoomEnabled:YES];
        [mymapview setScrollEnabled:YES];
        //[self.locationManager startUpdatingLocation];
        //[mymapview setShowsUserLocation:YES];
        // mymapview.showsUserLocation = YES;
        
    }
    //Map anotation self.mapAnnotations = [[NSMutableArray alloc] initWithCapacity:2];
    
    
    // annotation for Japanese Tea Garden
    item = [[CustomAnnotation alloc] init];
    item.place = @"Parking Location";
    item.imageName = @"ParkingMemory";
    item.coordinate = CLLocationCoordinate2DMake(Parkinglatitude, Parkinglongitude);
    
    [self.mapAnnotations addObject:item];
    [self gotoByAnnotationClass:[CustomAnnotation class]];
    


}
-(void)LoadAndFireParkerFor
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IsParkingNow"]) {
        
        
        
        NSDate *TimerOldFireDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"TimerStartSince"];
        NSDate *TimerNewFiredate=[NSDate date];
        // Assuming you have fistDate and secondDate
        // FInd the DIfference
        int myHour;
        int myMin;
        int mySec;
        NSDateFormatter *Oldformatter = [[NSDateFormatter alloc] init];
        [Oldformatter setDateFormat:@"hh"];
        NSString *OldHour = [Oldformatter stringFromDate:TimerOldFireDate];
        [Oldformatter setDateFormat:@"mm"];
        NSString *OldMin = [Oldformatter stringFromDate:TimerOldFireDate];
        [Oldformatter setDateFormat:@"ss"];
        NSString *OldSec= [Oldformatter stringFromDate:TimerOldFireDate];
        
        NSDateFormatter *Newformatter = [[NSDateFormatter alloc] init];
        [Newformatter setDateFormat:@"hh"];
        NSString *NewHour = [Newformatter stringFromDate:TimerNewFiredate];
        [Newformatter setDateFormat:@"mm"];
        NSString *NewMin= [Newformatter stringFromDate:TimerNewFiredate];
        [Newformatter setDateFormat:@"ss"];
        NSString *NewSec = [Newformatter stringFromDate:TimerNewFiredate];
        
        if([OldHour isEqualToString:NewHour])
        {
            // Do Nothing
            // Check the minute if diffrent
            if([OldMin isEqualToString:NewMin])
            {
                // Do Nothing
                if([OldSec isEqualToString:NewSec])
                {
                    
                    // Do Nothing
                }
                else
                {
                    
                    mySec=[OldSec intValue]-[NewSec intValue];
                }
            }
            else{
                
                myMin=[OldMin intValue]-[NewMin intValue];
                
            }
            
        }
        else
        {
            myHour=[OldHour intValue]-[NewHour intValue];
            
            
        }
        
        
        
        
        // Create date from the elapsed time
        NSDate *FinalDate =[self SetUpHourForDate:TimerNewFiredate WithHour:myHour withMin:myMin withSec:mySec];
        
        self.startDate=FinalDate;
        
        [[NSUserDefaults standardUserDefaults] setObject:self.startDate forKey:@"TimerStartSince"];
        
        // Create the stop watch timer that fires every 100 ms
        self.stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                               target:self
                                                             selector:@selector(updateTimer)
                                                             userInfo:nil
                                                              repeats:YES];
    }
    else
    {
        [self SetLablesEmpty];
    
    }
    
}

-(NSDate *)SetUpHourForDate:(NSDate *)myDate WithHour:(int)myhour withMin:(int)myMin withSec:(int)mySec
{
    
    
    
    // format
    NSDateFormatter *df = [NSDateFormatter new];
    [df setDateFormat:@"MM-dd-yyyy HH:mm"];
    
    NSString *stringFromDate = [df stringFromDate:myDate];
    //Create the date assuming the given string is in GMT
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    NSDate *date = [df dateFromString:stringFromDate];
    df.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[NSTimeZone localTimeZone].secondsFromGMT];
    
    //
    
    NSDate *oldDate =date;
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:oldDate];
    comps.hour   = myhour;
    comps.minute = myMin;
    comps.second = mySec;
    
    
    //Create a date string in the local timezone
    
    
    NSDate *newDate = [calendar dateFromComponents:comps];
    return newDate;
}
-(void)LoadNote
{
    NSString *parkNote = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkNote"];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isParkNote"]) {
        parkNote=@"Nothing";
    }
    
    
    
    lblnotesAboutParking.text=parkNote;
    
    
    
    
    
}
-(void)LoadTheTimeParkedFor
{
    
    NSString *TimeParked = [[NSUserDefaults standardUserDefaults] objectForKey:@"ParkingFor"];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"IsParkingNow"]) {
        TimeParked=@"";
    }
    
    
    //===============================================
    
    // Set Up the button if its parking now

    //===============================================
    
    // Set up the timer
    
    //----------------- 1-Get the date you parked in and get the current date
    //----------------- 2-Find the diffrence and store it in string
    //----------------- 3-FireUp The Timer With the same value as start
    
    
    // Set Up the Saved Location
    //----------------- 1- Intiate the map view with certain location x and y
    
    
    
    if(!TimeParked)
    {
        
        TimeParked=@"";
    }
    lblTimeParked.hidden=NO;
    lblTimeParked.text = TimeParked;
    
}

//========================================================================
#pragma mark -Other Methods
//============================================================================
//------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------

-(void)SetLableRound
{
    lblParkedFor.layer.cornerRadius=lblParkedFor.layer.bounds.size.width/2;
    lblParkedFor.layer.borderWidth = 2;
    


}

//Clear the whole string data
-(void)SetLablesEmpty
{
    GeneralTimeParked=@"";
    lblTimeParked.text=@"";
    GeneralParkedFor=@"";
    //lblParkedFor.text=@"00:00";
    GenealNotesAboutPatking=@"";
    lblnotesAboutParking.text=@"";
    // please Empty the stop watch as well
    
    [self.stopWatchTimer invalidate];
    self.stopWatchTimer = nil;
    //[self SetParkedFor];
}


//========================================================================
#pragma mark - Map Section
//============================================================================
- (MKCoordinateRegion)gotoDefaultLocation
{
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;

    NSLog(@"latitudete is  %+.6f",Parkinglatitude);
    NSLog(@"longtitude is  %+.6f",Parkinglongitude);

    newRegion.center.latitude = Parkinglatitude;
    newRegion.center.longitude = Parkinglongitude;
    
    newRegion.span.latitudeDelta = 10;
    newRegion.span.longitudeDelta = 0.2;
    
    return newRegion;
}
- (void)gotoByAnnotationClass:(Class)annotationClass
{
    // user tapped "City" button in the bottom toolbar
    for (id annotation in self.mapAnnotations)
    {
        if ([annotation isKindOfClass:annotationClass])
        {
            // remove any annotations that exist
            
            [self.mymapview removeAnnotations:self.mymapview.annotations];
            // add just the city annotation
            [self.mymapview addAnnotation:annotation];
            
            [self gotoDefaultLocation];
        }
    }
}

-(void)statLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone; //whenever we move
    self. locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
    [self.locationManager requestWhenInUseAuthorization]; // Add This Line
    
    
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    

// Get coordinate
    CLLocationCoordinate2D ParkingLocation=[userLocation coordinate];
    Parkinglongitude =ParkingLocation.longitude;
    Parkinglatitude =ParkingLocation.latitude;

// Zoom Region
    MKCoordinateRegion ZoomRegion=MKCoordinateRegionMakeWithDistance(ParkingLocation, 10, 10);
    
    
    
    //Show current parking location
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IsParkingNow"]) {
        // start off by default in San Francisco
        MKCoordinateRegion newRegion;
        
        NSLog(@"latitudete is  %+.6f",Parkinglatitude);
        NSLog(@"longtitude is  %+.6f",Parkinglongitude);
        
        newRegion.center.latitude = Parkinglatitude;
        newRegion.center.longitude = Parkinglongitude;
        
        newRegion.span.latitudeDelta = 10;
        newRegion.span.longitudeDelta = 0.2;
        CLLocationCoordinate2D memorizedLocation = (CLLocationCoordinate2D){.latitude = Parkinglatitude, .longitude = Parkinglongitude};
        
        newRegion=MKCoordinateRegionMakeWithDistance(memorizedLocation, 10, 10);
 [mymapview setMapType:MKMapTypeSatellite];

        [self.mymapview setRegion:newRegion animated:NO];
        
        
        [self.animatedView setTitle: @"Stop" forState:UIControlStateNormal];
        
        [self.animatedView setSelected:YES];
        

    }
    else
    {
        [mymapview setMapType:MKMapTypeStandard];

    [self.mymapview setRegion:ZoomRegion animated:YES];
    }
    mymapview.showsUserLocation=NO;
 // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    [self.mymapview addAnnotation:point];

}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    [self.locationManager stopUpdatingLocation ];

    CLLocation* location = [locations lastObject];
    Parkinglatitude= location.coordinate.latitude;
    Parkinglongitude= location.coordinate.longitude;
}





// Show the Anotation with Picture
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
    MKPinAnnotationView *pinView =
    (MKPinAnnotationView *)[mymapview dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
    if (!pinView)
    {
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                         reuseIdentifier:SFAnnotationIdentifier];
        UIImageView *imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location-alt-512.png"]];
        [imgV setFrame:CGRectMake(0, 0, 40, 40)];
        // You may need to resize the image here.
        annotationView.image = imgV.image;
        return annotationView;
    }
    else
    {
        pinView.annotation = annotation;
    }
    return pinView;
}
#pragma  mark - AllAboutButton
// UI Action

-(void)ProcessForget
{
    
    [self.animatedView setTitle: @"Parking Sopt" forState:UIControlStateNormal];
      [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"IsParkingNow"];
   // [self SetLablesInvisble];
    [mymapview setMapType:MKMapTypeStandard];
    //Empty The Lables and General String Varibles
   [self SetLablesEmpty];
    isRemembering=NO;
    
    

}
-(void)ProcessRemember
{

  

    [self.animatedView setTitle: @"Stop" forState:UIControlStateNormal];
    [self SetLablesVisble];
    [mymapview setMapType:MKMapTypeSatellite];
    //what time i parked my Car.
    [self SetTimeParked];
    //How long I parked the Car For?
    [self SetParkedFor];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsParkingNow"];

    //Turn On The Remembering Session
    isRemembering=YES;
    //Stop Updating User Location

}
- (IBAction)Remember:(id)sender {
    
   
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"IsParkingNow"])
        {
        
            [sender setSelected:NO];

        }
        else
        {
        
            [sender setSelected:YES];

        }
    
    if([sender isSelected]){
        //...
        [self ProcessRemember];
        [sender setSelected:NO];
        txtNoteAboutParking.text=@"";

    } else {
        
        txtNoteAboutParking.hidden=NO;
        [self ProcessForget];

        [sender setSelected:YES];
        
    }


    
}



- (IBAction)Done:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
