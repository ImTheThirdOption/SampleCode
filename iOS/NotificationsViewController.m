//
//  NotificationsViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//
#import "NotificationsViewController.h"
#import "GlobalVariables.h"
#import "UIButtonWithString.h"
#import "BottomNavigationBar.h"
#import "MyUtilities.h"
#import "SpecificNotificationViewController.h"
#import "MessagerViewController.h"

@interface NotificationsViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation NotificationsViewController


-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
 }

- (void) viewDidLoad{
    [super viewDidLoad];
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notifications_bg_red.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:backgroundView];
    
    UIImageView *header1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"general_notifications_header.png"]];
    [self.view addSubview:header1];
    
    header1.frame = CGRectMake(0.2*self.view.frame.size.width, self.navigationController.navigationBar.frame.origin.y+self.navigationController.navigationBar.frame.size.height+16.7, 0.6*self.view.frame.size.width, 0.6*self.view.frame.size.width*header1.image.size.height/header1.image.size.width);
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, header1.frame.origin.y+header1.frame.size.height+16.7, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.origin.y-2.0*self.navigationController.navigationBar.frame.size.height-header1.frame.size.height-2.0*16.7) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.alwaysBounceVertical = NO;
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)nil headerImage:(UIView *)self.view];
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"get-notification-previews.php"]]];
    NSString *post = globals.phpKey;
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    urlRequest.HTTPMethod = @"POST";
    [urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPBody = postData;
    
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(data)  {
            _jsonDataArray = [[NSArray alloc] initWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error]];
            dispatch_async(dispatch_get_main_queue(), ^{
                tableView.dataSource = self;
                tableView.delegate = self;
                tableView.estimatedRowHeight = 120.0;
                tableView.rowHeight = UITableViewAutomaticDimension;
                [self.view addSubview:tableView];
            });
        }
        
    }];
    
    [dataTask resume];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _jsonDataArray.count;
}
#define NOTIFICATIONIMAGE_TAG 1

#define PREVIEWTEXT_TAG 2

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myIdentifier";
    UIButton *preview;
    UIImageView *notificationImage;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil==cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1];
        
        int hMargin = 9;
        int vMargin = 2;
        notificationImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group.png"]];
        notificationImage.tag = NOTIFICATIONIMAGE_TAG;
        [notificationImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:notificationImage];
        /*[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
        //[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:.27 constant:0]];
        if (notificationImage.image.size.height!=0){
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:notificationImage attribute:NSLayoutAttributeHeight multiplier:(notificationImage.image.size.width / notificationImage.image.size.height) constant:0]];
        }
        
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeLeading multiplier:1 constant:hMargin]];*/
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:0.165 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:0.33 constant:-2*hMargin]];
        if (notificationImage.image.size.height!=0){
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:notificationImage attribute:NSLayoutAttributeHeight multiplier:(notificationImage.image.size.width / notificationImage.image.size.height) constant:0]];
        }
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:notificationImage attribute:NSLayoutAttributeHeight multiplier:1 constant:+2*vMargin]];
        
        preview = [[UIButton alloc] init];
        preview.tag = PREVIEWTEXT_TAG;
        [preview setTranslatesAutoresizingMaskIntoConstraints:NO];
        //preview.editable = NO;
        //preview.scrollEnabled = NO;
        preview.userInteractionEnabled = NO;
        [MyUtilities addCellButton:preview contentView:cell.contentView vMargin:vMargin hMargin:hMargin];
        [preview setTitleColor:[UIColor colorWithRed:137.0/255.0 green:133.0/255.0 blue:132.0/255.0 alpha:1] forState:UIControlStateNormal];
        [preview.titleLabel setTextAlignment:NSTextAlignmentLeft];
        preview.titleLabel.font = [UIFont systemFontOfSize:13.0];
        
        //preview.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:1.0/255.0 alpha:1];
        preview.backgroundColor = [UIColor clearColor];
        /*[cell.contentView addSubview:preview];
        //[cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:.7 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:vMargin]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:preview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:notificationImage attribute:NSLayoutAttributeWidth multiplier:2.3333333 constant:0]];
        [preview sizeToFit];*/
        
        [MyUtilities addShadow:cell];
    }
    else {
        notificationImage = (UIImageView *)[cell.contentView viewWithTag:NOTIFICATIONIMAGE_TAG];
        preview = (UIButton *)[cell.contentView viewWithTag:PREVIEWTEXT_TAG];
    }
    NSURL *url = [NSURL URLWithString:[[_jsonDataArray objectAtIndex:indexPath.row] objectForKey:@"first"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [notificationImage setImage: [UIImage imageWithData:data]];
    if (notificationImage.image.size.height!=0){
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:notificationImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:notificationImage attribute:NSLayoutAttributeHeight multiplier:(notificationImage.image.size.width / notificationImage.image.size.height) constant:0]];
    }
    [preview setTitle:[[_jsonDataArray objectAtIndex:indexPath.row] objectForKey:@"second"] forState:UIControlStateNormal];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[SpecificNotificationViewController alloc] initWithNumber: [[_jsonDataArray objectAtIndex:indexPath.row] objectForKey:@"notificationNumber"] ] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */

@end
