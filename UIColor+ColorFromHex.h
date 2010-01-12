//
//  UIColor+ColorFromHex.h
//  Saturation
//
//  Created by Shawn Roske on 1/11/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorFromHexAdditions)

+ (UIColor *)colorFromHex:(NSString *)hexValue alpha:(float)alpha;

@end
