//
//  AppSettingViewController.m
//  TIMES
//Developed under the name of Code tent Development 
//  Created by Sami Shamsan on 1/5/15.
//  Copyright (c) 2015 com.Sami.Times. All rights reserved.
//

#import "AppSettingViewController.h"
#import "WishListEditViewController.h"
#import "SlidersColors.h"
#import "WLDetailViewController.h"
#import "NEOColorPickerViewController.h"
//FeedbackRelated
#import <MessageUI/MessageUI.h>
#import "SWRevealViewController.h"

@interface AppSettingViewController ()<UITextFieldDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
   BOOL isFirstEditingEnabled;
    BOOL isSecondEditingEnabled;
    BOOL isThirdEditingEnabled;
}
//Feadback related
@property(nonatomic,strong) MFMailComposeViewController *myFeedbackMailController;
@property(nonatomic,strong) MFMessageComposeViewController *myTellFriendsMessageController;


@end

@implementation AppSettingViewController
@synthesize currentColor = _currentColor;
@synthesize myFeedbackMailController;
@synthesize myTellFriendsMessageController;

- (void)viewDidLoad {
    [super viewDidLoad];
       //Delegate the Text
    
    
    
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
    
    
    self.txtFirstGroup.delegate=self;
    self.txtSecondGroup.delegate=self;
    self.txtThirdGroup.delegate=self;
    
    [self LoadData];
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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
if(textField==self.txtFirstGroup || textField==self.txtSecondGroup || textField ==self.txtThirdGroup )
{
    [self setFirstGroupText:self.txtFirstGroup.text];
    [self setSecondGroupText:self.txtSecondGroup.text];
    [self setThirdGroupText:self.txtThirdGroup.text];
    
    [textField resignFirstResponder];
    [self LoadText];
}
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)setFirstGroupColor:(UIColor *)color
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstSliderColorDataChangeFlag"];

    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"firstSliderColorData"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setSecondGroupColor:(UIColor *)color
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"secondSliderColorDataChangeFlag"];

    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"SecondSliderColorData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setThirdGroupColor:(UIColor *)color
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"thirdSliderColorDataChangeFlag"];

    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:@"ThirdSliderColorData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


