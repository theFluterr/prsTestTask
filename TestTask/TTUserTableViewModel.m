//
//  TTUserTableViewModel.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTUserTableViewModel.h"
#import "TTUserManager.h"
#import <BlocksKit/BlocksKit.h>
#import "TTUserCellViewModel.h"
#import "TTUser.h"

@interface TTUserTableViewModel ()

@property (nonatomic) TTUserManager *userManager;

@property (nonatomic, readwrite) NSDictionary<NSString *, NSMutableArray<TTUserCellViewModel *> *> *cellViewModels;
@property (nonatomic, readwrite) NSArray *alphabet;
@property (nonatomic, readwrite) NSArray *sectionTitles;

@end

@implementation TTUserTableViewModel

- (instancetype)init {
    if (self = [super init]) {
        _userManager = [TTUserManager new];
        _cellViewModels = [NSDictionary new];
        _sectionTitles = [NSArray new];
        
        _alphabet = @[ @"#",@"A", @"•", @"B", @"•", @"C", @"•", @"D", @"•", @"E",@"•", @"F",@"•", @"G",@"•", @"H",@"•", @"I",@"•", @"J",@"•", @"K",@"•", @"L",@"•", @"M",@"•", @"N",@"•", @"O",@"•", @"P",@"•", @"Q",@"•", @"R",@"•", @"S",@"•", @"T",@"•", @"U",@"•", @"V",@"•", @"W",@"•", @"X",@"•", @"Y",@"•",@"Z",@"•",@"А",@"•",@"Б",@"•",@"В",@"•",@"Г",@"•",@"Д",@"•",@"Е",@"•",@"Ё",@"•",@"Ж",@"•",@"З",@"•",@"И",@"•",@"К",@"•",@"Л",@"•",@"М",@"•",@"Н",@"•",@"О",@"•",@"П",@"•",@"Р",@"•",@"С",@"•",@"Т",@"•",@"У",@"•",@"Ф",@"•",@"Ц",@"•",@"Ч",@"•",@"Ш",@"•",@"Щ",@"•",@"Ъ",@"•",@"Ы",@"•",@"Ь",@"•",@"Э",@"•",@"Ю",@"•",@"Я",@""];
    }
    
    [RACObserve(self.userManager, users) subscribeNext:^(id  _Nullable newValue) {
        [self mapViewModels:newValue];
    }];
    
    [self.userManager fetchUsers];
    
    return self; 
}

- (void)mapViewModels:(NSArray<TTUser *> *)input {
    NSArray *cellVMs = [NSArray new];
    NSArray *sortedInput = [input sortedArrayUsingSelector:@selector(compare:)];
    
    cellVMs = [sortedInput bk_map:^id(TTUser * obj) {
        TTUserCellViewModel *cellVM = [[TTUserCellViewModel alloc] initWithUser:obj];
        return cellVM;
    }];

    NSMutableDictionary <NSString *, NSMutableArray<TTUserCellViewModel *> *> *cellsMutableCopy = self.cellViewModels.mutableCopy;
    
    for (NSString *title in self.alphabet) {
        if (![title isEqualToString:@"•"]) {
            NSMutableArray *section = [NSMutableArray new];
            [cellsMutableCopy setObject:section forKey:title];
        }
    }
    
    for (TTUserCellViewModel *cell in cellVMs) {
        NSString *firstNameLetter = [[cell.username substringToIndex:1] uppercaseString];
        if ([self.alphabet containsObject:firstNameLetter]) {
            [[cellsMutableCopy objectForKey:firstNameLetter] addObject:cell];
        } else {
            [[cellsMutableCopy objectForKey:@"#"] addObject:cell];
        }
    }
    
    for (NSString *key in cellsMutableCopy.allKeys) {
        if ([cellsMutableCopy objectForKey:key].count == 0) {
            [cellsMutableCopy removeObjectForKey:key];
        }
    }
    
    self.sectionTitles = [[cellsMutableCopy allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    self.cellViewModels = cellsMutableCopy;
    
}

@end
