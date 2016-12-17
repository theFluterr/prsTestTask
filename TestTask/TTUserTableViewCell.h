//
//  TTUserTableViewCell.h
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTUserCellViewModel; 

@interface TTUserTableViewCell : UITableViewCell

- (void)bindViewModel:(TTUserCellViewModel *)cellVM;

@end
