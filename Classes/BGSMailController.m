//
//  BGSMailController.m
//  Saturation
//
//  Created by Shawn Roske on 1/14/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSMailController.h"

@interface BGSMailController (Private)

- (NSString *)generateBodyHTML;

@end

@implementation BGSMailController

@synthesize entry;
@synthesize mailer;
@synthesize bodyHTMLTemplate;
@synthesize swatchHTMLTemplate;

- (MFMailComposeViewController *)mailer
{
	if (mailer == nil)
	{		
		MFMailComposeViewController *m = [MFMailComposeViewController new];
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
	[entry release];
	[bodyHTMLTemplate release];
	[swatchHTMLTemplate release];
	[super dealloc];
}

@end
