//
//  BGSListViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSEntryViewCell.h"
#import "BGSSectionButton.h"
#import "BGSSwatchColor.h"
#import "BGSKulerFeedController.h"

@interface BGSListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> 
{
	NSArray *selectedEntries;
	UIImageView *background;
	UIButton *closeButton;
	UITableView *tableView;
	BGSKulerFeedController *feed;
	BGSSectionButton *newestButton;
	BGSSectionButton *popularButton;
	BGSSectionButton *randomButton;
	BGSSectionButton *favoritesButton;
	BGSSwatchColor *seperator;
}

@property (nonatomic, retain) NSArray *selectedEntries;
@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) BGSKulerFeedController *feed;
@property (nonatomic, retain) BGSSectionButton *newestButton;
@property (nonatomic, retain) BGSSectionButton *popularButton;
@property (nonatomic, retain) BGSSectionButton *randomButton;
@property (nonatomic, retain) BGSSectionButton *favoritesButton;
@property (nonatomic, retain) BGSSwatchColor *seperator;

@end
