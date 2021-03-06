//
//  TTLoginViewModel.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

typedef enum TTLoginStatus : NSUInteger {
    LoginFailed,
    LoginSucceeded
} TTLoginStatus;

@interface TTLoginViewModel : NSObject

@property (nonatomic) TTLoginStatus loginStatus;

- (void)loginWithUsername:(NSString *)username password:(NSString *)password;

@end
