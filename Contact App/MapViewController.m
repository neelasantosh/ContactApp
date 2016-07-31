//
//  MapViewController.m
//  Contact App
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import "MapViewController.h"
#import "ViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize mapView,selectedPlace,location;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Select Address";
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onClickDone)];
    self.navigationItem.rightBarButtonItem = doneButton;
    UILongPressGestureRecognizer *longPressGesture  = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onLongPress:)];
    [self.mapView addGestureRecognizer:longPressGesture];
    self.mapView.userInteractionEnabled = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onClickDone
{
 
    if(selectedPlace==nil || location==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Detail" message:@"Please select place using Long Press" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        ViewController *viewCon = [[self.navigationController viewControllers]objectAtIndex:0];
        viewCon.location = location;
        viewCon.selectedPlace = selectedPlace;
        
        [self.navigationController popViewControllerAnimated:true];
    }
}

-(void)onLongPress:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        CGPoint pointOfTouch = [gesture locationInView:mapView];
        //convert x,y t0 lat, long;
        CLLocationCoordinate2D loc= [mapView convertPoint:pointOfTouch toCoordinateFromView:mapView];
        
        //labelData.text = [NSString stringWithFormat:@"%f ,%f",loc.latitude,loc.longitude];
         location = [[CLLocation alloc]initWithLatitude:loc.latitude longitude:loc.longitude];
        CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *place= [placemarks objectAtIndex:0];
            //NSLog(@"Place: %@",selectedPlace.addressDictionary);
            selectedPlace = place.addressDictionary;
        }];
    }
}

@end
