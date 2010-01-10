//
//  BGSDetailViewController.m
//  Saturation
//
//  Created by Shawn Roske on 12/18/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSDetailViewController.h"
#import "SaturationAppDelegate.h"

@interface BGSDetailViewController (Private)

- (void)close:(id)sender;
- (void)setupColorRows;
- (void)toggleFavorite:(id)sender;
- (void)toggleVisualization:(id)sender;

@end


@implementation BGSDetailViewController

@synthesize background;

@synthesize entry;
@synthesize feed;
@synthesize titleLabel;
@synthesize authorLabel;
@synthesize closeButton;
@synthesize colorStrip;

@synthesize hexheaderLabel;
@synthesize rgbHeaderLabel;
@synthesize visualizerHeaderLabel;

@synthesize colorIcons;
@synthesize hexContentLabels;

@synthesize hexSeperator;

@synthesize rgbRContentLabels;
@synthesize rgbGContentLabels;
@synthesize rgbBContentLabels;

@synthesize rgbSeperator;

@synthesize quadCircleOption;
@synthesize simpleCircleOption;
@synthesize quadSquareOption;
@synthesize simpleSquareOption;

@synthesize favoriteButton;
@synthesize emailButton;

- (BGSKulerFeedController *)feed
{
	if (feed == nil)
	{
		BGSKulerFeedController *f = [[BGSKulerFeedController alloc] init];
		[self setFeed:f];
		[f release];
	}
	return feed;
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
	SaturationAppDelegate *ad = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	[ad hideModalView];
}

- (UILabel *)titleLabel
{
	if (titleLabel == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 
																 -2.0f, 
																 480.0f-36.0f, 
																 66.0f)];
		[lbl setFont:CF_DETAIL_TITLE];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
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
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, 
																 50.0f, 
																 480.0f-36.0f, 
																 30.0f)];
		[lbl setFont:CF_DETAIL_AUTHOR];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		[lbl setText:[NSString stringWithFormat:@"by: %@", [[self.entry objectForKey:@"authorLabel"] lowercaseString]]];
		[self setAuthorLabel:lbl];
		[lbl release];
	}
	return authorLabel;
}

- (BGSSwatchStrip *)colorStrip
{
	if (colorStrip == nil)
	{
		BGSSwatchStrip *s = [[BGSSwatchStrip alloc] initWithFrame:CGRectMake(0.0f, 
																			 92.0f, 
																			 480.0f, 
																			 10.0f) 
													  andSwatches:[self.entry objectForKey:@"swatches"]];
		[self setColorStrip:s];
		[s release];
	}
	return colorStrip;
}

- (UILabel *)hexheaderLabel
{
	if (hexheaderLabel == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, 
																 120.0f, 
																 100.0f, 
																 30.0f)];
		[lbl setFont:CF_DETAIL_COLOR_TYPE];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		[lbl setText:@"hex:"];
		[self setHexheaderLabel:lbl];
		[lbl release];
	}
	return hexheaderLabel;
}

- (UILabel *)rgbHeaderLabel
{
	if (rgbHeaderLabel == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(130.0f, 
																 120.0f, 
																 100.0f, 
																 30.0f)];
		[lbl setFont:CF_DETAIL_COLOR_TYPE];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		[lbl setText:@"rgb:"];
		[self setRgbHeaderLabel:lbl];
		[lbl release];
	}
	return rgbHeaderLabel;
}

- (UILabel *)visualizerHeaderLabel
{
	if (visualizerHeaderLabel == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(298.0f, 
																 120.0f, 
																 160.0f, 
																 30.0f)];
		[lbl setFont:CF_DETAIL_COLOR_TYPE];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		[lbl setText:@"visualizers:"];
		[self setVisualizerHeaderLabel:lbl];
		[lbl release];
	}
	return visualizerHeaderLabel;
}

- (NSMutableArray *)colorIcons
{
	if (colorIcons == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setColorIcons:a];
		[a release];
	}
	return colorIcons;
}
- (NSMutableArray *)hexContentLabels
{
	if (hexContentLabels == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setHexContentLabels:a];
		[a release];
	}
	return hexContentLabels;
}

