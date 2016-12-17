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

#define kCellReuseId @"userCellReuseId"

@interface TTUserTableViewController ()<UISplitViewControllerDelegate>

@property (nonatomic) TTUserTableViewModel *viewModel;
@property (nonatomic) BOOL shouldCollapseDetailViewController;

@end

@implementation TTUserTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [TTUserTableViewModel new];
    
    self.title = @"Все контакты";
    
    self.tableView.sectionIndexColor = [UIColor colorWithHex:0xf27f8e];
    self.shouldCollapseDetailViewController = YES;
    self.splitViewController.delegate = self;
    
    [[[RACObserve(self.viewModel, cellViewModels) deliverOnMainThread]
     skip:1]
     subscribeNext:^(id  _Nullable x) {
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
     TTUserTableViewCell *cell = (TTUserTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kCellReuseId forIndexPath:indexPath];
    
    TTUserCellViewModel *cellVM = [[self.viewModel.cellViewModels objectForKey:[self.viewModel.sectionTitles objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];

    [cell bindViewModel:cellVM]; 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    headerView.contentView.backgroundColor = [UIColor whiteColor];
    headerView.textLabel.textColor = [UIColor redColor];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
