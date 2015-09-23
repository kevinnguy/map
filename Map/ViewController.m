//
//  ViewController.m
//  Map
//
//  Created by Kevin Nguy on 9/23/15.
//  Copyright © 2015 kevinnguy. All rights reserved.
//

#import "ViewController.h"

@import MapKit;

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

//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
//    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 725, 725);
//    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    [self.locationManager stopUpdatingLocation];
//}

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

/*
 @property (nonatomic, readonly, copy, nullable) NSString *name; // eg. Apple Inc.
 @property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; // street name, eg. Infinite Loop
 @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
 @property (nonatomic, readonly, copy, nullable) NSString *locality; // city, eg. Cupertino
 @property (nonatomic, readonly, copy, nullable) NSString *subLocality; // neighborhood, common name, eg. Mission District
 @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // state, eg. CA
 @property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea; // county, eg. Santa Clara
 @property (nonatomic, readonly, copy, nullable) NSString *postalCode; // zip code, eg. 95014
 @property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode; // eg. US
 @property (nonatomic, readonly, copy, nullable) NSString *country; // eg. United States
 @property (nonatomic, readonly, copy, nullable) NSString *inlandWater; // eg. Lake Tahoe
 @property (nonatomic, readonly, copy, nullable) NSString *ocean; // eg. Pacific Ocean
 @property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *areasOfInterest; // eg. Golden Gate Park
 */
@end