- (BGSSwatchColor *)hexSeperator
{
	if (hexSeperator == nil)
	{
		BGSSwatchColor *c = [[BGSSwatchColor alloc] initWithFrame:CGRectMake(104.0f, 
																			 163.0f, 
																			 1.0f, 
																			 91.0f) 
														 andColor:CC_WHITE];
		[self setHexSeperator:c];
		[c release];
	}
	return hexSeperator;
}

- (NSMutableArray *)rgbRContentLabels
{
	if (rgbRContentLabels == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setRgbRContentLabels:a];
		[a release];
	}
	return rgbRContentLabels;
}
- (NSMutableArray *)rgbGContentLabels
{
	if (rgbGContentLabels == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setRgbGContentLabels:a];
		[a release];
	}
	return rgbGContentLabels;
}
- (NSMutableArray *)rgbBContentLabels
{
	if (rgbBContentLabels == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setRgbBContentLabels:a];
		[a release];
	}
	return rgbBContentLabels;
}

- (BGSSwatchColor *)rgbSeperator
{
	if (rgbSeperator == nil)
	{
		BGSSwatchColor *c = [[BGSSwatchColor alloc] initWithFrame:CGRectMake(268.0f, 
																			 163.0f, 
																			 1.0f, 
																			 91.0f) 
														 andColor:CC_WHITE];
		[self setRgbSeperator:c];
		[c release];
	}
	return rgbSeperator;
}

- (BGSVisualOptionView *)quadCircleOption
{
	if (quadCircleOption == nil)
	{
		BGSVisualOptionView *v = [[BGSVisualOptionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rgbSeperator.frame)+24.0f, 
																					   CGRectGetMinY(self.rgbSeperator.frame)-6.0f, 
																					   48.0f, 
																					   48.0f) 
																	andType:kQuadCircle];
		[v.iconButton addTarget:self action:@selector(toggleVisualization:) forControlEvents:UIControlEventTouchDown];
		SaturationAppDelegate *app = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (app.currentVisualization == kQuadCircle)
			[v setIsSelected:YES];
		[self setQuadCircleOption:v];
		[v release];
	}
	return quadCircleOption;
}

- (BGSVisualOptionView *)simpleCircleOption
{
	if (simpleCircleOption == nil)
	{
		BGSVisualOptionView *v = [[BGSVisualOptionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.rgbSeperator.frame)+24.0f, 
																					   CGRectGetMinY(self.rgbSeperator.frame)-6.0f, 
																					   48.0f, 
																					   48.0f) 
																	andType:kSimpleCircle];
		[v.iconButton addTarget:self action:@selector(toggleVisualization:) forControlEvents:UIControlEventTouchDown];
		SaturationAppDelegate *app = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (app.currentVisualization == kSimpleCircle)
			[v setIsSelected:YES];
		[self setSimpleCircleOption:v];
		[v release];
	}
	return simpleCircleOption;
}

- (BGSVisualOptionView *)quadSquareOption
{
	if (quadSquareOption == nil)
	{
		BGSVisualOptionView *v = [[BGSVisualOptionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.simpleCircleOption.frame)+4.0f, 
																					   CGRectGetMinY(self.simpleCircleOption.frame), 
																					   48.0f, 
																					   48.0f) 
																	andType:kQuadSquare];
		[v.iconButton addTarget:self action:@selector(toggleVisualization:) forControlEvents:UIControlEventTouchDown];
		SaturationAppDelegate *app = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (app.currentVisualization == kQuadSquare)
			[v setIsSelected:YES];
		[self setQuadSquareOption:v];
		[v release];
	}
	return quadSquareOption;
}

