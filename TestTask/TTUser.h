//
//  TTUser.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum TTUserStatus : NSUInteger {
    Online,
    DontDisturb,
    Offline
} TTUserStatus;

typedef enum TTUserType : NSUInteger {
    Custom,
    PhoneBook
} TTUserType;

@interface TTUser : NSObject

- (instancetype)initWithUsername:(NSString *)username;

@property (nonatomic, readonly) NSString *username;
@property (nonatomic) NSString *password;
@property (nonatomic) TTUserStatus status;
@property (nonatomic) NSString *displayName;
@property (nonatomic) TTUserType userType;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSArray <NSString *> *phoneNumbers;

- (NSComparisonResult)compare:(TTUser *)other;

@end
