//
//  TTDetailViewController.h
//  TestTask
//
//  Created by Andrei on 16.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TTUserDetailViewModel;

@interface TTDetailViewController : UIViewController

- (void)bindViewModel:(TTUserDetailViewModel *)viewModel;

@end
