//
//  WebViewController.m
//  bliep
//
//  Created by Tom Freijsen on 16-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (nonatomic, retain) NSURL *urlToLoadAtViewLoad;
@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil url:(NSURL *)url
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.webView setDelegate:self];
        [self setTokenCookie];
        [self setUrlToLoadAtViewLoad:url];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    [self loadURL:self.urlToLoadAtViewLoad];
    
    //Back button
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:[UIImage imageNamed:@"Back.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.navigationItem setLeftBarButtonItem:backButton];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadURL:(NSURL *)url {
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

#pragma mark Webview delegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    NSLog(@"Error %d loading the website: %@", error.code, error.description);
    
}

- (void)setTokenCookie {
    
    /*NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"email" forKey:NSHTTPCookieName];
    [cookieProperties setObject:@"" forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"www.example.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:@"www.example.com" forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
     
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];*/
    
}

@end
