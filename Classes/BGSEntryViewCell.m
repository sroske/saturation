//
//  BGSEntryViewCell.m
//  Saturation
//
//  Created by Shawn Roske on 12/22/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import "BGSEntryViewCell.h"

@interface BGSEntryViewCell (Private)

- (void)showActivationState:(BOOL)activeState animated:(BOOL)animated;

@end

@implementation BGSEntryViewCell

@synthesize backgroundImage;
@synthesize selectedBackgroundImage;
@synthesize entry;
@synthesize favoriteView;
@synthesize colorStrip;
@synthesize nameLabel;

- (UIImageView *)backgroundImage
{
	if (backgroundImage == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"list-background-normal.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 
																		0.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setBackgroundImage:iv];
		[iv release];
	}
	return backgroundImage;
}

- (UIImageView *)selectedBackgroundImage
{
	if (selectedBackgroundImage == nil)
	{
		NSString *p = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"list-background-selected.png"];
		UIImage *i = [UIImage imageWithContentsOfFile:p];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 
																		0.0f, 
																		i.size.width, 
																		i.size.height)];
		[iv setImage:i];
		[self setSelectedBackgroundImage:iv];
		[iv release];
	}
	return selectedBackgroundImage;
}

- (void)setEntry:(NSDictionary *)newEntry
{
	if (entry != newEntry)
	{
		[entry release];
		entry = [newEntry retain];
	}
	[self.colorStrip setSwatches:[self.entry objectForKey:@"swatches"]];
	[self.nameLabel setText:[[self.entry objectForKey:@"themeTitle"] lowercaseString]];
	[self setNeedsLayout];
}

- (BGSFavoriteView *)favoriteView
{
	if (favoriteView == nil)
	{
		BGSFavoriteView *v = [[BGSFavoriteView alloc] initWithFrame:CGRectZero];
		[v setHasBackground:NO];
		[self setFavoriteView:v];
		[v release];
	}
	return favoriteView;
}

- (BGSSwatchStrip *)colorStrip
{
	if (colorStrip == nil)
	{
		BGSSwatchStrip *s = [[BGSSwatchStrip alloc] initWithFrame:CGRectZero andSwatches:nil];
		[self setColorStrip:s];
		[s release];
	}
	return colorStrip;
}

- (UILabel *)nameLabel
{
	if (nameLabel == nil)
	{
		UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
		[lbl setFont:CF_LIST_TITLE];
		[lbl setTextColor:CC_WHITE];
		[lbl setBackgroundColor:CC_CLEAR];
		[self setNameLabel:lbl];
		[lbl release];
	}
	return nameLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
	{
		//[self setSelectionStyle:UITableViewCellSelectionStyleNone];
		[self setAccessoryType:UITableViewCellAccessoryNone];
		
		[self setBackgroundView:self.backgroundImage];
		[self setSelectedBackgroundView:self.selectedBackgroundImage];
		
		[self addSubview:self.favoriteView];
		[self addSubview:self.colorStrip];
		[self addSubview:self.nameLabel];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.favoriteView.frame = CGRectMake(10.0f, 
										 floor(self.bounds.size.height/2-24.0f), 
										 48.0f, 
										 48.0f);
	self.colorStrip.frame = CGRectMake(self.favoriteView.frame.origin.x+self.favoriteView.frame.size.width+4.0f, 
									   self.bounds.size.height/2-5.0f, 
									   50.0f,
									   10.0f);
	self.nameLabel.frame = CGRectMake(self.colorStrip.frame.origin.x+self.colorStrip.frame.size.width+14.0f, 
									  self.bounds.size.height/2-10.0f, 
									  150.0f, 
									  20.0f);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
	[super setHighlighted:highlighted animated:animated];
	[self showActivationState:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated 
{
	[super setSelected:selected animated:animated];
	[self showActivationState:selected animated:animated];
}

- (void)showActivationState:(BOOL)activeState animated:(BOOL)animated
{
	/*
	if (activeState)
		[self.questionLabel setTextColor:CC_SELECTED_TEXT_COLOR];
	else 
		[self.questionLabel setTextColor:CC_DARK_BLUE];
	 */
}

- (void)dealloc 
{
	[backgroundImage release];
	[selectedBackgroundImage release];
	[entry release];
	[favoriteView release];
	[colorStrip release];
	[nameLabel release];
    [super dealloc];
}


@end
