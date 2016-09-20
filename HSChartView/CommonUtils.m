//
//  CommonUtils.m
//  Account
//
//  Created by HuyTCM on 9/20/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "CommonUtils.h"

@implementation CommonUtils

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:alpha];
}

@end
