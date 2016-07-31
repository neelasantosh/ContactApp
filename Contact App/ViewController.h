//
//  ViewController.h
//  Contact App
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController<ABPeoplePickerNavigationControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *textName;
@property (strong, nonatomic) IBOutlet UITextField *textEmail;
@property (strong, nonatomic) IBOutlet UITextField *textMobile;
@property (strong, nonatomic) IBOutlet UITextView *textAddress;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *labelLatLong;
- (IBAction)pickContact:(id)sender;
- (IBAction)pickImage:(id)sender;
- (IBAction)addToContacts:(id)sender;

@property NSDictionary *selectedPlace;
@property CLLocation *location;

@end

