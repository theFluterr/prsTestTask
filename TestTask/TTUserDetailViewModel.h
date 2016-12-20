//
//  TTUserDetailViewModel.h
//  TestTask
//
//  Created by Andrei on 17.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTUser;
@class TTUserManager;
@class TTPhoneCellViewModel; 

@interface TTUserDetailViewModel : NSObject

- (instancetype)initWithUser:(TTUser *)user userManager:(TTUserManager *)userManager;

@property (nonatomic, readonly) UIImage *userImage;
@property (nonatomic, readonly) NSString *username;

@property (nonatomic, readonly) NSAttributedString *userStatusAttributedString;
@property (nonatomic, readonly) NSArray<TTPhoneCellViewModel *> *phoneCellViewModels;

@property (nonatomic, readonly) UIImage *phoneButtonImage;
@property (nonatomic, readonly) UIImage *chatButtonImage;
@property (nonatomic, readonly) UIImage *videoButtonImage; 

@end
