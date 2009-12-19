//
//  BGSDetailViewController.m
//  Saturation
//
//  Created by Shawn Roske on 12/18/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSDetailViewController.h"

@interface BGSDetailViewController (Private)

- (void)close:(id)sender;

@end


@implementation BGSDetailViewController

@synthesize entry;
@synthesize titleLabel;
@synthesize authorLabel;
@synthesize closeButton;

- (UIButton *)closeButton
{
	if (closeButton == nil)
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setShowsTouchWhenHighlighted:YES];
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"button-close.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		[btn setImage:i forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
		[btn setFrame:CGRectMake(self.view.bounds.size.width-i.size.width-10.0f, 
								 10.0f, 
								 i.size.width, 
								 i.size.height)];
		[self setCloseButton:btn];
		[btn release];
	}
	return closeButton;
}

- (void)close:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (UILabel *)titleLabel
{
	if (titleLabel == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 
																 18.0f, 
																 480.0f-36.0f, 
																 60.0f)];
		[lbl setFont:CF_DETAIL_TITLE];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_BACKGROUND];
		[lbl setText:[[self.entry objectForKey:@"themeTitle"] lowercaseString]];
		[self setTitleLabel:lbl];
		[lbl release];
	}
	return titleLabel;
}

- (UILabel *)authorLabel
{
	if (authorLabel == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(18.0f, 
																 70.0f, 
																 480.0f-36.0f, 
																 30.0f)];
		[lbl setFont:CF_DETAIL_AUTHOR];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_BACKGROUND];
		[lbl setText:[NSString stringWithFormat:@"by: %@", [[self.entry objectForKey:@"authorLabel"] lowercaseString]]];
		[self setAuthorLabel:lbl];
		[lbl release];
	}
	return authorLabel;
}

- (id)initWithEntry:(NSDictionary *)entryData
{
	if (self = [super init])
	{
		[self setEntry:entryData];
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
	
	[self.view addSubview:self.titleLabel];
	[self.view addSubview:self.authorLabel];
	[self.view addSubview:self.closeButton];
}


- (void)viewWillAppear:(BOOL)animated 
{
	[self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
	[entry release];
	[titleLabel release];
	[authorLabel release];
    [super dealloc];
}


@end
