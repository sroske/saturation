//
//  BGSSwatchColor.m
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSSwatchColor.h"


@implementation BGSSwatchColor

@synthesize color;

- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)displayColor
{
    if (self = [super initWithFrame:frame]) 
	{
		self.color = displayColor;
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, self.color.CGColor);
	CGContextFillRect(context, self.bounds);
}


- (void)dealloc 
{
	[color release];
    [super dealloc];
}


@end
