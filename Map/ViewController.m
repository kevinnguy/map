//
//  ViewController.m
//  Map
//
//  Created by Kevin Nguy on 9/23/15.
//  Copyright © 2015 kevinnguy. All rights reserved.
//

#import "ViewController.h"

@import MapKit;


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.showsBuildings = NO;
    self.mapView.showsCompass = YES;
    self.mapView.showsPointsOfInterest = NO;
    self.mapView.showsUserLocation = YES;
}


@end
