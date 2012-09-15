//
//  LoadingView.m
//  bliep
//
//  Created by Tom Freijsen on 15-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "LoadingView.h"

@interface LoadingView()
@property (nonatomic) UIView *displayView;
@end

@implementation LoadingView

@synthesize displayView = _displayView;

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 230, 230)];
        _displayView.center = self.center;
        _displayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _displayView.layer.cornerRadius = 20;
        _displayView.layer.masksToBounds = YES;
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.frame = CGRectMake(self.displayView.frame.size.width / 2 - activityIndicator.frame.size.width / 2, self.displayView.frame.size.height / 2 - activityIndicator.frame.size.height / 2, activityIndicator.frame.size.width, activityIndicator.frame.size.height);
        [activityIndicator startAnimating];
        [_displayView addSubview:activityIndicator];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 230, 230)];
        [label setFont:[UIFont fontWithName:@"Museo" size:28.0f]];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Laden...";
        label.textColor = [UIColor whiteColor];
        //Shadow
        [label.layer setShadowColor:[UIColor blackColor].CGColor];
        [label.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
        [label.layer setShadowOpacity:0.7f];
        [label.layer setShadowRadius:0.0f];
        [_displayView addSubview:label];
        
        [self addSubview:_displayView];
        
        //Animate displayView
        
        [_displayView setAlpha:0.0f];
        [_displayView setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
        [UIView animateWithDuration:0.2 animations:^{
            [_displayView setAlpha:1.0f];
            [_displayView setTransform:CGAffineTransformIdentity];
        }];
        
    }
    return self;
}

- (void)removeFromSuperview {
    
    [UIView animateWithDuration:0.2 animations:^{
        [_displayView setAlpha:0.0f];
        [_displayView setTransform:CGAffineTransformMakeScale(0.8, 0.8)];
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
