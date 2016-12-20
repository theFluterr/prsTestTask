//
//  TTPhoneTableViewCell.m
//  TestTask
//
//  Created by Andrei on 17.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTPhoneTableViewCell.h"
#import "TTPhoneCellViewModel.h"

@interface TTPhoneTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *favButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;

@property (nonatomic) TTPhoneCellViewModel *viewModel;

@end

@implementation TTPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)bindViewModel:(TTPhoneCellViewModel *)viewModel {
    self.viewModel = viewModel;
    self.phoneLabel.text = viewModel.phoneNumber;
    [self changeButtonImage]; 
}

- (IBAction)setAsFavourite:(id)sender {
    self.viewModel.isFavourite = !self.viewModel.isFavourite;
    [self changeButtonImage];
}

- (void)changeButtonImage {
    if (self.viewModel.isFavourite) {
        [self.favButton setImage:[UIImage imageNamed:@"starOn"] forState:UIControlStateNormal];
    } else {
        [self.favButton setImage:[UIImage imageNamed:@"starOff"] forState:UIControlStateNormal]; 
    }
}

@end
