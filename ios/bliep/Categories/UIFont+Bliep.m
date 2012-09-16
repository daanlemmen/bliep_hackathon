//
//  UIFont+Bliep.m
//  bliep
//
//  Created by Robbert van Ginkel on 16-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "UIFont+Bliep.h"

@implementation UIFont (Bliep)

+ (UIFont *)bliepFont {
    return [UIFont bliepFontWithSize:17];
}

+ (UIFont *)bliepFontWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Museo" size:fontSize];
}
@end
