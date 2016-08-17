//
//  PPGetAddressBook.h
//  PPGetAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPPersonModel.h"

/**
 *  获取本机所有联系人的回调
 *
 *  @param addressBookDict 装有所有联系人的字典->每个字典key对应装有多个联系人模型的数组->每个模型里面包含着用户的相关信息.
 *  @param peopleNameKey   联系人姓名的大写首字母的数组
 */
typedef void(^AddressBookInfoBlock)(NSDictionary<NSString *,NSArray *> *addressBookDict,NSArray *peopleNameKey);

@interface PPGetAddressBook : NSObject

/**
 *  请求用户是否授权APP访问通讯录的权限,建议在APPDeletegate.m中的didFinishLaunchingWithOptions方法中调用
 */
+ (void)requestAddressBookAuthorization;

/**
 *  获取所有联系人信息
 */
+ (void)getAddressBook:(AddressBookInfoBlock)addressBookInfo;

@end
