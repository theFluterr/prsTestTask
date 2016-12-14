//
//  TTUser.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTUser : NSObject

- (instancetype)initWithUsername:(NSString *)username;

@property (nonatomic, readonly) NSString *username;
@property (nonatomic) NSString *password; 

@end
