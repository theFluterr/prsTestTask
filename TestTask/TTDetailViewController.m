//
//  TTDetailViewController.m
//  TestTask
//
//  Created by Andrei on 16.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTDetailViewController.h"
#import "TTUserDetailViewModel.h"
#import "TTPhoneTableViewCell.h"
#import <ReactiveObjC/ReactiveObjC.h>

#define phoneCellReuseId @"phoneCellReuseId"

@interface TTDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) TTUserDetailViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBarButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end

@implementation TTDetailViewController

- (void)bindViewModel:(TTUserDetailViewModel *)viewModel {
    self.viewModel = viewModel;
    @weakify(self);
    [RACObserve(self.viewModel, userStatusAttributedString) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateStatus];
    }];
}

- (void)updateStatus {
    self.statusLabel.attributedText = self.viewModel.userStatusAttributedString;
    [self.chatButton setImage:self.viewModel.chatButtonImage forState:UIControlStateNormal];
    [self.videoButton setImage:self.viewModel.videoButtonImage forState:UIControlStateNormal];
    [self.phoneButton setImage:self.viewModel.phoneButtonImage forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userImageView.image = self.viewModel.userImage;
    self.usernameLabel.text = self.viewModel.username;
    self.statusLabel.attributedText = self.viewModel.userStatusAttributedString; 
    
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.statusLabel.attributedText = self.viewModel.userStatusAttributedString;
    [self.chatButton setImage:self.viewModel.chatButtonImage forState:UIControlStateNormal];
    [self.videoButton setImage:self.viewModel.videoButtonImage forState:UIControlStateNormal];
    [self.phoneButton setImage:self.viewModel.phoneButtonImage forState:UIControlStateNormal];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.userImageView.layer.cornerRadius = self.userImageView.frame.size.height / 2;
    self.userImageView.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.phoneCellViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTPhoneTableViewCell *cell = (TTPhoneTableViewCell *)[tableView dequeueReusableCellWithIdentifier:phoneCellReuseId];
    [cell bindViewModel:[self.viewModel.phoneCellViewModels objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
