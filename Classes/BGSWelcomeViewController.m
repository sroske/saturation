//
//  BGSWelcomeViewController.m
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSWelcomeViewController.h"
#import "SaturationAppDelegate.h"

@interface BGSWelcomeViewController (Private)

- (void)introCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context;

@end


@implementation BGSWelcomeViewController

@synthesize background;
@synthesize shadow;
@synthesize logo;
@synthesize kulerLogo;
@synthesize light;

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


- (UIImageView *)shadow
{
	if (shadow == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logo-shadow.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(41.0f, 
																		128.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setShadow:iv];
		[iv release];
	}
	return shadow;
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

- (UIImageView *)light
{
	if (light == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"logo-background.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 
																		0.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setLight:iv];
		[iv release];
	}
	return light;
}

- (void)loadView 
{	
	CGRect frame = [[UIScreen mainScreen] bounds];
	
	UIView *v = [[UIView alloc] initWithFrame:frame];
	[v setTransform:CGAffineTransformMakeRotation(M_PI/2)];
	[v setBounds:CGRectMake(0.0f, 0.0f, frame.size.height, frame.size.width)];
	[v setBackgroundColor:CC_CLEAR];
	[v setAutoresizesSubviews:YES];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[v sizeToFit];
	self.view = v;
	[v release];
	
	[self.view addSubview:self.background];
	[self.view addSubview:self.light];
	[self.view addSubview:self.shadow];
	[self.view addSubview:self.logo];
	[self.view addSubview:self.kulerLogo];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelay:0.5];
	[UIView setAnimationDuration:0.5];
	
	[self.shadow setFrame:CGRectMake(self.shadow.frame.origin.x, 
									 self.shadow.frame.origin.y+6.0f, 
									 self.shadow.frame.size.width, 
									 self.shadow.frame.size.height)];
	
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationDelay:0.5];
	[UIView setAnimationDuration:0.8];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(introCompleted:finished:context:)];
	
	[self.light setAlpha:0.0f];
	
	[UIView commitAnimations];

	[super viewWillAppear:animated];
}

- (void)introCompleted:(NSString *)animationID finished:(NSNumber *)finished context:(NSObject *)context
{
	SaturationAppDelegate *d = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	[d showMainView];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	[background release];
	[shadow release];
	[logo release];
	[light release];
    [super dealloc];
}


@end
