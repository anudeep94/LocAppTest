//
//  ViewController.m
//  LocationAppDemo
//
//  Created by vm mac on 21/06/2016.
//  Copyright © 2016 PytenLabs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark  *placemark;
    
}

@property (weak, nonatomic) IBOutlet UILabel *latitudeField;

@property (weak, nonatomic) IBOutlet UILabel *longitudeField;

@property (weak, nonatomic) IBOutlet UILabel *addressField;

- (IBAction)getCurrentLoaction:(id)sender;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])  {
        [locationManager requestWhenInUseAuthorization];
    }
    
    geocoder = [[CLGeocoder alloc]init];
    
//    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [locationManager requestAlwaysAuthorization];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getCurrentLocation:(id)sender {
    
    NSLog(@"%d",[CLLocationManager authorizationStatus]);
    
    
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{

    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to get your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _longitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _latitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _addressField.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 placemark.subThoroughfare, placemark.thoroughfare,
                                 placemark.postalCode, placemark.locality,
                                 placemark.administrativeArea,
                                 placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
    
}


@end
