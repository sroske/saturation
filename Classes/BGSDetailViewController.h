//
//  BGSDetailViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/18/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSKulerFeedController.h"
#import "BGSSwatchColor.h"
#import "BGSSwatchStrip.h"
#import "BGSFavoriteView.h"
#import "BGSEmailCTAView.h"
#import "BGSVisualOptionView.h"
#import "UIColor+CMYK.h"

@interface BGSDetailViewController : UIViewController 
{
	UIImageView *background;
	
	NSDictionary *entry;
	BGSKulerFeedController *feed;
	UILabel *titleLabel;
	UILabel *authorLabel;
	UIButton *closeButton;
	BGSSwatchStrip *colorStrip;
	
	UILabel *hexheaderLabel;
	UILabel *rgbHeaderLabel;
	UILabel *visualizerHeaderLabel;
	
	NSMutableArray *colorIcons;
	NSMutableArray *hexContentLabels;
	
	BGSSwatchColor *hexSeperator;
	
	NSMutableArray *rgbRContentLabels;
	NSMutableArray *rgbGContentLabels;
	NSMutableArray *rgbBContentLabels;
	
	BGSSwatchColor *rgbSeperator;

	BGSVisualOptionView *quadCircleOption;
	BGSVisualOptionView *simpleCircleOption;
	BGSVisualOptionView *quadSquareOption;
	
	BGSFavoriteView *favoriteButton;
	BGSEmailCTAView *emailButton;
}

@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) BGSKulerFeedController *feed;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *authorLabel;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) BGSSwatchStrip *colorStrip;

@property (nonatomic, retain) UILabel *hexheaderLabel;
@property (nonatomic, retain) UILabel *rgbHeaderLabel;
@property (nonatomic, retain) UILabel *visualizerHeaderLabel;

@property (nonatomic, retain) NSMutableArray *colorIcons;
@property (nonatomic, retain) NSMutableArray *hexContentLabels;

@property (nonatomic, retain) BGSSwatchColor *hexSeperator;

@property (nonatomic, retain) NSMutableArray *rgbRContentLabels;
@property (nonatomic, retain) NSMutableArray *rgbGContentLabels;
@property (nonatomic, retain) NSMutableArray *rgbBContentLabels;

@property (nonatomic, retain) BGSSwatchColor *rgbSeperator;

@property (nonatomic, retain) BGSVisualOptionView *quadCircleOption;
@property (nonatomic, retain) BGSVisualOptionView *simpleCircleOption;
@property (nonatomic, retain) BGSVisualOptionView *quadSquareOption;

@property (nonatomic, retain) BGSFavoriteView *favoriteButton;
@property (nonatomic, retain) BGSEmailCTAView *emailButton;

- (id)initWithEntry:(NSDictionary *)entryData;

@end
