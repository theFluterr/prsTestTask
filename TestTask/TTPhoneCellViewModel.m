
//
//  TTPhoneCellViewModel.m
//  TestTask
//
//  Created by Andrei on 17.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTPhoneCellViewModel.h"
#import "TTUser.h"

@interface TTPhoneCellViewModel ()

@property (nonatomic) TTUser *user;
@property (nonatomic, readwrite) NSString *phoneNumber;

@end

@implementation TTPhoneCellViewModel

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber user:(TTUser *) user {
    if (self = [super init]) {
        _user = user;
        _phoneNumber = phoneNumber;
    }
    [self formatPhoneNumber];
    
    return self;
}

- (void)formatPhoneNumber {
    NSMutableString *mut = self.phoneNumber.mutableCopy;
    if (self.phoneNumber.length >= 12) {
        if ([self.phoneNumber containsString:@"+"]) {
            [mut insertString:@" " atIndex:2];
            [mut insertString:@" " atIndex:6];
            [mut insertString:@" " atIndex:10];
            [mut insertString:@" " atIndex:13];
        } else {
            [mut insertString:@" " atIndex:1];
            [mut insertString:@" " atIndex:5];
            [mut insertString:@" " atIndex:9];
            [mut insertString:@" " atIndex:12];
        }
        
        self.phoneNumber = mut;
    }
}


@end
