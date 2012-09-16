//
//  WebViewController.h
//  bliep
//
//  Created by Tom Freijsen on 16-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, retain) IBOutlet UIWebView *webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url;
- (void)loadURL:(NSURL *)url;

@end
