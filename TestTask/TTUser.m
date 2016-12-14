//
//  TTUser.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTUser.h"

@interface TTUser ()

@property (nonatomic, readwrite) NSString *username;

@end

@implementation TTUser

- (instancetype)initWithUsername:(NSString *)username {
    if (self = [super init]) {
        _username = username;
    }
    
    return self;
}

@end
