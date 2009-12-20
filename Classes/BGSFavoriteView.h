//
//  BGSFavoriteView.h
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

@interface BGSFavoriteView : UIView 
{
	UIImageView *background;
	UIImage *unfavoritedIcon;
	UIImage *favoritedIcon;
	UIButton *icon;
}


@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIImage *unfavoritedIcon;
@property (nonatomic, retain) UIImage *favoritedIcon;
@property (nonatomic, retain) UIButton *icon;

@end
