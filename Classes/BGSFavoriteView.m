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
@synthesize isFavorite;
@synthesize hasBackground;

- (void)setHasBackground:(BOOL)newHasBackground
{
	hasBackground = newHasBackground;
	[self.background removeFromSuperview];
	if (self.hasBackground)
		[self insertSubview:self.background atIndex:0];
}
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

- (void)setIsFavorite:(BOOL)newIsFavorite
{
	isFavorite = newIsFavorite;
	[self.iconButton setImage:(self.isFavorite ? self.favoritedIcon : self.unfavoritedIcon) forState:UIControlStateNormal];
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
		[self setIconButton:btn];
		[btn release];
	}
	return iconButton;
}

- (id)initWithFrame:(CGRect)frame 
{
    if (self = [super initWithFrame:frame]) 
	{
		self.isFavorite = NO;
		self.hasBackground = YES;
		[self addSubview:self.background];
		[self addSubview:self.iconButton];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.iconButton.frame = CGRectMake(floor(self.bounds.size.width/2-self.unfavoritedIcon.size.width/2), 
									   floor(self.bounds.size.height/2-self.unfavoritedIcon.size.height/2-2.0f), 
									   self.unfavoritedIcon.size.width, 
									   self.unfavoritedIcon.size.height);
}

- (void)dealloc 
{
	[favoritedIcon release];
	[unfavoritedIcon release];
	[background release];
    [super dealloc];
}


@end
