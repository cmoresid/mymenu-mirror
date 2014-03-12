//
//  UIImage+GreyscaleTransform.m
//  MyMenu
//
//  Created by Connor Moreside on 3/11/2014.
//
//

#import "UIImage+MMTransform.h"

@implementation UIImage (MMTransform)

+ (UIImage *)addRestrictionMask:(UIImage *)image {
    UIImage *greyscaleImage = [UIImage addGreyscaleFilterToImage:image];

    UIImage *restrictedImage = [UIImage imageNamed:@"restricted.png"];
    
    return [UIImage drawImage:restrictedImage inImage:greyscaleImage atPoint:CGPointMake(0, 0)];
}

+ (UIImage *)addGreyscaleFilterToImage:(UIImage *)image {
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

+ (UIImage *)drawImage:(UIImage *)fgImage inImage:(UIImage *)bgImage atPoint:(CGPoint)point {
    UIGraphicsBeginImageContextWithOptions(bgImage.size, FALSE, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    [fgImage drawInRect:CGRectMake(point.x, point.y, bgImage.size.width - 50, bgImage.size.height - 50)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
