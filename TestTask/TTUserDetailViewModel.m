//
//  TTUserDetailViewModel.m
//  TestTask
//
//  Created by Andrei on 17.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTUserDetailViewModel.h"
#import "TTUser.h"
#import "TTUserManager.h"
#import "UIColor+Hex.h"
#import "TTPhoneCellViewModel.h"
#import <BlocksKit/BlocksKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface TTUserDetailViewModel ()

@property (nonatomic) TTUser *user;
@property (nonatomic) TTUserManager *userManager;

@property (nonatomic, readwrite) UIImage *userImage;
@property (nonatomic, readwrite) NSString *username;
@property (nonatomic, readwrite) NSAttributedString *userStatusAttributedString;

@property (nonatomic, readwrite) NSArray<TTPhoneCellViewModel *> *phoneCellViewModels;


@end

@implementation TTUserDetailViewModel

- (instancetype)initWithUser:(TTUser *)user userManager:(TTUserManager *)userManager{
    if (self = [super init]) {
        _user = user;
        _userManager = userManager;
        _userImage = user.image;
        _username = user.displayName;
    }
    
    [self updateStatusString];
    self.phoneCellViewModels = [self createPhoneCellViewModels]; 
    @weakify(self)
    [RACObserve(self.userManager, users) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self updateUserStatus:x];
    }];
    
    return self; 
}

- (UIImage *)userImage {
    if (!_userImage) {
        return [UIImage imageNamed:@"emptyAvatar"];
    } else {
        return _userImage;
    }
}


- (UIImage *)chatButtonImage {
    if (self.user.userType == Custom) {
        switch (self.user.status) {
            case Online:
                return [UIImage imageNamed:@"chatAvailableIcon"];
                break;
            case DontDisturb:
                return [UIImage imageNamed:@"chatOrange"];
                break;
            default:
                return [UIImage imageNamed:@"chatGray"];
                break;
        }
    } else {
        return [UIImage imageNamed:@"plusGray"];
    }
}


- (UIImage *)videoButtonImage {
    if (self.user.userType == PhoneBook) {
        return [UIImage imageNamed:@"videoGray"];
    }
    switch (self.user.status) {
        case Online:
            return [UIImage imageNamed:@"videoAvailableIcon"];
            break;
        case DontDisturb:
            return [UIImage imageNamed:@"videoOrange"];
            break;
        default:
            return [UIImage imageNamed:@"videoGray"];
            break;
    }
}

- (UIImage *)phoneButtonImage {
    if (self.user.userType == PhoneBook) {
        return [UIImage imageNamed:@"phoneGray"];
    }
    switch (self.user.status) {
        case Online:
            return [UIImage imageNamed:@"phoneAvailableIcon"];
            break;
        case DontDisturb:
            return [UIImage imageNamed:@"phoneOrange"];
            break;
        default:
            return [UIImage imageNamed:@"phoneGray"];
            break;
    }
}

- (void)updateStatusString {
    if (self.user.userType == PhoneBook) {
        self.userStatusAttributedString = [self createAttributedStatusForOutsideUser];
    } else {
        self.userStatusAttributedString = [self createAttributedStatus:self.user.status];
    }
}

- (void)updateUserStatus:(NSArray<TTUser *> *) users {
    [users bk_each:^(TTUser *obj) {
        if ([obj.username isEqualToString:self.user.username]) {
            self.user = obj;
            [self updateStatusString]; 
        }
    }];
}

- (NSArray *)createPhoneCellViewModels {
    NSMutableArray *phoneVMs = [NSMutableArray new];
    if (self.user.phoneNumbers.count != 0) {
        [self.user.phoneNumbers bk_each:^(id obj) {
            TTPhoneCellViewModel *phoneVM = [[TTPhoneCellViewModel alloc] initWithPhoneNumber:obj user:self.user];
            [phoneVMs addObject:phoneVM];
        }];
    }
    
    return phoneVMs;
}

- (NSAttributedString *)createAttributedStatusForOutsideUser {
    NSDictionary *attributesForText = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                        NSForegroundColorAttributeName: [UIColor colorWithHex:0x7d7d7d]};
    NSAttributedString *statusText = [[NSAttributedString alloc] initWithString:@"Контакт не зарегистрирован в системе" attributes:attributesForText];
    return statusText;
}

- (NSAttributedString *)createAttributedStatus:(TTUserStatus) status {
    NSDictionary *attributesForText = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                        NSForegroundColorAttributeName: [UIColor colorWithHex:0x7d7d7d]};
    NSDictionary *attributesForGreenDot = @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                            NSForegroundColorAttributeName: [UIColor colorWithHex:0x60b312]};
    NSDictionary *attributesForOrangeDot = @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                             NSForegroundColorAttributeName: [UIColor colorWithHex:0xeeb706]};
    NSDictionary *attributesForGrayDot = @{NSFontAttributeName: [UIFont systemFontOfSize:16],
                                           NSForegroundColorAttributeName: [UIColor colorWithHex:0x7d7d7d]};
    
    NSMutableAttributedString *greenDot = [[NSMutableAttributedString alloc] initWithString:@"• " attributes:attributesForGreenDot];
    NSMutableAttributedString *orangeDot = [[NSMutableAttributedString alloc] initWithString:@"• " attributes:attributesForOrangeDot];
    NSMutableAttributedString *grayDot = [[NSMutableAttributedString alloc] initWithString:@"• " attributes:attributesForGrayDot];
    
    if (status == Online) {
        NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"В сети. Доступен по будням" attributes:attributesForText];
        
        [greenDot appendAttributedString:statusString];
        
        return greenDot;
        
    } else if (status == DontDisturb) {
        NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"Не беспокоить" attributes:attributesForText];
        
        [orangeDot appendAttributedString:statusString];
        
        return orangeDot;
        
    } else {
        NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:@"Не в сети" attributes:attributesForText];
        
        [grayDot appendAttributedString:statusString];
        
        return grayDot;
    }   
}


@end
