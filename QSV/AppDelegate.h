//
//  AppDelegate.h
//  QSV
//
//  Created by Eric Kuehne on 1/7/14.
//  Copyright (c) 2014 Chroma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Nike.h"
#import "FitbitHandler.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FitbitHandler *fitbitHandler;

@end
