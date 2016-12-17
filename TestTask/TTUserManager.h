//
//  TTUserManager.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TTUser;

@interface TTUserManager : NSObject

@property (nonatomic) NSArray<TTUser *> *users;

- (void)fetchUsers; 

@end
