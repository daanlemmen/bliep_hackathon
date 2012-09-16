//
//  StateChangeButton.m
//  bliep
//
//  Created by Tom Freijsen on 15-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "StateChangeButton.h"
#import <QuartzCore/QuartzCore.h>

#define highlightedTextColor [UIColor colorWithWhite:227.0f/255.0f alpha:1.0f]
#define normalTextColor [UIColor colorWithWhite:227.0f/255.0f alpha:0.7f]

#define highlightedStrokeColor [UIColor colorWithRed:253.0f/255.0f green:244.0f/255.0f blue:0.0f alpha:1.0f]
#define normalStrokeColor [UIColor colorWithWhite:0.478 alpha:1.0]

@interface StateChangeButton()
@property (nonatomic) CGFloat strokeWidth;
@property (nonatomic, retain) UIView *pulseView;
@end

@implementation StateChangeButton

@synthesize highlighted = _highlighted;
@synthesize strokeWidth = _strokeWidth;
@synthesize pulseView = _pulseView;

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
    [self setTransform:CGAffineTransformMakeTranslation(0, -30)];
    
    //Shadow
    [self.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.layer setShadowOffset:CGSizeMake(0.0f, 1.0f)];
    [self.layer setShadowOpacity:0.75f];
    [self.layer setShadowRadius:1.0f];
    
    //Init pulseView
    _pulseView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    [_pulseView setBackgroundColor:highlightedStrokeColor];
    [_pulseView setUserInteractionEnabled:NO];
    [_pulseView.layer setCornerRadius:_pulseView.frame.size.width/2];
    [self insertSubview:_pulseView atIndex:0];
    //Create an overlaying black view
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    [blackView setUserInteractionEnabled:NO];
    [blackView.layer setCornerRadius:blackView.frame.size.width/2];
    [self insertSubview:blackView aboveSubview:_pulseView];
    
}

#pragma mark Properties

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    
    //Title label color
    if (highlighted) {
        [self setTitleColor:highlightedTextColor forState:UIControlStateNormal];
        [self setTitleColor:highlightedTextColor forState:UIControlStateDisabled];
        [self setStrokeWidth:5.0f];
        [self setEnabled:YES];
    } else {
        [self setTitleColor:normalTextColor forState:UIControlStateNormal];
        [self setTitleColor:normalTextColor forState:UIControlStateDisabled];
        [self setStrokeWidth:2.0f];
        [self setEnabled:YES];
    }
    
    [self setNeedsDisplay];
    
    [super setHighlighted:highlighted];
}

- (void)setStrokeWidth:(CGFloat)strokeWidth {
    
    [StateChangeButton animateWithDuration:0.3 animations:^{
        _strokeWidth = strokeWidth * 2.0f;
    }];
    
}

#pragma mark Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.1 animations:^{
        [_pulseView setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
    }];
    
    [super touchesBegan:touches withEvent:event];
    
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.3 animations:^{
        [_pulseView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }];
    
    [super touchesEnded:touches withEvent:event];
    
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [UIView animateWithDuration:0.3 animations:^{
        [_pulseView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    }];
    
    [super touchesCancelled:touches withEvent:event];
    
}

#pragma mark Drawing

- (void)drawRect:(CGRect)rect
{
    
    //Draw the circle with the border
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f)
                                                              radius:self.bounds.size.width / 2 - 10
                                                          startAngle:0.0
                                                            endAngle:2*M_PI
                                                           clockwise:YES];
    if (self.highlighted) {
        [circlePath setLineWidth:_strokeWidth];
        [[UIColor blackColor] setFill];
        [highlightedStrokeColor setStroke];
        [circlePath stroke];
    } else {
        [circlePath setLineWidth:_strokeWidth];
        [[UIColor blackColor] setFill];
        [normalStrokeColor setStroke];
        [circlePath stroke];
        [circlePath fill];
    }
    
}

@end
