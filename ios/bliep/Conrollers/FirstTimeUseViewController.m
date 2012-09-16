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
@interface FirstTimeUseViewController () {
    BliepAPI *api;
}
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
    api = [[BliepAPI alloc] init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)login:(id)sender {
    NSString *email = [emailTextField text];
    NSString *wachtwoord = [passwordTextField text];
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:loadingView];
    
    [api getTokenWithUsername:email andPassword:wachtwoord andCompletionBlock:^(NSDictionary *dict) {
        NSLog(@"%@", dict);
        BOOL succes = [[dict objectForKey:@"success"] boolValue];
        if (succes == YES){
            // Save token
            [BliepAPI setToken:[[dict objectForKey:@"result"] objectForKey:@"token"]];
            ViewController *vc = [[ViewController alloc] init];
            vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:vc animated:YES completion:nil];
        }else {
            // Get errorcode
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"%@", [dict objectForKey:@"error"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
     
        [loadingView removeFromSuperview];
     
    }];
}
-(IBAction)next:(id)sender {
    [passwordTextField becomeFirstResponder];
}
@end
