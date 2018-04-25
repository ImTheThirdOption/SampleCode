//
//  MessagerViewController.h
//  iRealtor
//
//  Copyright © 2016 SIAB. All rights reserved.
//

#import "BaseViewController.h"
#import <sqlite3.h>

@interface MessagerViewController : BaseViewController
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *firstNames;
@property (strong, nonatomic) NSMutableArray *lastNames;
@property (strong, nonatomic) NSString *chosenFirstName;
@property (strong, nonatomic) NSString *chosenLastName;
@property (strong, nonatomic) UITableView *tableView;

@end
