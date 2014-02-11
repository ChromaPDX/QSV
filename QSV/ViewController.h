//
//  ViewController.h
//  QSV
//
//  Created by Eric Kuehne on 1/7/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "OAuthController.h"
#import "LoginWebViewController.h"
#import "NikeConnect.h"
#import "OAuthConsumer.h"
//#import "NSMutableURLRequest+Parameters.h"
#import "RKWithings.h"
#import <MessageUI/MessageUI.h>
#import "FitbitHandler.h"

//#import <sys/types.h>
//#import <security/security.h>



@interface ViewController : UIViewController <NikeConnectDelegate, UIWebViewDelegate>
//@property (nonatomic, strong) OAuthController *OAuthControllerFitbit;
//@property (nonatomic, strong) OAConsumer *goodreadsConsumer;
//@property (nonatomic, strong) OAToken *goodreadsRequestToken;

@property (nonatomic, strong) FitbitHandler *fitbitHandler;
@property (nonatomic, strong) NSString *oauthTokenFitBit;
@property (nonatomic, strong) NSString *oauthTokenSecretFitBit;
@property (nonatomic, strong) NSString *oauthTokenGoodreads;
@property (nonatomic, strong) NSString *oauthTokenSecretGoodreads;
@property (weak, nonatomic) IBOutlet UIButton *fitbitButton;
@property (weak, nonatomic) IBOutlet UIButton *nikeButton;
@property (weak, nonatomic) IBOutlet UIButton *goodreadsButton;
@property (weak, nonatomic) IBOutlet UIButton *fitnesspalButton;
@property (weak, nonatomic) IBOutlet UIButton *rescuetimeButton;
@property (weak, nonatomic) IBOutlet UIButton *withingsButton;
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;
@property (nonatomic, strong) NSMutableArray *fitBitData;
@property (nonatomic, strong) NSMutableArray *nikeData;
@property (atomic) int numColumns;
@property (nonatomic, strong) NikeConnect *nikeConnect;
//@property (weak, nonatomic) LoginWebViewController *loginWebViewController;

@property (weak, nonatomic) IBOutlet UIWebView *webView;



-(void) connectionSuccessful;
-(void) dataDidUpdate;
-(IBAction)refreshAllData;
@end
