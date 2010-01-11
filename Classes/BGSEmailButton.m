//
//  BGSEmailButton.m
//  Saturation
//
//  Created by Shawn Roske on 1/10/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSEmailButton.h"


@implementation BGSEmailButton

@synthesize background;
@synthesize icon;

- (UIImage *)background
{
	if (background == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"button-email-background.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		[self setBackground:i];
	}
	return background;
}

- (UIButton *)icon
{
	if (icon == nil)
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setShowsTouchWhenHighlighted:YES];
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"icon-email.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		[btn setImage:i forState:UIControlStateNormal];
		[btn setFrame:CGRectMake(0.0f, 
								 0.0f, 
								 i.size.width, 
								 i.size.height)];
		[self setIcon:btn];
		[btn release];
	}
	return icon;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		[self setBackgroundColor:CC_CLEAR];
		[self setBackgroundImage:self.background forState:UIControlStateNormal];
		[self setBackgroundImage:self.background forState:UIControlStateHighlighted];
		
		[self.titleLabel setFont:CF_DETAIL_EMAIL];
		[self setTitleColor:CC_WHITE forState:UIControlStateNormal];
		[self setTitle:@"email this theme" forState:UIControlStateNormal];
		
		[self addSubview:self.icon];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	[self.icon setHighlighted:self.highlighted];	
	self.icon.frame = CGRectMake(14.0f, 
								 floor(self.bounds.size.height/2-self.icon.frame.size.height/2), 
								 self.icon.frame.size.width, 
								 self.icon.frame.size.height);
	self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x-90.0f, 
									   self.titleLabel.frame.origin.y-1.0f, 
									   self.titleLabel.frame.size.width, 
									   self.titleLabel.frame.size.height);
}

- (void)dealloc 
{
	[background release];
	[icon release];
    [super dealloc];
}

@end