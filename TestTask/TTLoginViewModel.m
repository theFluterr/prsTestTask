//
//  TTLoginViewModel.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTLoginViewModel.h"
#import "TTLoginManager.h"
#import "TTUser.h"

@interface TTLoginViewModel ()

@property (nonatomic) TTLoginManager *loginManager;

@end

@implementation TTLoginViewModel

- (instancetype)init {
    if (self = [super init]) {
        _loginManager = [TTLoginManager new];
    }
    
    return self;
}

- (void)loginWithUsername:(NSString *)username password:(NSString *)password {
    TTUser *user = [[TTUser alloc] initWithUsername:username];
    user.password = password;
    RACSignal *loginSignal = [self.loginManager loginWithUser:user];
    
    @weakify(self)
    [loginSignal subscribeError:^(NSError * _Nullable error) {
        @strongify(self)
        self.loginStatus = LoginFailed;
    } completed:^{
        @strongify(self)
        self.loginStatus = LoginSucceeded;
    }];
    
}

@end
