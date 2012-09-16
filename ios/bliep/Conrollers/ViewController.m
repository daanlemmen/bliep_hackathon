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
@property (nonatomic, strong) BliepAPI *api;

@end

@implementation ViewController

-(void)loguit {
    [BliepAPI removeTokenFromKeychain];
}

- (void)viewDidLoad
{
    
    UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 90.0, 44.0)];
    [logoutButton setImage:[UIImage imageNamed:@"Logout.png"] forState:UIControlStateNormal];
    [logoutButton addTarget:self action:@selector(loguit) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:logoutButton]];
    
    self.stateLabel.font = [UIFont bliepFontWithSize:17];
    self.balanceLabel.font = [UIFont bliepFontWithSize:48];
    self.calltimeLabel.font = [UIFont bliepFontWithSize:30];
    
    [super viewDidLoad];
    self.api = [[BliepAPI alloc] init];
    
    // Set cached Data
    NSDictionary *cachedData = [BliepAPI getAccountInfoFromUserDefaults];
    
    if (cachedData){
        self.stateLabel.text = [cachedData objectForKey:@"state"];
        if ([[cachedData objectForKey:@"state"] isEqualToString:@"pause"]) {
            [self.pauseButton setHighlighted:YES];
            [self.bliepButton setHighlighted:NO];
            [self.bliepplusButton setHighlighted:NO];
        } else if ([[cachedData objectForKey:@"state"] isEqualToString:@"bliep"]) {
             [self.pauseButton setHighlighted:NO];
             [self.bliepButton setHighlighted:YES];
             [self.bliepplusButton setHighlighted:NO];
        } else if ([[cachedData objectForKey:@"state"] isEqualToString:@"bliep-plus"]) {
            [self.pauseButton setHighlighted:NO];
            [self.bliepButton setHighlighted:NO];
            [self.bliepplusButton setHighlighted:YES];
        }
        self.balanceLabel.text = [NSString stringWithFormat:@"€ %@", [cachedData objectForKey:@"balance"]];
        NSString *seconds = [NSString stringWithFormat:@"%@", [[cachedData objectForKey:@"calltime"] objectForKey:@"seconds"]];
        if ([seconds length] == 1)
            seconds = [@"0" stringByAppendingString:seconds];
        self.calltimeLabel.text = [NSString stringWithFormat:@"%@:%@", [[cachedData objectForKey:@"calltime"] objectForKey:@"minutes"], seconds];
    }else {
        self.stateLabel.text = @"";
        self.balanceLabel.text = @"";
        self.calltimeLabel.text = @"";
    }
    [self.pauseButton setEnabled:NO];
    [self.bliepButton setEnabled:NO];
    [self.bliepplusButton setEnabled:NO];
    
    if ([[BliepAPI getTokenFromUserDefaults] length] > 0){
        [self getAccountInfo:nil];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getAccountInfo:(id)sender {
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    
    [self.api getAccountInfoWithToken:[BliepAPI getTokenFromUserDefaults]
                         onCompletion:^(NSDictionary *dict) {
                             // Get account info
                             NSDictionary *result = [dict objectForKey:@"result"];
                             self.stateLabel.text = [result objectForKey:@"state"];
                             if ([[result objectForKey:@"state"] isEqualToString:@"pause"]) {
                                 [self.pauseButton setHighlighted:YES];
                                 [self.bliepButton setHighlighted:NO];
                                 [self.bliepplusButton setHighlighted:NO];
                             } else if ([[result objectForKey:@"state"] isEqualToString:@"bliep"]) {
                                 [self.pauseButton setHighlighted:NO];
                                 [self.bliepButton setHighlighted:YES];
                                 [self.bliepplusButton setHighlighted:NO];
                             } else if ([[result objectForKey:@"state"] isEqualToString:@"bliep-plus"]) {
                                 [self.pauseButton setHighlighted:NO];
                                 [self.bliepButton setHighlighted:NO];
                                 [self.bliepplusButton setHighlighted:YES];
                             }
                             self.balanceLabel.text = [NSString stringWithFormat:@"€ %@", [result objectForKey:@"balance"]];
                             NSString *seconds = [NSString stringWithFormat:@"%@", [[result objectForKey:@"calltime"] objectForKey:@"seconds"]];
                             if ([seconds length] == 1)
                                 seconds = [@"0" stringByAppendingString:seconds];
                             self.calltimeLabel.text = [NSString stringWithFormat:@"%@:%@", [[result objectForKey:@"calltime"] objectForKey:@"minutes"], seconds];
                             [BliepAPI setAccountInfo:result];
                             
                             [loadingView removeFromSuperview];
                         }
                              onError:^(NSError *error) {
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %d", [error code]]
                                                                                  message:[error localizedDescription]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:@"Ok"
                                                                        otherButtonTitles:nil, nil];
                                  [alert show];

                              }];
}

-(IBAction)pause:(id)sender {
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    __weak ViewController *weakSelf = self;
    
    [self.api setStateWithState:@"pause"
                       andToken:[BliepAPI getTokenFromUserDefaults]
                   onCompletion:^(NSDictionary *dict) {
                            // Update user info
                            [weakSelf getAccountInfo:nil];
                            [loadingView removeFromSuperview];
                        }
                        onError:^(NSError *error) {
                            [loadingView removeFromSuperview];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %d", [error code]]
                                                                            message:[error localizedDescription]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];

                        }];
}

-(IBAction)bliep:(id)sender {
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    __weak ViewController *weakSelf = self;
    [self.api setStateWithState:@"bliep"
                       andToken:[BliepAPI getTokenFromUserDefaults]
                   onCompletion:^(NSDictionary *dict) {
                       // Update user info
                       [weakSelf getAccountInfo:nil];
                       [loadingView removeFromSuperview];
                   }
                        onError:^(NSError *error) {
                            [loadingView removeFromSuperview];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %d", [error code]]
                                                                            message:[error localizedDescription]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            
                        }];
}

-(IBAction)bliepplus:(id)sender {
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    __weak ViewController *weakSelf = self;
    [self.api setStateWithState:@"bliep-plus"
                       andToken:[BliepAPI getTokenFromUserDefaults]
                   onCompletion:^(NSDictionary *dict) {
                       // Update user info
                       [weakSelf getAccountInfo:nil];
                       [loadingView removeFromSuperview];
                   }
                        onError:^(NSError *error) {
                            [loadingView removeFromSuperview];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %d", [error code]]
                                                                            message:[error localizedDescription]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"Ok"
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            
                        }];
}

@end
