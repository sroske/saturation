//
//  BGSMainViewController.m
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSMainViewController.h"


@interface BGSMainViewController (Private)

//- (void)randomKulerProfile;
//- (UIColor *)colorForHex:(NSString *)hexColor;

@end


@implementation BGSMainViewController

@synthesize colors;

- (NSArray *)colors
{
	if (colors == nil)
	{
		NSArray *array = [NSArray arrayWithObjects:[UIColor colorWithRed:247.0f/255.0f green:197.0f/255.0f blue:92.0f/255.0f alpha:1.0f], 
						  [UIColor colorWithRed:255.0f/255.0f green:169.0f/255.0f blue:35.0f/255.0f alpha:1.0f], 
						  [UIColor colorWithRed:218.0f/255.0f green:123.0f/255.0f blue:37.0f/255.0f alpha:1.0f],
						  [UIColor colorWithRed:149.0f/255.0f green:89.0f/255.0f blue:64.0f/255.0f alpha:1.0f], nil];
		[self setColors:array];
	}
	return colors;
}

- (UIColor *)randomColor
{
	int i = arc4random()%[self.colors count];
	return [self.colors objectAtIndex:i];
}


- (void)loadView 
{
	//[self randomKulerProfile];
	
	CGRect frame = [[UIScreen mainScreen] bounds];
	
	UIView *newView = [[UIView alloc] initWithFrame:frame];
	[newView setAutoresizesSubviews:YES];
	[newView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[newView sizeToFit];
	[newView setBackgroundColor:[UIColor colorWithRed:17.0f/255.0f green:23.0f/255.0f blue:23.0f/255.0f alpha:1.0f]];
	self.view = newView;
	[newView release];
	
	for (int i = 0; i < ROWS*COLS; i++)
	{
		int row = i/COLS;
		int col = i%COLS;
		BGSCircleView *circle = [[BGSCircleView alloc] initWithFrame:CGRectMake(col*(frame.size.width/COLS), 
																		  row*(frame.size.height/ROWS), 
																		  frame.size.width/COLS, 
																		  frame.size.height/ROWS)];
		[circle setColor:[self randomColor]];
		[self.view addSubview:circle];
		[circle release];
	}
	
	
	BGSKulerParser *parser = [[BGSKulerParser alloc] init];
	NSArray *entries = [parser fetchEntriesFromURL:@"http://kuler-api.adobe.com/feeds/rss/get.cfm?timeSpan=30&listType=rating"];
	NSLog(@"entries: %@", entries);
	[parser release];
}

- (void)dealloc 
{
	[colors release];
    [super dealloc];
}

- (void)dupeCircle:(BGSCircleView *)circle1
{
	CGRect smallerRect = CGRectMake(circle1.frame.origin.x+PADDING, 
									circle1.frame.origin.y+PADDING, 
									circle1.frame.size.width-PADDING*2, 
									circle1.frame.size.height-PADDING*2);
	[circle1 setNewColor:[self randomColor]];
	BGSCircleView *circle2 = [[BGSCircleView alloc] initWithFrame:smallerRect];
	[circle2 setColor:circle1.color];
	[circle2 setNewColor:[self randomColor]];
	[self.view addSubview:circle2];
	
	BGSCircleView *circle3 = [[BGSCircleView alloc] initWithFrame:smallerRect];
	[circle3 setColor:circle1.color];
	[circle3 setNewColor:[self randomColor]];
	[self.view addSubview:circle3];
	
	BGSCircleView *circle4 = [[BGSCircleView alloc] initWithFrame:smallerRect];
	[circle4 setColor:circle1.color];
	[circle4 setNewColor:[self randomColor]];
	[self.view addSubview:circle4];
	
	CGRect original = circle1.frame;
	
	circle1.animating = circle2.animating = circle3.animating = circle4.animating = YES;
	
	[UIView beginAnimations:@"shrink" context:[[NSArray arrayWithObjects:circle1, circle2, circle3, circle4, nil] retain]];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(shrinkComplete:finished:context:)];
    [UIView setAnimationDuration:1.0f];
    
	[circle1 setFrame:CGRectMake(original.origin.x, 
								 original.origin.y, 
								 original.size.width/2, 
								 original.size.height/2)];
	[circle2 setFrame:CGRectMake(original.origin.x+original.size.width/2, 
								 original.origin.y, 
								 original.size.width/2, 
								 original.size.height/2)];
	[circle3 setFrame:CGRectMake(original.origin.x, 
								 original.origin.y+original.size.height/2, 
								 original.size.width/2, 
								 original.size.height/2)];
	[circle4 setFrame:CGRectMake(original.origin.x+original.size.width/2, 
								 original.origin.y+original.size.height/2, 
								 original.size.width/2, 
								 original.size.height/2)];
    
    [UIView commitAnimations];
}

- (void)shrinkComplete:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	NSArray *circles = (NSArray *)context;
	for (BGSCircleView *circle in circles)
	{
		[circle setColor:circle.newColor];
		circle.animating = NO;
	}
	[circles release];
}

#pragma mark Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		if ([[touch view] isKindOfClass:[BGSCircleView class]])
		{
			BGSCircleView *v = (BGSCircleView *)[touch view];
			if (!v.animating)
				[self dupeCircle:(BGSCircleView *)[touch view]];
		}		
	}
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
	{
		CGPoint point = [touch locationInView:self.view];
		UIView *v = [self.view hitTest:point withEvent:event];
		if ([v isKindOfClass:[BGSCircleView class]])
		{
			BGSCircleView *cv = (BGSCircleView *)v;
			if (!cv.animating)
				[self dupeCircle:cv];
		}		
	}
}

@end
