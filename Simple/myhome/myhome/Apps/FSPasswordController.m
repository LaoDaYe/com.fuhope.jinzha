//
//  FSPasswordController.m
//  Expand
//
//  Created by Fudongdong on 2017/8/3.
//  Copyright © 2017年 china. All rights reserved.
//

#import "FSPasswordController.h"
#import "FSLabel.h"
#import "FSCryptorSupport.h"
#import <FSUIKit.h>
#import "FSMacro.h"

static NSString  *_English_placeholder = @"Anything";
static NSString  *_Chinese_placeholder = @"人生若只如初见";

@interface FSPasswordController ()

@end

@implementation FSPasswordController{
    @private
    UITextField     *_textField;
    UIButton        *_button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self passwordDesignViews];
}

- (void)passwordDesignViews{
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    BOOL isHans = [FSKit isChineseEnvironment];
    self.scrollView.contentSize = CGSizeMake(size.width, size.height + 50 + (isHans?0:(50)));
    
    UILabel *big = [[UILabel alloc] initWithFrame:CGRectMake(30, 70, size.width - 60, 50)];
    big.text = NSLocalizedString(@"Core Password", nil);
    big.textAlignment = NSTextAlignmentCenter;
    big.font = [UIFont boldSystemFontOfSize:28];
    [self.scrollView addSubview:big];
    
    NSString *iStr = _fs_userDefaults_objectForKey(_UDKey_ImportNewDB);
    BOOL imported = [iStr boolValue];
    NSString *origin = nil;
    NSString *place = nil;
    NSString *btnTitle = nil;
    if (imported) {
        origin = @"你从外面导入了一个数据库，数据库中已经保留了你原来设置的‘核心密码’，请输入该密码来校验通过。";
        place = @"原来设置的'核心密码'";
        btnTitle = @"校验";
    }else{
        origin = NSLocalizedString(@"Core password description", nil);
        place = [[NSString alloc] initWithFormat:@"如'%@'，‘%@’",_English_placeholder,_Chinese_placeholder];
        btnTitle = NSLocalizedString(@"Set", nil);
    }
    UILabel *label = [[FSLabel alloc] initWithFrame:CGRectMake(30, 130, size.width - 60, 0)];
    label.text = origin;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:14];
    [self.scrollView addSubview:label];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(15, label.frame.origin.y + label.frame.size.height + 20, size.width - 30, 40)];
    _textField.textAlignment = NSTextAlignmentCenter;
    _textField.backgroundColor = [UIColor colorWithRed:230 / 255.0 green:240 / 255.0 blue:220 / 255.0 alpha:1.0];
    _textField.placeholder = place;
    _textField.font = [UIFont systemFontOfSize:13];
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.scrollView addSubview:_textField];
    
#if TARGET_IPHONE_SIMULATOR

#else
#endif

    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    _button.frame = CGRectMake(15, _textField.frame.origin.y + _textField.frame.size.height + 20, size.width - 30, 44);
    _button.backgroundColor = THISCOLOR;
    [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_button setTitle:btnTitle forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_button];
    
    [self addKeyboardNotificationWithBaseOn:_button.bottom + 40];
}

- (void)click{
    [self.view endEditing:YES];
    if ([FSKit cleanString:_textField.text].length == 0) {
        [FSToast show:NSLocalizedString(@"Please input the password", nil)];
        return;
    }
    if (_textField.text.length < 2) {
        [FSUIKit showAlertWithMessage:NSLocalizedString(@"For data security, character length at least 3 or above!", nil) controller:self];
        return;
    }
    
    if ([_textField.text isEqualToString:_English_placeholder] || [_textField.text isEqualToString:_Chinese_placeholder]) {
        [FSUIKit showAlertWithMessage:NSLocalizedString(@"This password is not recommended", nil) controller:self];
        return;
    }
    NSString *text = [_textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *title = [[NSString alloc] initWithFormat:@"%@ [%@]?",NSLocalizedString(@"Confirm use", nil),text];
    
    [FSUIKit alert:UIAlertControllerStyleActionSheet controller:self title:title message:nil actionTitles:@[NSLocalizedString(@"I have memorise and use it", nil)] styles:@[@(UIAlertActionStyleDefault)] handler:^(UIAlertAction *action) {
        BOOL canStepOn = [FSCryptorSupport savePassword:text];
        if (!canStepOn) {
            return;
        }
        if (self.callback) {
            self.callback(self);
        }
    }];
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
