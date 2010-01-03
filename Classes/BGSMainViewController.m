//
//  BGSMainViewController.m
//  Saturation
//
//  Created by Shawn Roske on 12/15/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSMainViewController.h"
#import "SaturationAppDelegate.h"

@interface BGSMainViewController (Private)

- (void)showSettings:(id)sender;
- (void)showDetailView:(id)sender;

- (void)logoFaded:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context;

@end


@implementation BGSMainViewController

@synthesize entry;
@synthesize background;
@synthesize logo;
@synthesize kulerLogo;
@synthesize settingsButton;
@synthesize infoButton;

@synthesize visualizer;

- (void)setEntry:(NSDictionary *)newEntry
{
	if (newEntry != entry)
	{
		[entry release];
		entry = [newEntry retain];
	}
	
	[self.visualizer removeFromSuperview];
	self.visualizer = nil;
	[self.view insertSubview:self.visualizer atIndex:1];
}

- (UIImageView *)logo
{
	if (logo == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logo-saturation.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(46.0f, 
																		137.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setLogo:iv];
		[iv release];
	}
	return logo;
}

- (UIImageView *)kulerLogo
{
	if (kulerLogo == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logo-kuler.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(293.0f, 
																		140.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setKulerLogo:iv];
		[iv release];
	}
	return kulerLogo;
}

- (UIImageView *)background
{
	if (background == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 
																		0.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setBackground:iv];
		[iv release];
	}
	return background;
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

- (BGSCircleVisualizer *)visualizer
{
	if (visualizer == nil)
	{
		BGSCircleVisualizer *v = [[BGSCircleVisualizer alloc] initWithFrame:self.view.bounds andEntry:self.entry];
		[self setVisualizer:v];
		[v release];
	}
	return visualizer;
}

- (void)showSettings:(id)sender
{
	SaturationAppDelegate *ad = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	[ad showListView];
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
	SaturationAppDelegate *ad = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	[ad showDetailFor:self.entry];
}

- (id)initWithEntry:(NSDictionary *)entryData
{
	if (self = [super init])
	{
		hasAnimated = NO;
		entry = [entryData retain];
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
	
	[self.view addSubview:self.background];
	[self.view addSubview:self.visualizer];
	[self.view addSubview:self.logo];
	[self.view addSubview:self.kulerLogo];
	[self.view addSubview:self.settingsButton];
	[self.view addSubview:self.infoButton];
}

- (void)viewWillAppear:(BOOL)animated 
{
	NSLog(@"viewWillAppear: %i", animated);
	if (!hasAnimated)
	{
		[visualizer viewWillAppear:YES];
		
		[UIView beginAnimations:@"kulerLogoFade" context:self.kulerLogo];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelay:0.4];
		[UIView setAnimationDuration:0.6];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(logoFaded:finished:context:)];
		
		[self.kulerLogo setAlpha:0.0f];
		
		[UIView commitAnimations];
		
		[UIView beginAnimations:@"logoFade" context:self.logo];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDelay:1.0];
		[UIView setAnimationDuration:0.6];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(logoFaded:finished:context:)];
		
		[self.logo setAlpha:0.0f];
		
		[UIView commitAnimations];
		
		hasAnimated = YES;
	}
	else 
	{
		[visualizer viewWillAppear:animated];
	}

	
	[self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewWillAppear:animated];
}


- (void)logoFaded:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	UIView *v = (UIView *)context;
	[v removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc 
{
	[entry release];
	[background release];
	[logo release];
	[kulerLogo release];
	[visualizer release];
    [super dealloc];
}


@end
