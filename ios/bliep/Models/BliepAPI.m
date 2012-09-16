//
//  BliepAPI.m
//  bliep
//
//  Created by Daan Lemmen on 14-09-12.
//  Copyright (c) 2012 Daan Lemmen. All rights reserved.
//

#import "BliepAPI.h"
#import "BliepJSONEngine.h"
#import "BliepJSONOperation.h"
#import "PDKeychainBindings.h"

@interface BliepAPI()
@property (nonatomic, strong) BliepJSONEngine *networkEngine;
@end		

@implementation BliepAPI

- (id)init {
    self = [super init];
    if (self) {
        self.networkEngine = [[BliepJSONEngine alloc] initWithHostName:@"www.bliep.nl"
                                                                           apiPath:@"api" customHeaderFields:nil];
        [self.networkEngine registerOperationSubclass:[BliepJSONOperation class]];
        
    }
    return self;
}

#pragma mark - API Calls

- (void)getTokenWithUsername:(NSString *)username
                 andPassword:(NSString *)password
                onCompletion:(BliepCompletionBlock)completionBlock
                     onError:(BliepErrorBlock)errorBlock; {
    
    MKNetworkOperation *operation = [self.networkEngine operationWithPath:@"auth"
                                                                   params:[NSMutableDictionary dictionaryWithObjects:@[username, password]
                                                                                                             forKeys:@[@"email", @"password"]]
                                                               httpMethod:@"POST"
                                                                      ssl:YES];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dict = [completedOperation responseJSON];
        completionBlock(dict);
    } onError:^(NSError *error) {
        DLog(@"Error: %d %@: %@", [error code], [error domain], [error localizedDescription]);
        errorBlock(error);
    }];
    
    [self.networkEngine enqueueOperation:operation];
    
}
- (void)getAccountInfoWithToken:(NSString *)token
                   onCompletion:(BliepCompletionBlock)completionBlock
                        onError:(BliepErrorBlock)errorBlock; {
    MKNetworkOperation *operation = [self.networkEngine operationWithPath:@"account"
                                                                   params:[NSMutableDictionary dictionaryWithObjects:@[token] forKeys:@[@"token"]]
                                                               httpMethod:@"GET" ssl:YES];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dict = [completedOperation responseJSON];
        completionBlock(dict);
    } onError:^(NSError *error) {
        DLog(@"Error: %d %@: %@", [error code], [error domain], [error localizedDescription]);
        errorBlock(error);
    }];
    
    [self.networkEngine enqueueOperation:operation];
    
}

-(void)setStateWithState:(NSString *)state
                andToken:(NSString *)token
            onCompletion:(BliepCompletionBlock)completionBlock
                 onError:(BliepErrorBlock)errorBlock; {
    
    MKNetworkOperation *operation = [self.networkEngine operationWithPath:[NSString stringWithFormat:@"account/state/%@", state]
                                                                   params:[NSMutableDictionary dictionaryWithObjects:@[token] forKeys:@[@"token"]]
                                                               httpMethod:@"POST" ssl:YES];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *dict = [completedOperation responseJSON];
        completionBlock(dict);
    } onError:^(NSError *error) {
        DLog(@"Error: %d %@: %@", [error code], [error domain], [error localizedDescription]);
        errorBlock(error);
    }];
    
    [self.networkEngine enqueueOperation:operation];
}

#pragma mark - Offline storage

+ (NSString *)getTokenFromUserDefaults {
    return [[PDKeychainBindings sharedKeychainBindings] objectForKey:@"bliep_token"];
}

+ (void)setToken:(NSString *)token {
    [[PDKeychainBindings sharedKeychainBindings] setObject:token forKey:@"bliep_token"];
}

+ (void)removeTokenFromKeychain {
    [[PDKeychainBindings sharedKeychainBindings] removeObjectForKey:@"bliep_token"];
}

+ (NSDictionary *)getAccountInfoFromUserDefaults {
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"cachedAccountInfo"];
}

+ (BOOL)setAccountInfo:(NSDictionary *)accountInfo {
    [[NSUserDefaults standardUserDefaults] setValue:accountInfo forKey:@"cachedAccountInfo"];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
