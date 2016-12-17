//
//  TTUserCellViewModel.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TTUser; 

@interface TTUserCellViewModel : NSObject

@property (nonatomic) UIImage *userImage;
@property (nonatomic) NSString *username;
@property (nonatomic) NSAttributedString *status; 

- (instancetype)initWithUser:(TTUser *)user;

@end
