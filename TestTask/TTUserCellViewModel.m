//
//  TTUserCellViewModel.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTUserCellViewModel.h"
#import "TTUser.h"
#import "UIColor+Hex.h"

@interface TTUserCellViewModel ()

@property (nonatomic) TTUser *user;

@end

@implementation TTUserCellViewModel

- (instancetype)initWithUser:(TTUser *)user {
    if (self = [super init]) {
        _user = user;
        _username = user.displayName;
        _userImage = user.image;
        
    }
    
    if (user.userType != PhoneBook) {
        self.status = [self createAttributedStatus:user.status];
    }
    
    return self;
}

- (UIImage *)userImage {
    if (!_userImage) {
        return [UIImage imageNamed:@"emptyAvatar"]; 
    } else {
        return _userImage; 
    }
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
