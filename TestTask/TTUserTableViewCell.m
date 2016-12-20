//
//  TTUserTableViewCell.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTUserTableViewCell.h"
#import "TTUserCellViewModel.h"

@interface TTUserTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userstatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@end

@implementation TTUserTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.userImage.layer.cornerRadius = self.userImage.frame.size.height / 2;
    self.userImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindViewModel:(TTUserCellViewModel *)cellVM {
    self.userImage.image = cellVM.userImage;
    self.usernameLabel.text = cellVM.username;
    self.userstatusLabel.attributedText = cellVM.status;
    [self.phoneButton setImage:cellVM.phoneButtonImage forState:UIControlStateNormal];
    [self.chatButton setImage:cellVM.chatButtonImage forState:UIControlStateNormal];
}

@end
