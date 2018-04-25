//
//  LaunchScreen.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//
#import "LaunchScreen.h"
#import "HomeScreenViewController.h"
@interface LaunchScreen()

@end

@implementation LaunchScreen

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void) viewDidLoad{
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    UIButton *launchScreenImage = [[UIButton alloc] init];
    [launchScreenImage setBackgroundImage:[UIImage imageNamed:@"LaunchScreen"] forState:UIControlStateNormal];
    [launchScreenImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:launchScreenImage];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:launchScreenImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:launchScreenImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:launchScreenImage attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:launchScreenImage attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [launchScreenImage addTarget:self action:@selector(openHomeScreenViewController) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)openHomeScreenViewController{
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setViewControllers:@[[HomeScreenViewController new]]];
    //[self.navigationController pushViewController:[HomeScreenViewController new] animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */

@end
