//
//  ContactTableViewController.m
//  Contact App
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import "ContactTableViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface ContactTableViewController ()

@end

@implementation ContactTableViewController

@synthesize arrayContacts,clickedIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =@"Contact List";
   
}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate  = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *objContext = [appDelegate managedObjectContext];
    
    //prepare selection query request to fetch student
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Contact"];
    //execute fetch request
    NSError *error;
    //  NSArray *temparrayStudent = [objContext executeFetchRequest:request error:&error];
    arrayContacts = [[NSMutableArray alloc] initWithArray:[objContext executeFetchRequest:request error:&error]];
    if (error==nil) {
        [self.tableView reloadData];
    }
    else
    {
        NSLog(@"Error: %@",error);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [arrayContacts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    NSManagedObject *obj = [arrayContacts objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj valueForKey:@"name"];
    cell.detailTextLabel.text = [obj valueForKey:@"mobileno"];
    
    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    
    NSString *imagePath =[NSString stringWithFormat:@"%@/%@.png",[arrayPath objectAtIndex:0],[obj valueForKey:@"image"]];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL exists = [fileManger fileExistsAtPath:imagePath];
    if (exists) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    clickedIndex = (int)indexPath.row ;
    NSManagedObject *obj = [arrayContacts objectAtIndex:indexPath.row];
    NSString *name  = [obj valueForKey:@"name"];
    NSNumber *number = [obj valueForKey:@"mobileno"];
    NSString *email =  [obj valueForKey:@"email"];
    NSString *msg = [NSString stringWithFormat:@"Mobile No : %@\nEmail : %@ ",number,email];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:name message:msg delegate:self cancelButtonTitle:@"Close" otherButtonTitles:@"Call",@"Email",@"Show in Map", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSManagedObject *obj = [arrayContacts objectAtIndex:clickedIndex];
    NSString *name = [obj valueForKey:@"name"];
    NSNumber *number = [obj valueForKey:@"mobileno"];
    NSString *email =  [obj valueForKey:@"email"];
    float lat =  [[obj valueForKey:@"latitude"]floatValue];
    float longitude =  [[obj valueForKey:@"longitude"]floatValue];
    NSLog(@"%f ,%f",lat,longitude);
    NSString *address = [obj valueForKey:@"address"];
    NSLog(@"%@",address);
    NSLog(@"%@",number);

    if(buttonIndex == 1)
    {
        NSString *phoneNumber = [NSString stringWithFormat:@"telprompt://%@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
    if (buttonIndex ==2) {
        NSString *url = [NSString stringWithFormat: @"mailto:%@",email];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
    if (buttonIndex ==3) {
        Class mapItemClass = [MKMapItem class];
        if (mapItemClass && [mapItemClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)])
        {
            // Create an MKMapItem to pass to the Maps app
            CLLocationCoordinate2D coordinate =
            CLLocationCoordinate2DMake(lat, longitude);
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate
                                                           addressDictionary:nil];
            MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
            [mapItem setName:name];
            // Pass the map item to the Maps app
            [mapItem openInMapsWithLaunchOptions:nil];
        }

    }
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
