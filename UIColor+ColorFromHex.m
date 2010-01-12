//
//  UIColor+ColorFromHex.m
//  Saturation
//
//  Created by Shawn Roske on 1/11/10.
//  Copyright 2010 Bitgun. All rights reserved.
//
// From CocoaDialog http://cocoadialog.sourceforge.net
//

#import "UIColor+ColorFromHex.h"


@implementation UIColor (ColorFromHexAdditions)

+ (UIColor *)colorFromHex:(NSString *)hexValue alpha:(float)alpha
{
	unsigned char r, g, b;
	unsigned int value;
	[[NSScanner scannerWithString:hexValue] scanHexInt:&value];
	r = (unsigned char)(value >> 16);
	g = (unsigned char)(value >> 8);
	b = (unsigned char)value;
	return [UIColor colorWithRed:(float)r/255 green:(float)g/255 blue:(float)b/255 alpha:alpha];
}

@end
