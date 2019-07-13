//
//  FSWebsiteViewController.m
//  FBRetainCycleDetector
//
//  Created by FudonFuchina on 2019/1/12.
//

#import "FSWebsiteViewController.h"
#import "FSTuple.h"
#import "FSImageLabelView.h"
#import "FSWebKitController.h"
#import "FSCryptorSupport.h"

#if DEBUG
#import "FSToast.h"
#endif

@interface FSWebsiteViewController ()

@end

@implementation FSWebsiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self websiteDesignViews];
}

- (void)spendTimeInCreateViews{
#if DEBUG
    _fs_spendTimeInDoSomething(^{
        [self websiteDesignViews];
    }, ^(double time) {
        [FSToast toast:@(time).stringValue];
    });
#else
    [self websiteDesignViews];
#endif
}

- (void)websiteDesignViews{
    self.title = @"网址";
    
#if DEBUG
    UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Development" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    self.navigationItem.leftBarButtonItem = bbi;
#endif
    
    NSArray *ts = @[
           [Tuple3 v1:NSLocalizedString(@"Baidu", nil) v2:@"baidu.jpg" v3:@"https://m.baidu.com"],
           [Tuple3 v1:NSLocalizedString(@"Tmall",nil) v2:@"tmall.jpg" v3:@"https://www.tmall.com"],
           [Tuple3 v1:NSLocalizedString(@"JD", nil) v2:@"jd.jpg" v3:@"http://m.jd.com"],
           [Tuple3 v1:NSLocalizedString(@"Taobao", nil) v2:@"taobao.jpg" v3:@"https://m.taobao.com"],
           
           [Tuple3 v1:NSLocalizedString(@"Hao123", nil) v2:@"hao123.jpg" v3:@"https://www.hao123.com"],
           [Tuple3 v1:NSLocalizedString(@"Meituan", nil) v2:@"mt.jpg" v3:@"http://i.meituan.com"],
           [Tuple3 v1:NSLocalizedString(@"Eleme", nil) v2:@"elme.jpg" v3:@"http://m.ele.me"],
           [Tuple3 v1:NSLocalizedString(@"Amazon", nil) v2:@"amazon.jpg" v3:@"https://www.amazon.cn"],
           
           [Tuple3 v1:NSLocalizedString(@"QQ news", nil) v2:@"txxw.jpg" v3:@"http://xw.qq.com"],
           [Tuple3 v1:NSLocalizedString(@"Netease", nil) v2:@"wyxw.jpg" v3:@"http://3g.163.com"],
           [Tuple3 v1:NSLocalizedString(@"Weibo", nil) v2:@"xlwb.jpg" v3:@"http://www.weibo.com"],
           [Tuple3 v1:NSLocalizedString(@"Jianshu", nil) v2:@"jianshu.jpg" v3:@"http://www.jianshu.com"],
           
           [Tuple3 v1:NSLocalizedString(@"Youku", nil) v2:@"youku.jpg" v3:@"http://www.youku.com"],
           [Tuple3 v1:NSLocalizedString(@"TV", nil) v2:@"qqtv.jpg" v3:@"http://m.v.qq.com"],
           [Tuple3 v1:NSLocalizedString(@"iQiyi", nil) v2:@"iqiyi.jpg" v3:@"http://m.iqiyi.com"],
           [Tuple3 v1:NSLocalizedString(@"CCTV", nil) v2:@"cctv.jpg" v3:@"http://m.cctv.com"],
           ];
    
    WEAKSELF(this);
    CGFloat width = (WIDTHFC - 100) / 4;
    for (int x = 0; x < ts.count; x ++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Tuple3 *t = ts[x];
            FSImageLabelView *imageView = [FSImageLabelView imageLabelViewWithFrame:CGRectMake(20 + (x % 4) * (width + 20), 40 + (x / 4) * (width + 45), width, width + 25) imageName:t._2 text:t._1];
            imageView.tag = x;
            imageView.block = ^ (FSImageLabelView *bImageLabelView){
                [this actionForType:t order:bImageLabelView.tag];
            };
            [this.scrollView addSubview:imageView];
        });
    }
}

- (void)actionForType:(Tuple3 *)t order:(NSInteger)order{
    NSString *url = t._3;
    FSWebKitController *webController = [[FSWebKitController alloc] init];
    webController.urlString = url;
    [self.navigationController pushViewController:webController animated:YES];
    
    NSString *event = [[NSString alloc] initWithFormat:@"webevent_%@",@(order)];
    [self event:event];
}

- (void)leftClick{
    [FSKit pushToViewControllerWithClass:@"FSCompanyPartController" navigationController:self.navigationController param:@{@"password":FSCryptorSupport.localUserDefaultsCorePassword?:@""} configBlock:nil];
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
