//
//  PPDataHandle.h
//  PPAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif
#import <AddressBook/AddressBook.h>

#import "PPPersonModel.h"

#define IOS9_LATER ([[UIDevice currentDevice] systemVersion].floatValue > 9.0 ? YES : NO )

/** 一个联系人的相关信息*/
typedef void(^PPPersonModelBlock)(PPPersonModel *model);
/** 授权失败的Block*/
typedef void(^AuthorizationFailure)(void);




@interface PPAddressBookHandle : NSObject

/**
 *  返回每个联系人的模型
 *
 *  @param personModel 单个联系人模型
 *  @param failure     授权失败的Block
 */
+ (void)getAddressBookDataSource:(PPPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure;

@end
