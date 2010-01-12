//
//  BGSSectionButton.m
//  Saturation
//
//  Created by Shawn Roske on 12/29/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSSectionButton.h"


@implementation BGSSectionButton

@synthesize label;

- (FontLabel *)label
{
	if (label == nil)
	{
		FontLabel *lbl = [[FontLabel alloc] initWithFrame:CGRectZero fontName:CF_NORMAL pointSize:18.0f];
		[lbl setTextColor:CC_SECTION_BUTTON];
		[lbl setBackgroundColor:CC_CLEAR];
		[lbl setTextAlignment:UITextAlignmentCenter];
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
		
		[self addSubview:self.label];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	if (self.selected || self.highlighted)
		[self.label setTextColor:CC_WHITE];
	else
		[self.label setTextColor:CC_SECTION_BUTTON];
	
	self.label.frame = CGRectMake(self.bounds.origin.x, 
								  self.bounds.origin.y, 
								  self.bounds.size.width, 
								  self.bounds.size.height);
}

- (void)dealloc
{
	[label release];
	[super dealloc];
}

@end
