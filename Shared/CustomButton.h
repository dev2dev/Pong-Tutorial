//
//  CustomButton.h
//  Pong
//
//  Created by H4CK3R on 03/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface CustomButton : UIButton {
	@private
	BOOL mPressedDown;
}

@property (nonatomic, assign) BOOL  pressedDown;


-(void)activate;

@end
