//
//  AlarmListTableController.m
//  AlarmListTableController
//


#import "AlarmListTableController.h"
#import "AlarmObject.h"
#import "AddEditAlarmViewController.h"
#import "SWRevealViewController.h"

@implementation AlarmListTableController

@synthesize tableView;
@synthesize imageView;
@synthesize listOfAlarms;

//
// viewDidLoad
//
// Configures the table after it is loaded.
//
- (void)viewDidLoad
{
    
   //[self SlideMenu];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	tableView.rowHeight = 130;
	tableView.backgroundColor = [UIColor clearColor];
	imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *alarmListData = [defaults objectForKey:@"AlarmListData"];
    self.listOfAlarms = [NSKeyedUnarchiver unarchiveObjectWithData:alarmListData];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self SlideMenu];

    self.navigationItem.title = @"Personal Alarms";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self action:@selector(GoToAddEditAlarm)];//Personal Alarms

}
-(void)GoToAddEditAlarm
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"AddEditAlarmViewController"];
    
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
    
   
   
  //  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.listOfAlarms){
        
        return [self.listOfAlarms count];
    }
    else return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"AlarmListToEditAlarm" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"AlarmListToEditAlarm"])
    {
        AddEditAlarmViewController *controller = (AddEditAlarmViewController *)segue.destinationViewController;
        controller.indexOfAlarmToEdit = tableView.indexPathForSelectedRow.row;
        controller.editMode = YES;
    }
}
//
// tableView:cellForRowAtIndexPath:
//
// Returns the cell for a given indexPath.
//
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDateFormatter * dateReader = [[NSDateFormatter alloc] init];
    [dateReader setDateFormat:@"hh:mm a"];
    AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:indexPath.row];
    
    NSString *label = currentAlarm.label;
    BOOL enabled = currentAlarm.enabled;
    NSString *date = [dateReader stringFromDate:currentAlarm.timeToSetOff];
    
    
	UILabel *topLabel;
	UILabel *bottomLabel;
    UILabel *secondbottomLabel;

    UISwitch *enabledSwitch;

	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		//
		// Create the cell.
		//
		cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];

		//
		// Create the label for the top row of text
		//
		topLabel =
			[[UILabel alloc]
				initWithFrame:
              CGRectMake(14,5,170,40)];
		[cell.contentView addSubview:topLabel];

		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor blackColor];
		topLabel.highlightedTextColor = [UIColor whiteColor];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]+2];

		//
		// Create the label for the top row of text
		//
		bottomLabel =
			[[UILabel alloc]
				initWithFrame:
					CGRectMake(14,70,170,40)];
		[cell.contentView addSubview:bottomLabel];

        secondbottomLabel =
        [[UILabel alloc]
         initWithFrame:
         CGRectMake(14,60,170,40)];
        [cell.contentView addSubview:secondbottomLabel];


        
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.backgroundColor = [UIColor clearColor];
		bottomLabel.textColor = [UIColor blackColor];
		bottomLabel.highlightedTextColor = [UIColor whiteColor];
		bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        // Configure the properties for the text that are the same on every row
        //
        secondbottomLabel.backgroundColor = [UIColor clearColor];
        secondbottomLabel.textColor = [UIColor blackColor];
        secondbottomLabel.highlightedTextColor = [UIColor whiteColor];
        secondbottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];

        
        enabledSwitch = [[UISwitch alloc]
                         initWithFrame:
                         CGRectMake(250,45,170,40)];
        enabledSwitch.tag = indexPath.row;
        [enabledSwitch addTarget:self
                            action:@selector(toggleAlarmEnabledSwitch:)
                  forControlEvents:UIControlEventTouchUpInside];
		[cell.contentView addSubview:enabledSwitch];
        [enabledSwitch setOnTintColor:[UIColor blackColor]];
        [enabledSwitch setOn:enabled];
        topLabel.text = date;
        bottomLabel.text = label;
        
        NSString *SelectedTone= [[NSUserDefaults standardUserDefaults] objectForKey:@"PersonalAlarmSelectedToneFileNameData"];
        if(!SelectedTone)
        {       SelectedTone=@"Tone";
        }

      //  secondbottomLabel.text =SelectedTone ;


	}
		return cell;
}

-(void)toggleAlarmEnabledSwitch:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    //UITableViewCell *mycell =(UITableViewCell *)sender;

    if(mySwitch.isOn == NO)
    
   {

      // mycell.backgroundColor = [UIColor grayColor];
// Cancel Notification
       // God your name is enough , Amen Jesus Christ
       //++++++++++++++++++++++++++
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *eventArray = [app scheduledLocalNotifications];
        AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:mySwitch.tag];
        currentAlarm.enabled = NO;
        for (int i=0; i<[eventArray count]; i++)
        {
            UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
            NSDictionary *userInfoCurrent = oneEvent.userInfo;
            NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"notificationID"]];
            if ([uid isEqualToString:[NSString stringWithFormat:@"%li",mySwitch.tag]])
            {
                //Cancelling local notification            
                [app cancelLocalNotification:oneEvent];
                break;
            }
        }
        
    }
    else if(mySwitch.isOn == YES)
    {
     
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        AlarmObject *currentAlarm = [self.listOfAlarms objectAtIndex:mySwitch.tag];
        currentAlarm.enabled = YES;
        if (!localNotification)
            return;

        localNotification.repeatInterval = NSCalendarUnitDay;
        [localNotification setFireDate:currentAlarm.timeToSetOff];
        [localNotification setTimeZone:[NSTimeZone defaultTimeZone]];
        // Setup alert notification
        [localNotification setAlertBody:@"Alarm" ];
        [localNotification setAlertAction:@"Open App"];
        [localNotification setHasAction:YES];
        
        
        NSNumber* uidToStore = [NSNumber numberWithInt:currentAlarm.notificationID];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:uidToStore forKey:@"notificationID"];
        localNotification.userInfo = userInfo;
        
        // Schedule the notification
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    NSData *alarmListData2 = [NSKeyedArchiver archivedDataWithRootObject:self.listOfAlarms];
    [[NSUserDefaults standardUserDefaults] setObject:alarmListData2 forKey:@"AlarmListData"];
}




- (IBAction)DOne:(id)sender {
    // Navigate to UIViewController programaticly inside storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController  *vc =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];


}


- (IBAction)BtnAdd:(id)sender {
    [self GoToAddEditAlarm];
}


@end


