//
//  ViewController2.m
//  LWCustomNavi
//
//  Created by LWEleven21 on 2018/10/18.
//  Copyright © 2018 LW. All rights reserved.
//

#import "ViewController2.h"
#import "LWCustomNavi.h"
#import "ViewController.h"
@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    self.title = @"标题2";
    self.shadowHidden = YES;
    self.leftImage = [UIImage imageNamed:@"back"];
    self.statusStyle = 1;
    self.titleColor = [UIColor whiteColor];
    self.rightHidden = NO;
    __weak typeof(self) weakSelf = self;
    self.rightOnClick = ^{
        [weakSelf presentViewController:[ViewController new] animated:YES completion:^{
            
        }];
    };
}


@end
