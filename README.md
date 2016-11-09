![image](https://github.com/jkpang/PPGetAddressBook/blob/master/Picture/PPGetAddressBook.png)

![](https://img.shields.io/badge/platform-iOS-red.svg)  ![](https://img.shields.io/badge/language-Objective--C-orange.svg)  ![](https://img.shields.io/badge/pod-v0.2.7-blue.svg) ![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)  [![](https://img.shields.io/badge/weibo-%40CoderPang-yellow.svg)](http://weibo.com/5743737098/profile?rightmod=1&wvr=6&mod=personinfo&is_all=1)

* PPGetAddressBook对AddressBook框架(iOS9之前)和Contacts框架(iOS9之后)做了对应的封装处理;

* 支持一句代码获取按联系人姓名首字拼音A~Z排序(*重点:已处理姓名所有字符的排序问题,排序更准确!*);
* 支持一句代码获取原始顺序的联系人,未分组,可自行处理;
* 已对号码中的"+86","-","()",空号和联系人姓名空白做了处理,不会出现因为数据源NULL导致程序crash的问题;
* 对姓"长","沈","厦","地","冲"多音字进行优化处理.

###新建 PP-iOS学习交流群 : 323408051 有关于PP系列封装的问题和iOS技术可以在此群讨论

[简书地址](http://www.jianshu.com/p/b51a6125bcff) ; [codeData 地址](http://www.codedata.cn/cdetail/Objective-C/Demo/1471619974294285)

####如果你需要Swift版本,请戳: https://github.com/jkpang/PPGetAddressBookSwift

![image](https://github.com/jkpang/PPGetAddressBook/blob/master/Picture/AddressBook.mov.gif)

##Requirements 要求
* iOS 7+
* Xcode 8+

##Installation 安装
###1.手动安装:
`下载DEMO后,将子文件夹PPGetAddressBook拖入到项目中, 导入头文件PPGetAddressBook.h开始使用`
###2.CocoaPods安装:
first
`pod 'PPGetAddressBook',:git => 'https://github.com/jkpang/PPGetAddressBook.git'`

then
`pod install或pod install --no-repo-update`

如果发现pod search PPGetAddressBook 不是最新版本，在终端执行pod setup命令更新本地spec镜像缓存(时间可能有点长),重新搜索就OK了
##Usage 使用方法
****注意, 在iOS 10系统下必须在info.plist文件中配置获取隐私数据权限声明 : [兼容iOS 10：配置获取隐私数据权限声明
](http://www.jianshu.com/p/616240463a7a)***
###一、首先必须要请求用户是否授权APP访问通讯录的权限(建议在APPDeletegate.m中的didFinishLaunchingWithOptions方法中调用)

```objc
     //请求用户获取通讯录权限
    [PPGetAddressBook requestAddressBookAuthorization];
```
###二、获取通讯录
###1.获取按联系人姓名首字拼音A~Z排序(已处理姓名所有字符的排序问题),一句话搞定!

```objc
    //获取按联系人姓名首字拼音A~Z排序(已经对姓名的第二个字做了处理)
    [PPGetAddressBook getOrderAddressBook:^(NSDictionary<NSString *,NSArray *> *addressBookDict, NSArray *nameKeys) {
        //addressBookDict: 装着所有联系人的字典
        //nameKeys: A~Z拼音字母数组;
        //刷新 tableView       
        [self.tableView reloadData];
    } authorizationFailure:^{
        NSLog(@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录");
    }];

   
```
###2.获取原始顺序的联系人模型,未分组,一句话搞定!

```objc
    //获取没有经过排序的联系人模型
    [PPGetAddressBook getOriginalAddressBook:^(NSArray<PPPersonModel *> *addressBookArray) {
       //addressBookArray:原始顺序的联系人模型数组
       
       //刷新 tableView       
        [self.tableView reloadData];
    } authorizationFailure:^{
       NSLog(@"请在iPhone的“设置-隐私-通讯录”选项中，允许PPAddressBook访问您的通讯录");
    }];
    
```

如果你有更好的实现方法,希望不吝赐教!
####你的star是我持续更新的动力!
===
##CocoaPods更新日志
* 2016.10.30(tag:0.2.7)--1.对姓"长","沈","厦","地","冲"多音字进行优化处理; 2.将'#'key值排列在A~Z的末尾!
* 2016.10.08(tag:0.2.6)--读取联系人速度再次提升!
* 2016.09.16(tag:0.2.5)--读取排序通讯录时性能提升3~6倍以及部分代码优化,推荐使用此版本及之后的版本
* 2016.09.12(tag:0.2.2)--小细节优化
* 2016.09.01(tag:0.2.1)--修复 当用户没有授权时程序卡死的Bug
* 2016.08.26(tag:0.2.0)--将联系人排序的耗时操作放在子线程,大大优化程序的载入速度与体验
* 2016.08.23(tag:0.1.2)--小细节优化
* 2016.08.21(tag:0.1.1)--Pods初始化

##联系方式:
* Weibo : @CoderPang
* Email : jkpang@outlook.com
* QQ群 : 323408051

![PP-iOS学习交流群群二维码](https://github.com/jkpang/PPCounter/blob/master/PP-iOS%E5%AD%A6%E4%B9%A0%E4%BA%A4%E6%B5%81%E7%BE%A4%E7%BE%A4%E4%BA%8C%E7%BB%B4%E7%A0%81.png)

##许可证
PPGetAddressBook 使用 MIT 许可证，详情见 LICENSE 文件。




