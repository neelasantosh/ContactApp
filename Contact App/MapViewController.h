//
//  MapViewController.h
//  Contact App
//
//  Created by Rajesh on 19/12/15.
//  Copyright © 2015 CDAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

-(void)onClickDone;
-(void)onLongPress:(UIGestureRecognizer *)gesture;

@property NSDictionary *selectedPlace;
@property CLLocation *location;
@end
