//
//  ViewController.m
//  PPGetAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

/*
 *********************************************************************************
 *
 *⭐️⭐️⭐️ 新建 PP-iOS学习交流群: 323408051 欢迎加入!!! ⭐️⭐️⭐️
 *
 * 如果您在使用 PPGetAddressBook 的过程中出现bug或有更好的建议,还请及时以下列方式联系我,我会及
 * 时修复bug,解决问题.
 *
 * Weibo : jkpang-庞
 * Email : jkpang@outlook.com
 * QQ 群 : 323408051
 * GitHub: https://github.com/jkpang
 *
 * PS:我的另外两个很好用的封装,欢迎使用!
 * 1.对AFNetworking 3.x 与YYCache的二次封装,一句代码搞定数据请求与缓存,告别FMDB:
 *   GitHub:https://github.com/jkpang/PPNetworkHelper
 * 2.仿京东淘宝商品数量的加减按钮,可定制程度高,使用简单:
 *   GitHub:https://github.com/jkpang/PPNumberButton
 *
 * 如果 PPGetAddressBook 好用,希望您能Star支持,你的 ⭐️ 是我持续更新的动力!
 *********************************************************************************
 */

#import "ViewController.h"
#import "AddressBookController1.h"
#import "AddressBookController2.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"PPGetAddressBook";
    
    _dataSource = @[@"A~Z顺序排列 - AddressBookController1",@"原始顺序 - AddressBookController2"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    static UIViewController *VC;
    
    if(indexPath.row == 0)
    {
        VC = [AddressBookController1 new];
    }
    else
    {
        VC = [AddressBookController2 new];
    }
    [self.navigationController pushViewController:VC animated:YES];
}





@end
