//
//  BGSRefreshView.m
//  Saturation
//
//  Created by Shawn Roske on 1/9/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import "BGSRefreshView.h"


@implementation BGSRefreshView

@synthesize refreshButton;

- (BGSRefreshButton *)refreshButton;
{
	if (refreshButton == nil)
	{
		BGSRefreshButton *b = [[BGSRefreshButton alloc] initWithFrame:CGRectZero];
		[b.label setText:@"refresh themes"];
		[self setRefreshButton:b];
		[b release];
	}
	return refreshButton;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		[self addSubview:self.refreshButton];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	self.refreshButton.frame = CGRectMake(14.0f, 
										  self.bounds.size.height/2-10.0f, 
										  180.0f, 
										  20.0f);
}

- (void)dealloc 
{
	[refreshButton release];
    [super dealloc];
}


@end
