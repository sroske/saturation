//
//  BGSEmailButton.h
//  Saturation
//
//  Created by Shawn Roske on 1/10/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"

@interface BGSEmailButton : UIButton 
{
	UIImage *background;
	UIButton *icon;
}

@property (nonatomic, retain) UIImage *background;
@property (nonatomic, retain) UIButton *icon;

@end
