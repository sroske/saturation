//
//  BGSDetailViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/18/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSSwatchColor.h"
#import "BGSSwatchStrip.h"
#import "BGSEmailCTAView.h"
#import "UIColor+CMYK.h"

@interface BGSDetailViewController : UIViewController 
{
	NSDictionary *entry;
	UILabel *titleLabel;
	UILabel *authorLabel;
	UIButton *closeButton;
	BGSSwatchStrip *colorStrip;
	
	UILabel *hexheaderLabel;
	UILabel *rgbHeaderLabel;
	UILabel *cmykHeaderLabel;
	
	NSMutableArray *colorIcons;
	NSMutableArray *hexContentLabels;
	
	BGSSwatchColor *hexSeperator;
	
	NSMutableArray *rgbRContentLabels;
	NSMutableArray *rgbGContentLabels;
	NSMutableArray *rgbBContentLabels;
	
	BGSSwatchColor *rgbSeperator;
	
	NSMutableArray *cmykCContentLabels;
	NSMutableArray *cmykMContentLabels;
	NSMutableArray *cmykYContentLabels;
	NSMutableArray *cmykKContentLabels;
	
	UIView *favoriteButton;
	BGSEmailCTAView *emailButton;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *authorLabel;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) BGSSwatchStrip *colorStrip;

@property (nonatomic, retain) UILabel *hexheaderLabel;
@property (nonatomic, retain) UILabel *rgbHeaderLabel;
@property (nonatomic, retain) UILabel *cmykHeaderLabel;

@property (nonatomic, retain) NSMutableArray *colorIcons;
@property (nonatomic, retain) NSMutableArray *hexContentLabels;

@property (nonatomic, retain) BGSSwatchColor *hexSeperator;

@property (nonatomic, retain) NSMutableArray *rgbRContentLabels;
@property (nonatomic, retain) NSMutableArray *rgbGContentLabels;
@property (nonatomic, retain) NSMutableArray *rgbBContentLabels;

@property (nonatomic, retain) BGSSwatchColor *rgbSeperator;

@property (nonatomic, retain) NSMutableArray *cmykCContentLabels;
@property (nonatomic, retain) NSMutableArray *cmykMContentLabels;
@property (nonatomic, retain) NSMutableArray *cmykYContentLabels;
@property (nonatomic, retain) NSMutableArray *cmykKContentLabels;

@property (nonatomic, retain) UIView *favoriteButton;
@property (nonatomic, retain) BGSEmailCTAView *emailButton;

- (id)initWithEntry:(NSDictionary *)entryData;

@end
