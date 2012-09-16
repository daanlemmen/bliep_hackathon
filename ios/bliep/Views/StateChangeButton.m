//
//  StateChangeButton.m
//  bliep
//
//  Created by Tom Freijsen on 15-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "StateChangeButton.h"

#define highlightedTextColor [UIColor colorWithWhite:227.0f/255.0f alpha:1.0f]
#define normalTextColor [UIColor colorWithWhite:227.0f/255.0f alpha:0.7f]

#define highlightedStrokeColor [UIColor colorWithRed:253.0f/255.0f green:244.0f/255.0f blue:0.0f alpha:1.0f]
#define normalStrokeColor [UIColor colorWithWhite:0.478 alpha:1.0]

@implementation StateChangeButton

@synthesize highlighted = _highlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [self initialize];
}

- (void)initialize {
    [self setHighlighted:NO];
    [self.titleLabel setFont:[UIFont bliepFontWithSize:27.0]];
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    
    //Title label color
    if (highlighted) {
        [self.titleLabel setTextColor:highlightedTextColor];
        [self setEnabled:NO];
    } else {
        [self.titleLabel setTextColor:normalTextColor];
        [self setEnabled:YES];
    }
    
    [self setNeedsDisplay];
    
    [super setHighlighted:highlighted];
}

- (void)setEnabled:(BOOL)enabled {
    if (self.highlighted) {
        [self.titleLabel setTextColor:highlightedTextColor];
    } else {
        [self.titleLabel setTextColor:normalTextColor];
    }
    
    [super setEnabled:enabled];
}

- (void)drawRect:(CGRect)rect
{
    
    //Draw the circle with the border
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f)
                                                              radius:self.bounds.size.width / 2 - 10
                                                          startAngle:0.0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    if (self.highlighted) {
        [circlePath setLineWidth:5.0f];
        [[UIColor blackColor] setFill];
        [highlightedStrokeColor setStroke];
        [circlePath fill];
        [circlePath stroke];
    } else {
        [circlePath setLineWidth:2.0f];
        [[UIColor blackColor] setFill];
        [normalStrokeColor setStroke];
        [circlePath fill];
        [circlePath stroke];
    }
    
}

@end
