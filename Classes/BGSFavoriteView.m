//
//  BGSFavoriteView.m
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSFavoriteView.h"


@implementation BGSFavoriteView

@synthesize background;
@synthesize unfavoritedIcon;
@synthesize favoritedIcon;
@synthesize icon;

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		// TODO
    }
    return self;
}


- (void)drawRect:(CGRect)rect 
{
    // Drawing code
}


- (void)dealloc 
{
    [super dealloc];
}


@end
