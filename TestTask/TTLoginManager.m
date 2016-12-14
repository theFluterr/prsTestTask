
//
//  TTLoginManager.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTLoginManager.h"
#import "TTUser.h"

@implementation TTLoginManager

- (RACSignal *)loginWithUser:(TTUser *)user {
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"user_storage" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    RACScheduler *scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityBackground];
    
    return [RACSignal startEagerlyWithScheduler:scheduler block:^(id<RACSubscriber>  _Nonnull subscriber) {
        [scheduler afterDelay:2.0 schedule:^{
            
            NSDictionary *loginInfo = [jsonData objectForKey:@"user_storage"];
            if ([user.username isEqualToString:[loginInfo objectForKey:@"username"]] && [user.password isEqualToString:[loginInfo objectForKey:@"password"]]) {
                [subscriber sendNext:user];
                [subscriber sendCompleted];
            } else {
                NSError *error;
                [subscriber sendError:error];
            }
        }];
        
    }];
}

@end
