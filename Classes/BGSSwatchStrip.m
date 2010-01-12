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

- (void)setSwatches:(NSArray *)newSwatches
{
	if (swatches != newSwatches)
	{
		[swatches release];
		swatches = [newSwatches retain];
	}
	[self setNeedsDisplay];
}

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
			UIColor *color = [UIColor colorFromHex:[swatch objectForKey:@"swatchHexColor"] alpha:1.0];
			CGContextSetFillColorWithColor(context, color.CGColor);
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
