//
//  SecondJSViewController.m
//  WKWebView_delegate_js
//
//  Created by WangXueqi on 2017/12/20.
//  Copyright © 2017年 JingBei. All rights reserved.
//

#import "SecondJSViewController.h"
#import "OC_JS_View.h"

@interface SecondJSViewController ()<WKUIDelegate,WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView * webView;
@property(nonatomic,strong)OC_JS_View * OCView;
@end

@implementation SecondJSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.view addSubview:self.OCView];
}

- (WKWebView *)webView {
    
    if (!_webView) {
        //配置控制器
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [WKUserContentController new];
        
        //配置js调用统一参数
        [configuration.userContentController addScriptMessageHandler:self name:@"Back"];
        [configuration.userContentController addScriptMessageHandler:self name:@"Color"];
        [configuration.userContentController addScriptMessageHandler:self name:@"Param"];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, K_ScreenWidth, K_ScreenWidth*5/4-20) configuration:configuration];
        _webView.UIDelegate = self;
        NSString * urlStr = [[NSBundle mainBundle] pathForResource:@"wkwebview.html" ofType:nil];
        NSURL * fileURL = [NSURL fileURLWithPath:urlStr];
        [_webView loadFileURL:fileURL allowingReadAccessToURL:fileURL];
    }
    return _webView;
}

- (OC_JS_View *)OCView {
    
    if (!_OCView) {
        _OCView = [[OC_JS_View alloc]initWithFrame:CGRectMake(0, K_ScreenWidth*5/4, K_ScreenWidth, 180)];
        [_OCView.button addTarget:self action:@selector(transterClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _OCView;
}

//改变背景颜色（随机）
- (void)changeBackGroundViewColor {
    
    CGFloat r = arc4random() % 255;
    CGFloat g = arc4random() % 255;
    CGFloat b = arc4random() % 255;
    CGFloat a = arc4random() % 10;
    self.OCView.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/10];
}

//oc数据传给js
- (void)transterClick {
    
    NSString * paramString = self.OCView.fieldView.text;
    //transferPrama()是JS的语言
    NSString * jsStr = [NSString stringWithFormat:@"transferPrama('%@')",paramString];
    [self.webView evaluateJavaScript:jsStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        NSLog(@"result=%@  error=%@",result, error);
    }];
}

- (void)dealloc {
   //控制器不能销毁 需解决[configuration.userContentController addScriptMessageHandler:self name:@"Back"];
}

#pragma mark - 获取js传回参数
- (void)jsParams:(NSDictionary *)paramDic {
    
    if (![paramDic isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //获取网页传回来的数据
    NSString * firstStr = [paramDic objectForKey:@"first"];
    NSString * secondStr = [paramDic objectForKey:@"second"];
    self.OCView.showLabel.text = [NSString stringWithFormat:@"%@%@",firstStr,secondStr];
}

#pragma mark - WKUIDelegate
// 在JS端调用alert函数alert(content)时，会触发此代理方法，通过message可以拿到JS端所传的数据，在iOS端得到结果后，需要回调JS，通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

// JS端调用confirm函数时，会触发此方法，通过message可以拿到JS端所传的数据，在iOS端显示原生alert得到YES/NO后，通过completionHandler回调给JS端
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"confirm" message:@"JS调用confirm" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
}

//JS端调用prompt函数时，会触发此方法，要求输入一段文本，在原生输入得到文本内容后，通过completionHandler回调给JS
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - WKScriptMessageHandler
//收从js传给oc的数据
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    if ([message.name isEqualToString:@"Back"]) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if ([message.name isEqualToString:@"Color"]) {
        [self changeBackGroundViewColor];
    } else if ([message.name isEqualToString:@"Param"]) {
        [self jsParams:message.body];
    }
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
