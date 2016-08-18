# PPGetAddressBook
* PPGetAddressBook对AddressBook框架(iOS9之前)和Contacts框架(iOS9之后)做了对应的封装处理;

* 支持获取按联系人姓名首字拼音A~Z排序(*重点:已经对姓名的第二个字做了处理,排序更准确!*);
* 支持获取原始顺序的联系人,未分组,可自行处理.
##Usage 使用方法

###首先必须要请求用户是否授权APP访问通讯录的权限(建议在APPDeletegate.m中的didFinishLaunchingWithOptions方法中调用)

```objc
//请求用户获取通讯录权限
    [PPGetAddressBook requestAddressBookAuthorization];
```
###获取通讯录
###1.获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理),一句话搞定!

```objc
    [PPGetAddressBook getAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *peopleNameKey) {
        //装着所有联系人的字典
        self.contactPeopleDict = addressBookDict;
        //联系人分组按拼音分组的Key值
        self.keys = peopleNameKey;
    }];
```
###2.获取原始顺序的联系人模型,未分组,一句话搞定!

```objc
    self.dataSource = [NSMutableArray array];
    [PPAddressBookHandle getAddressBookDataSource:^(PPPersonModel *model) {
        [self.dataSource addObject:model];
    }];
```
###排序的实现
对姓名第二个字的排序处理其实很简单,直接调用系统的对数组内元素的排序方法: - (void)sortUsingComparator:(NSComparator)cmptr就能实现

```objc
// 重新对所有大写字母Key值里面对应的的联系人数组进行排序
    //1.遍历联系人字典中所有的元素
    //利用到多核cpu的优势:参考:http://blog.sunnyxx.com/2014/04/30/ios_iterator/
    [addressBookDict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, NSMutableArray * _Nonnull keyPeopleArray, BOOL * _Nonnull stop) {
        //2.对每个Key值对应的数组里的元素来排序
        [keyPeopleArray sortUsingComparator:^NSComparisonResult(PPPersonModel*  _Nonnull obj1, PPPersonModel  *_Nonnull obj2) {
            
            return [obj1.name localizedCompare:obj2.name];
        }];

    }];
```
此封装里面还有些不太完美的地方,如果你有更好的实现方法,希望不吝赐教!
##联系方式:
* Weibo : @CoderPang
* Email : jkpang@outlook.com
* QQ : 2406552315




