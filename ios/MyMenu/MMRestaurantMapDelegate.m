//
//  MMRestaurantMapDelegate.m
//  MyMenu
//
//  Created by Connor Moreside on 2/9/2014.
//
//

#import "MMRestaurantMapDelegate.h"

@implementation MMRestaurantMapDelegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *AnnotationViewID = @"annotationViewID";
    static NSString *UserAnnotationViewID = @"userAnnotationViewID";
    
    NSString *annotationId;
    NSString *imageName;
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        annotationId = UserAnnotationViewID;
        imageName = @"CurrentLocation.png";
    }
    else {
        annotationId = AnnotationViewID;
        imageName = @"LocationMarker.png";
    }
    
    MKAnnotationView *annotationView = (MKAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:annotationId];
    
    if (annotationView == nil) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationId];
    }
    
    
    annotationView.image = [UIImage imageNamed:imageName];
    annotationView.annotation = annotation;
        
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews {
    for (MKAnnotationView *annView in annotationViews) {
        if ([annView.annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        
        CGRect endFrame = annView.frame;
        annView.frame = CGRectOffset(endFrame, 0, -500);
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             annView.frame = endFrame;
                         }];
    }
}

@end
