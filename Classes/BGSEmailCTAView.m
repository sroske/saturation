//
//  BGSEmailCTAView.m
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSEmailCTAView.h"


@implementation BGSEmailCTAView

@synthesize background;
@synthesize icon;
@synthesize label;

- (UIImageView *)background
{
	if (background == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"button-email-background.png"];
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

- (UIImageView *)icon
{
	if (icon == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"icon-email.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 
																		0.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setIcon:iv];
		[iv release];
	}
	return icon;
}

- (UILabel *)label
{
	if (label == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
		[lbl setFont:CF_DETAIL_EMAIL];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:[UIColor clearColor]];
		[lbl setText:@"email this color theme"];
		[self setLabel:lbl];
		[lbl release];
	}
	return label;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		[self addSubview:self.background];
		[self addSubview:self.label];
		[self addSubview:self.icon];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.icon.frame = CGRectMake(14.0f, 
								 self.bounds.size.height/2-self.icon.image.size.height/2, 
								 self.icon.image.size.width, 
								 self.icon.image.size.height);
	self.label.frame = CGRectMake(self.icon.frame.origin.x+self.icon.frame.size.width+4.0f, 
								  self.bounds.size.height/2-10.0f, 
								  300.0f, 
								  20.0f);
}

- (void)dealloc 
{
	[background release];
	[icon release];
	[label release];
    [super dealloc];
}


@end
