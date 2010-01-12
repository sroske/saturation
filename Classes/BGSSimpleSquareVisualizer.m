//
//  BGSSimpleSquareVisualizer.m
//  Saturation
//
//  Created by Shawn Roske on 1/10/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSSimpleSquareVisualizer.h"

@interface BGSSimpleSquareVisualizer (Private)

- (UIColor *)randomColor;
- (void)duplicate:(BGSSimpleSquareView *)original;

@end


@implementation BGSSimpleSquareVisualizer

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
			BGSSimpleSquareView *item = [[BGSSimpleSquareView alloc] initWithFrame:CGRectMake(col*(self.bounds.size.width/COLS), 
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
			for (BGSSimpleSquareView *v in items)
			{
				CGRect original = v.frame;
				
				CGSize size = original.size;
				CGPoint position = original.origin;
				
				if (position.y >= self.bounds.size.height/ROWS)
					position.y += size.height;
				else
					position.y -= size.height;

				if (arc4random()%100 > 50)
				{
					if (position.x < self.bounds.size.width/COLS)
					{
						position.x -= size.width;
						position.y = v.frame.origin.y;
					}
					else if (position.x >= self.bounds.size.width-self.bounds.size.width/COLS)
					{
						position.x += size.width;
						position.y = v.frame.origin.y;
					}
				}
				v.frame = CGRectMake(position.x, position.y, size.width, size.height);
				
				[UIView beginAnimations:@"drop" context:nil];
				[UIView setAnimationDelay:delay];
				[UIView setAnimationDuration:0.8];

				if (v == [items objectAtIndex:[items count]-1])
				{
					[UIView setAnimationDelegate:self];
					[UIView setAnimationDidStopSelector:@selector(squaresDroppedIn:finished:context:)];
				}
				
				v.frame = original;
				
				[UIView commitAnimations];
				
				delay += 0.4f;
			}		
		}
		else 
		{
			for (BGSSimpleSquareView *v in self.subviews)
				[v setHidden:NO];
			isFadingIn = NO;
			hasAnimated = YES;
		}		
	}
}

- (void)squaresDroppedIn:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
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

- (void)duplicate:(BGSSimpleSquareView *)original
{
	if (original.frame.size.width <= CUTOFF) return;

	CGRect rect = CGRectMake(original.frame.origin.x+original.frame.size.width/2, 
							 original.frame.origin.y+original.frame.size.height/2, 
							 original.frame.size.width/2, 
							 original.frame.size.height/2);
	
	BGSSimpleSquareView *square2 = [[BGSSimpleSquareView alloc] initWithFrame:rect];
	[square2.layer setValue:(id)[self randomColor].CGColor forKey:@"backgroundColor"];
	[self addSubview:square2];
	
	BGSSimpleSquareView *square1 = [[BGSSimpleSquareView alloc] initWithFrame:rect];
	CGColorRef originalColorRef = (CGColorRef)[original.layer valueForKey:@"backgroundColor"];
	[square1.layer setValue:(id)originalColorRef forKey:@"backgroundColor"];
	[self addSubview:square1];

	original.animating = square1.animating = square2.animating = YES;
	
	[UIView beginAnimations:@"square2" context:[[NSArray arrayWithObjects:original, square1, square2, nil] retain]];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(square2Moved:finished:context:)];
	
	square2.frame = CGRectMake(rect.origin.x-rect.size.width, 
							   rect.origin.y, 
							   rect.size.width, 
							   rect.size.height);;
	
	[UIView commitAnimations];
	
	[square2 release];
	[square1 release];
}

- (void)square2Moved:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	NSArray *items = (NSArray *)context;
	if (items != nil)
	{
		BGSSimpleSquareView *last = [items lastObject];	
		
		BGSSimpleSquareView *square = [[BGSSimpleSquareView alloc] initWithFrame:last.frame];
		[square.layer setValue:(id)[self randomColor].CGColor forKey:@"backgroundColor"];
		[self insertSubview:square belowSubview:last];
		
		square.animating = YES;
		
		[UIView beginAnimations:@"square3" context:[[items arrayByAddingObject:square] retain]];
		[UIView setAnimationDuration:0.25];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(square3Moved:finished:context:)];
		
		square.frame = CGRectMake(last.frame.origin.x, 
								  last.frame.origin.y-last.frame.size.height, 
								  last.frame.size.width, 
								  last.frame.size.height);
		
		[UIView commitAnimations];
		
		[square release];
		
	}
	[items release];
}

- (void)square3Moved:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	NSArray *items = (NSArray *)context;
	if (items != nil)
	{
		BGSSimpleSquareView *last = [items lastObject];	
		
		BGSSimpleSquareView *square = [[BGSSimpleSquareView alloc] initWithFrame:last.frame];
		[square.layer setValue:(id)[self randomColor].CGColor forKey:@"backgroundColor"];
		[self insertSubview:square belowSubview:last];
		
		square.animating = YES;
		
		[UIView beginAnimations:@"square4" context:[[items arrayByAddingObject:square] retain]];
		[UIView setAnimationDuration:0.25];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(square4Moved:finished:context:)];
		
		square.frame = CGRectMake(last.frame.origin.x+last.frame.size.width, 
								  last.frame.origin.y, 
								  last.frame.size.width, 
								  last.frame.size.height);
		
		[UIView commitAnimations];
		
		[square release];
		
	}
	[items release];
}

- (void)square4Moved:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	NSArray *items = (NSArray *)context;
	if (items != nil)
	{	
		for (BGSSimpleSquareView *v in items)
			v.animating = NO;
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
		if ([[touch view] isKindOfClass:[BGSSimpleSquareView class]])
		{
			BGSSimpleSquareView *v = (BGSSimpleSquareView *)[touch view];
			if (!v.animating)
				[self duplicate:(BGSSimpleSquareView *)[touch view]];
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
		if ([v isKindOfClass:[BGSSimpleSquareView class]])
		{
			BGSSimpleSquareView *cv = (BGSSimpleSquareView *)v;
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