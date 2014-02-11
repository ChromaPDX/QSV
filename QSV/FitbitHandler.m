//
//  FitbitHandler.m
//  QSV
//
//  Created by Eric Kuehne on 2/1/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#import "FitbitHandler.h"

@implementation FitbitHandler

-(BOOL)login:(UIWebView *)inWebView
{
    _webView = inWebView;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.fitbit.com/oauth/request_token"]];
    _consumer = [[OAConsumer alloc] initWithKey:@"375d7f484cf34330b93c084dfd378f38" secret:@"7b13e6a08cf6443884fe0ef38f214ca5"];

    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:_consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:@"jumpbots://fitbit"   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
    
    
    [request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
    
    NSLog(@"request_token = %@", _requestToken);
    NSString *strUrl = [NSString stringWithFormat: @"https://www.fitbit.com/oauth/authorize?oauth_token=%@&display=touch", _requestToken.key];
    url = [NSURL URLWithString:strUrl];
    
    request = [NSURLRequest requestWithURL:url];
    
    
    //  [loginWebViewController.webView setScalesPageToFit:YES];
    NSLog(@"loading url: %@", url);
    [_webView loadRequest:request];
    

    return TRUE;
}

- (BOOL)isConnected
{
    if(_requestToken){
        return TRUE;
    }
    else{
        return FALSE;
    }
}

- (void) fetchAuthorizedOpenAuthTokenWithVerifier: (NSString *) oAuthVerifier; {
    
    NSLog(@"in fethAuthorizedOpenAuthTokenWithVerifier");

    //NSURL *url = [NSURL URLWithString:ACCESS_TOKEN_URL];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.fitbit.com/oauth/access_token"]];

        
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                    consumer:_consumer
                                                                       token:_requestToken   // We have a token now
                                                                       realm:@"jumpbots://fitbit"   
                                                           signatureProvider:nil]; // use the default method, HMAC-SHA1
    
    [request setHTTPMethod:@"POST"];
    
    OARequestParameter *verifierParam = [[OARequestParameter alloc] initWithName:@"oauth_verifier"
                                                                            value:oAuthVerifier];
   // NSArray *params = [NSArray arrayWithObjects:verifierParam, nil];
  // [request setOAuthParameterName:@"oauth_verifier" withValue:oAuthVerifier];
  //  [request setParameters:@"oauth_verifier" withValue:oAuthVerifier];
   // [request setParameters:params];

    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(requestTokenTicket:didFailWithError:)];

}

// Delegate methods
- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data
{
    NSLog(@"in requestTokenTicket data = %@", data);
    if (ticket.didSucceed) {
        NSLog(@"requestTokenTicket success!");
        NSString *responseBody = [[NSString alloc] initWithData:data
                                                       encoding:NSUTF8StringEncoding];
        _requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error
{
    NSLog(@"Error in reqeustTokenTicket: %@", error);
}


@end
