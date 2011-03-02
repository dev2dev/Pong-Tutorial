//
//  Game.h
//  Pong
//
//  Created by H4CK3R on 29/01/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sparrow.h"
#import "SHCircle.h"
#import "Prefs.h"
#import "PauseScreen.h"

@protocol SPGameDelegate <NSObject>
@required
-(void)removeGameView;
@end


@interface Game : SPStage <UIAccelerometerDelegate, PauseScreenDelegate>{
	id <SPGameDelegate> delegate;

	SHCircle *ball;
	SPImage *paddle1;
	SPImage *paddle2;
	SPSprite *infoSprite;
	SPTextField *p1ScoreFeild;
	SPTextField *p2ScoreFeild;
	SPRectangle *player1Side;
	SPRectangle *player2Side;
	SPQuad *guideX1;
	SPQuad *guideY1;

	BOOL gamePaused;

	int p1Score;
	int p2Score;

	float kAISpeed;
	float ballXSpeed;
	float ballYSpeed;
}

@property(nonatomic,assign) id <SPGameDelegate> delegate;


@end
