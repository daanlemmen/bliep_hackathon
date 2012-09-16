//
//  FirstTimeUseViewController.m
//  bliep
//
//  Created by Daan Lemmen on 15-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "FirstTimeUseViewController.h"

#import "ViewController.h"
#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
@interface FirstTimeUseViewController ()

@property (nonatomic, strong) BliepAPI *api;
@property (nonatomic, strong) UIView *loadingView;

@end

@implementation FirstTimeUseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.api = [[BliepAPI alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
    self.api = nil;
    self.loadingView = nil;
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender {
    NSString *email = [self.emailTextField text];
    NSString *wachtwoord = [self.passwordTextField text];
    [self.emailTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];

    [self.api getTokenWithUsername:email andPassword:wachtwoord
                      onCompletion:^(NSDictionary *dict) {
                          // Save token
                          [BliepAPI setToken:[[dict objectForKey:@"result"] objectForKey:@"token"]];
                          ViewController *vc = [[ViewController alloc] init];
                          UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
                          
                          [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:252.0f/255.0f green:242.0f/255.0f blue:0.0f alpha:1.0f]]
                                                             forBarMetrics:UIBarMetricsDefault];
                          navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                          
                          [self presentViewController:navController animated:YES completion:nil];
                          
                          [loadingView removeFromSuperview];
                      } onError:^(NSError *error) {
                          // Get errorcode
                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %d", [error code]]
                                                                          message:[error localizedDescription]
                                                                         delegate:nil
                                                                cancelButtonTitle:@"Ok"
                                                                otherButtonTitles:nil, nil];
                          [alert show];
                          
                          
                          [loadingView removeFromSuperview];
                      }];
}

- (IBAction)next:(id)sender {
    [self.passwordTextField becomeFirstResponder];
}

@end
