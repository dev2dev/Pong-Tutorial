//
//  SettingsBackgroundView.m
//  Pong
//
//  Created by H4CK3R on 06/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsBackgroundView.h"
#import "Common.h"


@implementation SettingsBackgroundView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	// Drawing code
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGColorRef whiteColor = [UIColor colorWithRed:60.0/255.0 green:60.0/255.0 
											 blue:60.0/255.0 alpha:0.85].CGColor;
	CGColorRef lightGrayColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 
												 blue:0.0/255.0 alpha:0.85].CGColor;
	CGRect paperRect = self.bounds;
	drawLinearGradient(context, paperRect, whiteColor, lightGrayColor);
}

- (void)dealloc {
    [super dealloc];
}


@end
