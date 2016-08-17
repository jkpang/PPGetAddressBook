//
//  PPAddressModel.h
//  PPAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PPPersonModel : NSObject

/** 联系人姓名*/
@property (nonatomic, copy) NSString *name;
/** 联系人电话数组,因为一个联系人可能存储多个号码*/
@property (nonatomic, strong) NSMutableArray *mobile;
/** 联系人头像*/
@property (nonatomic, strong) UIImage *headerImage;


@end
