//
//  TTPhoneTableViewCell.h
//  TestTask
//
//  Created by Andrei on 17.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTPhoneCellViewModel; 

@interface TTPhoneTableViewCell : UITableViewCell

- (void)bindViewModel:(TTPhoneCellViewModel *)viewModel;

@end
