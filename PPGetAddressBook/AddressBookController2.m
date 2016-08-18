//
//  AddressBookController2.m
//  PPGetAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import "AddressBookController2.h"
#import "PPAddressBookHandle.h"

@interface AddressBookController2 ()<UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation AddressBookController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"原始顺序";
    
    _dataSource = [NSMutableArray array];
    
    //获取没有经过排序的联系人模型
    [PPAddressBookHandle getAddressBookDataSource:^(PPPersonModel *model) {
        [_dataSource addObject:model];
    }];
    
    self.tableView.rowHeight = 60;
}


#pragma mark - TableViewDatasouce/TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    PPPersonModel *people = _dataSource[indexPath.row];
    cell.imageView.image = people.headerImage ? people.headerImage : [UIImage imageNamed:@"defult"];
    cell.imageView.layer.cornerRadius = 60/2;
    cell.imageView.clipsToBounds = YES;
    cell.textLabel.text = people.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PPPersonModel *people = _dataSource[indexPath.row];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:people.name
                                                    message:people.mobile.firstObject
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"打电话", nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIApplication *app = [UIApplication sharedApplication];
    if (buttonIndex == 1) {
        [app openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", alertView.message]]];
    }
}






@end