// setting the text to the public
-(void)setFirstGroupText:(NSString *)mytext
{
    NSData *textData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstSliderTextDataChangeFlag"];
    
    [[NSUserDefaults standardUserDefaults] setObject:textData forKey:@"firstSliderTextData"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setSecondGroupText:(NSString *)mytext
{
    NSData *textData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"secondSliderTextDataChangeFlag"];
    
    [[NSUserDefaults standardUserDefaults] setObject:textData forKey:@"SecondSliderTextData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)setThirdGroupText:(NSString *)mytext
{
    NSData *textData = [NSKeyedArchiver archivedDataWithRootObject:mytext];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"thirdSliderTextDataChangeFlag"];
    
    [[NSUserDefaults standardUserDefaults] setObject:textData forKey:@"ThirdSliderTextData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



//========================================================================
#pragma mark - Load Data
//============================================================================

-(void)LoadData
{

    //Load Data
    [self LoadShapeAndColors];
    [self LoadText];
    [self LoadHoursValues];
}
-(void)LoadShapeAndColors
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
    //
    
    
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
    self.txtFirstGroup.text=firsttext;
    self.txtSecondGroup.text=secondText;
    self.txtThirdGroup.text=thirdText;
    
    
}
-(void)LoadHoursValues
{
    
    
    NSData *firstValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstValueData"];
    NSString *firstValue = [NSKeyedUnarchiver unarchiveObjectWithData:firstValueData];
    
    NSData *secondValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecondValueData"];
    NSString *secondValue = [NSKeyedUnarchiver unarchiveObjectWithData:secondValueData];
    
    NSData *thirdValueData = [[NSUserDefaults standardUserDefaults] objectForKey:@"ThirdValueData"];
    NSString *thirdValue = [NSKeyedUnarchiver unarchiveObjectWithData:thirdValueData];
    
    
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
//========================================================================
#pragma mark - Other Methods
//============================================================================
- (IBAction)GoToAlarmAndNotificationSetting:(id)sender {
    
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"AlarmAndNotificationViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    

    
}

- (IBAction)SetDefultColors:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstSliderColorDataChangeFlag"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"secondSliderColorDataChangeFlag"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"thirdSliderColorDataChangeFlag"];
    [self LoadShapeAndColors];
    
}

- (void)colorPickerViewController:(NEOColorPickerBaseViewController *)controller didSelectColor:(UIColor *)color {
 if(isFirstEditingEnabled==YES)
 {
    [self setFirstGroupColor:color];
    }
    if (isSecondEditingEnabled==YES)
    {
        [self setSecondGroupColor:color];

    }
    if(isThirdEditingEnabled==YES)
    {
        [self setThirdGroupColor:color];

    
    }
    [self LoadShapeAndColors];
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)colorPickerViewControllerDidCancel:(NEOColorPickerBaseViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(void)CallColorPick
{

    NEOColorPickerViewController *mycontroller = [[NEOColorPickerViewController alloc] init];
    mycontroller.delegate = self;
    mycontroller.selectedColor = self.currentColor;
    mycontroller.title = @"Colors";
    UINavigationController* navVC = [[UINavigationController alloc] initWithRootViewController:mycontroller];
    
    [self presentViewController:navVC animated:YES completion:nil];

}
- (IBAction)BtnFirstEditingEnabled:(id)sender {
    isFirstEditingEnabled=YES;
    isSecondEditingEnabled=NO;
    isThirdEditingEnabled=NO;
    [self CallColorPick];
}

- (IBAction)BtnSecondEditingEnabled:(id)sender {
    isSecondEditingEnabled=YES;
    isFirstEditingEnabled=NO;
    isThirdEditingEnabled=NO;
    [self CallColorPick];


}

- (IBAction)BtnThirdEditingEnbled:(id)sender {
    isThirdEditingEnabled=YES;
    isFirstEditingEnabled=NO;
    isSecondEditingEnabled=NO;
    [self CallColorPick];

}
//========================================================================
#pragma mark - FeedBack
//============================================================================
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            //Do Somthing
            break;
        case MFMailComposeResultSaved:
            //Do Somthing
            break;
        case MFMailComposeResultFailed:
            //Do Somthing
            break;
        case MFMailComposeResultSent:
        {
            UIAlertView *thanksAlert=[[UIAlertView alloc]initWithTitle:@"Thank You" message:@"Thank You For Your Feedback" delegate:self
                                                    cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
            
            [thanksAlert show];
            
            break;
        }
        default:
            break;
    }
[self dismissViewControllerAnimated:myFeedbackMailController completion:nil];

}
- (IBAction)Feedback:(id)sender {
    
    if([MFMailComposeViewController canSendMail]==YES)
    {
    myFeedbackMailController=[[MFMailComposeViewController alloc]init ];
    myFeedbackMailController.mailComposeDelegate=self;
    [myFeedbackMailController setSubject:@"Times Feedback Test"];
    NSArray *toRecipients=[[NSArray alloc]initWithObjects:@"eng.shamsan@gmail.com",@"mohammedalwadeai@yahoo.com",nil ];
    [myFeedbackMailController setToRecipients:toRecipients];
    NSString *SentFromApp=@"This is A Feedback test Email:\n i have been using Times for a quit while, it's amazingly helped me out to displine my Time. Thanks for the awsome Work. ";
    [myFeedbackMailController setMessageBody:SentFromApp isHTML:YES];
    [self presentViewController:myFeedbackMailController animated:YES completion:nil];
    }
    else
    {
    
        UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Your Device Can't Send Email" delegate:self
                                                cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
    
        [errorAlert show];
    }
    
    
}


//========================================================================
#pragma mark - Tell A friend
//============================================================================
- (IBAction)TellFriends:(id)sender {
    if([MFMessageComposeViewController canSendText]==YES)
    {
    myTellFriendsMessageController = [[MFMessageComposeViewController alloc] init];
    myTellFriendsMessageController.messageComposeDelegate = self;
    [myTellFriendsMessageController setRecipients: @[@" "]];
    [myTellFriendsMessageController setBody: @"Check out Time, Helped me A lot to Displine my Time"];
        [self presentViewController:myTellFriendsMessageController animated:YES completion:nil];

    }
    else
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        

    
    }
}

- (IBAction)GoToTourGuid:(id)sender {
    
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"TourLanchViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];

}

- (IBAction)RegisterEmail:(id)sender {
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"EmailRegestrationViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];

}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
        /*
        {UIAlertView *thanksAlert=[[UIAlertView alloc]initWithTitle:@"Thank You" message:@"Thank You For Telling Friends About Times" delegate:self
                                                  cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil ];
            
            [thanksAlert show];
            break;
        }
         */
            break;
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
