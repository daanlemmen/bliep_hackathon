//
//  UIImage+Bliep.m
//  bliep
//
//  Created by Robbert van Ginkel on 16-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "UIImage+Bliep.h"

@implementation UIImage (Bliep)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
