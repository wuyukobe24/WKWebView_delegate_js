//
//  OC_JS_View.m
//  WKWebView_delegate_js
//
//  Created by WangXueqi on 2017/12/20.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "OC_JS_View.h"

@implementation OC_JS_View

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showLabel = [[UILabel alloc]init];
        self.showLabel.text = @"展示来自js的数据";
        [self addSubview:self.showLabel];
        
        self.fieldView = [[UITextField alloc]init];
        self.fieldView.placeholder = @"输入从oc传给js的数据";
        self.fieldView.borderStyle = UITextBorderStyleRoundedRect;
        [self addSubview:self.fieldView];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button setTitle:@"上传" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:self.button];
    }
    return self;
}

- (void)layoutSubviews {
    
    self.showLabel.frame = CGRectMake(10, 20, K_ScreenWidth-20, 80);
    self.showLabel.backgroundColor = [UIColor lightGrayColor];
    self.fieldView.frame = CGRectMake(10, 120, K_ScreenWidth-100, 50);
    [self.button setFrame:CGRectMake(K_ScreenWidth-100, 120, 90, 50)];
    [self.button setBackgroundColor:[UIColor blueColor]];
}

@end
