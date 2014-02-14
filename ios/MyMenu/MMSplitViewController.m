//
//  Copyright (C) 2014  MyMenu, Inc.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see [http://www.gnu.org/licenses/].
//

#import "MMSplitViewController.h"
#import "MMLocationManager.h"

@interface MMSplitViewController ()

@end

@implementation MMSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Get the Nav Controller for the Slider

    UINavigationController *navigationController = [self.viewControllers lastObject];
    self.delegate = (id) navigationController.topViewController;
    // Do any additional setup after loading the view.
    
    self.locationManager = [[MMLocationManager alloc] initWithConfigurationBlock:^(CLLocationManager *locationManager, NSArray *locations) {
        
        CLLocation *currentLocation = [locations lastObject];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kRetrievedUserLocation
                                                            object:currentLocation];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.locationManager startTrackingUserLocation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.locationManager stopTrackingUserLocation];
}
@end
