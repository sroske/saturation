//
//  BGSDetailViewController.h
//  Saturation
//
//  Created by Shawn Roske on 12/18/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

@interface BGSDetailViewController : UIViewController 
{
	NSDictionary *entry;
	UILabel *titleLabel;
	UILabel *authorLabel;
	UIButton *closeButton;
}

@property (nonatomic, retain) NSDictionary *entry;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *authorLabel;
@property (nonatomic, retain) UIButton *closeButton;

- (id)initWithEntry:(NSDictionary *)entryData;

@end
