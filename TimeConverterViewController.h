//
//  TimeConverterViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 2/10/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeConverterViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIDatePicker *FirstPlaceTime;
@property (nonatomic, strong) IBOutlet UIDatePicker *SecondPlaceTime;

@property (nonatomic, strong) IBOutlet UILabel *lblFirstPlaceDate;
@property (nonatomic, strong) IBOutlet UILabel *lblSecondPlaceDate;


@property (nonatomic, strong) IBOutlet UILabel *lblIs;


@property (nonatomic, strong) IBOutlet UILabel *lblFirstCity;
@property (nonatomic, strong) IBOutlet UILabel *lblSecondCity;
- (IBAction)GoHome:(id)sender;

@end
