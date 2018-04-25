//
//  BaseViewController.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import "UIScrollViewHack.h"

@interface BaseViewController : UIViewController <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic)UIView *chooseEmailOrTextPopup;
@property (strong, nonatomic)UIScrollViewHack *registrationPopup;
@property (strong, nonatomic)UIView *helpPopup;
@property (strong, nonatomic)UIScrollView *hamburgerMenu;
@property (strong, nonatomic)UIView *shadeView;
@property (strong, nonatomic)NSArray *segmentedControlArray1;
@property (strong, nonatomic)NSArray *segmentedControlArray2;

-(void)startSharing;
-(void)tryToRegister;

@end
