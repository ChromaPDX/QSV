//
//  ViewController.m
//  QSV
//
//  Created by Eric Kuehne on 1/7/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_exportButton setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [_refreshButton setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
   
    _nikeConnect = [[NikeConnect alloc] init];
    [_nikeConnect setDelegate:self];
    [_nikeConnect loadAllPriorLogins];

    _numColumns = 0;
	
    _fitBitData = [[NSMutableArray alloc] init];
    
    [self updateButtons];
}

-(void) dataDidUpdate{
    NSLog(@"in dataDidUpdate");
    if([_nikeConnect isLoading]){
        NSLog(@"Still loading...");
    }
    else{
        _nikeData = [_nikeConnect getNikeActivity];
        [_exportButton setEnabled:TRUE];
        [_exportButton setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
        //NSLog(@"_nikeData = %@", _nikeData);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginFitbit
{
    LoginWebViewController *loginWebViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loginWebViewController"];
    
    if(_oauthTokenFitBit == nil){   // If not logged in, then do it
    
        [self presentViewController:loginWebViewController
                           animated:YES
                         completion:^{
                             [self.oauth1Controller loginWithWebView:loginWebViewController.webView completion:^(NSDictionary *oauthTokens, NSError *error) {
                                 if (!error) {
                                     // Store your tokens for authenticating your later requests, consider storing the tokens in the Keychain
                                     _oauthTokenFitBit = oauthTokens[@"oauth_token"];
                                     _oauthTokenSecretFitBit = oauthTokens[@"oauth_token_secret"];
                                     
                                     // set button to "connect"
                                     [_fitbitButton setTitle:@"connected" forState:UIControlStateNormal];
                                     [_fitbitButton setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]];
                                 }
                                 else
                                 {
                                     NSLog(@"Error authenticating: %@", error.localizedDescription);
                                 }
                                 [self dismissViewControllerAnimated:YES completion: ^{
                                     _oauth1Controller = nil;
                                 }];
                             }];
                         }];

    }
    else{  //  allready logged in, so log out
        // Clear cookies so no session cookies can be used for the UIWebview
        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [storage cookies]) {
            if (cookie.isSecure) {
                [storage deleteCookie:cookie];
            }
        }
        
        // Clear tokens from instance variables
        _oauthTokenFitBit = nil;
        _oauthTokenSecretFitBit = nil;
        
        // set button to "connect"
        [_fitbitButton setTitle:@"connect" forState:UIControlStateNormal];
    }
    [self updateButtons];
}

-(void) connectionSuccessful{
    NSLog(@"DELEGATE:nikeconnect:connectionSuccessful");
    [self updateButtons];
   // [loginView setNeedsDisplay];
    //    [nikeConnect request10Days];
   //[_nikeConnect requestCascadingDataOfMonths:1];
}

-(void) updateButtons
{
    if([_nikeConnect isConnected]){
        [_nikeButton setTitle:@"connected"forState:UIControlStateNormal];
        [_nikeButton setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]];
    }
    else{
        [_nikeButton setTitle:@"connect"forState:UIControlStateNormal];
        [_nikeButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    }
    if(_oauthTokenFitBit){
        [_fitbitButton setTitle:@"connected"forState:UIControlStateNormal];
        [_fitbitButton setBackgroundColor:[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0]];
    }
    else{
        [_fitbitButton setTitle:@"connect"forState:UIControlStateNormal];
        [_fitbitButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    }
    [_fitnesspalButton setTitle:@"connect"forState:UIControlStateNormal];
    [_fitnesspalButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];

    [_withingsButton setTitle:@"connect"forState:UIControlStateNormal];
    [_withingsButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];

    [_goodreadsButton setTitle:@"connect"forState:UIControlStateNormal];
    [_goodreadsButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
    
    [_rescuetimeButton setTitle:@"connect"forState:UIControlStateNormal];
    [_rescuetimeButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];

}


- (IBAction)loginNike
{
    if([_nikeConnect isConnected]){
        [_nikeConnect disconnect];
    }
    else{
        [_nikeConnect connect];
    }
    if([_nikeConnect isConnected]){
       // NSLog(@"connected to Nike");
        [_nikeButton setTitle:@"connected" forState:UIControlStateNormal];
    }
    else{
       // NSLog(@"disconnected from Nike");
        [_nikeButton setTitle:@"connect" forState:UIControlStateNormal];
    }
    [self updateButtons];
}

-(void) refreshNike
{
    if([_nikeConnect isConnected]){
        NSLog(@"In refreshNike");
        [_nikeConnect request100Days];
        _nikeData = [_nikeConnect getNikeActivity];
    }
}


-(void) refreshFitBit
{
    // init all paths to GET
    NSArray *fetchPaths = [NSArray arrayWithObjects:
                     //    @"1/user/-/profile.json",
                           @"1/user/-/foods/log/caloriesIn/date/today/3m.json",
                           @"1/user/-/foods/log/water/date/today/3m.json",
                           @"1/user/-/activities/calories/date/today/3m.json",
                           //@"1/user/-/activities/caloriesBMR/date/today/3m.json",
                           @"1/user/-/activities/steps/date/today/3m.json",
                           @"1/user/-/activities/distance/date/today/3m.json",
                         //  @"1/user/-/activities/floors/date/today/3m.json",
                         //  @"1/user/-/activities/elevation/date/today/3m.json",
                           @"1/user/-/activities/minutesSedentary/date/today/3m.json",
                           @"1/user/-/activities/minutesLightlyActive/date/today/3m.json",
                          // @"1/user/-/activities/minutesFairlyActive/date/today/3m.json",
                           @"1/user/-/activities/minutesVeryActive/date/today/3m.json",
                          // @"1/user/-/activities/activityCalories/date/today/3m.json",
                          // @"1/user/-/sleep/startTime/date/today/3m.json",
                          // @"1/user/-/sleep/timeInBed/date/today/3m.json",
                          // @"1/user/-/sleep/minutesAsleep/date/today/3m.json",
                          // @"1/user/-/sleep/awakeningsCount/date/today/3m.json",
                          // @"1/user/-/sleep/minutesAwake/date/today/3m.json",
                          // @"1/user/-/sleep/minutesToFallAsleep/date/today/3m.json",
                          // @"1/user/-/sleep/minutesAfterWakeup/date/today/3m.json",
                          // @"1/user/-/sleep/efficiency/date/today/3m.json",
                          // @"1/user/-/body/weight/date/today/3m.json",
                           //@"1/user/-/body/bmi/date/today/3m.json",
                           //@"1/user/-/body/fat/date/today/3m.json",

                           nil];
    
    NSString *path;
    _numColumns = [fetchPaths count];
    for (path in fetchPaths){
        //_numColumns++;
     
//    NSString *path = @"1/user/-/profile.json";
    
        NSLog(@"refreshFitBit: fetching %@", path);
        NSURLRequest *preparedRequest = [OAuth1Controller
                                     preparedRequestForPath:path parameters:nil
                                     HTTPmethod:@"GET"
                                     oauthToken:self.oauthTokenFitBit
                                     oauthSecret:self.oauthTokenSecretFitBit];
    
        [NSURLConnection sendAsynchronousRequest:preparedRequest
                                        queue:NSOperationQueue.mainQueue
                                        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                        dispatch_async(dispatch_get_main_queue(),^{
                                          
                                            // NSLog(@"in refresh: data:%@", data);
                                            NSError *jsonParsingError = nil;
                                            // parse JSON and add to data collection
                                            [_fitBitData addObject: [NSJSONSerialization JSONObjectWithData: data options:0 error:&jsonParsingError]];
                                            if(jsonParsingError){
                                                NSLog(@"Error: %@", jsonParsingError);
                                            }
                                           // NSLog(@"%@", _fitBitData);

                                           
                                            
                                            if (error) NSLog(@"Error in API request: %@", error.localizedDescription);
                                        });
                                    }];
        
        }
}


// pull data from all connected services
- (IBAction)refreshAllData
{
    [_exportButton setEnabled:FALSE];
    [_exportButton setBackgroundColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];

    if(_oauthTokenFitBit != nil){
        [self refreshFitBit];
    }
    [self refreshNike];
    
  //  NSLog(@"_rawDataFitBit = %@", _rawDataFitBit);

}


// export data via email attachment
- (IBAction)export
{
    //NSLog(@"%@", _fitBitData);
   // NSLog(@"numColumns = %@", [NSString stringWithFormat:@"%i",_numColumns]);
    // first write the file to disc
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"QSV_export.csv"];
   // NSError *error;
    [[NSFileManager defaultManager] createFileAtPath:appFile contents:nil attributes:nil];
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:appFile];
    
    // Extract FitBit Data
    NSDictionary *mainDict;
    NSString *CSVkeys = @"dateTime,";
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];// initWithCapacity:10];];  // a dicitonary keyed by dateTime = array of values

    if(_oauthTokenFitBit){
    
        int columnCount = -1;
        for(mainDict in _fitBitData){
            //NSLog(@"type of mainArray = %@", [mainDict class]);
            NSArray *keys = [mainDict allKeys];
            
            //  NSArray *items = [mainArray objectAtIndex:0];
            for(NSString *key in keys){
                columnCount++;
                NSLog(@"key = %@", key);
                //NSLog(@"value= %@", [mainDict objectForKey:key]);
                CSVkeys = [CSVkeys stringByAppendingString:keys[0]];
                CSVkeys = [CSVkeys stringByAppendingString:@","];
                NSArray *mainArray = [mainDict objectForKey:key];
                // NSLog(@"valueType = %@", [mainArray class]);
                //iterate through final array
                
                for( NSDictionary *thisDict in mainArray){
                    //NSLog(@"dateTime value = %@", [thisDict valueForKey:@"dateTime"]);
                    //NSLog(@"value value = %@", [thisDict valueForKey:@"value"]);
                    // see if this dateTime has been seen before, if not create a new array for it
                    if([values objectForKey:[thisDict valueForKey:@"dateTime"]] == Nil){
                        //NSLog(@"adding array for %@", [thisDict valueForKey:@"dateTime"]);
                        NSMutableArray *newArray = [NSMutableArray array];
                        for(int i = 0; i<_numColumns; i++){
                            [newArray addObject:[NSNumber numberWithFloat:0.0]];
                        }
                        if([thisDict valueForKey:@"dateTime"]){
                            [values setObject:newArray forKey:[thisDict valueForKey:@"dateTime"]];
                        }
                        //   NSLog(@"values = %@", values);
                        
                    }
                    // add the value to the list
                    if([thisDict valueForKey:@"value"]){
                        // NSLog(@"adding %@", [thisDict valueForKey:@"value"]);
                        NSMutableArray *newArray =[values objectForKey:[thisDict valueForKey:@"dateTime"]];
                        [newArray replaceObjectAtIndex:columnCount withObject:[thisDict valueForKey:@"value"]];
                    }
                }
            }
        }
        // remove trailing ","
        CSVkeys = [CSVkeys substringToIndex:[CSVkeys length] - 1];
        
        
        
        
        [fileHandle writeData:[@"Data exported from FitBit...\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle writeData:[CSVkeys dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"allKeys = %@", [values allKeys]);
        // Write the data to file
        NSArray *sortedKeys = [[values allKeys] sortedArrayUsingDescriptors:@[ [NSSortDescriptor  sortDescriptorWithKey:@"" ascending:YES selector:@selector(localizedStandardCompare:)] ]];
        for(NSString *key in sortedKeys){
            NSString *newLine = [key stringByAppendingString:@","];
            for(NSString *value in [values objectForKey:key]){
                NSLog(@"value = %@", value);
                newLine = [newLine stringByAppendingString:[NSString stringWithFormat:@"%@",value]];
                newLine = [newLine stringByAppendingString:@","];
                
            }
            newLine = [newLine substringToIndex:[newLine length] - 1];
            // NSLog(@"newline = %@", newLine);
            [fileHandle writeData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
            //  NSLog(@"key = %@", key);
            //  NSLog(@"value = %@", [values valueForKey:key]);
        }
        //    [fileHandle writeData:[CSVkeys dataUsingEncoding:NSUTF8StringEncoding]];

    }
    
    // extract Nike data
    //_nikeData = [_nikeConnect extractDatabase];
    
    [fileHandle writeData:[@"Data exported from Nike+...\n" dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"NikeData ------------- %@", _nikeData);
    NSMutableDictionary *thisEntry;
    CSVkeys = [NSString stringWithFormat:@"dateTime,calories,distance,duration,fuel,steps\n"];
    [fileHandle writeData:[CSVkeys dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *firstArray = [_nikeData objectAtIndex:0];
    for(thisEntry in firstArray){
        //NSLog(@"thisEntry = %@", thisEntry);
        NSDictionary *metricsDict = [thisEntry  objectForKey:@"metricSummary"];
        NSLog(@"metricsDict = %@", metricsDict);
        NSString *newLine = [thisEntry valueForKey:@"startTime"];
        newLine = [newLine stringByAppendingString:@","];
        newLine = [newLine stringByAppendingString:[NSString stringWithFormat:@"%@",[metricsDict valueForKey:@"calories"]]];
        newLine = [newLine stringByAppendingString:@","];
        newLine = [newLine stringByAppendingString:[NSString stringWithFormat:@"%@",[metricsDict valueForKey:@"distance"]]];
        newLine = [newLine stringByAppendingString:@","];
        newLine = [newLine stringByAppendingString:[NSString stringWithFormat:@"%@",[metricsDict valueForKey:@"duration"]]];
        newLine = [newLine stringByAppendingString:@","];
        newLine = [newLine stringByAppendingString:[NSString stringWithFormat:@"%@",[metricsDict valueForKey:@"fuel"]]];
        newLine = [newLine stringByAppendingString:@","];
        newLine = [newLine stringByAppendingString:[NSString stringWithFormat:@"%@",[metricsDict valueForKey:@"steps"]]];

        newLine = [newLine stringByAppendingString:@"\n"];
        [fileHandle writeData:[newLine dataUsingEncoding:NSUTF8StringEncoding]];

    }
    
    [fileHandle closeFile];
    
    
    //[fileHandle writeData:_fitBitData];
    
   //  NSString* output = [xmlNode XMLStringWithOptions:NSXMLNodePrettyPrint];
   //[_fitBitData writeToFile:appFile atomically:TRUE encoding:NSPropertyListXMLFormat_v1_0 error:&error];
    
    
    // open blank email and attach doc
    NSString *emailTitle = @"QSV export";
    NSString *messageBody = @"Congratulations, you are living a well examined life! Here is your data.";
  //  NSArray *toRecipents = [NSArray arrayWithObject:@"eric@chroma.io"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
   // [mc setToRecipients:toRecipents];
    
    // Determine the file name and extension
    NSArray *filepart = [appFile componentsSeparatedByString:@"."];
    NSString *filename = [filepart objectAtIndex:0];
    NSString *extension = [filepart objectAtIndex:1];
    
    // Get the resource path and read the file using NSData
    NSString *filePath = appFile;
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    // Determine the MIME type
    NSString *mimeType = @"text/csv";
    // Add attachment
    [mc addAttachmentData:fileData mimeType:mimeType fileName:@"QSV_export.csv"];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (OAuth1Controller *)oauth1Controller
{
    if (_oauth1Controller == nil) {
        _oauth1Controller = [[OAuth1Controller alloc] init];
    }
    return _oauth1Controller;
}

@end