- (BGSVisualOptionView *)simpleSquareOption
{
	if (simpleSquareOption == nil)
	{
		BGSVisualOptionView *v = [[BGSVisualOptionView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.simpleCircleOption.frame)+4.0f, 
																					   CGRectGetMinY(self.simpleCircleOption.frame), 
																					   48.0f, 
																					   48.0f) 
																	andType:kSimpleSquare];
		[v.iconButton addTarget:self action:@selector(toggleVisualization:) forControlEvents:UIControlEventTouchDown];
		SaturationAppDelegate *app = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
		if (app.currentVisualization == kSimpleSquare)
			[v setIsSelected:YES];
		[self setSimpleSquareOption:v];
		[v release];
	}
	return simpleSquareOption;
}

- (void)toggleVisualization:(id)sender
{
	SaturationAppDelegate *app = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	int type = app.currentVisualization;
	
	if ([sender superview] == self.quadCircleOption && app.currentVisualization != kQuadCircle)
	{
		type = kQuadCircle;
		[self.simpleSquareOption setIsSelected:NO];
		[self.quadSquareOption setIsSelected:NO];
		[self.quadCircleOption setIsSelected:YES];
		[self.simpleCircleOption setIsSelected:NO];
	}
	else if ([sender superview] == self.simpleCircleOption && app.currentVisualization != kSimpleCircle)
	{
		type = kSimpleCircle;
		[self.simpleSquareOption setIsSelected:NO];
		[self.quadSquareOption setIsSelected:NO];
		[self.simpleCircleOption setIsSelected:YES];
		[self.quadCircleOption setIsSelected:NO];
	}
	else if ([sender superview] == self.quadSquareOption && app.currentVisualization != kQuadSquare)
	{
		type = kQuadSquare;
		[self.simpleSquareOption setIsSelected:NO];
		[self.quadSquareOption setIsSelected:YES];
		[self.simpleCircleOption setIsSelected:NO];
		[self.quadCircleOption setIsSelected:NO];
	}
	else if ([sender superview] == self.simpleSquareOption && app.currentVisualization != kSimpleSquare)
	{
		type = kSimpleSquare;
		[self.simpleSquareOption setIsSelected:YES];
		[self.quadSquareOption setIsSelected:NO];
		[self.simpleCircleOption setIsSelected:NO];
		[self.quadCircleOption setIsSelected:NO];
	}

	if (type != app.currentVisualization)
	{
		[app setCurrentVisualization:type];
		[app changeEntry:self.entry];
	}
}

- (BGSFavoriteView *)favoriteButton
{
	if (favoriteButton == nil)
	{
		BGSFavoriteView *e = [[BGSFavoriteView alloc] initWithFrame:CGRectMake(14.0f, 
																			   268.0f, 
																			   48.0f, 
																			   48.0f)];
		[e setIsFavorite:[self.feed isFavorite:self.entry]];
		[e.iconButton addTarget:self action:@selector(toggleFavorite:) forControlEvents:UIControlEventTouchDown];
		[self setFavoriteButton:e];
		[e release];
	}
	return favoriteButton;
}

- (void)toggleFavorite:(id)sender
{
	if (self.favoriteButton.isFavorite)
	{
		[self.feed removeFromFavorites:self.entry];
		[self.favoriteButton setIsFavorite:NO];
	}
	else
	{
		[self.feed addToFavorites:self.entry];
		[self.favoriteButton setIsFavorite:YES];
	}
}

- (BGSEmailCTAView *)emailButton
{
	if (emailButton == nil)
	{
		BGSEmailCTAView *e = [[BGSEmailCTAView alloc] initWithFrame:CGRectMake(70.0f, 
																			   268.0f, 
																			   401.0f, 
																			   48.0f)];
		[self setEmailButton:e];
		[e release];
	}
	return emailButton;
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
	//[v setBackgroundColor:CC_WHITE]; // for testing
	[v setAutoresizesSubviews:YES];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[v sizeToFit];
	self.view = v;
	[v release];
	
	[self.view addSubview:self.background];
	
	[self.view addSubview:self.titleLabel];
	[self.view addSubview:self.authorLabel];
	[self.view addSubview:self.closeButton];
	[self.view addSubview:self.colorStrip];
	
	[self.view addSubview:self.hexheaderLabel];
	[self.view addSubview:self.rgbHeaderLabel];
	[self.view addSubview:self.visualizerHeaderLabel];
	
	[self setupColorRows];
	
	//[self.view addSubview:self.quadCircleOption];
	[self.view addSubview:self.simpleCircleOption];
	//[self.view addSubview:self.quadSquareOption];
	[self.view addSubview:self.simpleSquareOption];
	
	[self.view addSubview:self.hexSeperator];
	[self.view addSubview:self.rgbSeperator];
	
	[self.view addSubview:self.favoriteButton];
	[self.view addSubview:self.emailButton];
}

