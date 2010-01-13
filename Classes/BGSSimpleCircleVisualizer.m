//
//  BGSSimpleCircleVisualizer.m
//  Saturation
//
//  Created by Shawn Roske on 1/12/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleCircleVisualizer.h"

@interface BGSSimpleCircleVisualizer (Private)

- (UIColor *)randomColor;
- (void)duplicate:(BGSSimpleCircleView *)circle1;

@end


@implementation BGSSimpleCircleVisualizer

@synthesize entry;

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData
{
    if (self = [super initWithFrame:frame]) 
	{
		isFadingIn = hasAnimated = NO;
		[self setEntry:entryData];
		
		for (int i = 0; i < ROWS*COLS; i++)
		{
			int row = i/COLS;
			int col = i%COLS;
			BGSSimpleCircleView *item = [[BGSSimpleCircleView alloc] initWithFrame:CGRectMake(col*(self.bounds.size.width/COLS), 
																							  row*(self.bounds.size.height/ROWS), 
																							  self.bounds.size.width/COLS, 
																							  self.bounds.size.height/ROWS)];
			[item.layer setValue:(id)[self randomColor].CGColor forKey:@"backgroundColor"];
			[self addSubview:item];
			[item release];
		}
    }
    return self;
}

- (void)dealloc 
{
	[entry release];
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
	if (!hasAnimated)
	{
		if (animated)
		{
			isFadingIn = YES;
			
			CGFloat delay = 0.3;
			NSArray *items = [self.subviews shuffledArray];
			for (BGSSimpleCircleView *v in items)
			{
				[v setAlpha:0.0f];
				[UIView beginAnimations:@"fade" context:nil];
				[UIView setAnimationDelay:delay];
				[UIView setAnimationDuration:0.8];
				
				if (v == [items objectAtIndex:[items count]-1])
				{
					[UIView setAnimationDelegate:self];
					[UIView setAnimationDidStopSelector:@selector(circlesFadedIn:finished:context:)];
				}
				
				[v setAlpha:1.0f];
				
				[UIView commitAnimations];
				
				delay += 0.4f;
			}		
		}
		else 
		{
			isFadingIn = NO;
			hasAnimated = YES;
		}		
	}
}

- (void)circlesFadedIn:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	isFadingIn = NO;
	hasAnimated = YES;	
}

- (void)viewWillDisappear:(BOOL)animated
{
	// nothing
}

- (UIColor *)randomColor
{
	NSArray *swatches = [self.entry objectForKey:@"swatches"];
	UIColor *color = CC_WHITE;
	if ([swatches count] > 0)
	{
		int i = arc4random()%[swatches count];
		NSDictionary *swatch = [swatches objectAtIndex:i];
		color = [UIColor colorFromHex:[swatch objectForKey:@"swatchHexColor"] alpha:1.0];
	}
	return color;
}

- (void)duplicate:(BGSSimpleCircleView *)circle1
{
	if (circle1.frame.size.width <= CUTOFF) return;
	
	CGRect original = circle1.frame;
	
	BGSSimpleCircleView *circle2 = [[BGSSimpleCircleView alloc] initWithFrame:original];
	[circle2.layer setBackgroundColor:circle1.layer.backgroundColor];
	[self addSubview:circle2];
	
	BGSSimpleCircleView *circle3 = [[BGSSimpleCircleView alloc] initWithFrame:original];
	[circle3.layer setBackgroundColor:circle1.layer.backgroundColor];
	[self addSubview:circle3];
	
	BGSSimpleCircleView *circle4 = [[BGSSimpleCircleView alloc] initWithFrame:original];
	[circle4.layer setBackgroundColor:circle1.layer.backgroundColor];
	[self addSubview:circle4];
	
	/*
	circle1.animating = circle2.animating = circle3.animating = circle4.animating = YES;
	
	[UIView beginAnimations:@"move" context:[[NSArray arrayWithObjects:circle1, circle2, circle3, circle4, nil] retain]];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveCompleted:finished:context:)];


	
	[UIView commitAnimations];
	 
	 */
	
	circle1.animating = circle2.animating = circle3.animating = circle4.animating = YES;
	
	[UIView beginAnimations:@"move" context:[[NSArray arrayWithObjects:circle1, circle2, circle3, circle4, nil] retain]];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(moveCompleted:finished:context:)];
	
	[circle1.layer setTransform:CATransform3DMakeScale(0.5f, 0.5f, 1.0)];
	[circle2.layer setTransform:CATransform3DMakeScale(0.5f, 0.5f, 1.0)];
	[circle3.layer setTransform:CATransform3DMakeScale(0.5f, 0.5f, 1.0)];
	[circle4.layer setTransform:CATransform3DMakeScale(0.5f, 0.5f, 1.0)];

	[circle1.layer setPosition:CGPointMake(original.origin.x+original.size.width/4, 
										   original.origin.y+original.size.height/4)];
	[circle2.layer setPosition:CGPointMake(original.origin.x+original.size.width/4+original.size.width/2, 
										   original.origin.y+original.size.height/4)];
	[circle3.layer setPosition:CGPointMake(original.origin.x+original.size.width/4, 
										   original.origin.y+original.size.height/4+original.size.width/2)];
	[circle4.layer setPosition:CGPointMake(original.origin.x+original.size.width/4+original.size.width/2, 
										   original.origin.y+original.size.height/4+original.size.width/2)];
	
	circle1.destinationRect = CGRectMake(original.origin.x, 
										 original.origin.y, 
										 original.size.width/2, 
										 original.size.height/2);
	
	circle2.destinationRect = CGRectMake(original.origin.x+original.size.width/2, 
										 original.origin.y, 
										 original.size.width/2, 
										 original.size.height/2);
	
	circle3.destinationRect = CGRectMake(original.origin.x, 
										 original.origin.y+original.size.height/2, 
										 original.size.width/2, 
										 original.size.height/2);
	
	circle4.destinationRect = CGRectMake(original.origin.x+original.size.width/2, 
										 original.origin.y+original.size.height/2, 
										 original.size.width/2, 
										 original.size.height/2);
	
	[circle1.layer setBackgroundColor:[self randomColor].CGColor];
	[circle2.layer setBackgroundColor:[self randomColor].CGColor];
	[circle3.layer setBackgroundColor:[self randomColor].CGColor];
	[circle4.layer setBackgroundColor:[self randomColor].CGColor];
	 
	[UIView commitAnimations];
}

- (void)moveCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	NSArray *items = (NSArray *)context;
	if (items != nil)
	{
		for (BGSSimpleCircleView *c in items)
		{
			[c.layer setTransform:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)];
			[c.layer setPosition:CGPointMake(0.0f, 0.0f)];
			c.frame = c.destinationRect;
			c.animating = NO;
		}
	}
	[items release];
}


#pragma mark -
#pragma mark Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isFadingIn) return;
	
	for (UITouch *touch in touches)
	{
		if ([[touch view] isKindOfClass:[BGSSimpleCircleView class]])
		{
			BGSSimpleCircleView *v = (BGSSimpleCircleView *)[touch view];
			if (!v.animating)
				[self duplicate:(BGSSimpleCircleView *)[touch view]];
		}		
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (isFadingIn) return;
	
	for (UITouch *touch in touches)
	{
		CGPoint point = [touch locationInView:self];
		UIView *v = [self hitTest:point withEvent:event];
		if ([v isKindOfClass:[BGSSimpleCircleView class]])
		{
			BGSSimpleCircleView *cv = (BGSSimpleCircleView *)v;
			if (!cv.animating)
				[self duplicate:cv];
		}
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	// nothing
}

@end