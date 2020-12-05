//
//  ARPersonController.m
//  myhome
//
//  Created by fudon on 2016/11/1.
//  Copyright © 2016年 fuhope. All rights reserved.
//

#import "ARPersonController.h"
#import "FSShare.h"
#import <StoreKit/StoreKit.h>
#import <FSUIKit.h>
#import "FSTrackKeys.h"
#import "FSUseGestureView+Factory.h"
#import "FSDBMaster.h"
#import "FSToast.h"
#import "FSMacro.h"
#import "FSCryptorSupport.h"
#import "FSSqlite3BroswerController.h"
#import <MessageUI/MessageUI.h>
#import "FSApp.h"

@interface ARPersonController ()<UITableViewDelegate,UITableViewDataSource,SKStoreProductViewControllerDelegate>

@property (nonatomic,strong) NSArray    *titles;

@end

@implementation ARPersonController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Me", nil);
    [self personDesignViews];
}

- (void)bbiAction{
    [FSUseGestureView verify:self.tabBarController.view password:FSCryptorSupport.localUserDefaultsCorePassword success:^(FSUseGestureView *view) {
        [FSKit pushToViewControllerWithClass:@"FSSetController" navigationController:self.navigationController param:@{@"pwd":FSCryptorSupport.localUserDefaultsCorePassword?:@""} configBlock:nil];
    }];
}

- (void)birdClick{
    [FSUseGestureView verify:self.tabBarController.view password:FSCryptorSupport.localUserDefaultsCorePassword success:^(FSUseGestureView *view) {
        [self watchSQLite3];
    }];
}

- (void)watchSQLite3{
    FSSqlite3BroswerController *broswer = [[FSSqlite3BroswerController alloc] init];
    broswer.path = [FSDBMaster dbPath];
    [self.navigationController pushViewController:broswer animated:YES];
}

//- (void)checkOverMinus:(NSString *)account subject:(NSString *)subject{
//    [FSDBTool checkOverMinus:subject account:account controller:self];
//}
//
//- (void)findError:(NSString *)account subject:(NSString *)subject{
//    [FSDBTool findErrorTrackForSubject:subject table:account controller:self];
//}

//- (void)subject:(NSString *)account{
//    __weak typeof(self)this = self;
//    [FSUIKit alertInput:1 controller:self title:@"请输入科目(2个字符)" message:nil ok:@"OK" handler:^(UIAlertController *bAlert, UIAlertAction *action) {
//        UITextField *tf = bAlert.textFields.firstObject;
//        NSString *subject = [FSKit stringDeleteNewLineAndWhiteSpace:[tf.text lowercaseString]];
//        if (subject.length != 2) {
//            [FSToast show:@"科目输入不正确"];
//            return;
//        }
//        CGFloat plus = [FSDBTool woodpeckerPlus:subject account:account];
//        CGFloat minus = [FSDBTool woodpeckerMinus:subject account:account];
//        CGFloat track = [FSDBTool woodpeckerTrack:subject account:account];
//        CGFloat rest = [FSDBTool woodpeckerRest:subject account:account];
//        CGFloat delta = track - minus;
//        CGFloat sum = [FSDBTool sumSubject:subject table:account start:0 end:_fs_integerTimeIntevalSince1970()];
//
//        NSString *show = [[NSString alloc] initWithFormat:@"增加:%.2f\n减少:%.2f\n踪记:%.2f\n应剩:%.2f\n实剩:%.2f\n超减:%.2f\n余额:%.2f",plus,minus,track,plus - minus,rest,delta,sum];
//        [FSUIKit showAlertWithMessage:show controller:this];
//    } cancel:@"Cancel" handler:nil textFieldConifg:nil completion:nil];
//}

- (void)personDesignViews{
    _titles = @[NSLocalizedString(@"Feedback", nil),NSLocalizedString(@"Like", nil),NSLocalizedString(@"Give a score", nil),NSLocalizedString(@"Core password", nil),NSLocalizedString(@"Clear pasteboard", nil)];
    
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Set", nil) style:UIBarButtonItemStylePlain target:self action:@selector(bbiAction)];
    bbi.tintColor = UIColor.blackColor;
    self.navigationItem.rightBarButtonItem = bbi;
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"数据库" style:UIBarButtonItemStylePlain target:self action:@selector(birdClick)];
    self.navigationItem.leftBarButtonItem = left;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _fs_statusAndNavigatorHeight(), WIDTHFC, HEIGHTFC - _fs_statusAndNavigatorHeight() - 49) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.rowHeight = 70;
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, 10)];
    tableView.tableHeaderView = headView;
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTHFC, 50)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:14];
    versionLabel.textColor = [UIColor lightGrayColor];
    NSString *what = nil;
#if DEBUG
    what = @"Debug";
#else
    what = @"Release";
#endif
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    versionLabel.text = [[NSString alloc] initWithFormat:@"%@ %@(%@)",what,[FSKit appVersionNumber],build];
    tableView.tableFooterView = versionLabel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row == 0){
        BOOL canSendMail = [MFMailComposeViewController canSendMail];
        if (!canSendMail) {
            [FSToast show:@"手机设置邮箱后才可以反馈信息"];
            return;
        }
        [self event:_UMeng_Event_feedback];
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *subject = [[NSString alloc] initWithFormat:@"%@iOS %@",[infoDictionary objectForKey:@"CFBundleDisplayName"],NSLocalizedString(@"Feedback", nil)];
       
        [FSShare emailShareWithSubject:subject on:self messageBody:nil recipients:@[_feedback_Email] fileData:nil fileName:nil mimeType:nil];
    }else if (row == 1){
        [FSKit pushToViewControllerWithClass:@"ARAboutController" navigationController:self.navigationController param:@{@"title":NSLocalizedString(@"Like", nil)} configBlock:nil];
    }else if (row == 2){
        [self evaluate];
    }else if (row == 3){
        [FSKit pushToViewControllerWithClass:@"FSChangeCorePwdController" navigationController:self.navigationController param:@{@"password":FSCryptorSupport.localUserDefaultsCorePassword?:@""} configBlock:nil];
    }else if (row == 4){
        [FSKit copyToPasteboard:@""];
        [FSToast show:NSLocalizedString(@"Pasteboard clear", nil)];
    }
}

- (void)evaluate{
    [self event:_UMeng_Event_cent_start];
    SKStoreProductViewController *storeVC = [[SKStoreProductViewController alloc] init];
    storeVC.delegate = self;
    [self presentViewController:storeVC animated:YES completion:nil];
    __weak typeof(self)this = self;
    [storeVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@(1291692536)} completionBlock:^(BOOL result, NSError * error) {
        if (error) {
            [self event:_UMeng_Event_cent_fail];
            [storeVC dismissViewControllerAnimated:YES completion:nil];
            [FSUIKit showAlertWithMessage:error.localizedDescription controller:this];
        }else{
            [self event:_UMeng_Event_cent_success];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
