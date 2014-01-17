//
//  NSString+URLEncoding.h
//  IdeaFlasher Authentication

#import <Foundation/Foundation.h>

@interface NSString (URLEncoding)

- (NSString *)utf8AndURLEncode;
+ (NSString *)getNonce;

@end
