//
//  FSJZStartPageView.h
//  myhome
//
//  Created by FudonFuchina on 2020/12/6.
//  Copyright © 2020 fuhope. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FSJZStartPageView : UIView

@property (nonatomic, copy, nullable) void (^willDissmiss)(FSJZStartPageView *bView);

@end

NS_ASSUME_NONNULL_END
