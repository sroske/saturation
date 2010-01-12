//
//  BGSEntryViewCell.h
//  Saturation
//
//  Created by Shawn Roske on 12/22/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "FontsAndColors.h"
#import "BGSFavoriteView.h"
#import "BGSSwatchStrip.h"


@interface BGSEntryViewCell : UITableViewCell 
{
	UIImageView *backgroundImage;
	UIImageView *selectedBackgroundImage;
	NSDictionary *entry;
	BGSFavoriteView *favoriteView;
	BGSSwatchStrip *colorStrip;
	FontLabel *nameLabel;
}

@property (nonatomic, retain) UIImageView *backgroundImage;
@property (nonatomic, retain) UIImageView *selectedBackgroundImage;
@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) BGSFavoriteView *favoriteView;
@property (nonatomic, retain) BGSSwatchStrip *colorStrip;
@property (nonatomic, retain) FontLabel *nameLabel;

@end
