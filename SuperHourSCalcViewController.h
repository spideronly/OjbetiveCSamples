//
//  SuperHourSCalcViewController.h
//  TIMES
//
//  Created by Sami Shamsan on 1/14/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SuperHourSCalcViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *EditingView;

@property (weak, nonatomic) IBOutlet UIButton *btnFristGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnSecondGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnThirdGroup;
@property (readwrite) IBOutlet UINavigationItem *Navitem;

@property (weak, nonatomic) IBOutlet UILabel *lblSuperHour;

@property (weak, nonatomic) IBOutlet UILabel *lblFirstGroup;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondGroup;
@property (weak, nonatomic) IBOutlet UILabel *lblThirdGroup;

@property (weak, nonatomic) IBOutlet UILabel *lblFirstGroupValue;
@property (weak, nonatomic) IBOutlet UILabel *lblSecondGroupValue;
@property (weak, nonatomic) IBOutlet UILabel *lblThirdGroupValue;


@property (weak, nonatomic) IBOutlet UIPickerView *PVFIrstGroup;
@property (weak, nonatomic) IBOutlet UIPickerView *PVSecondGroup;
@property (weak, nonatomic) IBOutlet UIPickerView *PVThirdGroup;

@property (strong, nonatomic) UILabel *dateLabel;
- (IBAction)btnFirstGroup:(id)sender forEvent:(UIEvent *)event;
- (IBAction)btnSecondGroup:(id)sender forEvent:(UIEvent *)event;
- (IBAction)btnThirdGroup:(id)sender forEvent:(UIEvent *)event;

- (IBAction)Done:(id)sender;

@end
