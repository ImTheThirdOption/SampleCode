//
//  ReferralsViewController.m
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "ReferralsViewController.h"
#import "SpecificReferralViewController.h"
#import "GlobalVariables.h"
#import "UIButtonWithString.h"
#import "MyUtilities.h"
#import "BottomNavigationBar.h"

@interface ReferralsViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ReferralsViewController

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"referrals_bg.png"]];
    backgroundView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height);
    [self.view addSubview:backgroundView];
    
    float buttonWidth = 0.9;
    int buttonVMargin = 9;
    
    UIImageView *header1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"referrals_header.png"]];
    [header1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:header1];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:buttonWidth constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1 constant:buttonVMargin]];
    if (header1.image.size.height!=0){
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:header1 attribute:NSLayoutAttributeHeight multiplier:(header1.image.size.width / header1.image.size.height) constant:0]];
    }
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:header1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, buttonWidth*self.view.frame.size.width*header1.image.size.height/header1.image.size.width+2.0*buttonVMargin, self.view.frame.size.width, self.view.frame.size.height-2.0*buttonVMargin-self.navigationController.navigationBar.frame.origin.y-2.0*self.navigationController.navigationBar.frame.size.height-buttonWidth*self.view.frame.size.width*header1.image.size.height/header1.image.size.width) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:0 blue:1.0/255.0 alpha:1];
    tableView.alwaysBounceVertical = NO;
    
    UIView *bottomNavigationBar = [[UIView alloc] init];
    [BottomNavigationBar addBottomNavigationBar:bottomNavigationBar to:self.view navigationBarHeight:self.navigationController.navigationBar.frame.size.height scrollView:(UIView *)nil headerImage:(UIView *)self.view];
    
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globals.serverAddress, @"get-referrals-previews.php"]]];
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
#define REFERRALIMAGE_TAG 1

#define PREVIEWSHOLDER_TAG 2

#define PREVIEWFIRSTTEXT_TAG 3

#define PREVIEWSECONDTEXT_TAG 4

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myIdentifier";
    UIImageView *previewsHolder;
    UITextView *firstPreview;
    UITextView *secondPreview;
    UIImageView *referralImage;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil==cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor colorWithRed:208.0/255.0 green:191.0/255.0 blue:173.0/255.0 alpha:1];
        
        int hMargin = 9;
        int vMargin = 2;
        referralImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"group.png"]];
        referralImage.tag = REFERRALIMAGE_TAG;
        [referralImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cell.contentView addSubview:referralImage];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:0.165 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:0.33 constant:-2*hMargin]];
        if (referralImage.image.size.height!=0){
            [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:referralImage attribute:NSLayoutAttributeHeight multiplier:(referralImage.image.size.width / referralImage.image.size.height) constant:0]];
        }
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:referralImage attribute:NSLayoutAttributeHeight multiplier:1 constant:+2*vMargin]];
        
        
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
        previewsHolder = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"white_notification_textbox.png"] resizableImageWithCapInsets:edgeInsets]];
        [previewsHolder setUserInteractionEnabled:YES];
        [previewsHolder setTranslatesAutoresizingMaskIntoConstraints:NO];
        //previewsHolder = [UIView new];
        previewsHolder.tag = PREVIEWSHOLDER_TAG;
        [cell.contentView addSubview:previewsHolder];
        
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:previewsHolder attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeWidth multiplier:.67 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:previewsHolder attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:previewsHolder attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:previewsHolder attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.contentView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        
        firstPreview = [UITextView new];
        firstPreview.tag = PREVIEWFIRSTTEXT_TAG;
        firstPreview.editable = NO;
        firstPreview.scrollEnabled = NO;
        firstPreview.userInteractionEnabled = NO;
        [firstPreview setTextAlignment:NSTextAlignmentCenter];
        firstPreview.textColor = [UIColor blackColor];
        firstPreview.font = [UIFont systemFontOfSize:18];
        firstPreview.backgroundColor = [UIColor clearColor];
        [firstPreview setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [previewsHolder addSubview:firstPreview];
        [previewsHolder addConstraint:[NSLayoutConstraint constraintWithItem:firstPreview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previewsHolder attribute:NSLayoutAttributeTop multiplier:1 constant:vMargin]];
        [previewsHolder addConstraint:[NSLayoutConstraint constraintWithItem:firstPreview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:previewsHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
        [previewsHolder addConstraint:[NSLayoutConstraint constraintWithItem:firstPreview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previewsHolder attribute:NSLayoutAttributeWidth multiplier:1 constant:-2*hMargin]];
        [firstPreview sizeToFit];
        
        secondPreview = [UITextView new];
        secondPreview.tag = PREVIEWFIRSTTEXT_TAG;
        secondPreview.editable = NO;
        secondPreview.scrollEnabled = NO;
        secondPreview.userInteractionEnabled = NO;
        [secondPreview setTextAlignment:NSTextAlignmentCenter];
        secondPreview.textColor = [UIColor blackColor];
        secondPreview.font = [UIFont systemFontOfSize:14];
        secondPreview.backgroundColor = [UIColor clearColor];
        [secondPreview setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [previewsHolder addSubview:secondPreview];
        [previewsHolder addConstraint:[NSLayoutConstraint constraintWithItem:secondPreview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:firstPreview attribute:NSLayoutAttributeBottom multiplier:1 constant:2*vMargin]];
        [previewsHolder addConstraint:[NSLayoutConstraint constraintWithItem:secondPreview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:previewsHolder attribute:NSLayoutAttributeTrailing multiplier:1 constant:-hMargin]];
        [previewsHolder addConstraint:[NSLayoutConstraint constraintWithItem:secondPreview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:previewsHolder attribute:NSLayoutAttributeWidth multiplier:1 constant:-2*hMargin]];
        [secondPreview sizeToFit];
        [previewsHolder addConstraint:[NSLayoutConstraint constraintWithItem:secondPreview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:previewsHolder attribute:NSLayoutAttributeBottom multiplier:1 constant:-vMargin]];
            
        [MyUtilities addShadow:cell];
    }
    else {
        referralImage = (UIImageView *)[cell.contentView viewWithTag:REFERRALIMAGE_TAG];
        previewsHolder = (UIImageView *)[cell.contentView viewWithTag:PREVIEWSHOLDER_TAG];
        firstPreview = (UITextView *)[cell.contentView viewWithTag:PREVIEWFIRSTTEXT_TAG];
        secondPreview = (UITextView *)[cell.contentView viewWithTag:PREVIEWSECONDTEXT_TAG];
    }
    NSURL *url = [NSURL URLWithString:[[_jsonDataArray objectAtIndex:indexPath.row] objectForKey:@"first"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    [referralImage setImage: [UIImage imageWithData:data]];
    if (referralImage.image.size.height!=0){
        [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:referralImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:referralImage attribute:NSLayoutAttributeHeight multiplier:(referralImage.image.size.width / referralImage.image.size.height) constant:0]];
    }
    
    [firstPreview setText:[[_jsonDataArray objectAtIndex:indexPath.row] objectForKey:@"second"]];
    [secondPreview setText:[[_jsonDataArray objectAtIndex:indexPath.row] objectForKey:@"third"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[SpecificReferralViewController alloc] initWithNumber: [[_jsonDataArray objectAtIndex:indexPath.row] objectForKey:@"referralNumber"] ] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 */

@end
