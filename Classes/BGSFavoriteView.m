//
//  BGSFavoriteView.m
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSFavoriteView.h"

@interface BGSFavoriteView (Private)

- (void)toggleFavorite:(id)sender;

@end


@implementation BGSFavoriteView

@synthesize background;
@synthesize unfavoritedIcon;
@synthesize favoritedIcon;
@synthesize icon;

- (UIImageView *)background
{
	if (background == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"button-favorite-background.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 
																		0.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setBackground:iv];
		[iv release];
	}
	return background;
}

- (UIImage *)unfavoritedIcon
{
	if (unfavoritedIcon == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"icon-favorite-unselected.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		[self setUnfavoritedIcon:i];
	}
	return unfavoritedIcon;
}
- (UIImage *)favoritedIcon
{
	if (favoritedIcon == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"icon-favorite-selected.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		[self setFavoritedIcon:i];
	}
	return favoritedIcon;
}

/*
- (UIImageView *)icon
{
	if (icon == nil)
	{

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
 */

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		[self addSubview:self.background];
		[self addSubview:self.icon];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)dealloc 
{
    [super dealloc];
}


@end
