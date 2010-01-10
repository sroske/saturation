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
		color = CC_FROM_SWATCH(swatch);		
	}
	return color;
}

- (void)duplicate:(BGSSimpleSquareView *)original
{
	if (original.frame.size.width <= CUTOFF) return;

	CGSize size = CGSizeMake(original.frame.size.width/2, original.frame.size.height/2);
	CGRect rect = CGRectMake(original.frame.origin.x+size.width, 
							 original.frame.origin.y+size.height, 
							 size.width, 
							 size.height);
	CGRect firstRect = CGRectMake(rect.origin.x-size.width, 
								  rect.origin.y, 
								  rect.size.width, 
								  rect.size.height);
	CGRect secondRect = CGRectMake(rect.origin.x-size.width, 
								   rect.origin.y-size.height, 
								   rect.size.width, 
								   rect.size.height);
	CGRect thirdRect = CGRectMake(rect.origin.x, 
								  rect.origin.y-size.height, 
								  rect.size.width, 
								  rect.size.height);
	
	BGSSimpleSquareView *square4 = [[BGSSimpleSquareView alloc] initWithFrame:rect];
	[square4.layer setValue:(id)[self randomColor].CGColor forKey:@"backgroundColor"];
	[self addSubview:square4];
	
	BGSSimpleSquareView *square3 = [[BGSSimpleSquareView alloc] initWithFrame:rect];
	[square3.layer setValue:(id)[self randomColor].CGColor forKey:@"backgroundColor"];
	[self addSubview:square3];
	
	BGSSimpleSquareView *square2 = [[BGSSimpleSquareView alloc] initWithFrame:rect];
	[square2.layer setValue:(id)[self randomColor].CGColor forKey:@"backgroundColor"];
	[self addSubview:square2];
	
	BGSSimpleSquareView *square1 = [[BGSSimpleSquareView alloc] initWithFrame:rect];
	CGColorRef originalColorRef = (CGColorRef)[original.layer valueForKey:@"backgroundColor"];
	[square1.layer setValue:(id)originalColorRef forKey:@"backgroundColor"];
	[self addSubview:square1];
	
	// TODO animations
	original.animating = square1.animating = square2.animating = square3.animating = square4.animating = YES;
	
	[UIView beginAnimations:@"first" context:[[NSArray arrayWithObjects:square2, nil] retain]];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(squareMoved:finished:context:)];
	
	square2.frame = square3.frame = square4.frame = firstRect;
	
	[UIView commitAnimations];
	
	[UIView beginAnimations:@"second" context:[[NSArray arrayWithObjects:square3, nil] retain]];
	[UIView setAnimationDelay:0.25];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(squareMoved:finished:context:)];
	
	square3.frame = square4.frame = secondRect;
	
	[UIView commitAnimations];
	
	[UIView beginAnimations:@"third" context:[[NSArray arrayWithObjects:square1, square4, original, nil] retain]];
	[UIView setAnimationDelay:0.5];
	[UIView setAnimationDuration:0.25];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(squareMoved:finished:context:)];
	
	square4.frame = thirdRect;
	
	[UIView commitAnimations];
	
	[square4 release];
	[square3 release];
	[square2 release];
	[square1 release];
}

- (void)squareMoved:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	NSArray *items = (NSArray *)context;
	if (items != nil)
	{
		for (BGSSimpleSquareView *square in items)
			square.animating = NO;
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