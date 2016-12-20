//
//  TTPhoneCellViewModel.h
//  TestTask
//
//  Created by Andrei on 17.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TTUser; 

@interface TTPhoneCellViewModel : NSObject

@property (nonatomic, readonly) NSString *phoneNumber;
@property (nonatomic) BOOL isFavourite;

- (instancetype)initWithPhoneNumber:(NSString *)phoneNumber user:(TTUser *) user;

@end
