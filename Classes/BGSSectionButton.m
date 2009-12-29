//
//  BGSSectionButton.m
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSSectionButton.h"


@implementation BGSSectionButton

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setBackgroundColor:CC_CLEAR];
		[self.titleLabel setFont:CF_LIST_SECTION_BUTTON];
		[self setTitleColor:CC_WHITE forState:UIControlStateSelected];
		[self setTitleColor:CC_WHITE forState:UIControlStateHighlighted];
		[self setTitleColor:CC_SECTION_BUTTON forState:UIControlStateNormal];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	// this is here getting around the odd delay caused with setTitleColor:forState:
	if (self.selected || self.highlighted)
		[self.titleLabel setTextColor:CC_WHITE];
	else
		[self.titleLabel setTextColor:CC_SECTION_BUTTON];
}

@end
