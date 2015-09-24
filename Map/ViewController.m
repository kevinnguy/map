//
//  ViewController.m
//  Map
//
//  Created by Kevin Nguy on 9/23/15.
//  Copyright © 2015 kevinnguy. All rights reserved.
//

#import "ViewController.h"

@import MapKit;

@import MapKit.MKAnnotation;

@interface MAPAnnotation : NSObject <MKAnnotation>

@end

@implementation MAPAnnotation

@synthesize coordinate;

@end

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager startUpdatingLocation];
    
    self.mapView.showsBuildings = NO;
    self.mapView.showsCompass = YES;
    self.mapView.showsPointsOfInterest = NO;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    [self.editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    
    MKCoordinateRegion region;
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.00625f;
    region.span.longitudeDelta = 0.00625f;
    [self.mapView setRegion:region animated:YES];
    
}

- (void)editButtonPressed:(id)sender {
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = self.mapView.centerCoordinate;
    [self.mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:mapView.centerCoordinate.latitude longitude:mapView.centerCoordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            self.addressLabel.text = @"Sorry, could not find the address.";
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            if (!placemark.subThoroughfare.length || !placemark.thoroughfare.length) {
                if (placemark.subAdministrativeArea.length) {
                    self.addressLabel.text = placemark.subAdministrativeArea;
                } else if (placemark.administrativeArea.length) {
                    self.addressLabel.text = placemark.administrativeArea;
                } else if (placemark.country.length) {
                    self.addressLabel.text = placemark.country;
                } else {
                    self.addressLabel.text = @"EARTH";
                }
                
                return;
            }
            
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@, %@ %@", placemark.subThoroughfare, placemark.thoroughfare, placemark.subAdministrativeArea, placemark.administrativeArea, placemark.postalCode];
        }
    }];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%@", view.description);

    MAPAnnotation *annotation= view.annotation;  // Get your annotaion here
    MKCoordinateRegion region = mapView.region;
    region.center.latitude=annotation.coordinate.latitude;
    region.center.longitude=annotation.coordinate.longitude;
    [mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // this part is boilerplate code used to create or reuse a pin annotation
    static NSString *viewId = @"MKPinAnnotationView";
    MKAnnotationView *annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:viewId];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:viewId];
    }
    
    // set your custom image
    annotationView.image = [UIImage imageNamed:@"circle"];
    return annotationView;
}


@end