- (void)setupColorRows
{
	CGFloat originX = 16.0f;
	CGFloat rowHeight = 20.0f;
	
	CGPoint p = CGPointMake(originX, 162.0f);
	
	NSArray *swatches = [self.entry objectForKey:@"swatches"];
	for (NSDictionary *swatch in swatches)
	{
		UIColor *color = CC_FROM_SWATCH(swatch);
		// color icon
		BGSSwatchColor *i = [[BGSSwatchColor alloc] initWithFrame:CGRectMake(p.x, 
																			 p.y+2.0f, 
																			 10.0f, 
																			 10.0f) 
														 andColor:color];
		[self.view addSubview:i];
		[self.colorIcons addObject:i];
		[i release];
		
		p.x += 16.0f;
		
		// hex label
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, 
																 p.y-1.0f, 
																 70.0f, 
																 16.0f)];
		[lbl setFont:CF_DETAIL_COLOR_DATA];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		[lbl setText:[swatch objectForKey:@"swatchHexColor"]];
		[self.view addSubview:lbl];
		[self.hexContentLabels addObject:lbl];
		[lbl release];
		
		p.x = 130.0f;
		
		// rgb R label
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, 
														p.y-2.0f, 
														35.0f, 
														16.0f)];
		[lbl setFont:CF_DETAIL_COLOR_DATA];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		int v = [[swatch objectForKey:@"swatchChannel1"] floatValue]*255;
		[lbl setText:[NSString stringWithFormat:@"%i", v]];
		[self.view addSubview:lbl];
		[self.rgbRContentLabels addObject:lbl];
		[lbl release];
		
		p.x += 46.0f;
		
		// rgb G label
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, 
														p.y-2.0f, 
														35.0f, 
														16.0f)];
		[lbl setFont:CF_DETAIL_COLOR_DATA];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		v = [[swatch objectForKey:@"swatchChannel2"] floatValue]*255;
		[lbl setText:[NSString stringWithFormat:@"%i", v]];
		[self.view addSubview:lbl];
		[self.rgbGContentLabels addObject:lbl];
		[lbl release];
		
		p.x += 46.0f;
		
		// rgb B label
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, 
														p.y-2.0f, 
														35.0f, 
														16.0f)];
		[lbl setFont:CF_DETAIL_COLOR_DATA];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		v = [[swatch objectForKey:@"swatchChannel3"] floatValue]*255;
		[lbl setText:[NSString stringWithFormat:@"%i", v]];
		[self.view addSubview:lbl];
		[self.rgbBContentLabels addObject:lbl];
		[lbl release];
		
		p.x = originX;
		p.y += rowHeight;
	}
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
	[background release];
	
	[entry release];
	[feed release];
	[titleLabel release];
	[authorLabel release];
	[colorStrip release];
	
	[hexheaderLabel release];
	[rgbHeaderLabel release];
	[visualizerHeaderLabel release];
	
	[colorIcons release];
	[hexContentLabels release];
	
	[hexSeperator release];
	
	[rgbRContentLabels release];
	[rgbGContentLabels release];
	[rgbBContentLabels release];
	
	[rgbSeperator release];

	[quadCircleOption release];
	[simpleCircleOption release];
	[quadSquareOption release];
	[simpleSquareOption release];
	
	[favoriteButton release];
	[emailButton release];
	
    [super dealloc];
}


@end
