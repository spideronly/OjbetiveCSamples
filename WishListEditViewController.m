//
//  WLItemsViewController.m
//  Wishlist
//
//  Created by Scott Leberknight on 10/8/12.
//  Copyright (c) 2012 Scott Leberknight. All rights reserved.
//
#import "WishListEditViewController.h"

#import "WLDetailViewController.h"
#import "WLItemStore.h"
#import "WLImageStore.h"


@interface WishListEditViewController ()

@end

@implementation WishListEditViewController

@synthesize tableView;
@synthesize imageView;
@synthesize listOfWishes;

-(IBAction)addNewItem:(id)sender {
    WLItem *newItem = [[WLItemStore defaultStore] createItem];
    
    WLDetailViewController *detailViewController = [[WLDetailViewController alloc] initForNewItem:YES];
    [detailViewController setItem:newItem];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:navController animated:YES completion:nil];
}


//
// viewDidLoad
//
// Configures the table after it is loaded.
//
- (void)viewDidLoad
{
    //
   
    

    
    //
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.rowHeight = 70;
    tableView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"gradientBackground.png"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *wishListData = [defaults objectForKey:@"WishListData"];
    self.listOfWishes = [NSKeyedUnarchiver unarchiveObjectWithData:wishListData];

    
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}





//-------------------------------------------------------------------------------------

#pragma mark Table View Data Source methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[WLItemStore defaultStore] allItems] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Check for a reusable cell first
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    // If there isn't a reusable cell, then create one
    if (!cell) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleSubtitle
                reuseIdentifier:@"UITableViewCell"];
    }
    
    // Set text and detail text labels on cell
    WLItem *item = [[[WLItemStore defaultStore] allItems] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[item itemName]];
    NSString *details = [NSString stringWithFormat:@"%@ ",
                         [item occasion]];
    [[cell detailTextLabel] setText:details];
    
       //
    NSString *imageKey = [item imageKey];
    UIImage *originalImage = [[WLImageStore defaultStore] imageForKey:imageKey];
    
    // Resize the image
    CGSize cellViewSize = CGSizeMake(46.0, 46.0);
    CGRect cellViewRect = [WLImageStore rectForImage:originalImage withSize:cellViewSize];
    UIGraphicsBeginImageContext(cellViewSize);
    [originalImage drawInRect:cellViewRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    [[cell imageView] setImage:resizedImage];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Remove item from store
        WLItemStore *store = [WLItemStore defaultStore];
        NSArray *items = [store allItems];
        WLItem *item = [items objectAtIndex:[indexPath row]];
        [store removeItem:item];
        
        // Remove item from table view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    [[WLItemStore defaultStore] moveItemAtIndex:(uint32_t)[sourceIndexPath row] toIndex:(uint32_t)[destinationIndexPath row]];
}
//1. Pass-------------------------------------------------------------------------------------------------
#pragma mark Table View Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // [self performSegueWithIdentifier:@"WishListToEditWish" sender:self];
    WLDetailViewController *detailViewController = [[WLDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[WLItemStore defaultStore] allItems];
    WLItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    // Ensure detail view controller has a pointer to the selected item
    [detailViewController setItem:selectedItem];
    
    
    [self presentViewController:detailViewController animated:YES completion:nil];
    
    
}












@end
