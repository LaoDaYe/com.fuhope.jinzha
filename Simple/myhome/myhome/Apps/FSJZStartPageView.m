//
//  FSJZStartPageView.m
//  myhome
//
//  Created by FudonFuchina on 2020/12/6.
//  Copyright © 2020 fuhope. All rights reserved.
//

#import "FSJZStartPageView.h"
#import "FSApp.h"
#import "FSKit.h"
#import "FSDate.h"

@implementation FSJZStartPageView {
    UILabel     *_label;
    UILabel     *_timeLabel;
    NSInteger   _days;
    NSString    *_tip;
}

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self startPageHandleDatas];
    }
    return self;
}

- (void)startPageHandleDatas {
    _fs_dispatch_global_main_queue_async(^{
        [self handleDatas];
    }, ^{
        [self startPageDesignViews];
    });
}

- (void)handleDatas {
    NSDate *then = [FSDate dateByString:@"2077-05-10 23:59:59" formatter:nil];
    NSDate *now = NSDate.date;
    NSTimeInterval tt = [then timeIntervalSince1970];
    NSTimeInterval tn = [now timeIntervalSince1970];
    NSTimeInterval delta = tt - tn;
    NSTimeInterval days = delta / 86400;
    _days = (NSInteger)days;
    
    NSDateComponents *time = [FSDate componentForDate:now];
    if (time.hour >= 22 || time.hour <= 6) {
        _tip = @"念华，夜深了 ~";
    } else if (time.hour > 6 && time.hour <= 12) {
        _tip = @"念华，上午好 ~";
    } else if (time.hour > 12 && time.hour <= 18) {
        _tip = @"念华，下午好 ~";
    } else {
        _tip = @"念华，晚上好 ~";
    }
}

- (void)startPageDesignViews {
    self.backgroundColor = UIColor.whiteColor;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.bounds];
    imgView.image = [UIImage imageNamed:@"start_bg"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    [self addSubview:imgView];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width / 2 - 39.9, _fs_statusAndNavigatorHeight(), 80, 80)];
    headImageView.image = [UIImage imageNamed:@"start_heart"];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    [self addSubview:headImageView];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(10, headImageView.frame.origin.y + headImageView.frame.size.height + 20, UIScreen.mainScreen.bounds.size.width - 20, 60)];
    _label.text = _tip;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:30];
    _label.alpha = 0;
    [self addSubview:_label];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _label.frame.origin.y + _label.frame.size.height, UIScreen.mainScreen.bounds.size.width - 20, 30)];
    _timeLabel.text = @(_days).stringValue;
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont boldSystemFontOfSize:18];
    _timeLabel.alpha = 0;
    [self addSubview:_timeLabel];
    
    [UIView animateWithDuration:2 animations:^{
        self-> _label.alpha = 1;
        self-> _timeLabel.alpha = 1;
    } completion:^(BOOL finished) {
        if (self.willDissmiss) {
            self.willDissmiss(self);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                [self removeFromSuperview];
            }];
        });
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
