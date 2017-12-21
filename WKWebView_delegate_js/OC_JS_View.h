//
//  OC_JS_View.h
//  WKWebView_delegate_js
//
//  Created by WangXueqi on 2017/12/20.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import <UIKit/UIKit.h>

#define K_ScreenWidth               CGRectGetWidth([[UIScreen mainScreen] bounds])// 当前屏幕宽
#define K_ScreenHeight              CGRectGetHeight([[UIScreen mainScreen] bounds])// 当前屏幕高
@interface OC_JS_View : UIView
@property(nonatomic,strong)UILabel * showLabel;
@property(nonatomic,strong)UITextField * fieldView;
@property(nonatomic,strong)UIButton * button;
@end
