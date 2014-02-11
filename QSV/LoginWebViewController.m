//
//  LoginWebViewController.m
//  QSV
//
//  Created by Eric Kuehne on 1/7/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#import "LoginWebViewController.h"

@interface LoginWebViewController ()

@end

@implementation LoginWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"LoginWebViewController initWithNibName...");

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.webView.delegate = self;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"LoginWebViewController loading...");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadRequest{
    NSLog(@"inside loadRequest");
    [super loadView];
}

- (IBAction)cancelTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{ // starting the load, show the activity indicator in the status bar
    NSLog(@"in webViewDidStartLoad");
}
    
@end
