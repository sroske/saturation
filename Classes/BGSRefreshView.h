//
//  BGSRefreshView.h
//  Saturation
//
//  Created by Shawn Roske on 1/9/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FontsAndColors.h"
#import "BGSRefreshButton.h"

@interface BGSRefreshView : UIView 
{
	BGSRefreshButton *refreshButton;
}

@property (nonatomic, retain) BGSRefreshButton *refreshButton;
@end
