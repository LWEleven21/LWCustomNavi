//
//  LWCustomNavi.h
//  LWCustomNavi
//
//  Created by LW.
//  Copyright © 2018 LW. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - =======  LWCustomNavi  =======
@interface LWCustomNavi : UIView
+ (CGFloat)statusBarHeight;
+ (CGFloat)naviBarHeight;
+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;
@end

#pragma mark - =======  UIViewController (LWCustomNavi)  =======
@interface UIViewController (LWCustomNavi)

typedef void(^BtnOnClick)(void);

//导航栏背景颜色,default:whiteColor
@property (nonatomic, strong) UIColor * naviBGColor;
//导航栏透明度,default:1.0  0.0 ~ 1.0
@property (nonatomic, assign) float naviBGAlpha;
//导航栏背景图片,default:nil
@property (nonatomic, strong) UIImage * naviBGImage;
//标题颜色,default:blcakColor
@property (nonatomic, strong) UIColor * titleColor;
//标题字体,default:boldSystemFontOfSize:18
@property (nonatomic, strong) UIFont * titleFont;
//左按钮图片,default:nil
@property (nonatomic, strong) UIImage * leftImage;
//左按钮标题,default:返回
@property (nonatomic,  copy ) NSString * leftTitle;
//左按钮标题颜色,default:0 0.478431 1 1
@property (nonatomic, strong) UIColor * leftColor;
//左按钮隐藏,default:NO
@property (nonatomic, assign) BOOL  leftHidden;
//左按钮点击事件,default:返回事件
@property (nonatomic,  copy ) BtnOnClick  leftOnClick;
//右按钮图片,default:nil
@property (nonatomic, strong) UIImage * rightImage;
//右按钮标题,default:更多
@property (nonatomic,  copy ) NSString * rightTitle;
//右按钮标题颜色,default:0 0.478431 1 1
@property (nonatomic, strong) UIColor * rightColor;
//右按钮隐藏,default:YES
@property (nonatomic, assign) BOOL  rightHidden;
//右按钮点击事件,default:右按钮事件
@property (nonatomic,  copy ) BtnOnClick  rightOnClick;
//返回手势,default:YES
@property (nonatomic, assign) BOOL  backGesture;
//状态栏样式,default:UIStatusBarStyleDefault
@property (nonatomic, assign) UIStatusBarStyle  statusStyle;
//细线隐藏,default:NO
@property (nonatomic, assign) BOOL  shadowHidden;

@end
