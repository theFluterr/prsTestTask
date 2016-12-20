//
//  TTUserCellViewModel.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTUser.h"

@interface TTUserCellViewModel : NSObject

@property (nonatomic) UIImage *phoneButtonImage;
@property (nonatomic) UIImage *chatButtonImage; 

@property (nonatomic) TTUserType userType;

@property (nonatomic) UIImage *userImage;
@property (nonatomic) NSString *username;
@property (nonatomic) NSAttributedString *status;
@property (nonatomic, readonly) TTUser *user;

- (instancetype)initWithUser:(TTUser *)user;

@end
