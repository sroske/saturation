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
- (void)setupColorRows;

@end


@implementation BGSDetailViewController

@synthesize entry;
@synthesize titleLabel;
@synthesize authorLabel;
@synthesize closeButton;
@synthesize colorStrip;

@synthesize hexheaderLabel;
@synthesize rgbHeaderLabel;
@synthesize cmykHeaderLabel;

@synthesize colorIcons;
@synthesize hexContentLabels;

@synthesize hexSeperator;

@synthesize rgbRContentLabels;
@synthesize rgbGContentLabels;
@synthesize rgbBContentLabels;

@synthesize rgbSeperator;

@synthesize cmykCContentLabels;
@synthesize cmykMContentLabels;
@synthesize cmykYContentLabels;
@synthesize cmykKContentLabels;

@synthesize favoriteButton;
@synthesize emailButton;

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
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(12.0f, 
																 -2.0f, 
																 480.0f-36.0f, 
																 66.0f)];
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
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(14.0f, 
																 50.0f, 
																 480.0f-36.0f, 
																 30.0f)];
		[lbl setFont:CF_DETAIL_AUTHOR];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:[UIColor clearColor]];
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
		[lbl setBackgroundColor:CC_BACKGROUND];
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
		[lbl setBackgroundColor:CC_BACKGROUND];
		[lbl setText:@"rgb:"];
		[self setRgbHeaderLabel:lbl];
		[lbl release];
	}
	return rgbHeaderLabel;
}

- (UILabel *)cmykHeaderLabel
{
	if (cmykHeaderLabel == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(298.0f, 
																 120.0f, 
																 100.0f, 
																 30.0f)];
		[lbl setFont:CF_DETAIL_COLOR_TYPE];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_BACKGROUND];
		[lbl setText:@"cmyk:"];
		[self setCmykHeaderLabel:lbl];
		[lbl release];
	}
	return cmykHeaderLabel;
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

- (NSMutableArray *)cmykCContentLabels
{
	if (cmykCContentLabels == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setCmykCContentLabels:a];
		[a release];
	}
	return cmykCContentLabels;
}
- (NSMutableArray *)cmykMContentLabels
{
	if (cmykMContentLabels == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setCmykMContentLabels:a];
		[a release];
	}
	return cmykMContentLabels;
}
- (NSMutableArray *)cmykYContentLabels
{
	if (cmykYContentLabels == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setCmykYContentLabels:a];
		[a release];
	}
	return cmykYContentLabels;
}
- (NSMutableArray *)cmykKContentLabels
{
	if (cmykKContentLabels == nil)
	{
		NSMutableArray *a = [[NSMutableArray alloc] init];
		[self setCmykKContentLabels:a];
		[a release];
	}
	return cmykKContentLabels;
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
	
	[self.view addSubview:self.titleLabel];
	[self.view addSubview:self.authorLabel];
	[self.view addSubview:self.closeButton];
	[self.view addSubview:self.colorStrip];
	
	[self.view addSubview:self.hexheaderLabel];
	[self.view addSubview:self.rgbHeaderLabel];
	[self.view addSubview:self.cmykHeaderLabel];
	
	[self setupColorRows];
	
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
		[lbl setBackgroundColor:CC_BACKGROUND];
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
		[lbl setBackgroundColor:CC_BACKGROUND];
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
		[lbl setBackgroundColor:CC_BACKGROUND];
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
		[lbl setBackgroundColor:CC_BACKGROUND];
		v = [[swatch objectForKey:@"swatchChannel3"] floatValue]*255;
		[lbl setText:[NSString stringWithFormat:@"%i", v]];
		[self.view addSubview:lbl];
		[self.rgbBContentLabels addObject:lbl];
		[lbl release];
		
		
		p.x = 298.0f;
		NSDictionary *cmyk = [color cmykValues];
		
		// cmyk C label
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, 
														p.y-2.0f, 
														35.0f, 
														16.0f)];
		[lbl setFont:CF_DETAIL_COLOR_DATA];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_BACKGROUND];
		v = [[cmyk objectForKey:@"c"] floatValue]*100;
		[lbl setText:[NSString stringWithFormat:@"%i", v]];
		[self.view addSubview:lbl];
		[self.cmykCContentLabels addObject:lbl];
		[lbl release];
		
		p.x += 46.0f;
		
		// cmyk M label
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, 
														p.y-2.0f, 
														35.0f, 
														16.0f)];
		[lbl setFont:CF_DETAIL_COLOR_DATA];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_BACKGROUND];
		v = [[cmyk objectForKey:@"m"] floatValue]*100;
		[lbl setText:[NSString stringWithFormat:@"%i", v]];
		[self.view addSubview:lbl];
		[self.cmykMContentLabels addObject:lbl];
		[lbl release];
		
		p.x += 46.0f;
		
		// cmyk Y label
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, 
														p.y-2.0f, 
														35.0f, 
														16.0f)];
		[lbl setFont:CF_DETAIL_COLOR_DATA];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_BACKGROUND];
		v = [[cmyk objectForKey:@"y"] floatValue]*100;
		[lbl setText:[NSString stringWithFormat:@"%i", v]];
		[self.view addSubview:lbl];
		[self.cmykYContentLabels addObject:lbl];
		[lbl release];
		
		p.x += 46.0f;
		
		// cmyk K label
		lbl = [[UILabel alloc] initWithFrame:CGRectMake(p.x, 
														p.y-2.0f, 
														35.0f, 
														16.0f)];
		[lbl setFont:CF_DETAIL_COLOR_DATA];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_BACKGROUND];
		v = [[cmyk objectForKey:@"k"] floatValue]*100;
		[lbl setText:[NSString stringWithFormat:@"%i", v]];
		[self.view addSubview:lbl];
		[self.cmykKContentLabels addObject:lbl];
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
	[entry release];
	[titleLabel release];
	[authorLabel release];
	[colorStrip release];
	
	[hexheaderLabel release];
	[rgbHeaderLabel release];
	[cmykHeaderLabel release];
	
	[colorIcons release];
	[hexContentLabels release];
	
	[hexSeperator release];
	
	[rgbRContentLabels release];
	[rgbGContentLabels release];
	[rgbBContentLabels release];
	
	[rgbSeperator release];
	
	[cmykCContentLabels release];
	[cmykMContentLabels release];
	[cmykYContentLabels release];
	[cmykKContentLabels release];
	
	[favoriteButton release];
	[emailButton release];
	
    [super dealloc];
}


@end
