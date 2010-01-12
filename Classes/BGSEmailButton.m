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
@synthesize label;

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

- (FontLabel *)label
{
	if (label == nil)
	{
		FontLabel *lbl = [[FontLabel alloc] initWithFrame:CGRectZero fontName:CF_NORMAL pointSize:16.0f];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		[lbl setText:@"email this theme"];
		[self setLabel:lbl];
		[lbl release];
	}
	return label;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		[self setBackgroundColor:CC_CLEAR];
		[self setBackgroundImage:self.background forState:UIControlStateNormal];
		[self setBackgroundImage:self.background forState:UIControlStateHighlighted];

		[self addSubview:self.label];
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
	self.label.frame = CGRectMake(self.icon.frame.origin.x+self.icon.frame.size.width+6.0f, 
								  self.bounds.size.height/2-10.0f, 
								  260.0f, 
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