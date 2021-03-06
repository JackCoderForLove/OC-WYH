//
//  FirstVC.m
//  RuntimeProDemo
//
//  Created by hnbwyh on 2018/1/31.
//  Copyright © 2018年 ZhiXingJY. All rights reserved.
//

#import "FirstVC.h"
#import "UIImage+ImageName.h"
#import "PersonDataModel.h"
#import <objc/runtime.h>

@interface FirstVC ()

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FirstVC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, 80.0, 30.0)];
    btn.center = self.view.center;
    [self.view addSubview:btn];
    [btn setTitle:@"点击测试" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickEventBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)clickEventBtn:(UIButton *)btn{
 
    [self test6];
}

#pragma mark ------ /*<获取 PersonDataModel 与 UIView 的属性>*/
- (void)test1{
    
    u_int count11;
    objc_objectptr_t *propertys1 = class_copyPropertyList([PersonDataModel class], &count11);
    for (NSInteger i = 0; i < count11; i++) {
        const char *pName = property_getName(propertys1[i]);
        NSString *strName = [NSString stringWithCString:pName encoding:NSUTF8StringEncoding];
        //NSLog(@" PersonDataModel - strName :%@ \n ",strName);
    }
}

#pragma mark ------ /*<获取 PersonDataModel 与 UIView 的方法>*/
- (void)test2{
    
    u_int count21;
    Method *ms21 = class_copyMethodList([PersonDataModel class], &count21);
    for (NSInteger i = 0; i < count21; i ++) {
        SEL name = method_getName(ms21[i]); // 这里只有实例方法，并没有类方法
        //        NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        NSString *strName = NSStringFromSelector(name);
        //NSLog(@" PersonDataModel - method :%@ \n ",strName);
    }
}

#pragma mark ------ /*<获取 PersonDataModel 实例 / 类方法>*/
- (void)test3{
    /*<获取 PersonDataModel 实例方法>*/
    Method clsMethod = class_getClassMethod([PersonDataModel class], @selector(testClsMethod11));
    
    /*<获取 PersonDataModel 类方法>*/
    Method instanceMethod = class_getInstanceMethod([PersonDataModel class], @selector(testInstanceMethod21));
}

#pragma mark ------ /*<系统方法拦截>*/
- (void)test4{
    /*<系统方法拦截>*/
    UIImage *img = [UIImage imageNamed:@"login_hnb_icon"];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 80, 50, 50)];
    imgV.backgroundColor = [UIColor greenColor];
    imgV.image = img;
    [self.view addSubview:imgV];
}

#pragma mark ------ /*<属性遍历在数据模型归解档中的应用 ： MJEXtension,YYModel 字典与模型间的转换 >*/
- (void)test5{
    /*<属性遍历在数据模型归解档中的应用 ： MJEXtension,YYModel 字典与模型间的转换 >*/
    NSString *tmpPath = @"testRuntime";
    NSString *sysPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE) lastObject];
    NSString *lastPath = [sysPath stringByAppendingPathComponent:tmpPath];
    
    PersonDataModel *f = [[PersonDataModel alloc] init];
    f.name = @"ZhongGuo";
    f.age = 22;
    f.children = @[@"Son:Jolin",@"Girl:LinCon"];
    f.homeLocation = @{
                       @"省":@"河南",
                       @"市":@"南阳",
                       };
    
    // 归档
    [NSKeyedArchiver archiveRootObject:f toFile:lastPath];
    
    // 解档
    PersonDataModel *lf = (PersonDataModel *)[NSKeyedUnarchiver unarchiveObjectWithFile:lastPath];
    
    NSLog(@" lf: %@ ",lf);
}


#pragma mark ------ /**<依据类名字符串创建该类的实例对象>*/
- (void)test6{
    
    /**<依据类名字符串创建该类的实例对象>*/
    //FirstVC
    NSString *class = @"DefendContinHitVC";
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    // 从一个字符串返回一个类
    Class newClass = objc_getClass(className);
    // 创建一个类
    Class superClass = [NSObject class];
    // 注册创建的类
    objc_registerClassPair(newClass);
    // 创建对象
    id instance = [[newClass alloc] init];
    [self.navigationController pushViewController:instance animated:TRUE];
    
}
@end
