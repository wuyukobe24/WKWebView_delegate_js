//
//  BaseViewController.h
//  WKWebView_delegate_js
//
//  Created by WangXueqi on 2017/12/20.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#define K_ScreenWidth               CGRectGetWidth([[UIScreen mainScreen] bounds])// 当前屏幕宽
#define K_ScreenHeight              CGRectGetHeight([[UIScreen mainScreen] bounds])// 当前屏幕高
#define K_NavBarHeight              (OSScreenIsAtiPhone5_8() ? 44.0f+44.0f : 44.0f+20.0f)// 导航条高度
// 是否是iPhone5.8寸的屏幕
__attribute__((unused)) static BOOL OSScreenIsAtiPhone5_8()
{
    return CGRectGetHeight([[UIScreen mainScreen] bounds]) == 812.f;
}

@interface BaseViewController : UIViewController

@end
