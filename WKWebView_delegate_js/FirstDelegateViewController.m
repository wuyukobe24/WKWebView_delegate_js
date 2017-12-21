//
//  FirstDelegateViewController.m
//  WKWebView_delegate_js
//
//  Created by WangXueqi on 2017/12/20.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "FirstDelegateViewController.h"
#define k_url                   @"https://www.vczhushou.cn/api/activity/bannerInfo?id=9"
#define k_estimatedProgress     @"estimatedProgress"
@interface FirstDelegateViewController ()<WKNavigationDelegate>
@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,strong)UIProgressView * progressView;
@end

@implementation FirstDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
}

- (WKWebView *)webView {
    
    if (!_webView) {
        //配置控制器
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.preferences = [[WKPreferences alloc]init];
        configuration.preferences.javaScriptEnabled = YES;
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        configuration.processPool = [[WKProcessPool alloc]init];
        configuration.allowsInlineMediaPlayback = YES;
        //缓存机制
        configuration.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
        configuration.userContentController = [[WKUserContentController alloc] init];
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, K_NavBarHeight, K_ScreenWidth, K_ScreenHeight-K_NavBarHeight) configuration:configuration];
        _webView.navigationDelegate = self;
        [_webView addSubview:self.progressView];
        //监听进度
        [_webView addObserver:self forKeyPath:k_estimatedProgress options:NSKeyValueObservingOptionNew context:nil];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:k_url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_webView loadRequest:request];
            });
        });
    }
    return _webView;
}

- (UIProgressView *)progressView {
    
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
        _progressView.frame = CGRectMake(0, 0, K_ScreenWidth, 2.5);
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor lightGrayColor];
    }
    return _progressView;
}

- (void)dealloc {
    
    [_webView removeObserver:self forKeyPath:k_estimatedProgress];
}

#pragma mark - KVO
//计算wkWebView进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:k_estimatedProgress]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setProgress:1.0 animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            });
        }else {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

#pragma mark - WKNavigationDelegate
/**
//如果不实现这个方法,web视图将加载请求,或在适当的情况下,其转发到另一个应用程序。(在发送请求之前，决定是否跳转)
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSLog(@"1");
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated
        && ![hostname containsString:@".baidu.com"]) {
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        self.progressView.alpha = 1.0;
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    NSLog(@"%s", __FUNCTION__);
}
*/
/**
 //如果不实现这个方法,将允许响应web视图,如果web视图可以表现出来。(在收到响应后，决定是否跳转)
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSLog(@"2");
    // 如果响应的地址是百度，则允许跳转
        if ([navigationResponse.response.URL.host.lowercaseString isEqual:@"www.baidu.com"]) {
            // 允许跳转
            decisionHandler(WKNavigationResponsePolicyAllow);
            return;
        }
        // 不允许跳转
        decisionHandler(WKNavigationResponsePolicyCancel);
    decisionHandler(WKNavigationResponsePolicyAllow);
}
*/

//开始调用一个主框架导航(页面开始加载时调用)
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"3");
}

//调用的主要服务器接收到重定向框架(接收到服务器跳转请求之后调用)
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"4");
}

//开始加载数据时出现错误时调用(加载失败时调用)
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"5");
}

//内容开始到达时调用的主要框架(当内容开始返回时调用)
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"6");
}

//主框架导航完成时调用(页面加载完成之后调用)
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    NSLog(@"7");
}

//发生错误时调用。(导航失败时会回调)
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    NSLog(@"8");
}

/**
//讨论如果你不实现这个方法,web视图将响应身份验证的挑战，对于HTTPS的都会触发此代理，如果不要求验证，传默认就行，如果需要证书验证，与使用AFN进行HTTPS证书验证是一样的
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
    NSLog(@"9");
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}
*/

//调用web视图的web内容过程终止时调用，9.0才能使用
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)) {
    
    NSLog(@"10");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
