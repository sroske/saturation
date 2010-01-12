//
//  BGSLoadingView.m
//  Saturation
//
//  Created by Shawn Roske on 12/30/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSLoadingView.h"


@implementation BGSLoadingView

@synthesize indicator;
@synthesize titleLabel;

- (UIActivityIndicatorView *)indicator
{
	if (indicator == nil)
	{
		UIActivityIndicatorView *v = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[v startAnimating];
		[self setIndicator:v];
		[v release];
	}
	return indicator;
}

- (FontLabel *)titleLabel
{
	if (titleLabel == nil)
	{
		FontLabel *lbl = [[FontLabel alloc] initWithFrame:CGRectZero fontName:CF_NORMAL pointSize:16.0f];
		[lbl setTextColor:CC_LOADING];
		[lbl setBackgroundColor:CC_CLEAR];
		[lbl setText:@"Loading..."];
		[self setTitleLabel:lbl];
		[lbl release];
	}
	return titleLabel;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		[self addSubview:self.indicator];
		[self addSubview:self.titleLabel];
    }
    return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.indicator.frame = CGRectMake(14.0f, 
									  self.bounds.size.height/2-self.indicator.frame.size.height/2, 
									  self.indicator.frame.size.width, 
									  self.indicator.frame.size.height);
	self.titleLabel.frame = CGRectMake(self.indicator.frame.origin.x+self.indicator.frame.size.width+16.0f, 
									  self.bounds.size.height/2-10.0f, 
									  240.0f, 
									  20.0f);
}

- (void)dealloc 
{
	[indicator release];
	[titleLabel release];
    [super dealloc];
}


@end
