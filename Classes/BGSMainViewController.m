//
//  BGSMainViewController.m
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSMainViewController.h"


@interface BGSMainViewController (Private)

- (UIColor *)randomColor;
- (void)showSettings:(id)sender;
- (void)showDetailView:(id)sender;

@end


@implementation BGSMainViewController

@synthesize circleView;
@synthesize entry;
@synthesize settingsButton;
@synthesize infoButton;

- (UIView *)circleView
{
	if (circleView == nil)
	{
		UIView *v = [[UIView alloc] initWithFrame:self.view.bounds];
		[v setAutoresizesSubviews:YES];
		[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
		[v sizeToFit];
		[self setCircleView:v];
		[v release];
	}
	return circleView;
}

- (UIButton *)settingsButton
{
	if (settingsButton == nil)
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setShowsTouchWhenHighlighted:YES];
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"button-gear.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		[btn setImage:i forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(showSettings:) forControlEvents:UIControlEventTouchUpInside];
		[btn setFrame:CGRectMake(10.0f, 
								 self.view.bounds.size.height-i.size.height-10.0f, 
								 i.size.width, 
								 i.size.height)];
		[self setSettingsButton:btn];
		[btn release];
	}
	return settingsButton;
}

- (void)showSettings:(id)sender
{
	NSLog(@"show settings");
}

- (UIButton *)infoButton
{
	if (infoButton == nil)
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setShowsTouchWhenHighlighted:YES];
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"button-info.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		[btn setImage:i forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];
		[btn setFrame:CGRectMake(self.view.bounds.size.width-i.size.width-10.0f, 
								 self.view.bounds.size.height-i.size.height-10.0f, 
								 i.size.width, 
								 i.size.height)];
		[self setInfoButton:btn];
		[btn release];
	}
	return infoButton;
}

- (void)showDetailView:(id)sender
{
	BGSDetailViewController *controller = [[BGSDetailViewController alloc] initWithEntry:self.entry];
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (id)initWithEntry:(NSDictionary *)entryData
{
	if (self = [super init])
	{
		[self setEntry:entryData];
		NSLog(@"themeTitle: %@", [self.entry objectForKey:@"themeTitle"]);
	}
	return self;
}

- (void)loadView 
{	
	CGRect frame = CGRectMake(0.0f, 0.0f, 480.0f, 320.0f);
	
	UIView *v = [[UIView alloc] initWithFrame:frame];
	[v setBackgroundColor:CC_BACKGROUND];
	[v setAutoresizesSubviews:YES];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[v sizeToFit];
	self.view = v;
	[v release];
	
	[self.view addSubview:self.circleView];
	[self.view addSubview:self.settingsButton];
	[self.view addSubview:self.infoButton];
	
	for (int i = 0; i < ROWS*COLS; i++)
	{
		int row = i/COLS;
		int col = i%COLS;
		BGSCircleView *circle = [[BGSCircleView alloc] initWithFrame:CGRectMake(col*(frame.size.width/COLS), 
																				row*(frame.size.height/ROWS), 
																				frame.size.width/COLS, 
																				frame.size.height/ROWS)];
		[circle setColor:[self randomColor]];
		[self.circleView addSubview:circle];
		[circle release];
	}
}

- (void)viewWillAppear:(BOOL)animated 
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
	[circleView release];
	[entry release];
    [super dealloc];
}

- (UIColor *)randomColor
{
	NSArray *swatches = [self.entry objectForKey:@"swatches"];
	int i = arc4random()%[swatches count];
	NSDictionary *swatch = [swatches objectAtIndex:i];
	return CC_FROM_SWATCH(swatch);
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
	[self.circleView addSubview:circle2];
	
	BGSCircleView *circle3 = [[BGSCircleView alloc] initWithFrame:smallerRect];
	[circle3 setColor:circle1.color];
	[circle3 setNewColor:[self randomColor]];
	[self.circleView addSubview:circle3];
	
	BGSCircleView *circle4 = [[BGSCircleView alloc] initWithFrame:smallerRect];
	[circle4 setColor:circle1.color];
	[circle4 setNewColor:[self randomColor]];
	[self.circleView addSubview:circle4];
	
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
	[super touchesBegan:touches withEvent:event];
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
	[super touchesMoved:touches withEvent:event];
}

@end
