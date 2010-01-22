//
//  BGSDetailViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/18/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontLabel.h"
#import "FontsAndColors.h"
#import "BGSKulerFeedController.h"
#import "BGSSwatchColor.h"
#import "BGSSwatchStrip.h"
#import "BGSFavoriteView.h"
#import "BGSEmailButton.h"
#import "BGSVisualOptionView.h"
#import "BGSMailController.h"
#import "UIColor+CMYK.h"
#import "UIColor+ColorFromHex.h"

@interface BGSDetailViewController : UIViewController 
{
	UIImageView *background;
	
	NSDictionary *entry;
	BGSKulerFeedController *feed;
	FontLabel *titleLabel;
	FontLabel *authorLabel;
	UIButton *closeButton;
	
	UIScrollView *colorStripScroll;
	BGSSwatchStrip *colorStrip;
	
	FontLabel *hexheaderLabel;
	FontLabel *rgbHeaderLabel;
	FontLabel *visualizerHeaderLabel;
	
	NSMutableArray *colorIcons;
	NSMutableArray *hexContentLabels;
	
	BGSSwatchColor *hexSeperator;
	
	NSMutableArray *rgbRContentLabels;
	NSMutableArray *rgbGContentLabels;
	NSMutableArray *rgbBContentLabels;
	
	BGSSwatchColor *rgbSeperator;

	BGSVisualOptionView *simpleCircleOption;
	BGSVisualOptionView *simpleParticleOption;
	
	BGSFavoriteView *favoriteButton;
	BGSEmailButton *emailButton;
}

@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) BGSKulerFeedController *feed;
@property (nonatomic, retain) FontLabel *titleLabel;
@property (nonatomic, retain) FontLabel *authorLabel;
@property (nonatomic, retain) UIButton *closeButton;

@property (nonatomic, retain) UIScrollView *colorStripScroll;
@property (nonatomic, retain) BGSSwatchStrip *colorStrip;

@property (nonatomic, retain) FontLabel *hexheaderLabel;
@property (nonatomic, retain) FontLabel *rgbHeaderLabel;
@property (nonatomic, retain) FontLabel *visualizerHeaderLabel;

@property (nonatomic, retain) NSMutableArray *colorIcons;
@property (nonatomic, retain) NSMutableArray *hexContentLabels;

@property (nonatomic, retain) BGSSwatchColor *hexSeperator;

@property (nonatomic, retain) NSMutableArray *rgbRContentLabels;
@property (nonatomic, retain) NSMutableArray *rgbGContentLabels;
@property (nonatomic, retain) NSMutableArray *rgbBContentLabels;

@property (nonatomic, retain) BGSSwatchColor *rgbSeperator;

@property (nonatomic, retain) BGSVisualOptionView *simpleCircleOption;
@property (nonatomic, retain) BGSVisualOptionView *simpleParticleOption;

@property (nonatomic, retain) BGSFavoriteView *favoriteButton;
@property (nonatomic, retain) BGSEmailButton *emailButton;

- (id)initWithEntry:(NSDictionary *)entryData;

@end
