//
//  BGSSwatchStrip.m
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSSwatchStrip.h"


@implementation BGSSwatchStrip

@synthesize swatches;

- (id)initWithFrame:(CGRect)frame andSwatches:(NSArray *)swatchEntries
{
    if (self = [super initWithFrame:frame]) 
	{
		self.swatches = swatchEntries;
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGPoint p = self.bounds.origin;
	while (p.x <= self.bounds.origin.x+self.bounds.size.width)
	{
		for (NSDictionary *swatch in self.swatches)
		{
			CGContextSetFillColorWithColor(context, CC_FROM_SWATCH(swatch).CGColor);
			CGContextFillRect(context, CGRectMake(p.x, 
												  p.y, 
												  COLOR_STRIP_ENTRY_WIDTH, 
												  COLOR_STRIP_ENTRY_HEIGHT));     
			p.x += COLOR_STRIP_ENTRY_WIDTH;
		}		
	}
}


- (void)dealloc 
{
	[swatches release];
    [super dealloc];
}


@end