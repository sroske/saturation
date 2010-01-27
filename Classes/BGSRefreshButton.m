//
//  BGSRefreshButton.m
//  Saturation
//
//  Created by Shawn Roske on 1/9/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSRefreshButton.h"


@implementation BGSRefreshButton

@synthesize icon;
@synthesize label;

- (UIImageView *)icon
{
	if (icon == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"icon-refresh.png"];
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

- (FontLabel *)label
{
	if (label == nil)
	{
		FontLabel *lbl = [[FontLabel alloc] initWithFrame:CGRectZero fontName:CF_NORMAL pointSize:16.0f];
		[lbl setTextColor:CC_REFRESH];
		[lbl setBackgroundColor:CC_CLEAR];
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
		
		[self addSubview:self.icon];
		[self addSubview:self.label];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.icon.frame = CGRectMake(4.0f, 
								 self.bounds.size.height/2-self.icon.image.size.height/2-2.0f, 
								 self.icon.image.size.width, 
								 self.icon.image.size.height);
	self.label.frame = CGRectMake(self.icon.frame.origin.x+self.icon.frame.size.width+18.0f, 
								  self.bounds.size.height/2-10.0f, 
								  200.0f, 
								  20.0f);
}

- (void)dealloc
{
	[icon release];
	[label release];
	[super dealloc];
}

@end
