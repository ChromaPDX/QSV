//
//  FitbitHandler.h
//  QSV
//
//  Created by Eric Kuehne on 2/1/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OAuthConsumer.h"

@protocol FitbitHandlerDelegate <NSObject>

@required

- (void) gotAuthorizationURL: (NSURL *) url;
- (void) failedToGetAuthorizationURL: (NSError *) error;

- (void) successfullyFetchedAuthorizedToken;
- (void) failedToFetchAuthorizedToken: (NSError *) error;

@end

@interface FitbitHandler : NSObject

@property (nonatomic, strong) OAConsumer *consumer;
@property (nonatomic, strong) OAToken *requestToken;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (void) fetchAuthorizedOpenAuthTokenWithVerifier: (NSString *) oAuthVerifier; // Fetches an authorized oAuth token after the user has approved the app.

-(BOOL)login:(UIWebView *)inWebView;
-(BOOL)isConnected;

@end
