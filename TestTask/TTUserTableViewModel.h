//
//  TTUserTableViewModel.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@class TTUserCellViewModel;

@interface TTUserTableViewModel : NSObject

@property (nonatomic, readonly) NSDictionary<NSString *, NSMutableArray<TTUserCellViewModel *> *> *cellViewModels;
@property (nonatomic, readonly) NSArray *alphabet;
@property (nonatomic, readonly) NSArray *sectionTitles; 

@end
