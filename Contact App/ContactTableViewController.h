//
//  ContactTableViewController.h
//  Contact App
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewController : UITableViewController<UIAlertViewDelegate>

@property NSMutableArray *arrayContacts;
@property int clickedIndex;
@end
