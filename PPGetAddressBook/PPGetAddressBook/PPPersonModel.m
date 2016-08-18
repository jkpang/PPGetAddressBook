//
//  PPAddressModel.m
//  PPAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import "PPPersonModel.h"

@implementation PPPersonModel

- (NSMutableArray *)mobile
{
    if(!_mobile)
    {
        _mobile = [NSMutableArray array];
    }
    return _mobile;
}

@end
