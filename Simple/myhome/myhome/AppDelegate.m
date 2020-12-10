//
//  AppDelegate.m
//  myhome
//
//  Created by fudon on 2016/10/31.
//  Copyright © 2016年 fuhope. All rights reserved.
//

#import "AppDelegate.h"
#import "FSShare.h"
#import "FSDBMaster.h"
#import "FSTrackKeys.h"
#import "FSMacro.h"
#import "FSRestartAppController.h"
#import "FSCryptorSupport.h"
#import <FSUIKit.h>
#import "AppDelegate+Handler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    return YES;
}

- (void)handleParts{
    [self configParts];
}

- (void)handleViews{
    [self normalAction];
}

/*
 https://github.com/Tencent/OOMDetector
 */

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [FSLockView showLockView];
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [FSTrack event:_UMeng_Event_app_foreground];
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    if (application.applicationIconBadgeNumber) {
        application.applicationIconBadgeNumber = 0;
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    for (UILocalNotification *noti in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSString *notiID = noti.userInfo[@"someKey"];
        NSString *receiveNotiID = notification.userInfo[@"someKey"];
        if ([notiID isEqualToString:receiveNotiID]) {
            application.applicationIconBadgeNumber -= 1;
        }
    }
}

#pragma mark - 从别的应用回来
// iOS9 以上用这个方法接收
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    BOOL isWechatDo = [FSShare handleOpenUrl:url];
    if (isWechatDo == NO) {
        [self handleDBFile:url];
    }
//    NSDictionary * dic = options;
//    if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.sina.weibo"]) {
//        return [WeiboSDK handleOpenURL:url delegate:[FSShareManager shareInstance]];
//    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.xin"]){
//        return [WXApi handleOpenURL:url delegate:[FSShareManager shareInstance]];
//    }else if ([options[UIApplicationOpenURLOptionsSourceApplicationKey] isEqualToString:@"com.tencent.mqq"]){
//        [FSShareManager didReceiveTencentUrl:url];
//#if __OPTIMIZE__
//        return [TencentOAuth HandleOpenURL:url];
//#endif
//    }
    return YES;
}

// iOS9 以下用这个方法接收
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        return [FSShare handleOpenUrl:url];
    }
//    else if ([sourceApplication isEqualToString:@"com.tencent.qqmail"]){
//    }
    [self handleDBFile:url];
    
//    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
//        return [WeiboSDK handleOpenURL:url delegate:[FSShareManager shareInstance]];
//    }else if ([sourceApplication isEqualToString:@"com.tencent.xin"]){
//        return [WXApi handleOpenURL:url delegate:[FSShareManager shareInstance]];
//    }else if ([sourceApplication isEqualToString:@"com.tencent.mqq"]){
//        [FSShareManager didReceiveTencentUrl:url];
//#if __OPTIMIZE__
//        return [TencentOAuth HandleOpenURL:url];
//#endif
//    }
    return YES;
}

- (void)handleDBFile:(NSURL *)url{
    NSString *file = url.absoluteString;
    NSString *extension = [file pathExtension];
    if (!([extension isEqualToString:@"db"] || [extension isEqualToString:@"sqlite"])) {
        [FSUIKit showAlertWithMessageOnCustomWindow:@"暂只支持扩展名为[db]或[sqlite]的文件导入"];
        return;
    }
    
    [FSTrack event:_UMeng_Event_db_import];
    [FSUIKit alertOnCustomWindow:UIAlertControllerStyleActionSheet title:@"确认导入此数据库" message:nil actionTitles:@[@"确认"] styles:@[@(UIAlertActionStyleDefault)] handler:^(UIAlertAction *action) {
        NSError *error = nil;
        NSData *myData = [NSData dataWithContentsOfURL:url];
        if (!myData) {
            [FSUIKit showAlertWithMessageOnCustomWindow:@"导入失败：文件为空"];
            return;
        }
        NSString *target = [FSDBMaster dbPath];
        BOOL success = [myData writeToFile:target atomically:YES];
        if (!success) {
            [FSUIKit showAlertWithMessageOnCustomWindow:error.localizedDescription];
        }else{
            [FSTrack event:_UMeng_Event_db_import_success];
            
            _fs_userDefaults_setObjectForKey(@"1", _UDKey_ImportNewDB);
            FSRestartAppController *rs = [[FSRestartAppController alloc] init];
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.window.rootViewController = rs;
        }
    }];
}

@end
