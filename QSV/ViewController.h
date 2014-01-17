//
//  ViewController.h
//  QSV
//
//  Created by Eric Kuehne on 1/7/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuth1Controller.h"
#import "LoginWebViewController.h"
#import "NikeConnect.h"

@interface ViewController : UIViewController <NikeConnectDelegate>

@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@property (nonatomic, strong) NSString *oauthTokenFitBit;
@property (nonatomic, strong) NSString *oauthTokenSecretFitBit;
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

-(void) connectionSuccessful;
-(void) dataDidUpdate;
-(IBAction)refreshAllData;
@end
