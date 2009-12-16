//
//  CircleView.m
//  Recursion
//
//  Created by Shawn Roske on 10/2/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSCircleView.h"


@implementation BGSCircleView

@synthesize color;
@synthesize newColor;
@synthesize animating;

- (void)setColor:(UIColor *)nc
{
	if (color != nc)
	{
		[color release];
		color = [nc retain];
	}
	
	[self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		self.animating = NO;
		self.backgroundColor = [UIColor clearColor];
		self.color = [UIColor colorWithRed:0.3f green:0.2f blue:0.4f alpha:1.0];
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	CGContextSetFillColorWithColor(context, [self.color CGColor]);

	CGContextBeginPath(context);
	CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2, 0, 2*M_PI, false);
	CGContextFillPath(context);
	//CGContextClosePath(context);
}


- (void)dealloc 
{
	[color release];
	[newColor release];
    [super dealloc];
}


@end
