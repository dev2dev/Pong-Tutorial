//
//  PauseScreen.h
//  Pong
//
//  Created by H4CK3R on 26/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoolWhiteView.h"
#import "Sparrow.h"

@protocol PauseScreenDelegate
@required
-(void)unPause;
-(void)quit;
@end



@interface PauseScreen : SPSprite {
	id <PauseScreenDelegate> delegate;

	SPSprite *innerSprite;

	int actualWidth;
	int actualHeight;
}

@property (nonatomic, assign) id <PauseScreenDelegate> delegate;

-(id)initWithHeight:(int)h andWidth:(int)w;
-(void)showAnimated:(BOOL)yesOrNo;


@end
