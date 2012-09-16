//
//  BliepAPI.h
//  bliep
//
//  Created by Daan Lemmen on 14-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BliepConnectionTypeToken,
    BliepConnectionTypeAccount,
    BliepConnectionTypeChangeAccountState,
} BliepConnectionType;

typedef void(^BliepCompletionBlock)(NSDictionary *dict);
typedef void(^BliepErrorBlock)(NSError *error);

@interface BliepAPI : NSObject <NSURLConnectionDataDelegate>

- (void)getTokenWithUsername:(NSString *)username
                 andPassword:(NSString *)password
                onCompletion:(BliepCompletionBlock)completionBlock
                     onError:(BliepErrorBlock)errorBlock;

- (void)getAccountInfoWithToken:(NSString *)token
                   onCompletion:(BliepCompletionBlock)completionBlock
                        onError:(BliepErrorBlock)errorBlock;

- (void)setStateWithState:(NSString *)state andToken:(NSString *)token
             onCompletion:(BliepCompletionBlock)completionBlock
                  onError:(BliepErrorBlock)errorBlock;

+ (NSString *)getTokenFromUserDefaults;
+ (void)setToken:(NSString *)token;
+ (void)removeTokenFromKeychain;
+ (NSDictionary *)getAccountInfoFromUserDefaults;
+ (BOOL)setAccountInfo:(NSDictionary *)accountInfo;
@end
