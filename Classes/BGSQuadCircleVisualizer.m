//
//  BGSQuadCircleVisualizer.m
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSQuadCircleVisualizer.h"

@interface BGSQuadCircleVisualizer (Private)

- (void)combine;
- (UIColor *)randomColor;
- (void)circlesFaded:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context;

@end


@implementation BGSQuadCircleVisualizer

@synthesize entry;
@synthesize circles;
@synthesize timer;

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
																		   andPrimaryColor:[self randomColor]
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

- (NSTimer *)timer
{
	if (timer == nil)
	{
		[self setTimer:[NSTimer scheduledTimerWithTimeInterval:1.0
														target:self 
													  selector:@selector(combine)
													  userInfo:nil 
													   repeats:YES]];
	}
	return timer;
}

- (void)combine
{
	for (BGSQuadCircleGroupView *c in self.circles)
		[c combine];
}

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData 
{
    if (self = [super initWithFrame:frame]) 
	{
		isFadingIn = hasAnimated = NO;
		[self setEntry:entryData];
		for (BGSQuadCircleGroupView *c in self.circles)
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
			for (BGSQuadCircleGroupView *c in shuffled)
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
			for (BGSQuadCircleGroupView *c in self.circles)
			{
				[c setHidden:NO];
				[c setIsAnimating:NO];
			}
			isFadingIn = NO;
			hasAnimated = YES;
		}		
	}
	[self.timer fire];
}

- (void)circlesFaded:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	isFadingIn = NO;
	hasAnimated = YES;
	for (BGSQuadCircleGroupView *c in self.circles)
		[c setIsAnimating:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[self.timer invalidate];
	self.timer = nil;
}

- (void)dealloc 
{
	[entry release];
	[circles release];
	[timer invalidate];
	[timer release];
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
			[cv split];
		}
	}
	[super touchesMoved:touches withEvent:event];
}

@end
