//
//  PPAddressBook.m
//  PPAddressBook
//
//  Created by AndyPang on 16/8/17.
//  Copyright © 2016年 AndyPang. All rights reserved.
//

#import "PPGetAddressBook.h"
#define START NSDate *startTime = [NSDate date]
#define END NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])
@implementation PPGetAddressBook

+ (void)requestAddressBookAuthorization
{
    if(IOS9_LATER)
    {
#ifdef __IPHONE_9_0
        // 1.判断是否授权成功,若授权成功直接return
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized) return;
        // 2.创建通讯录
        CNContactStore *store = [[CNContactStore alloc] init];
        // 3.授权
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"授权成功");
            }else{
                NSLog(@"授权失败");
            }
        }];
#endif
    }
    else
    {
        // 1.获取授权的状态
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        // 2.判断授权状态,如果是未决定状态,才需要请求
        if (status == kABAuthorizationStatusNotDetermined) {
            // 3.创建通讯录进行授权
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"授权成功");
                } else {
                    NSLog(@"授权失败");
                }
            });
        }
        
    }
    
}

#pragma mark - 获取原始顺序所有联系人
+ (void)getOriginalAddressBook:(AddressBookArrayBlock)addressBookArray authorizationFailure:(AuthorizationFailure)failure
{
    //开启一个子线程,将耗时操作放到异步串行队列
    dispatch_queue_t queue = dispatch_queue_create("addressBook.array", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSMutableArray *array = [NSMutableArray array];
        [PPAddressBookHandle getAddressBookDataSource:^(PPPersonModel *model) {
            //将单个联系人模型装进数组
            [array addObject:model];
            
        } authorizationFailure:^{
            //将授权失败的信息回调到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                failure ? failure() : nil;
            });
        }];
        
        // 将联系人数组回调到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            addressBookArray ? addressBookArray(array) : nil ;
        });
    });
    
}

#pragma mark - 获取按A~Z顺序排列的所有联系人
+ (void)getOrderAddressBook:(AddressBookDictBlock)addressBookInfo authorizationFailure:(AuthorizationFailure)failure
{
    
    //开启一个子线程,将耗时操作放到异步串行队列
    dispatch_queue_t queue = dispatch_queue_create("addressBook.infoDict", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
        [PPAddressBookHandle getAddressBookDataSource:^(PPPersonModel *model) {
            
            //获取到姓名的大写首字母
            NSString *firstLetterString = [self getFirstLetterFromString:model.name];
            
            //如果该字母对应的联系人模型不为空,则将此联系人模型添加到此数组中
            if (addressBookDict[firstLetterString])
            {
                [addressBookDict[firstLetterString] addObject:model];
            }
            //没有出现过该首字母，则在字典中新增一组key-value
            else
            {
                //创建新发可变数组存储该首字母对应的联系人模型
                NSMutableArray *arrGroupNames = [NSMutableArray arrayWithObject:model];
                //将首字母-姓名数组作为key-value加入到字典中
                [addressBookDict setObject:arrGroupNames forKey:firstLetterString];
            }
            
        } authorizationFailure:^{
            //将授权失败的信息回调到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                failure ? failure() : nil;
            });
        }];
        
        // 将addressBookDict字典中的所有Key值进行排序: A~Z
        NSArray *peopleNameKey = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        // 将排序好的通讯录数据回调到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            addressBookInfo ? addressBookInfo(addressBookDict,peopleNameKey) : nil;
        });
        
    });

}


#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString
{
    /**
     * **************************************** START ***************************************
     * 之前PPGetAddressBook对联系人排序时在中文转拼音这一部分非常耗时
     * 参考博主-庞海礁先生的一文:iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131
     * 使PPGetAddressBook对联系人排序的性能提升 3~6倍, 非常感谢!
     */
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    /**
     *  *************************************** END ******************************************
     */
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [pinyinString capitalizedString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";

}


@end
