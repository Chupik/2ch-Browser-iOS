//
//  DVBRecaptchaViewController.m
//  dvach-browser
//
//  Created by Alexander Kochupalov on 30.12.2017.
//  Copyright © 2017 8of. All rights reserved.
//

#import "DVBRecaptchaViewController.h"
#import "DVBCaptchaManager.h"

@interface DVBRecaptchaViewController ()

@property (nonatomic, strong) DVBCaptchaManager *captchaManager;
@property (nonatomic, strong) NSString *captchaId;

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation DVBRecaptchaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _captchaManager = [[DVBCaptchaManager alloc] init];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *controller = [[WKUserContentController alloc] init];
    
    [controller addScriptMessageHandler:self name:@"recaptcha"];
    
    NSString *injectionSource = [self loadRecaptchaInjectWithEndpoint];
    WKUserScript *injection = [[WKUserScript alloc] initWithSource:injectionSource injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    [controller addUserScript: injection];
    
    [configuration setUserContentController: controller];
    
    _webView = [[WKWebView alloc] initWithFrame: CGRectZero configuration:configuration];
    self.view = _webView;
    
    [_captchaManager getCaptchaId:^(NSString *captchaId){
        if (captchaId) {
            _captchaId = captchaId;
            [_webView loadRequest: [[NSURLRequest alloc] initWithURL: [[NSURL alloc] initWithString:@"https://2ch.hk/api/captcha/recaptcha/mobile"]]];
        }
    }];
}

- (NSString *)loadRecaptchaInjectWithEndpoint {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"recaptcha" ofType:@"js"];
    NSString* html = [[NSString alloc] initWithContentsOfFile: htmlPath encoding: NSUTF8StringEncoding error:nil];
    //html = [html stringByReplacingOccurrencesOfString:@"${endpoint}" withString: endpoint];
    //html = [html stringByReplacingOccurrencesOfString:@"${apiKey}" withString: apiKey];
    return html;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSString *resultKey = (NSString *)message.body;
    resultKey = [resultKey substringWithRange:NSMakeRange(1, [resultKey length] - 2)];
    
    if (_dvachCaptchaViewControllerDelegate && [_dvachCaptchaViewControllerDelegate respondsToSelector:@selector(captchaBeenCheckedWithCode:andWithId:)]) {
        if (!resultKey || !_captchaId) { return; }
        [_dvachCaptchaViewControllerDelegate captchaBeenCheckedWithCode: resultKey
                                                              andWithId:_captchaId];
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
