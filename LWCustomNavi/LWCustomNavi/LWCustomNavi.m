//
//  LWCustomNavi.m
//  LWCustomNavi
//
//  Created by LW.
//  Copyright © 2018 LW. All rights reserved.
//

#import "LWCustomNavi.h"
#import <objc/runtime.h>
#pragma mark - =======  LWCustomNavi  =======
@implementation LWCustomNavi

+ (CGFloat)statusBarHeight {
    return [self iSiphoneXLater] ? 40 : 20;
}
+ (CGFloat)naviBarHeight {
    return [self iSiphoneXLater] ? 88 : 64;
}
+ (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}
+ (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (BOOL)iSiphoneXLater {
    BOOL iphoneXLater = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iphoneXLater;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iphoneXLater = YES;
        }
    }
    return iphoneXLater;
}
@end

#pragma mark - =======  UIViewController (LWCustomNavi)  =======
@implementation UIViewController (LWCustomNavi)
@dynamic leftOnClick;
@dynamic rightOnClick;

//exchangeMethod
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL needSwizzleSelectors[4] = {
            @selector(viewWillAppear:),
            @selector(viewDidLoad),
            @selector(setTitle:),
            @selector(viewDidAppear:)
        };
        for (int i = 0; i < 4;  i++) {
            SEL selector = needSwizzleSelectors[i];
            NSString *newSelectorStr = [NSString stringWithFormat:@"LW_%@", NSStringFromSelector(selector)];
            Method originMethod = class_getInstanceMethod(self, selector);
            Method swizzledMethod = class_getInstanceMethod(self, NSSelectorFromString(newSelectorStr));
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}
#pragma mark - =======  LW_viewWillAppear  =======
- (void)LW_viewWillAppear:(BOOL)animated {
    /*
     由于 UINavigationController 也是继承与UIViewController
     而 UINavigationController 不需要重新这些方法
     */
    if ([self isMemberOfClass:UINavigationController.class]){return;}
    if ([self canUpdateNavigationBar]) {
        [self updateCustomNavi];
    }
    [self LW_viewWillAppear:animated];
}
#pragma mark - =======  LW_viewDidLoad  =======
- (void)LW_viewDidLoad {
    /*
     由于 UINavigationController 也是继承与UIViewController
     而 UINavigationController 不需要重新这些方法
     */
    if ([self isMemberOfClass:UINavigationController.class]){return;}

    if ([self canUpdateNavigationBar]) {
        self.navigationController.navigationBar.hidden = YES;
        [self creatCustomNaviView];
    }
    [self LW_viewDidLoad];
}
#pragma mark - =======  LW_setTitle  =======
- (void)LW_setTitle:(NSString *)title {
    /*
     由于 UINavigationController 也是继承与UIViewController
     而 UINavigationController 不需要重新这些方法
     */
    if ([self isMemberOfClass:UINavigationController.class]){return;}
    self.titleText = title;
}
#pragma mark - =======  LW_viewDidAppear  =======
- (void)LW_viewDidAppear:(BOOL)animated {
    /*
     由于 UINavigationController 也是继承与UIViewController
     而 UINavigationController 不需要重新这些方法
     */
    if ([self isMemberOfClass:UINavigationController.class]){return;}
    [self LW_viewDidAppear:animated];
}
#pragma mark - =======  按钮事件  =======
//左按钮事件
- (void)LWLeftBtnAction {
    if (self.leftOnClick) {
        self.leftOnClick();
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//右按钮事件
- (void)LWRightBtnAction {
    if (self.rightOnClick) {
        self.rightOnClick();
    }
}
#pragma mark - =======  设置属性  =======
//导航栏背景颜色
- (UIColor *)naviBGColor {
    UIColor * bgColor = (UIColor *)objc_getAssociatedObject(self, _cmd);
    return bgColor ? bgColor : [UIColor whiteColor];
}
- (void)setNaviBGColor:(UIColor *)naviBGColor {
    objc_setAssociatedObject(self, @selector(naviBGColor), naviBGColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//导航栏透明度
- (float)naviBGAlpha {
    id bgAlpha = objc_getAssociatedObject(self, _cmd);
    return bgAlpha ? [bgAlpha floatValue] : 1.0;
}
- (void)setNaviBGAlpha:(float)naviBGAlpha {
    objc_setAssociatedObject(self, @selector(naviBGAlpha), @(naviBGAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//导航栏背景图片
- (UIImage *)naviBGImage {
    UIImage * bgImage = (UIImage *)objc_getAssociatedObject(self, _cmd);
    return bgImage ? bgImage : nil;
}
- (void)setNaviBGImage:(UIImage *)naviBGImage {
    objc_setAssociatedObject(self, @selector(naviBGImage), naviBGImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//标题
- (NSString *)titleText {
    NSString * titleText = (NSString *)objc_getAssociatedObject(self, _cmd);
    return titleText ? titleText : nil;
}
- (void)setTitleText:(NSString *)titleText {
   objc_setAssociatedObject(self, @selector(titleText), titleText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//标题颜色
- (UIColor *)titleColor {
    UIColor * titleColor = (UIColor *)objc_getAssociatedObject(self, _cmd);
    return titleColor ? titleColor : [UIColor blackColor];
}
- (void)setTitleColor:(UIColor *)titleColor {
    objc_setAssociatedObject(self, @selector(titleColor), titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//标题字体
- (UIFont *)titleFont {
    UIFont * titleFont = (UIFont *)objc_getAssociatedObject(self, _cmd);
    return titleFont ? titleFont : [UIFont boldSystemFontOfSize:18];
}
- (void)setTitleFont:(UIFont *)titleFont {
    objc_setAssociatedObject(self, @selector(titleFont), titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//左按钮图片
- (UIImage *)leftImage {
    UIImage * leftImage = (UIImage *)objc_getAssociatedObject(self, _cmd);
    return leftImage ? leftImage :nil;
}
- (void)setLeftImage:(UIImage *)leftImage {
    objc_setAssociatedObject(self, @selector(leftImage), leftImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//左按钮标题
- (NSString *)leftTitle {
    NSString * leftTitle = (NSString *)objc_getAssociatedObject(self, _cmd);
    return leftTitle ? leftTitle : @"返回";
}
- (void)setLeftTitle:(NSString *)leftTitle {
    objc_setAssociatedObject(self, @selector(leftTitle), leftTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//左按钮标题颜色
- (UIColor *)leftColor {
    UIColor * leftColor = (UIColor *)objc_getAssociatedObject(self, _cmd);
    return leftColor ? leftColor : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0];
}
- (void)setLeftColor:(UIColor *)leftColor {
    objc_setAssociatedObject(self, @selector(leftColor), leftColor,  OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//左按钮隐藏
- (BOOL)leftHidden {
    id leftHidden = objc_getAssociatedObject(self, _cmd);
    return leftHidden ? [leftHidden boolValue] : NO;
}
- (void)setLeftHidden:(BOOL)leftHidden {
    objc_setAssociatedObject(self, @selector(leftHidden), @(leftHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//左按钮点击事件
- (BtnOnClick)leftOnClick {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setLeftOnClick:(BtnOnClick)leftOnClick {
    objc_setAssociatedObject(self, @selector(leftOnClick), leftOnClick, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//右按钮图片
- (UIImage *)rightImage {
    UIImage * rightImage = (UIImage *)objc_getAssociatedObject(self, _cmd);
    return rightImage ? rightImage :nil;
}
- (void)setRightImage:(UIImage *)rightImage {
   objc_setAssociatedObject(self, @selector(rightImage), rightImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//右按钮标题
- (NSString *)rightTitle {
    NSString * rightTitle = (NSString *)objc_getAssociatedObject(self, _cmd);
    return rightTitle ? rightTitle : @"更多";
}
- (void)setRightTitle:(NSString *)rightTitle {
   objc_setAssociatedObject(self, @selector(rightTitle), rightTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//右按钮标题颜色
- (UIColor *)rightColor {
    UIColor * rightColor = (UIColor *)objc_getAssociatedObject(self, _cmd);
    return rightColor ? rightColor : [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1.0];
}
- (void)setRightColor:(UIColor *)rightColor {
     objc_setAssociatedObject(self, @selector(rightColor), rightColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//右按钮隐藏
- (BOOL)rightHidden {
    id rightHidden = objc_getAssociatedObject(self, _cmd);
    return rightHidden ? [rightHidden boolValue] : YES;
}
- (void)setRightHidden:(BOOL)rightHidden {
    objc_setAssociatedObject(self, @selector(rightHidden), @(rightHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//右按钮点击事件
- (BtnOnClick)rightOnClick {
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setRightOnClick:(BtnOnClick)rightOnClick {
    objc_setAssociatedObject(self, @selector(rightOnClick), rightOnClick, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//返回手势
- (BOOL)backGesture {
    id backGesture = objc_getAssociatedObject(self, _cmd);
    return backGesture ? [backGesture boolValue] : YES;
}
- (void)setBackGesture:(BOOL)backGesture {
    objc_setAssociatedObject(self, @selector(backGesture), @(backGesture), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//状态栏样式
- (UIStatusBarStyle)statusStyle {
    id statusStyle = objc_getAssociatedObject(self, _cmd);
    return statusStyle ? [statusStyle intValue] : UIStatusBarStyleDefault;
}
- (void)setStatusStyle:(UIStatusBarStyle)statusStyle {
    objc_setAssociatedObject(self, @selector(statusStyle), @(statusStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//细线隐藏
- (BOOL)shadowHidden {
    id shadowHidden = objc_getAssociatedObject(self, _cmd);
    return shadowHidden ? [shadowHidden boolValue] : NO;
}
- (void)setShadowHidden:(BOOL)shadowHidden {
   objc_setAssociatedObject(self, @selector(shadowHidden), @(shadowHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - =======  导航栏控件  =======
//背景
- (UIView *)LWNaviBGView {
    return (UIView *)objc_getAssociatedObject(self, _cmd);
}
- (void)setLWNaviBGView:(UIView *)LWNaviBGView {
    objc_setAssociatedObject(self, @selector(LWNaviBGView), LWNaviBGView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//背景图片
- (UIImageView *)LWNaviBGImageView {
    return (UIImageView *)objc_getAssociatedObject(self, _cmd);
}
- (void)setLWNaviBGImageView:(UIImageView *)LWNaviBGImageView {
    objc_setAssociatedObject(self, @selector(LWNaviBGImageView), LWNaviBGImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//标题
- (UILabel *)LWTitleLabel {
    return (UILabel *)objc_getAssociatedObject(self, _cmd);
}
- (void)setLWTitleLabel:(UILabel *)LWTitleLabel {
    objc_setAssociatedObject(self, @selector(LWTitleLabel), LWTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//左按钮
- (UIButton *)LWLeftBtn {
    return (UIButton *)objc_getAssociatedObject(self, _cmd);
}
- (void)setLWLeftBtn:(UIButton *)LWLeftBtn {
    objc_setAssociatedObject(self, @selector(LWLeftBtn), LWLeftBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//右按钮
- (UIButton *)LWRightBtn {
    return (UIButton *)objc_getAssociatedObject(self, _cmd);
}
- (void)setLWRightBtn:(UIButton *)LWRightBtn {
    objc_setAssociatedObject(self, @selector(LWRightBtn), LWRightBtn, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//shadowImage
- (UIView *)LWShadowImage {
    return (UIView *)objc_getAssociatedObject(self, _cmd);
}
- (void)setLWShadowImage:(UIView *)LWShadowImage {
    objc_setAssociatedObject(self, @selector(LWShadowImage), LWShadowImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (void)creatCustomNaviView {
    self.LWNaviBGView = [[UIView alloc] init];
    self.LWNaviBGView.frame = CGRectMake(0,0,[LWCustomNavi screenWidth], [LWCustomNavi naviBarHeight]);
    [self.view addSubview:self.LWNaviBGView];
    self.LWNaviBGImageView = [[UIImageView alloc] init];
    self.LWNaviBGImageView.frame = self.LWNaviBGView.frame;
    [self.view addSubview:self.LWNaviBGImageView];
    self.LWTitleLabel = [[UILabel alloc] init];
    self.LWTitleLabel.frame = CGRectMake(55,[LWCustomNavi statusBarHeight],[LWCustomNavi screenWidth] - 110,44);
    self.LWTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.LWTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:self.LWTitleLabel];
    self.LWLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LWLeftBtn.frame = CGRectMake(10, [LWCustomNavi statusBarHeight], 45, 44);
    self.LWLeftBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.LWLeftBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -20, 0.0, 0.0)];
    self.LWLeftBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.LWLeftBtn addTarget:self action:@selector(LWLeftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.LWLeftBtn];
    self.LWRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.LWRightBtn.frame = CGRectMake([LWCustomNavi screenWidth] - 55, [LWCustomNavi statusBarHeight], 40, 44);
    self.LWRightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.LWRightBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -20)];
    self.LWRightBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.LWRightBtn addTarget:self action:@selector(LWRightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.LWRightBtn];
    self.LWShadowImage = [[UIView alloc] init];
    self.LWShadowImage.frame = CGRectMake(0, [LWCustomNavi naviBarHeight]-0.3, [LWCustomNavi screenWidth], 0.3);
    self.LWShadowImage.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.LWShadowImage];
}
#pragma mark - =======  Method  =======
- (void)updateCustomNavi {
    //防止控件被遮挡
    [self.view bringSubviewToFront:self.LWNaviBGView];
    [self.view bringSubviewToFront:self.LWNaviBGImageView];
    [self.view bringSubviewToFront:self.LWTitleLabel];
    [self.view bringSubviewToFront:self.LWLeftBtn];
    [self.view bringSubviewToFront:self.LWRightBtn];
    [self.view bringSubviewToFront:self.LWShadowImage];

    //设置LWShadowImage
    if (self.shadowHidden) {
        self.LWShadowImage.hidden = YES;
    }else {
       self.LWShadowImage.hidden = NO;
        self.LWNaviBGView.frame = CGRectMake(0,0,[LWCustomNavi screenWidth], [LWCustomNavi naviBarHeight] - 0.3);
        self.LWNaviBGImageView.frame = self.LWNaviBGView.frame;
    }
    //设置返回手势
    if (self.backGesture) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }else {
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
    //设置标题
    self.LWTitleLabel.text = self.titleText;
    self.LWTitleLabel.textColor = self.titleColor;
    self.LWTitleLabel.font = self.titleFont;
    //设置左按钮
    if (self.leftImage) {
        [self.LWLeftBtn setTitle:nil forState:UIControlStateNormal];
        [self.LWLeftBtn setImage:self.leftImage forState:UIControlStateNormal];
        [self.LWLeftBtn setImage:self.leftImage forState:UIControlStateHighlighted];

    }else {
        [self.LWLeftBtn setTitle:self.leftTitle forState:UIControlStateNormal];
    }
    [self.LWLeftBtn setTitleColor:self.leftColor forState:UIControlStateNormal];
    self.LWLeftBtn.hidden = self.leftHidden;
    //设置右按钮
    if (self.rightImage) {
        [self.LWRightBtn setTitle:nil forState:UIControlStateNormal];
        [self.LWRightBtn setImage:self.rightImage forState:UIControlStateNormal];
        [self.LWRightBtn setImage:self.rightImage forState:UIControlStateHighlighted];
    }else {
        [self.LWRightBtn setTitle:self.rightTitle forState:UIControlStateNormal];
    }
    [self.LWRightBtn setTitleColor:self.rightColor forState:UIControlStateNormal];
    self.LWRightBtn.hidden = self.rightHidden;
    //设置背景颜色
    self.LWNaviBGView.backgroundColor = self.naviBGColor;
    //设置背景图片
    self.LWNaviBGImageView.image = self.naviBGImage;
    //设置透明度
    if (self.naviBGColor == [UIColor whiteColor] && self.naviBGAlpha >= 1.0) {
        self.naviBGAlpha = 0.5;
    }
    self.LWNaviBGView.alpha = self.naviBGAlpha;
    if (self.naviBGAlpha == 0) {
        self.LWNaviBGImageView.hidden = YES;
    }
    //设置状态栏样式
    if (self.statusStyle == UIStatusBarStyleDefault) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }

}
- (BOOL)canUpdateNavigationBar {
    return [self.navigationController.viewControllers containsObject:self];
}
- (BOOL)isRootViewController{
    UIViewController *rootViewController = self.navigationController.viewControllers.firstObject;
    if ([rootViewController isKindOfClass:[UITabBarController class]] == NO) {
        return rootViewController == self;
    } else {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [tabBarController.viewControllers containsObject:self];
    }
}
@end
