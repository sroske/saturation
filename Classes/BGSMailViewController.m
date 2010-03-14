//
//  BGSMailViewController.m
//  Saturation
//
//  Created by Shawn Roske on 1/22/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSMailViewController.h"
#import "SaturationAppDelegate.h"


@interface BGSMailViewController (Private)

- (NSString *)generateBodyHTML;
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;

@end

@implementation BGSMailViewController

@synthesize background;
@synthesize entry;
@synthesize mailer;
@synthesize bodyHTMLTemplate;
@synthesize swatchHTMLTemplate;

- (UIImageView *)background
{
	if (background == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"background-solid.png"];
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

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

- (void)loadView 
{
	CGRect frame = [[UIScreen mainScreen] bounds];
	
	UIView *v = [[UIView alloc] initWithFrame:frame];
	[v setTransform:CGAffineTransformMakeRotation(M_PI/2)];
	[v setBounds:CGRectMake(0.0f, 0.0f, frame.size.height, frame.size.width)];
	[v setAutoresizesSubviews:YES];
	[v setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
	[v sizeToFit];
	self.view = v;
	[v release];
	
	[self.view addSubview:self.background];
	[self.view addSubview:self.mailer.view];
	[self.mailer.view setFrame:self.view.bounds];
	//[self presentModalViewController:self.mailer animated:NO];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (id)initWithEntry:(NSDictionary *)entryData
{
	if (self = [super init])
	{
		self.entry = entryData;
	}
	return self;
}

- (void)dealloc
{
	[background release];
	[entry release];
	[mailer release];
	[bodyHTMLTemplate release];
	[swatchHTMLTemplate release];
	[super dealloc];
}

- (MFMailComposeViewController *)mailer
{
	if (mailer == nil)
	{		
		MFMailComposeViewController *m = [MFMailComposeViewController new];
		[m setMailComposeDelegate:self];
		[[m navigationBar] setTintColor:CC_BLACK];
		
		[m setSubject:[NSString stringWithFormat:@"[saturation] \"%@\" by %@", 
					   [[self.entry objectForKey:@"themeTitle"] lowercaseString], 
					   [[self.entry objectForKey:@"authorLabel"] lowercaseString], nil]];
		[m setMessageBody:[self generateBodyHTML] isHTML:YES];
		
		[self setMailer:m];
		[m release];
	}
	return mailer;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	if (result == MFMailComposeResultFailed)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:[error localizedDescription] 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else 
	{
		NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[self.entry objectForKey:@"themeID"], @"ThemeID", nil];
		[FlurryAPI logEvent:@"SentEmail" withParameters:dictionary];
	}


	SaturationAppDelegate *app = (SaturationAppDelegate *)[[UIApplication sharedApplication] delegate];
	[app closeEmailView];
}

- (NSString *)bodyHTMLTemplate
{
	if (bodyHTMLTemplate == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"email.html"];
		NSString *t = [[NSString alloc] initWithContentsOfFile:p];
		[self setBodyHTMLTemplate:t];
		[t release];
	}
	return bodyHTMLTemplate;
}

- (NSString *)swatchHTMLTemplate
{
	if (swatchHTMLTemplate == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"swatch.html"];
		NSString *t = [[NSString alloc] initWithContentsOfFile:p];
		[self setSwatchHTMLTemplate:t];
		[t release];
	}
	return swatchHTMLTemplate;
}

- (NSString *)generateBodyHTML
{
	NSMutableString *body = [self.bodyHTMLTemplate mutableCopy];
	for (NSString *key in self.entry)
	{
		NSString *formattedKey = [NSString stringWithFormat:@"{{%@}}", key];
		NSString *value = [self.entry objectForKey:key];
		[body replaceOccurrencesOfString:formattedKey 
							  withString:value 
								 options:NSCaseInsensitiveSearch 
								   range:NSMakeRange(0, [body length])];
	}
	
	NSString *swatchHTML = @"";
	NSArray *swatches = [self.entry objectForKey:@"swatches"];
	for (int i = 0; i < [swatches count]; i++)
	{
		NSDictionary *swatch = [swatches objectAtIndex:i];
		
		NSMutableString *swatchEntry = [self.swatchHTMLTemplate mutableCopy];
		
		[swatchEntry replaceOccurrencesOfString:@"{{colorNumber}}" 
									 withString:[NSString stringWithFormat:@"%i", i+1] 
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		[swatchEntry replaceOccurrencesOfString:@"{{swatchHexColor}}" 
									 withString:[swatch objectForKey:@"swatchHexColor"]
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		
		UIColor *color = [UIColor colorFromHex:[swatch objectForKey:@"swatchHexColor"] alpha:1.0];
		const CGFloat *components = CGColorGetComponents(color.CGColor);
		int red = components[0]*255;
		int green = components[1]*255;
		int blue = components[1]*255;
		[swatchEntry replaceOccurrencesOfString:@"{{swatchRedValue}}" 
									 withString:[NSString stringWithFormat:@"%i", red] 
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		[swatchEntry replaceOccurrencesOfString:@"{{swatchGreenValue}}" 
									 withString:[NSString stringWithFormat:@"%i", green] 
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		[swatchEntry replaceOccurrencesOfString:@"{{swatchBlueValue}}" 
									 withString:[NSString stringWithFormat:@"%i", blue] 
										options:NSCaseInsensitiveSearch 
										  range:NSMakeRange(0, [swatchEntry length])];
		
		swatchHTML = [swatchHTML stringByAppendingString:swatchEntry];
		
		[swatchEntry release];
	}
	
	[body replaceOccurrencesOfString:@"{{swatchHTML}}" 
						  withString:swatchHTML 
							 options:NSCaseInsensitiveSearch 
							   range:NSMakeRange(0, [body length])];
	
	return [body autorelease];
}

- (BOOL)canSendMail
{
	if (![MFMailComposeViewController canSendMail])
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" 
														message:@"Mail not configured." 
													   delegate:nil 
											  cancelButtonTitle:@"OK" 
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		return NO;
	}
	return YES;
}

@end
