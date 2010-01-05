//
//  BGSQuadCircleGroupView.m
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSQuadCircleGroupView.h"

@interface BGSQuadCircleGroupView (Private)

- (void)getReadyForCombine;
- (UIColor *)randomColor;
- (void)splitCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context;
- (void)combineCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context;
- (void)swapBack;

@end

@implementation BGSQuadCircleGroupView

@synthesize entry;
@synthesize primaryColor;
@synthesize parent;
@synthesize isAnimating;
@synthesize hasSplit;
@synthesize readyForCombine;

- (id)initWithFrame:(CGRect)frame andPrimaryColor:(UIColor *)color andEntry:(NSDictionary *)entryData
{
    if (self = [super initWithFrame:frame]) 
	{
		self.hasSplit = self.readyForCombine = self.isAnimating = NO;
		[self setBackgroundColor:CC_CLEAR];
		[self setEntry:entryData];
		[self setPrimaryColor:color];
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	if (!self.hasSplit)
	{
		CGContextSetFillColorWithColor(context, [self.primaryColor CGColor]);
		CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2, 0, 2*M_PI, false);
		CGContextFillPath(context);		
	}
	else 
	{
		CGContextClearRect(context, rect);
	}

}

- (void)dealloc 
{
	[entry release];
	[primaryColor release];
    [super dealloc];
}

- (UIColor *)randomColor
{
	NSArray *swatches = [self.entry objectForKey:@"swatches"];
	UIColor *c = CC_WHITE;
	if ([swatches count] > 0)
	{
		int i = arc4random()%[swatches count];
		NSDictionary *swatch = [swatches objectAtIndex:i];
		c = CC_FROM_SWATCH(swatch);		
	}
	return c;
}

- (void)split
{
	if (self.hasSplit || self.isAnimating) return;
	if (self.bounds.size.width <= QUAD_CIRCLE_CUTOFF) return;
	
	self.hasSplit = self.isAnimating = YES;
	
	[UIView beginAnimations:@"split" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(splitCompleted:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.4];
	
	for (int i = 0; i < QUAD_CIRCLE_GROUP_ROWS*QUAD_CIRCLE_GROUP_COLS; i++)
	{
		int row = i/QUAD_CIRCLE_GROUP_COLS;
		int col = i%QUAD_CIRCLE_GROUP_COLS;
		BGSQuadCircleGroupView *group = [[BGSQuadCircleGroupView alloc] initWithFrame:self.bounds
																	  andPrimaryColor:self.primaryColor 
																			 andEntry:self.entry];
		[group setParent:self];
		[group setIsAnimating:YES];
		[self addSubview:group];

		[group setFrame:CGRectMake(col*(self.bounds.size.width/QUAD_CIRCLE_GROUP_COLS), 
								   row*(self.bounds.size.height/QUAD_CIRCLE_GROUP_ROWS), 
								   self.bounds.size.width/QUAD_CIRCLE_GROUP_COLS, 
								   self.bounds.size.height/QUAD_CIRCLE_GROUP_ROWS)];
		[group release];
	}
	
	[UIView commitAnimations];

	[self setNeedsDisplay];
}

- (void)splitCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	[UIView beginAnimations:@"color" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(colorChangeCompleted:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.3];
	
	for (BGSQuadCircleGroupView *group in self.subviews)
	{
		BGSQuadCircleOverlayView *overlay = [[BGSQuadCircleOverlayView alloc] initWithFrame:group.frame andColor:self.primaryColor];
		[self addSubview:overlay];
		
		[group setPrimaryColor:[self randomColor]];
		[group setNeedsDisplay];
		
		[overlay setAlpha:0.0];
	}
	
	[UIView commitAnimations];
}

- (void)colorChangeCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	self.isAnimating = NO;
	for (UIView *v in self.subviews)
	{
		if ([v isKindOfClass:[BGSQuadCircleGroupView class]])
		{
			BGSQuadCircleGroupView *group = (BGSQuadCircleGroupView *)v;
			[group setIsAnimating:NO];
		}
		else 
		{
			[v removeFromSuperview];
			[v release];
		}
	}
	
	[self performSelector:@selector(getReadyForCombine) withObject:nil afterDelay:4.0];	
}

- (void)getReadyForCombine
{
	self.readyForCombine = YES;
}

- (void)combine
{
	if (!self.readyForCombine || !self.hasSplit || self.isAnimating) return;
	
	// if any children are split, just send this message down the line
	BOOL childrenAreSplit = NO;
	for (int i = 0; i < [self.subviews count]; i++)
	{
		BGSQuadCircleGroupView *group = (BGSQuadCircleGroupView *)[self.subviews objectAtIndex:i];
		if (group.hasSplit)
			childrenAreSplit = YES;
		if (group.readyForCombine)
			[group combine];
	}
	if (childrenAreSplit) return;
	
	self.isAnimating = YES;

	[UIView beginAnimations:@"color" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(colorRevertCompleted:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDuration:0.3];
	
	for (BGSQuadCircleGroupView *group in self.subviews)
	{
		BGSQuadCircleOverlayView *overlay = [[BGSQuadCircleOverlayView alloc] initWithFrame:group.frame andColor:group.primaryColor];
		[self addSubview:overlay];
		
		[group setPrimaryColor:self.primaryColor];
		[group setNeedsDisplay];
		
		[overlay setAlpha:0.0];
	}
	
	[UIView commitAnimations];
}

- (void)colorRevertCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	[UIView beginAnimations:@"combine" context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(combineCompleted:finished:context:)];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDuration:0.4];
	
	for (UIView *v in self.subviews)
	{
		if ([v isKindOfClass:[BGSQuadCircleGroupView class]])
		{
			BGSQuadCircleGroupView *group = (BGSQuadCircleGroupView *)v;
			[group setFrame:self.bounds];
		}
		else 
		{
			[v removeFromSuperview];
			[v release];
		}
	}

	[UIView commitAnimations];
}

- (void)combineCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	self.isAnimating = self.hasSplit = self.readyForCombine = NO;
	for (BGSQuadCircleGroupView *group in self.subviews)
		[group removeFromSuperview];
	
	[self setNeedsDisplay];
}

@end
