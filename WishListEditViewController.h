//
//  WishListEditViewController.h
//  Wishlist
//
//  Created by Scott Leberknight on 10/8/12.
//  Copyright (c) 2012 Scott Leberknight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WishListEditViewController : UIViewController
{
    UITableView *tableView;
    UIImageView *imageView;
}
-(IBAction)addNewItem:(id)sender;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) NSMutableArray *listOfWishes;

@end

