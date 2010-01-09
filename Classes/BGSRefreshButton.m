//
//  BGSRefreshButton.m
//  Saturation
//
//  Created by Shawn Roske on 1/9/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSRefreshButton.h"


@implementation BGSRefreshButton

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self setBackgroundColor:CC_CLEAR];
		[self.titleLabel setFont:CF_LIST_REFRESH_BUTTON];
		[self setTitleColor:CC_REFRESH forState:UIControlStateNormal];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	/*
	// this is here getting around the odd delay caused with setTitleColor:forState:
	if (self.selected || self.highlighted)
		[self.titleLabel setTextColor:CC_WHITE];
	else
		[self.titleLabel setTextColor:CC_SECTION_BUTTON];
	 */
}

@end
