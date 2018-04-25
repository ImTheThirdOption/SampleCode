//
//  BaseViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "UIScrollViewHack.h"
#import "UIButtonWithString.h"
#import "UIButtonWithDataForRegistrationPopup.h"
#import "BottomNavigationBar.h"
#import "MyUtilities.h"
#import "HttpPost.h"
#import "GlobalVariables.h"
#import "ContactMeViewController.h"
#import "AboutThisAppViewController.h"
//UIView *contactMePopup;
/* UIView *firstListingsPopup;
 UIView *secondListingsPopup;
 UIView *thirdListingsPopup;*/

@implementation BaseViewController

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tryToRegister) name:@"tokenWithNoName" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(triedToRegisterReceiver:) name:@"triedtoregister" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidLoad{
    _segmentedControlArray1 = @[@"Yes",@"No",@"Later"];
    _segmentedControlArray2 = @[@"Buying",@"Selling",@"Both"];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [self.navigationItem setTitle:globals.navigationBarTitle];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    UIButton *hamburgerMenuButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,self.navigationController.navigationBar.frame.size.height*0.8,self.navigationController.navigationBar.frame.size.height*0.8)];
    [hamburgerMenuButton setBackgroundImage:[UIImage imageNamed:@"hamburger_menu_icon.png"] forState:UIControlStateNormal];
    [hamburgerMenuButton addTarget:self action:@selector(slideHamburgerMenu)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *hamburgerMenuBarButton =[[UIBarButtonItem alloc] initWithCustomView:hamburgerMenuButton];
    self.navigationItem.leftBarButtonItem = hamburgerMenuBarButton;
}
-(void)slideHamburgerMenu{
    if (nil==_hamburgerMenu){
        int fontSize = 18;
        int buttonVMargin = 12;
        int buttonHMargin = 12;
        
        float yOrigin = 0;
        if (UIRectEdgeNone != self.edgesForExtendedLayout){
            yOrigin = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
        }
        _shadeView = [[UIView alloc] initWithFrame:CGRectMake(-self.view.frame.size.width, yOrigin, self.view.frame.size.width, self.view.frame.size.height-yOrigin)];
        _shadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.view addSubview:_shadeView];
        
        _hamburgerMenu  = [[UIScrollViewHack alloc] initWithFrame:CGRectMake(-self.view.frame.size.width*0.8, yOrigin, self.view.frame.size.width*0.8, self.view.frame.size.height-yOrigin)];
        _hamburgerMenu.bounces = NO;
        _hamburgerMenu.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:1.0/255.0 alpha:1];
        [self.view addSubview:_hamburgerMenu];
        
        UIView *hamburgerMenuContentView = [[UIView alloc] init];
        [hamburgerMenuContentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_hamburgerMenu addSubview:hamburgerMenuContentView];
        [_hamburgerMenu addConstraint:[NSLayoutConstraint constraintWithItem:hamburgerMenuContentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_hamburgerMenu attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [_hamburgerMenu addConstraint:[NSLayoutConstraint constraintWithItem:hamburgerMenuContentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_hamburgerMenu attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [_hamburgerMenu addConstraint:[NSLayoutConstraint constraintWithItem:hamburgerMenuContentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_hamburgerMenu attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [_hamburgerMenu addConstraint:[NSLayoutConstraint constraintWithItem:hamburgerMenuContentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_hamburgerMenu attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        [_hamburgerMenu addConstraint:[NSLayoutConstraint constraintWithItem:hamburgerMenuContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_hamburgerMenu attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        UIButtonWithString *button1 = [[UIButtonWithString alloc] initWithStringTag:@""];
        [MyUtilities addPopupButton:button1 title:@"Menu" viewHolder:hamburgerMenuContentView beneath:hamburgerMenuContentView position:1 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button1.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        UIView *underline = [UIView new];
        underline.backgroundColor = [UIColor whiteColor];
        [underline setTranslatesAutoresizingMaskIntoConstraints:NO];
        [hamburgerMenuContentView addSubview:underline];
        
        [hamburgerMenuContentView addConstraint:[NSLayoutConstraint constraintWithItem:underline attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button1 attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [hamburgerMenuContentView addConstraint:[NSLayoutConstraint constraintWithItem:underline attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:hamburgerMenuContentView attribute:NSLayoutAttributeWidth multiplier:1 constant:-2*buttonHMargin]];
        [hamburgerMenuContentView addConstraint:[NSLayoutConstraint constraintWithItem:underline attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:hamburgerMenuContentView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [hamburgerMenuContentView addConstraint:[NSLayoutConstraint constraintWithItem:underline attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:3]];
        
        UIButton *button2 = [UIButton new];
        [MyUtilities addPopupButton:button2 title:@"Home" viewHolder:hamburgerMenuContentView beneath:underline position:2 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button2 addTarget:self action:@selector(slideHamburgerMenu) forControlEvents:UIControlEventTouchUpInside];
        [button2 addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButtonWithString *button3 = [[UIButtonWithString alloc] initWithStringTag:@""];
        [MyUtilities addPopupButton:button3 title:@"Visit our website" viewHolder:hamburgerMenuContentView beneath:button2 position:2 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button3 addTarget:self action:@selector(slideHamburgerMenu) forControlEvents:UIControlEventTouchUpInside];
        [button3 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button4 = [UIButton new];
        [MyUtilities addPopupButton:button4 title:@"Contact us" viewHolder:hamburgerMenuContentView beneath:button3 position:2 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button4 addTarget:self action:@selector(slideHamburgerMenu) forControlEvents:UIControlEventTouchUpInside];
        [button4 addTarget:self action:@selector(openContactMeViewController) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button5 = [UIButton new];
        [MyUtilities addPopupButton:button5 title:@"Share app | Refer me" viewHolder:hamburgerMenuContentView beneath:button4 position:2 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button5 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button5 addTarget:self action:@selector(slideHamburgerMenu) forControlEvents:UIControlEventTouchUpInside];
        [button5 addTarget:self action:@selector(startSharing) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button6 = [UIButton new];
        [MyUtilities addPopupButton:button6 title:@"Register" viewHolder:hamburgerMenuContentView beneath:button5 position:2 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button6 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button6 addTarget:self action:@selector(slideHamburgerMenu) forControlEvents:UIControlEventTouchUpInside];
        [button6 addTarget:self action:@selector(tryToRegister) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button7 = [UIButton new];
        [MyUtilities addPopupButton:button7 title:@"Help" viewHolder:hamburgerMenuContentView beneath:button6 position:2 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button7 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button7 addTarget:self action:@selector(slideHamburgerMenu) forControlEvents:UIControlEventTouchUpInside];
        [button7 addTarget:self action:@selector(openHelpPopup) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button8 = [UIButton new];
        [MyUtilities addPopupButton:button8 title:@"About this app" viewHolder:hamburgerMenuContentView beneath:button7 position:2 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button8 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button8 addTarget:self action:@selector(slideHamburgerMenu) forControlEvents:UIControlEventTouchUpInside];
        [button8 addTarget:self action:@selector(openAboutThisAppViewController) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button9 = [UIButton new];
        [MyUtilities addPopupButton:button9 title:[@"Version " stringByAppendingString:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]] viewHolder:hamburgerMenuContentView beneath:button8 position:3 width:_hamburgerMenu.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        [button9 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    CGFloat red,green,blue,alpha;
    UIColor *backgroundColor = _shadeView.backgroundColor;
    [backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _hamburgerMenu.frame = CGRectMake(-_hamburgerMenu.frame.origin.x-_hamburgerMenu.frame.size.width,
                                      _hamburgerMenu.frame.origin.y,
                                      _hamburgerMenu.frame.size.width,
                                      _hamburgerMenu.frame.size.height);
    _shadeView.frame = CGRectMake(-_shadeView.frame.origin.x-_shadeView.frame.size.width,
                                      _shadeView.frame.origin.y,
                                      _shadeView.frame.size.width,
                                      _shadeView.frame.size.height);
    _shadeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8-alpha];
    [UIView commitAnimations];
}
- (void)goHome:(id)sender{
    [BottomNavigationBar goHome:sender];
}
- (void)openContactMeViewController{
    [self.navigationController pushViewController:[ContactMeViewController new] animated:YES];
}
- (void)startSharing{
    float width = 0.9;
    int fontSize = 24;
    int buttonVMargin = 8;
    int buttonHMargin = 12;
    float yOrigin = 0;
    if (UIRectEdgeNone != self.edgesForExtendedLayout){
        yOrigin = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    }
    
    _chooseEmailOrTextPopup = [UIView new];
    _chooseEmailOrTextPopup.frame = CGRectMake(0, yOrigin, self.view.frame.size.width, self.view.frame.size.height-yOrigin);
    _chooseEmailOrTextPopup.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:_chooseEmailOrTextPopup];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    UIImageView *viewHolder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
    [viewHolder setUserInteractionEnabled:YES];
    [viewHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_chooseEmailOrTextPopup addSubview:viewHolder];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    
    UIButton *button1 = [UIButton new];
    [MyUtilities addPopupButton:button1 title:@"Share through email" viewHolder:viewHolder beneath:viewHolder position:1 width:width*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [button1 addTarget:self action:@selector(emailChosen) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton new];
    [MyUtilities addPopupButton:button2 title:@"Share through text" viewHolder:viewHolder beneath:button1 position:2 width:width*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [button2 addTarget:self action:@selector(textChosen) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [UIButton new];
    [MyUtilities underlineTextInButton:button title:@"close" fontSize:20];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.numberOfLines = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"close";
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width*self.view.frame.size.width/3.0, 10000)];
    size = CGSizeMake(width*self.view.frame.size.width/3.0, MAX(size.height, 30));
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [viewHolder addSubview:button];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button2 attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-buttonVMargin]];
    [button addTarget:self action:@selector(closeEmailOrTextPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [_chooseEmailOrTextPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_chooseEmailOrTextPopup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [_chooseEmailOrTextPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_chooseEmailOrTextPopup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)closeEmailOrTextPopup{
    [_chooseEmailOrTextPopup removeFromSuperview];
}
-(void)emailChosen{
    [self closeEmailOrTextPopup];
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertController *alertController=[UIAlertController
                                            alertControllerWithTitle:@"Email not enabled"
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                   }];
        [alertController addAction:ok];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    
    MFMailComposeViewController *mailController = [MFMailComposeViewController new];
    mailController.mailComposeDelegate = self;
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [mailController setMessageBody:[NSString stringWithFormat:@"I would like to share the %@ app with you. Go to %@ for more information and download links.", globals.navigationBarTitle, globals.openDoorRealtorWebsite] isHTML:NO];
    [self presentViewController:mailController animated:YES completion:nil];
}

-(void)textChosen{
    [self closeEmailOrTextPopup];
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertController *alertController=[UIAlertController
                                            alertControllerWithTitle:@"SMS not enabled"
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                   }];
        [alertController addAction:ok];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    
    MFMessageComposeViewController *messageController = [MFMessageComposeViewController new];
    messageController.messageComposeDelegate = self;
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [messageController setBody:[NSString stringWithFormat:@"I would like to share the %@ app with you. Go to %@ for more information and download links.", globals.navigationBarTitle, globals.openDoorRealtorWebsite]];
    [self presentViewController:messageController animated:YES completion:nil];
}
/*-(void)startSharing{
    int status = ABAddressBookGetAuthorizationStatus();
    if (kABAuthorizationStatusDenied==status || kABAuthorizationStatusNotDetermined==status){
        ABAddressBookRef addressBook =  ABAddressBookCreateWithOptions(NULL, NULL);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            if (granted) {
                ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
                picker.peoplePickerDelegate = self;
                
                [self presentViewController:picker animated:YES completion:nil];
            }
            else {
                
            }
        });
    }
    else if (kABAuthorizationStatusAuthorized==status){
        ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
        picker.peoplePickerDelegate = self;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}*/
/*- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)picker didSelectPerson:(ABRecordRef)person {
 [AppDelegate makeToast:@"didSelectPerson"];
 [self displayPerson:person];
 
 //[self dismissViewControllerAnimated:YES completion:nil];
 }*/
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (kABPersonPhoneProperty==property){
        NSString *phone = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(ABRecordCopyValue(person, kABPersonPhoneProperty), identifier);
        [self dismissViewControllerAnimated:YES completion:^{
            [self sendReferralTextTo:phone];
        }];
    }
    else if (kABPersonEmailProperty==property){
        NSString *email = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(ABRecordCopyValue(person, kABPersonEmailProperty), identifier);
        [self dismissViewControllerAnimated:YES completion:^{
            [self sendReferralEmailTo:email];
        }];
    }
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)sendReferralTextTo:(NSString *)phoneNumber{
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertController *alertController=[UIAlertController
                                            alertControllerWithTitle:@"SMS not enabled"
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                   }];
        [alertController addAction:ok];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    
    MFMessageComposeViewController *messageController = [MFMessageComposeViewController new];
    messageController.messageComposeDelegate = self;
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [messageController setRecipients:@[phoneNumber]];
    [messageController setBody:[NSString stringWithFormat:@"I would like to share the %@ app with you. Go to %@ for more information and download links.", globals.navigationBarTitle, globals.openDoorRealtorWebsite]];
    [self presentViewController:messageController animated:YES completion:nil];
}
-(void)sendReferralEmailTo:(NSString *)emailAddress{
    if(![MFMailComposeViewController canSendMail]) {
        UIAlertController *alertController=[UIAlertController
                                            alertControllerWithTitle:@"Email not enabled"
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       
                                                   }];
        [alertController addAction:ok];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertController animated:YES completion:nil];
        });
        return;
    }
    
    MFMailComposeViewController *mailController = [MFMailComposeViewController new];
    mailController.mailComposeDelegate = self;
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [mailController setToRecipients:@[emailAddress]];
    [mailController setMessageBody:[NSString stringWithFormat:@"I would like to share the %@ app with you. Go to %@ for more information and download links.", globals.navigationBarTitle, globals.openDoorRealtorWebsite] isHTML:NO];
    [self presentViewController:mailController animated:YES completion:nil];
}
/*-(void)sendReferralEmailTo:(NSString *)email{
 GlobalVariables *globals = [GlobalVariables sharedInstance];
 CFStringRef CFDirections = (__bridge CFStringRef)[NSString stringWithFormat:@"I would like to share the %@ app with you. Go to %@ for more information and download links.", globals.navigationBarTitle, globals.openDoorRealtorWebsite];
 CFStringRef encodedDirections = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, CFDirections, NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
 [self openNonWebURLWithString:[NSString stringWithFormat:@"mailto:%@?body=%@", email, (__bridge NSString *)encodedDirections]];
 }*/
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:{
            break;
        }
        case MessageComposeResultFailed:
        {
            UIAlertController *alertController=[UIAlertController
                                                alertControllerWithTitle:@"Failed to send SMS"
                                                message:nil
                                                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                       }];
            [alertController addAction:ok];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:{
            UIAlertController *alertController=[UIAlertController
                                                alertControllerWithTitle:@"Failed to send email"
                                                message:[@"Error: " stringByAppendingString:[error localizedDescription]]
                                                preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {
                                                           
                                                       }];
            [alertController addAction:ok];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}
/*- (void)chooseReferralText:(int)choice{
 UIAlertController *alertController=[UIAlertController
 alertControllerWithTitle:@"Choose a message to include with your referral"
 message:nil
 preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action) {
 if (0==choice){
 [self chooseReferralRecipient:alertController.textFields[0].text];
 //[self openNonWebURLWithString:[@"mailto:?body=" stringByAppendingString:[alertController.textFields[0].text stringByAppendingString:@"\nGo to..."]]];
 }
 else{
 [self openNonWebURLWithString:@"sms:"];
 //[self onSendTextAndMessageChosen:alertController.textFields[0].text];
 
 //[self openNonWebURLWithString:[@"sms:?body=" stringByAppendingString:[alertController.textFields[0].text stringByAppendingString:@"\nGo to..."]]];
 
 }
 }];
 UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action) {
 [self startSharing];
 //[alertController dismissViewControllerAnimated:YES completion:nil];
 }];
 [alertController addAction:ok];
 [alertController addAction:cancel];
 [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
 textField.placeholder = @"";
 }];
 [self presentViewController:alertController animated:YES completion:nil];
 }
 - (void)chooseReferralRecipient:(NSString *)message{
 CFStringRef CFMessage = (__bridge CFStringRef)message;
 CFStringRef encodedMessage = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, CFMessage, NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
 message = (__bridge NSString *)encodedMessage;
 UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Enter the recipient's email address" message:nil preferredStyle:UIAlertControllerStyleAlert];
 
 UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
 CFStringRef CFDirections = (__bridge CFStringRef)@"\nGo to...";
 CFStringRef encodedDirections = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, CFDirections, NULL, CFSTR(":/?#[]@!$&'()*+,;="), kCFStringEncodingUTF8);
 
 [self openNonWebURLWithString:[@"mailto:" stringByAppendingString:[alertController.textFields[0].text stringByAppendingString: [@"?body=" stringByAppendingString: [message stringByAppendingString: (__bridge NSString *)encodedDirections]]]]];
 }];
 UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault
 handler:^(UIAlertAction * action) {
 }];
 [alertController addAction:ok];
 [alertController addAction:cancel];
 [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
 textField.placeholder = @"";
 }];
 [self presentViewController:alertController animated:YES completion:nil];
 }*/
- (void)tryToRegister{
    if (nil==_registrationPopup){
        float width = 0.9;
        int fontSize = 18;
        int buttonVMargin = 8;
        int buttonHMargin = 12;
        
        float yOrigin = 0;
        if (UIRectEdgeNone != self.edgesForExtendedLayout){
            yOrigin = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
        }
        
        _registrationPopup = [UIScrollViewHack new];
        _registrationPopup.frame = CGRectMake(0, yOrigin, self.view.frame.size.width, self.view.frame.size.height-yOrigin);
        _registrationPopup.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        _registrationPopup.bounces = NO;
        [self.view addSubview:_registrationPopup];
        
        UIView *contentView = [[UIView alloc] init];
        [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_registrationPopup addSubview:contentView];
        [_registrationPopup addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_registrationPopup attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [_registrationPopup addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:_registrationPopup attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [_registrationPopup addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_registrationPopup attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [_registrationPopup addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationLessThanOrEqual toItem:_registrationPopup attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        //[_registrationPopup addConstraint:[NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_registrationPopup attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        UIImageView *viewHolder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
        [viewHolder setUserInteractionEnabled:YES];
        [viewHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentView addSubview:viewHolder];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
        
        UITextField *textField1 = [UITextField new];
        [MyUtilities addTextField:textField1 :@"First name" :viewHolder :viewHolder :1 vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        textField1.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField1.delegate = self;
        
        UITextField *textField2 = [UITextField new];
        [MyUtilities addTextField:textField2 :@"Last name" :viewHolder :textField1 :2 vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        textField2.autocapitalizationType = UITextAutocapitalizationTypeWords;
        textField2.delegate = self;
        
        UITextField *textField3 = [UITextField new];
        [MyUtilities addTextField:textField3 :@"Email address" :viewHolder :textField2 :2 vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        textField3.delegate = self;
        
        UITextField *textField4 = [UITextField new];
        [MyUtilities addTextField:textField4 :@"Phone#" :viewHolder :textField3 :2 vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        textField4.delegate = self;
        
        UITextField *textField5 = [UITextField new];
        [MyUtilities addTextField:textField5 :@"How did you hear about me?" :viewHolder :textField4 :2 vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
        textField5.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        textField5.delegate = self;
        
        UITextView *textView1 = [UITextView new];
        textView1.text = @"May I contact you?";
        textView1.textColor = [UIColor blackColor];
        textView1.font = [UIFont systemFontOfSize:fontSize];
        textView1.editable = NO;
        textView1.scrollEnabled = NO;
        textView1.userInteractionEnabled = NO;
        [textView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [viewHolder addSubview:textView1];
        float height = [MyUtilities calculateHeightFor:textView1.text and:self.view.frame.size.width-2*buttonHMargin with:fontSize];
        [MyUtilities addConstraint:viewHolder view:textView1 topToBottomView:textField5 topToBottomMultiplier:1 topToBottomConstant:buttonVMargin heightView:nil heightMultiplier:0 heightConstant:height centerXView:viewHolder centerXMultiplier:1 centerXConstant:0 widthView:viewHolder widthMultiplier:1 widthConstant:-2*buttonHMargin];
        
        [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1]];
        [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
        [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateSelected];
        
        UISegmentedControl *segmentedControl1 = [[UISegmentedControl alloc] initWithItems:_segmentedControlArray1];
        [segmentedControl1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [viewHolder addSubview:segmentedControl1];
        [MyUtilities addConstraint:viewHolder view:segmentedControl1 topToBottomView:textView1 topToBottomMultiplier:1 topToBottomConstant:buttonVMargin centerXView:viewHolder centerXMultiplier:1 centerXConstant:0 widthView:viewHolder widthMultiplier:1 widthConstant:-2*buttonHMargin];
        
        UITextView *textView2 = [UITextView new];
        textView2.text = @"Are you buying or selling?";
        textView2.textColor = [UIColor blackColor];
        textView2.font = [UIFont systemFontOfSize:fontSize];
        textView2.editable = NO;
        textView2.scrollEnabled = NO;
        textView2.userInteractionEnabled = NO;
        [textView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [viewHolder addSubview:textView2];
        height = [MyUtilities calculateHeightFor:textView2.text and:self.view.frame.size.width-2*buttonHMargin with:fontSize];
        [MyUtilities addConstraint:viewHolder view:textView2 topToBottomView:segmentedControl1 topToBottomMultiplier:1 topToBottomConstant:buttonVMargin heightView:nil heightMultiplier:0 heightConstant:height centerXView:viewHolder centerXMultiplier:1 centerXConstant:0 widthView:viewHolder widthMultiplier:1 widthConstant:-2*buttonHMargin];
        
        UISegmentedControl *segmentedControl2 = [[UISegmentedControl alloc] initWithItems:_segmentedControlArray2];
        [segmentedControl2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [viewHolder addSubview:segmentedControl2];
        [MyUtilities addConstraint:viewHolder view:segmentedControl2 topToBottomView:textView2 topToBottomMultiplier:1 topToBottomConstant:buttonVMargin centerXView:viewHolder centerXMultiplier:1 centerXConstant:0 widthView:viewHolder widthMultiplier:1 widthConstant:-2*buttonHMargin];
        
        UIButton *closeButton = [UIButton new];
        [MyUtilities underlineTextInButton:closeButton title:@"close" fontSize:20];
        //[closeButton setTitle:@"close" forState:UIControlStateNormal];
        //[closeButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
        [closeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //closeButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [closeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        closeButton.titleLabel.numberOfLines = 0;
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"close";
        label.font = [UIFont systemFontOfSize:20];
        label.numberOfLines = 0;
        CGSize size = [label sizeThatFits:CGSizeMake(width*self.view.frame.size.width/3.0, 10000)];
        size = CGSizeMake(width*self.view.frame.size.width/3.0, MAX(size.height, 30));
        
        [closeButton addConstraint:[NSLayoutConstraint constraintWithItem:closeButton.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:closeButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        [viewHolder addSubview:closeButton];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:segmentedControl2 attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:closeButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [closeButton addTarget:self action:@selector(closeRegistrationPopup) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *registerLaterButton = [UIButton new];
        [MyUtilities underlineTextInButton:registerLaterButton title:@"register later" fontSize:20];
        //[registerLaterButton setTitle:@"register later" forState:UIControlStateNormal];
        //[registerLaterButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
        [registerLaterButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //registerLaterButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [registerLaterButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        registerLaterButton.titleLabel.numberOfLines = 0;
        
        label.text = @"register later";
        label.font = [UIFont systemFontOfSize:20];
        label.numberOfLines = 0;
        size = [label sizeThatFits:CGSizeMake(width*self.view.frame.size.width/3.0, 10000)];
        size = CGSizeMake(width*self.view.frame.size.width/3.0, MAX(size.height, 30));
        
        [registerLaterButton addConstraint:[NSLayoutConstraint constraintWithItem:registerLaterButton.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:registerLaterButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        [viewHolder addSubview:registerLaterButton];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerLaterButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:segmentedControl2 attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerLaterButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:closeButton attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerLaterButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerLaterButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerLaterButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [registerLaterButton addTarget:self action:@selector(closeRegistrationPopup) forControlEvents:UIControlEventTouchUpInside];
        
        UIButtonWithDataForRegistrationPopup *registerButton = [UIButtonWithDataForRegistrationPopup new];
        [MyUtilities underlineTextInButton:registerButton title:@"register" fontSize:20];
        //[registerButton setTitle:@"register" forState:UIControlStateNormal];
        //[registerButton setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
        [registerButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        //registerButton.titleLabel.font = [UIFont systemFontOfSize:20];
        [registerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        registerButton.titleLabel.numberOfLines = 0;
        
        label.text = @"register";
        label.font = [UIFont systemFontOfSize:20];
        label.numberOfLines = 0;
        size = [label sizeThatFits:CGSizeMake(width*self.view.frame.size.width/3.0, 10000)];
        size = CGSizeMake(width*self.view.frame.size.width/3.0, MAX(size.height, 30));
        
        [registerButton addConstraint:[NSLayoutConstraint constraintWithItem:registerButton.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:registerButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
        
        [viewHolder addSubview:registerButton];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:segmentedControl2 attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:registerLaterButton attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
        [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:registerButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [registerButton addData:textField1 :textField2 :textField3 :textField4 :textField5 :segmentedControl1 :segmentedControl2];
        [registerButton addTarget:self action:@selector(closeRegistrationPopup) forControlEvents:UIControlEventTouchUpInside];
        [registerButton addTarget:self action:@selector(onNameChosen:) forControlEvents:UIControlEventTouchUpInside];
        
        [_registrationPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_registrationPopup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [_registrationPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:_registrationPopup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [contentView addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        
    }
}
- (void)closeRegistrationPopup{
    [_registrationPopup removeFromSuperview];
    _registrationPopup = nil;
}
- (void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary* dictionary = [notification userInfo];
    CGSize keyboardSize = [[dictionary objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    _registrationPopup.frame = CGRectMake(0, _registrationPopup.frame.origin.y, _registrationPopup.frame.size.width, self.view.frame.size.height-_registrationPopup.frame.origin.y-keyboardSize.height);
    
    
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0];
    _registrationPopup.frame = CGRectMake(0, _registrationPopup.frame.origin.y, _registrationPopup.frame.size.width, self.view.frame.size.height-_registrationPopup.frame.origin.y);
    [UIView commitAnimations];
}
-(void)onNameChosen:(id)sender{
    NSString *newFirstName = [(UIButtonWithDataForRegistrationPopup *)sender textField1].text;
    NSString *newLastName = [(UIButtonWithDataForRegistrationPopup *)sender textField2].text;
    
    if ([newFirstName isEqualToString:@""] || [newLastName isEqualToString:@""]){
        UIAlertController *alertController=[UIAlertController
                                            alertControllerWithTitle:@"Please choose a first and last name."
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self tryToRegister];
                                                   }];
        [alertController addAction:ok];
        [(UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
    }
    else {
        NSString *oldFirstName = [AppDelegate firstName];
        NSString *oldLastName = [AppDelegate lastName];
        if (nil==oldFirstName){
            oldFirstName=@"";
        }
        if (nil==oldLastName){
            oldLastName=@"";
        }
        [AppDelegate firstName:newFirstName];
        [AppDelegate lastName:newLastName];
        NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"registeredname"] mutableCopy];
        if (myDictionary==nil){
            myDictionary = [NSMutableDictionary new];
        }
        myDictionary[@"firstName"] = newFirstName;
        myDictionary[@"lastName"] = newLastName;
        [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"registeredname"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self reRegister:sender oldFirstName:oldFirstName oldLastName:oldLastName];
    }
}

-(void)reRegister:(id)sender oldFirstName:(NSString *)oldFirstName oldLastName:(NSString *)oldLastName {
    NSString *text1 = [(UIButtonWithDataForRegistrationPopup *)sender textField1].text;
    NSString *text2 = [(UIButtonWithDataForRegistrationPopup *)sender textField2].text;
    NSString *text3 = [(UIButtonWithDataForRegistrationPopup *)sender textField3].text;
    NSString *text4 = [(UIButtonWithDataForRegistrationPopup *)sender textField4].text;
    NSString *text5 = [(UIButtonWithDataForRegistrationPopup *)sender textField5].text;
    UISegmentedControl *segmentedControl = [(UIButtonWithDataForRegistrationPopup *)sender segmentedControl1];
    NSString *texta1;
    if (-1==[segmentedControl selectedSegmentIndex]){
        texta1 = @"";
    }
    else{
        texta1 = [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    }
    NSString *texta2;
    segmentedControl = [(UIButtonWithDataForRegistrationPopup *)sender segmentedControl2];
    if (-1==[segmentedControl selectedSegmentIndex]){
        texta2 = @"";
    }
    else{
        texta2 = [segmentedControl titleForSegmentAtIndex:[segmentedControl selectedSegmentIndex]];
    }
    
    NSString *data = [NSString stringWithFormat:@"first_name=%@&last_name=%@&email_address=%@&phone_number=%@&how_heard=%@&may_contact=%@&buying_or_selling=%@&token=%@&system=ios&version=%@&old_first_name=%@&old_last_name=%@&new_name=%@",text1,text2,text3,text4,text5,texta1,texta2,[AppDelegate token],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],oldFirstName, oldLastName, @"yes"];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [HttpPost post:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"register-contact.php"] data:data broadcastReceiver:@"triedtoregister" extraData:@""];
}
-(void)triedToRegisterReceiver:(NSNotification *)notification {
    NSString *result = [[notification userInfo] objectForKey:@"result"];
    NSLog(@"aaa%@", result);
    if ([result isEqualToString:@"taken"] || ![result isEqualToString:@"success"]){
        NSString *title = @"";
        if ([result isEqualToString:@"taken"]){
            title = @"That name is not available. Please choose another.";
        }
        else if (![result isEqualToString:@"success"]){
            title = @"There was an error.";
        }
        NSMutableDictionary *myDictionary = [[[NSUserDefaults standardUserDefaults] objectForKey:@"registeredname"] mutableCopy];
        if (myDictionary==nil){
            myDictionary = [NSMutableDictionary new];
        }
        myDictionary[@"firstName"] = nil;
        myDictionary[@"lastName"] = nil;
        [AppDelegate firstName:nil];
        [AppDelegate lastName:nil];
        [[NSUserDefaults standardUserDefaults] setObject:myDictionary forKey:@"registeredname"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UIAlertController *alertController=[UIAlertController
                                            alertControllerWithTitle:title
                                            message:nil
                                            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [self tryToRegister];
                                                   }];
        [alertController addAction:ok];
        [(UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
    }
    else {
        [AppDelegate makeToast:@"Registration was successful."];
    }
}

/*- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)openHelpPopup{
    float width = 0.9;
    int fontSize = 24;
    int buttonVMargin = 8;
    int buttonHMargin = 12;
    
    float yOrigin = 0;
    if (UIRectEdgeNone != self.edgesForExtendedLayout){
        yOrigin = self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height;
    }
    
    _helpPopup = [UIView new];
    _helpPopup.frame = CGRectMake(0, yOrigin, self.view.frame.size.width, self.view.frame.size.height-yOrigin);
    _helpPopup.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [self.view addSubview:_helpPopup];
    
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    UIImageView *viewHolder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
    [viewHolder setUserInteractionEnabled:YES];
    [viewHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_helpPopup addSubview:viewHolder];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:width constant:0]];
    
    UIButtonWithString *button1 = [[UIButtonWithString alloc] initWithStringTag:@"http://www.opendoormediadesign.com/app-development/"];
    [MyUtilities addPopupButton:button1 title:@"Support website" viewHolder:viewHolder beneath:viewHolder position:1 width:width*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [button1 addTarget:self action:@selector(closeHelpPopup) forControlEvents:UIControlEventTouchUpInside];
    [button1 addTarget:self action:@selector(openURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButtonWithString *button2 = [[UIButtonWithString alloc] initWithStringTag:@"mailto:support@opendoormediadesign.com"];
    [MyUtilities addPopupButton:button2 title:@"Email support" viewHolder:viewHolder beneath:button1 position:2 width:width*self.view.frame.size.width vMargin:buttonVMargin hMargin:buttonHMargin fontSize:fontSize];
    [button2 addTarget:self action:@selector(closeHelpPopup) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(openNonWebURL:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [UIButton new];
    [MyUtilities underlineTextInButton:button title:@"close" fontSize:20];
    //[button setTitle:@"close" forState:UIControlStateNormal];
    //[button setTitleColor:[UIColor colorWithRed:0 green:174.0/255.0 blue:239.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setTextAlignment:NSTextAlignmentLeft];
    //button.titleLabel.font = [UIFont systemFontOfSize:20];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    button.titleLabel.numberOfLines = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"close";
    label.font = [UIFont systemFontOfSize:20];
    label.numberOfLines = 0;
    CGSize size = [label sizeThatFits:CGSizeMake(width*self.view.frame.size.width/3.0, 10000)];
    size = CGSizeMake(width*self.view.frame.size.width/3.0, MAX(size.height, 30));
    
    [button addConstraint:[NSLayoutConstraint constraintWithItem:button.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    
    [viewHolder addSubview:button];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button2 attribute:NSLayoutAttributeBottom multiplier:1 constant:buttonVMargin]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0/3.0 constant:0]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:size.height]];
    [viewHolder addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:viewHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-buttonVMargin]];
    [button addTarget:self action:@selector(closeHelpPopup) forControlEvents:UIControlEventTouchUpInside];
    
    [_helpPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_helpPopup attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [_helpPopup addConstraint:[NSLayoutConstraint constraintWithItem:viewHolder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_helpPopup attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void)closeHelpPopup{
    [_helpPopup removeFromSuperview];
}
- (void)openAboutThisAppViewController{
    [self.navigationController pushViewController:[AboutThisAppViewController new] animated:YES];
}

- (void)openURLWithString:(NSString *)url{
    [MyUtilities openURLWithString:url];
}

- (void)openURL:(id)sender{
    NSString *url = [(UIButtonWithString *)sender stringTag];
    [self openURLWithString:url];
}
- (void)openNonWebURLWithString:(NSString *)url{
    [MyUtilities openNonWebURLWithString:url];
}

- (void)openNonWebURL:(id)sender{
    NSString *url = [(UIButtonWithString *)sender stringTag];
    [self openNonWebURLWithString:url];
}

@end
