//
//  ViewController.m
//  Contact App
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
@interface ViewController ()

@end

@implementation ViewController

@synthesize textAddress,textEmail,textMobile,textName,imageView,labelLatLong,selectedPlace,location;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (location!=nil && selectedPlace != nil) {
        labelLatLong.text = [NSString stringWithFormat:@"%f, %f",location.coordinate.latitude,location.coordinate.longitude];
        textAddress.text = [NSString stringWithFormat:@"%@",[selectedPlace valueForKey:@"FormattedAddressLines"]];
        NSLog(@"%@",selectedPlace);
    }
}

- (IBAction)pickContact:(id)sender {
    
    ABPeoplePickerNavigationController *contactCon = [[ABPeoplePickerNavigationController alloc]init];
    contactCon.peoplePickerDelegate = self;
    [self presentViewController:contactCon animated:true completion:nil];
}

//delegate method to pick contact name ,email
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    NSLog(@"%@",person);
    
    // CFTypeRef x = ABRecordCopyValue(<#ABRecordRef record#>, <#ABPropertyID property#>);
    
    CFTypeRef cfTypeFName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    //convert core foundation type into NSstring
    
    NSString *fname = (__bridge_transfer NSString *)cfTypeFName;
    NSString *lname = (__bridge_transfer NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
    textName.text = [NSString stringWithFormat:@"%@ %@",fname,lname];
    
    //read multiple value phone no
    ABMultiValueRef phoneRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    long count = ABMultiValueGetCount(phoneRef);
    for (int i=0; i<count; i++) {
        CFTypeRef cfTypePhone = ABMultiValueCopyValueAtIndex(phoneRef, i);
        NSString *phone = (__bridge_transfer NSString *)cfTypePhone;
        textMobile.text = [NSString stringWithFormat:@"%@",phone];
        NSLog(@"%d, %@",i,phone);
    }
    
    ABMultiValueRef emailRef = ABRecordCopyValue(person, kABPersonEmailProperty);
    count = ABMultiValueGetCount(phoneRef);
    for (int i=0; i<count; i++) {
        CFTypeRef cfTypeEmail = ABMultiValueCopyValueAtIndex(emailRef, i);
        NSString *email = (__bridge_transfer NSString *)cfTypeEmail;
        textEmail.text = [NSString stringWithFormat:@"%@",email];
        NSLog(@"%d, %@",i,email);
    }
    [peoplePicker dismissViewControllerAnimated:true completion:nil];
}




- (IBAction)pickImage:(id)sender {
    UIImagePickerController *imageCon = [[UIImagePickerController alloc]init];
    imageCon.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; // setting gallery as image source
    //set delegate
    imageCon.delegate = self;
    imageCon.allowsEditing = true;
    
    [self presentViewController:imageCon animated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    imageView.image = image;
    [picker dismissViewControllerAnimated:true completion:nil];
    
}

- (IBAction)addToContacts:(id)sender {
    
    if(!([textName.text isEqualToString:@""] && [textMobile.text isEqualToString:@""] && [textMobile.text isEqualToString:@""]
        && imageView!= nil && [textAddress.text isEqualToString:@""]))
    {
        //save image
        NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
        
        NSString *imagePath =[NSString stringWithFormat:@"%@/%@.png",[arrayPath objectAtIndex:0],textMobile.text];
        NSFileManager *fileManger = [NSFileManager defaultManager];
        
        NSData *imageData = UIImagePNGRepresentation(imageView.image);
        [fileManger createFileAtPath:imagePath contents:imageData attributes:nil];
        
        //access ManagedObjectContext
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *objContext = [appdelegate managedObjectContext];
        //create new empty entity for student in object context
        NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:objContext];
        //set attributes values in empty object;
        [obj setValue:textName.text forKey:@"name"];
        [obj setValue:textMobile.text forKey:@"mobileno"];
        [obj setValue:textEmail.text forKey:@"email"];
        [obj setValue:textAddress.text forKey:@"address"];
        [obj setValue:textMobile.text forKey:@"image"];
        [obj setValue:[NSNumber numberWithFloat:location.coordinate.latitude]  forKey:@"latitude"];
        [obj setValue:[NSNumber numberWithFloat:location.coordinate.longitude]  forKey:@"longitude"];
        
        //save object in context
        NSError *error;
        BOOL result = [objContext save:&error];
        NSLog(@"result : %d , error : %@",result,error);
        if (result == true) {
            textName.text =@"";
            textMobile.text =@"";
            textEmail.text =@"";
            textAddress.text = @"";
            labelLatLong.text =@"Latitude,Longitude";
            imageView.image =nil;
            location = nil;
            selectedPlace = nil;
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error!!!" message:@"Please Enter all Information" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}
@end
