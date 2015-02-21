//
//  ParkingMemoryViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 1/3/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JTSlideShadowAnimation.h"
#import "CustomAnnotation.h"        // annotation for the Tea Garden


@interface ParkingMemoryViewController : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>




@property (nonatomic, retain) NSTimer *silenceTimer;
//Button Animation
@property (strong, nonatomic) JTSlideShadowAnimation *shadowAnimation;
@property (weak, nonatomic) IBOutlet UIButton *animatedView;
//Map Properties
@property (weak, nonatomic) IBOutlet MKMapView *mymapview;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;

//Static Labels
@property (weak, nonatomic) IBOutlet UILabel *lblParkingCheckin;
@property (weak, nonatomic) IBOutlet UILabel *lblCountUpParkingTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblnotesAboutParking;
//Note Text Field
@property (weak, nonatomic) IBOutlet UITextField *txtNoteAboutParking;
//Dynamic Labels
@property (weak, nonatomic) IBOutlet UILabel *lblTimeParked;
@property (weak, nonatomic) IBOutlet UILabel *lblParkedFor;
//Stop Watch Timer to calculate the time since we parked
@property (strong, nonatomic) NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
// Sart Date when we pressed remember
@property (strong, nonatomic) NSDate *startDate; // Stores the date of the click on the start button


- (IBAction)Done:(id)sender;
@property (strong, nonatomic) CLGeocoder *geocoder;
- (IBAction)Remember:(id)sender;
- (IBAction)GoHome:(id)sender;

@end
