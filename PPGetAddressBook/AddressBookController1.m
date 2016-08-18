//
//  AddressBookController1.m
//  PPGetAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import "AddressBookController1.h"
#import "PPGetAddressBook.h"

@interface AddressBookController1 ()

@property (nonatomic, copy) NSDictionary *contactPeopleDict;
@property (nonatomic, copy) NSArray *keys;

@end

@implementation AddressBookController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"A~Z顺序排列";
    
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *peopleNameKey) {
        //装着所有联系人的字典
        self.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        self.keys = peopleNameKey;
    }];

    self.tableView.rowHeight = 60;
}

#pragma mark - TableViewDatasouce/TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = _keys[section];
    return [_contactPeopleDict[key] count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _keys[section];
}

//右侧的索引
- (NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    NSString *key = _keys[indexPath.section];
    PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
    
    cell.imageView.image = people.headerImage ? people.headerImage : [UIImage imageNamed:@"defult"];
    cell.imageView.layer.cornerRadius = 60/2;
    cell.imageView.clipsToBounds = YES;
    cell.textLabel.text = people.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = _keys[indexPath.section];
    PPPersonModel *people = [_contactPeopleDict[key] objectAtIndex:indexPath.row];
    
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
