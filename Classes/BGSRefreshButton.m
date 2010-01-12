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
								 self.bounds.size.height/2-self.icon.image.size.height/2, 
								 self.icon.image.size.width, 
								 self.icon.image.size.height);
	self.label.frame = CGRectMake(self.titleLabel.frame.origin.x, 
								  self.titleLabel.frame.origin.y, 
								  self.titleLabel.frame.size.width, 
								  self.titleLabel.frame.size.height);
}

- (void)dealloc
{
	[icon release];
	[label release];
	[super dealloc];
}

@end
