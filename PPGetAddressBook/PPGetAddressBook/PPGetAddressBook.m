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
    dispatch_queue_t queue = dispatch_queue_create("addressBookArray", DISPATCH_QUEUE_SERIAL);
    
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
    dispatch_queue_t queue = dispatch_queue_create("addressBookInfo", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        
        NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
        //***************** 这是一段耗时操作 **********************//
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
        //***************** 这是一段耗时操作 **********************//
        
        
        // 重新对所有大写字母Key值里面对应的的联系人数组进行排序
        //1.遍历联系人字典中所有的元素,利用到多核cpu的优势,参考:http://blog.sunnyxx.com/2014/04/30/ios_iterator/
        [addressBookDict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, NSMutableArray * _Nonnull keyPeopleArray, BOOL * _Nonnull stop) {
            //2.对每个Key值对应的数组里的元素来排序
            [keyPeopleArray sortUsingComparator:^NSComparisonResult(PPPersonModel*  _Nonnull obj1, PPPersonModel  *_Nonnull obj2) {
                
                return [obj1.name localizedCompare:obj2.name];
            }];
            
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
    NSMutableString *str = [NSMutableString stringWithString:aString];
    //带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *strPinYin = [str capitalizedString];
    NSString *firstString = [strPinYin substringToIndex:1];
    //判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    //获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
}


@end
