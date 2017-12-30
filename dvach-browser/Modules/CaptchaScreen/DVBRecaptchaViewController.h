//
//  DVBRecaptchaViewController.h
//  dvach-browser
//
//  Created by Alexander Kochupalov on 30.12.2017.
//  Copyright © 2017 8of. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "DVBDvachCaptchaViewController.h"

@interface DVBRecaptchaViewController : UIViewController <WKScriptMessageHandler>

@property (nonatomic, weak, nullable) id<DVBDvachCaptchaViewControllerDelegate> dvachCaptchaViewControllerDelegate;

@end
