//
//  TTLoginViewController.m
//  TestTask
//
//  Created by Andrei on 13.12.16.
//  Copyright © 2016 Tesk. All rights reserved.
//

#import "TTLoginViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TTLoginManager.h"
#import "TTLoginViewModel.h"

@interface TTLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *proceedButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic) TTLoginViewModel *viewModel;

@property (strong) TTLoginManager *loginManager;

@end

@implementation TTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel = [TTLoginViewModel new];
    
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.errorLabel.hidden = YES;
    [self.activityIndicator setHidden:YES]; 
    
    [self registerForKeyboardNotifications];
    
    @weakify(self)
    [[[RACObserve(self.viewModel, loginStatus) deliverOnMainThread]
     skip:1]
     subscribeNext:^(NSNumber * _Nullable new) {
         @strongify(self)
         [self.activityIndicator stopAnimating];
         [self.activityIndicator setHidden:YES];
         if ([new isEqual:@1]) {
             self.errorLabel.hidden = YES;
             self.errorLabel.textColor = [UIColor greenColor];
             [self performSegueWithIdentifier:@"proceedToSplitViewController" sender:nil];

         } else {
             self.errorLabel.hidden = NO;
             self.errorLabel.text = @"Логин или пароль введены неверно";
             self.errorLabel.textColor = [UIColor redColor];
         }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)processLogin:(id)sender {
    [self.viewModel loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text];
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
}


#pragma mark - keyboard handling

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    
    
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    CGPoint scrollPoint = CGPointMake(0.0, self.proceedButton.frame.origin.y-kbSize.height - 60);
    [UIView animateWithDuration:0.5 animations:^{
        self.logoImageView.alpha = 0.0;
    }];
    [self.scrollView setContentOffset:scrollPoint animated:YES];
    [self.scrollView setAlwaysBounceVertical:YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = contentInsets;
    [UIView animateWithDuration:0.5 animations:^{
        self.logoImageView.alpha = 1.0;
    }];
    [self.scrollView setAlwaysBounceVertical:NO];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
