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

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    self.title = @"标题";
    self.rightHidden = NO;
    self.leftHidden = YES;
    self.statusStyle = 1;
    self.titleColor = [UIColor whiteColor];
//    self.rightImage = [UIImage imageNamed:@"sckc"];
    __weak typeof(self) weakSelf = self;
    self.rightOnClick = ^{
        [weakSelf.navigationController pushViewController:[ViewController2 new] animated:YES];
        weakSelf.title = @"首页";
    };
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
