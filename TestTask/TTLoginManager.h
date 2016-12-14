//
//  TTLoginManager.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@class TTUser;

@interface TTLoginManager : NSObject

- (RACSignal *)loginWithUser:(TTUser *)user;

@end
