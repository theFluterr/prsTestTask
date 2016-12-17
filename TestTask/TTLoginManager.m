
//
//  TTLoginManager.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTLoginManager.h"
#import "TTUser.h"

#define kUserDefaults @"savedUsernameKey"

@implementation TTLoginManager

- (RACSignal *)loginWithUser:(TTUser *)user {
    if ([TTLoginManager shouldWriteToUserDefaults]) {
        NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"auth_storage" ofType:@"txt"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];
        NSError *error;
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
        
        return [RACSignal startEagerlyWithScheduler:scheduler block:^(id<RACSubscriber>  _Nonnull subscriber) {
            [scheduler afterDelay:2.0 schedule:^{
                
                NSDictionary *loginInfo = [jsonData objectForKey:@"user_storage"];
                if ([user.username isEqualToString:[loginInfo objectForKey:@"username"]] && [user.password isEqualToString:[loginInfo objectForKey:@"password"]]) {
                    [self saveToUserDefaults:user.username];
                    [subscriber sendNext:user];
                    [subscriber sendCompleted];
                } else {
                    NSError *error;
                    [subscriber sendError:error];
                }
            }];
            
        }];
    }
    
    return nil; 
}

+ (BOOL)shouldWriteToUserDefaults {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults]) {
        
        return NO;
    }
    
    return YES;
}

- (void)saveToUserDefaults:(NSString *)username {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUserDefaults];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
