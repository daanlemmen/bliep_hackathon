//
//  ViewController.m
//  bliep
//
//  Created by Daan Lemmen on 14-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "ViewController.h"
#import "BliepAPI.h"
#import <QuartzCore/QuartzCore.h>
#import "LoadingView.h"

@interface ViewController ()
@end

@implementation ViewController

@synthesize connectionData, connectionType;

- (void)viewDidLoad
{
    
    stateLabel.font = [UIFont fontWithName:@"Museo" size:17];
    balanceLabel.font = [UIFont fontWithName:@"Museo" size:17];
    calltimeLabel.font = [UIFont fontWithName:@"Museo" size:17];
    
    [[pauseButton titleLabel] setFont:[UIFont fontWithName:@"Museo" size:17]];
    [[bliepButton titleLabel] setFont:[UIFont fontWithName:@"Museo" size:17]];
    [[bliepplusButton titleLabel] setFont:[UIFont fontWithName:@"Museo" size:17]];
    
    [super viewDidLoad];
    api = [[BliepAPI alloc] init];
    
    // Set cached Data
    NSDictionary *cachedData = [BliepAPI getAccountInfoFromUserDefaults];
    
    if (cachedData){
        stateLabel.text = [cachedData objectForKey:@"state"];
        if ([[cachedData objectForKey:@"state"] isEqualToString:@"pause"]) {
            [pauseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [bliepButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [bliepplusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        } else if ([[cachedData objectForKey:@"state"] isEqualToString:@"bliep"]) {
            [pauseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [bliepButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [bliepplusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        } else if ([[cachedData objectForKey:@"state"] isEqualToString:@"bliep-plus"]) {
            [pauseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [bliepButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [bliepplusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        }
        balanceLabel.text = [NSString stringWithFormat:@"€ %@", [cachedData objectForKey:@"balance"]];
        NSString *seconds = [NSString stringWithFormat:@"%@", [[cachedData objectForKey:@"calltime"] objectForKey:@"seconds"]];
        if ([seconds length] == 1)
            seconds = [@"0" stringByAppendingString:seconds];
        calltimeLabel.text = [NSString stringWithFormat:@"%@:%@", [[cachedData objectForKey:@"calltime"] objectForKey:@"minutes"], seconds];
    }else {
        stateLabel.text = @"";
        balanceLabel.text = @"";
        calltimeLabel.text = @"";
    }
    [pauseButton setEnabled:NO];
    [bliepButton setEnabled:NO];
    [bliepplusButton setEnabled:NO];
    
    if ([[BliepAPI getTokenFromUserDefaults] length] > 0){
        [self getAccountInfo:nil];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)getAccountInfo:(id)sender {
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    [api getAccountInfoWithToken:[BliepAPI getTokenFromUserDefaults] andCompletionBlock:^(NSDictionary *dict) {
        NSLog(@"%@", dict);
        BOOL succes = [[dict objectForKey:@"success"] boolValue];
        if (succes == YES) {
            // Get account info
            NSDictionary *result = [dict objectForKey:@"result"];
            stateLabel.text = [result objectForKey:@"state"];
            if ([[result objectForKey:@"state"] isEqualToString:@"pause"]) {
                [pauseButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [bliepButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bliepplusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            } else if ([[result objectForKey:@"state"] isEqualToString:@"bliep"]) {
                [pauseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bliepButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [bliepplusButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            } else if ([[result objectForKey:@"state"] isEqualToString:@"bliep-plus"]) {
                [pauseButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bliepButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [bliepplusButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            balanceLabel.text = [NSString stringWithFormat:@"€ %@", [result objectForKey:@"balance"]];
            NSString *seconds = [NSString stringWithFormat:@"%@", [[result objectForKey:@"calltime"] objectForKey:@"seconds"]];
            if ([seconds length] == 1)
                seconds = [@"0" stringByAppendingString:seconds];
            calltimeLabel.text = [NSString stringWithFormat:@"%@:%@", [[result objectForKey:@"calltime"] objectForKey:@"minutes"], seconds];
            if ([[result objectForKey:@"state"] isEqualToString:@"pause"]){
                [pauseButton setEnabled:NO];
                [bliepButton setEnabled:YES];
                [bliepplusButton setEnabled:YES];
            }else if ([[result objectForKey:@"state"] isEqualToString:@"bliep"]){
                [pauseButton setEnabled:YES];
                [bliepButton setEnabled:NO];
                [bliepplusButton setEnabled:YES];
            }else if ([[result objectForKey:@"state"] isEqualToString:@"bliep-plus"]){
                [pauseButton setEnabled:YES];
                [bliepButton setEnabled:YES];
                [bliepplusButton setEnabled:NO];
            }
            [BliepAPI setAccountInfo:result];
            
            [loadingView removeFromSuperview];
            
        }
    }];
}
-(IBAction)pause:(id)sender {
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    __weak ViewController *weakSelf = self;
    [api setStateWithState:@"pause" andToken:[BliepAPI getTokenFromUserDefaults] andCompletionBlock:^(NSDictionary *dict) {
        NSLog(@"%@", dict);
        BOOL succes = [[dict objectForKey:@"success"] boolValue];
        if (succes == YES) {
            // Update user info
            [weakSelf getAccountInfo:sender];
        }else {
            // Get errorcode
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%d", [[dict objectForKey:@"error_code"] integerValue]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        }

        [loadingView removeFromSuperview];
    
    }];
}
-(IBAction)bliep:(id)sender {
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    __weak ViewController *weakSelf = self;
    [api setStateWithState:@"bliep" andToken:[BliepAPI getTokenFromUserDefaults] andCompletionBlock:^(NSDictionary *dict) {
        NSLog(@"%@", dict);
        BOOL succes = [[dict objectForKey:@"success"] boolValue];
        if (succes == YES) {
            // Update user info
            [weakSelf getAccountInfo:sender];
        }else {
            // Get errorcode
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%d", [[dict objectForKey:@"error_code"] integerValue]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        }
     
        [loadingView removeFromSuperview];
     
    }];
}
-(IBAction)bliepplus:(id)sender {
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    __weak ViewController *weakSelf = self;
    [api setStateWithState:@"bliep-plus" andToken:[BliepAPI getTokenFromUserDefaults] andCompletionBlock:^(NSDictionary *dict) {
        NSLog(@"%@", dict);
        BOOL succes = [[dict objectForKey:@"success"] boolValue];
        if (succes == YES) {
            // Update user info
            [weakSelf getAccountInfo:sender];
        }else {
            // Get errorcode
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%d", [[dict objectForKey:@"error_code"] integerValue]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            
        }
     
        [loadingView removeFromSuperview];
     
    }];
}
@end
