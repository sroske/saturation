//
//  BGSQuadCircleVisualizer.m
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSQuadCircleVisualizer.h"

@interface BGSQuadCircleVisualizer (Private)

- (void)circlesFaded:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context;

@end


@implementation BGSQuadCircleVisualizer

@synthesize entry;
@synthesize circles;

- (NSArray *)circles
{
	if (circles == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		for (int i = 0; i < QUAD_CIRCLE_ROWS*QUAD_CIRCLE_COLS; i++)
		{
			int row = i/QUAD_CIRCLE_COLS;
			int col = i%QUAD_CIRCLE_COLS;
			BGSQuadCircleGroupView *circle = [[BGSQuadCircleGroupView alloc] initWithFrame:CGRectMake(col*(self.bounds.size.width/QUAD_CIRCLE_COLS), 
																									  row*(self.bounds.size.height/QUAD_CIRCLE_ROWS), 
																									  self.bounds.size.width/QUAD_CIRCLE_COLS, 
																									  self.bounds.size.height/QUAD_CIRCLE_ROWS)
																				  andEntry:self.entry];
			[circle setHidden:YES];
			[a addObject:circle];
			[circle release];
		}
		[self setCircles:a];
		[a release];
	}
	return circles;
}

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData 
{
    if (self = [super initWithFrame:frame]) 
	{
		isFadingIn = hasAnimated = NO;
		[self setEntry:entryData];
		for (BGSQuadCircleView *c in self.circles)
			[self addSubview:c];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
	if (!hasAnimated)
	{
		if (animated)
		{
			isFadingIn = YES;
			
			CGFloat delay = 0.3;
			NSArray *shuffled = [self.circles shuffledArray];
			for (BGSQuadCircleView *c in shuffled)
			{
				[c setHidden:NO];
				[c setAlpha:0.0f];
				[UIView beginAnimations:nil context:NULL];
				[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
				[UIView setAnimationDelay:delay];
				[UIView setAnimationDuration:0.6];
				
				if (c == [shuffled objectAtIndex:[shuffled count]-1])
				{
					[UIView setAnimationDelegate:self];
					[UIView setAnimationDidStopSelector:@selector(circlesFaded:finished:context:)];
				}
				
				[c setAlpha:1.0f];
				
				[UIView commitAnimations];
				
				delay += 0.4f;
			}
		}
		else 
		{
			for (BGSQuadCircleView *c in self.circles)
				[c setHidden:NO];
			isFadingIn = NO;
			hasAnimated = YES;
		}		
	}
}

- (void)circlesFaded:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	isFadingIn = NO;
	hasAnimated = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	// nothing
}

- (void)dealloc 
{
	[entry release];
	[circles release];
    [super dealloc];
}


#pragma mark -
#pragma mark Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isFadingIn) return;
	
	for (UITouch *touch in touches)
	{
		if ([[touch view] isKindOfClass:[BGSQuadCircleGroupView class]])
		{
			BGSQuadCircleGroupView *v = (BGSQuadCircleGroupView *)[touch view];
			if (!v.hasSplit && !v.isAnimating)
				[v split];
		}	
	}
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isFadingIn) return;
	
	for (UITouch *touch in touches)
	{
		CGPoint point = [touch locationInView:self];
		UIView *v = [self hitTest:point withEvent:event];
		if ([v isKindOfClass:[BGSQuadCircleGroupView class]])
		{
			BGSQuadCircleGroupView *cv = (BGSQuadCircleGroupView *)v;
			if (!cv.hasSplit && !cv.isAnimating)
				[cv split];
		}
	}
	[super touchesMoved:touches withEvent:event];
}

@end
