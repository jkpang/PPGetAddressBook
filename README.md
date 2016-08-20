# PPGetAddressBook
* PPGetAddressBook对AddressBook框架(iOS9之前)和Contacts框架(iOS9之后)做了对应的封装处理;

* 支持获取按联系人姓名首字拼音A~Z排序(*重点:已经对姓名的第二个字做了处理,排序更准确!*);
* 支持获取原始顺序的联系人,未分组,可自行处理.

[codeData 地址](http://www.codedata.cn/cdetail/Objective-C/Demo/1471619974294285)

![image](https://github.com/jkpang/PPGetAddressBook/blob/master/AddressBook.mov.gif)
##Installation 安装
###1.手动安装:
`下载DEMO后,将子文件夹PPGetAddressBook拖入到项目中, 导入头文件PPGetAddressBook.h开始使用`
###2.CocoaPods安装:
first
`pod 'PPGetAddressBook' `
then
`pod install或pod install --no-repo-update`
##Usage 使用方法

###一、首先必须要请求用户是否授权APP访问通讯录的权限(建议在APPDeletegate.m中的didFinishLaunchingWithOptions方法中调用)

```objc
     //请求用户获取通讯录权限
    [PPGetAddressBook requestAddressBookAuthorization];
```
###二、获取通讯录
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

此封装里面还有些不太完美的地方,如果你有更好的实现方法,希望不吝赐教!

##联系方式:
* Weibo : @CoderPang
* Email : jkpang@outlook.com
* QQ : 2406552315

##许可证
PPGetAddressBook 使用 MIT 许可证，详情见 LICENSE 文件。




