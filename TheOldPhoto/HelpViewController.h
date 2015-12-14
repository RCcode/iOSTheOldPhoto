//
//  HelpViewController.h
//  BestMe
//
//  Created by MAXToooNG on 15/6/16.
//  Copyright (c) 2015年 Chen.Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
//    kWebViewTips,
    kWebViewTerms,
    kWebViewPrivacy
}WebViewType;

@interface HelpViewController : UIViewController
@property (nonatomic, assign) WebViewType type;
@end
