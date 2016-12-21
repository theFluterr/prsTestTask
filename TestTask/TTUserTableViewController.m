//
//  TTUserTableViewController.m
//  TestTask
//
//  Created by Andrei on 14.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTUserTableViewController.h"
#import "TTUserCellViewModel.h"
#import "TTUserTableViewModel.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TTUserTableViewCell.h"
#import "UIColor+Hex.h"
#import "TTDetailViewController.h"

#define kCellReuseId @"userCellReuseId"
#define kContactCellReuseId @"contactCellReuseId"
#define detailSegueId @"showDetailSegueId"
#define contactDetailSegueId @"showDetailFromContactSegueId"

@interface TTUserTableViewController ()<UISplitViewControllerDelegate, UISearchBarDelegate>

@property (nonatomic) TTUserTableViewModel *viewModel;
@property (nonatomic) BOOL shouldCollapseDetailViewController;
@property (nonatomic) UISearchBar *searchBar;

@end

@implementation TTUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [TTUserTableViewModel new];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    self.searchBar.placeholder = @"поиск";
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.layer.borderWidth = 0.5;
    self.searchBar.layer.borderColor = [UIColor colorWithHex:0xd3d3d3].CGColor;
    self.title = @"Все контакты";
    
    self.tableView.sectionIndexColor = [UIColor colorWithHex:0xf27f8e];
    self.shouldCollapseDetailViewController = YES;
    self.splitViewController.delegate = self;
    
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [UIView new]; 
    
    @weakify(self);
    [[[RACObserve(self.viewModel, cellViewModels) deliverOnMainThread]
     skip:1]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData]; 
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SplitViewController delegate 

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return self.shouldCollapseDetailViewController;
}

#pragma mark - TablView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.viewModel.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.cellViewModels objectForKey:[self.viewModel.sectionTitles objectAtIndex:section]].count;
    
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.viewModel.alphabet;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSInteger sectionCount = self.viewModel.sectionTitles.count;
    NSInteger indexCount = self.viewModel.alphabet.count;
    NSInteger diff = indexCount / sectionCount;
    NSNumber *roundedIndex = @(index / diff);
    
    return [roundedIndex integerValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.viewModel.sectionTitles objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TTUserTableViewCell *cell = [TTUserTableViewCell new];
    
    TTUserCellViewModel *cellVM = [[self.viewModel.cellViewModels objectForKey:[self.viewModel.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    if (cellVM.userType == PhoneBook) {
        cell = (TTUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kContactCellReuseId forIndexPath:indexPath];
    } else {
        cell = (TTUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellReuseId forIndexPath:indexPath];
    }

    [cell bindViewModel:cellVM];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.textLabel.textColor = [UIColor redColor];
}

#pragma mark - searchBar delegate 

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.viewModel.searchKeyword = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString: detailSegueId] || [segue.identifier isEqualToString: contactDetailSegueId]) {
        TTUserDetailViewModel *detailVM = [self.viewModel createDetailViewModelForIndexPath:self.tableView.indexPathForSelectedRow];
        UINavigationController *navController = segue.destinationViewController;
        TTDetailViewController *detailVC = navController.viewControllers.firstObject;
        [detailVC bindViewModel:detailVM];
    }
}

@end
