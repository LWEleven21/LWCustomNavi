//
//  ViewController.m
//  LWCustomNavi
//
//  Created by LWEleven21 on 2018/10/18.
//  Copyright © 2018 LW. All rights reserved.
//

#import "ViewController.h"
#import "LWCustomNavi.h"
#import "ViewController2.h"

#define RGBA(r,g,b,a)   [UIColor colorWithRed:(r/255.) green:(g/255.) blue:(b/255.) alpha:a]

@interface ViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    self.title = @"标题";
    self.rightHidden = NO;
    self.leftHidden = YES;
    self.titleColor = RGBA(51, 51, 51, 0);
//    self.rightImage = [UIImage imageNamed:@"sckc"];
//    self.naviBGImage = [UIImage imageNamed:@"imageNav.jpg"];
    self.naviBGAlpha = 0;
    __weak typeof(self) weakSelf = self;
    self.rightOnClick = ^{
        [weakSelf.navigationController pushViewController:[ViewController2 new] animated:YES];
        weakSelf.title = @"首页";
    };
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(0, 10000);
    self.scrollView.delegate = self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float topY = scrollView.contentOffset.y;
    float alpha = topY/64;
    NSLog(@"topY-->%f",topY);
    self.titleColor = RGBA(255, 255, 255, alpha);
    self.naviBGAlpha = alpha;
    if (alpha > 0) {
        self.statusStyle = 1;
    }else {
        self.statusStyle = 0;
    }
    
}


@end
