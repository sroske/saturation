//
//  BGSQuadCircleOverlayView.m
//  Saturation
//
//  Created by Shawn Roske on 1/4/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSQuadCircleOverlayView.h"


@implementation BGSQuadCircleOverlayView

@synthesize color;


- (id)initWithFrame:(CGRect)frame andColor:(UIColor *)newColor
{
    if (self = [super initWithFrame:frame]) 
	{
		[self setColor:newColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 

	CGContextSetFillColorWithColor(context, [self.color CGColor]);
	CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2, 0, 2*M_PI, false);
	CGContextFillPath(context);	
}


- (void)dealloc 
{
	[color release];
    [super dealloc];
}


@end
