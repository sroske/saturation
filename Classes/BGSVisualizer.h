//
//  BGSVisualizer.h
//  Saturation
//
//  Created by Shawn Roske on 1/3/10.
//  Copyright 2010 Bitgun. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol BGSVisualizer <NSObject>

- (id)initWithFrame:(CGRect)frame andEntry:(NSDictionary *)entryData;

- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;

@end
