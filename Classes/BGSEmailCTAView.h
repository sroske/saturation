//
//  BGSEmailCTAView.h
//  Saturation
//
//  Created by Shawn Roske on 12/19/09.
//  Copyright 2009 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

@interface BGSEmailCTAView : UIView 
{
	UIImageView *background;
	UIImageView *icon;
	UILabel *label;
}

@property (nonatomic, retain) UIImageView *background;
@property (nonatomic, retain) UIImageView *icon;
@property (nonatomic, retain) UILabel *label;

@end
