//
//  FirstTimeUseViewController.h
//  bliep
//
//  Created by Daan Lemmen on 15-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BliepAPI.h"
@interface FirstTimeUseViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

-(IBAction)login:(id)sender;
-(IBAction)next:(id)sender;
@end
