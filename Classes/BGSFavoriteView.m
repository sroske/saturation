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
@synthesize iconButton;

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

- (UIButton *)iconButton
{
	if (iconButton == nil)
	{
		UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
		[btn setShowsTouchWhenHighlighted:YES];
		[btn setImage:self.unfavoritedIcon forState:UIControlStateNormal];
		[btn addTarget:self action:@selector(toggleFavorite:) forControlEvents:UIControlEventTouchUpInside];
		[btn setFrame:CGRectMake(self.bounds.size.width/2-self.unfavoritedIcon.size.width/2, 
								 self.bounds.size.height/2-self.unfavoritedIcon.size.height/2-2.0f, 
								 self.unfavoritedIcon.size.width, 
								 self.unfavoritedIcon.size.height)];
		[self setIconButton:btn];
		[btn release];
	}
	return iconButton;
}

- (void)toggleFavorite:(id)sender
{
	isFavorite = !isFavorite;
	[self.iconButton setImage:(isFavorite ? self.favoritedIcon : self.unfavoritedIcon) forState:UIControlStateNormal];
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		isFavorite = NO;
		[self addSubview:self.background];
		[self addSubview:self.iconButton];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
}

- (void)dealloc 
{
	[favoritedIcon release];
	[unfavoritedIcon release];
	[background release];
    [super dealloc];
}


@end
