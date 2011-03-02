//
//	Game.m
//	Pong
//
//	Created by H4CK3R on 29/01/2011.
//	Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Game.h"

// --- private interface ---------------------------------------------------------------------------
@interface Game ()

-(void)remove:(SPTouchEvent*)event;
-(void)movementController:(SPEnterFrameEvent*)event;
-(void)collisionController:(SPEnterFrameEvent*)event;
-(void)paddleTouched:(SPTouchEvent*)event;
-(void)pauseAnimated:(BOOL)yesOrNo;
-(void)gameOver;

@end
// --- class implementation ------------------------------------------------------------------------


@implementation Game

@synthesize delegate;

- (id)initWithWidth:(float)width height:(float)height{
	if (self = [super initWithWidth:width height:height]){

		//************* INITIAL STARTUP **************//
		//Background Gradient
		SPQuad *backgroundColor = [[SPQuad alloc] initWithWidth:self.width height:self.height];
		[backgroundColor setColor:0xcccccc ofVertex:0]; //set the color differently
		[backgroundColor setColor:0xcccccc ofVertex:1]; //in each corner to get
		[backgroundColor setColor:0x868686 ofVertex:2]; //a nice gradient
		[backgroundColor setColor:0x868686 ofVertex:3];
		[self addChild:backgroundColor]; //Add to screen
		[backgroundColor release]; //Don't forget to release it now

		//This is just for a visual touch if you dislike it you can remove it
		SPQuad *line = [[SPQuad alloc] initWithWidth:self.width height:2];
		line.y = (self.height*0.5)-1; //Set it half way down the screen
		line.alpha = 0.1; //Barely visible so it doesn't standout too much
		line.color = 0x000000; //See it's color to black
		[self addChild:line]; //Add it to screen
		[line release]; //Again release it from memory



		/************ TopBar Section : START ***********/
		infoSprite = [[SPSprite alloc] init];

		SPQuad *infoBackground = [SPQuad quadWithWidth:self.width height:25];
		infoBackground.color = 0x000000;
		[infoSprite addChild:infoBackground];

		p1ScoreFeild = [[SPTextField alloc] initWithText:@"Player1: 0"];
		p1ScoreFeild.fontName = @"Marker Felt";
		p1ScoreFeild.fontSize = 15;
		p1ScoreFeild.vAlign = SPVAlignTop;
		p1ScoreFeild.hAlign = SPHAlignLeft;
		p1ScoreFeild.width = self.width*0.25;
		p1ScoreFeild.height = 20;
		p1ScoreFeild.x = ((5.0/320.0)*self.width);
		p1ScoreFeild.y = 5;
		p1ScoreFeild.color = 0xFFFFFF;
		p1ScoreFeild.alpha = 0.8;
		[infoSprite addChild:p1ScoreFeild];

		p2ScoreFeild = [[SPTextField alloc] initWithText:@"AI: 0"];
		p2ScoreFeild.fontName = @"Marker Felt";
		p2ScoreFeild.fontSize = 15;
		p2ScoreFeild.vAlign = SPVAlignTop;
		p2ScoreFeild.hAlign = SPHAlignLeft;
		p2ScoreFeild.width = self.width*0.25;
		p2ScoreFeild.height = 20;
		p2ScoreFeild.x = ((5.0/320.0)*self.width)+(p1ScoreFeild.x+p1ScoreFeild.width);
		p2ScoreFeild.y = 5;
		p2ScoreFeild.color = 0xFFFFFF;
		p2ScoreFeild.alpha = 0.8;
		[infoSprite addChild:p2ScoreFeild];

		SPSprite *pauseButton = [[SPSprite alloc] init];
		SPQuad *pause1 = [SPQuad quadWithWidth:5 height:15];
		[pauseButton addChild:pause1];
		SPQuad *pause2 = [SPQuad quadWithWidth:5 height:15];
		pause2.x = pause1.width+5;
		[pauseButton addChild:pause2];

		pauseButton.x = self.width-pauseButton.width-10;
		pauseButton.y = 5;
		[infoSprite addChild:pauseButton];
		[pauseButton release];

		[self addChild:infoSprite];

		SPQuad *buttonArea = [SPQuad quadWithWidth:50 height:50];
		buttonArea.alpha = 0.0;
		buttonArea.x = self.width-buttonArea.width;
		[buttonArea addEventListener:@selector(pausePressed:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
		[self addChild:buttonArea];
		/************ TopBar Section : END ***********/



		/** The Paddles Position Guides **/
		//Create the here because we what them on the screen below the ball and paddle,
		guideX1 = [[SPQuad alloc] initWithWidth:1 height:75]; // but their positions
		[self addChild:guideX1]; // are worked out relative to the paddle
		guideY1 = [[SPQuad alloc] initWithWidth:320 height:2]; //so we put their
		[self addChild:guideY1]; //postitioning code after the paddle is added to the screen
		/** The Paddles Position Guides **/


		//The ball Itself
		ball = [[SHCircle alloc] initWithWidth:30 height:30];
		ball.x = (self.width/2-ball.width/2);
		ball.y = (self.height/2-ball.height/2);
		ball.color = 0x0000FF;
		[self addChild:ball];
		//We release it later i didn't forget the release call

		/***** The Paddel Textures *****/
		//Load the graphics only once and use it twice.
		SPTexture *paddleTexture = [[SPTexture alloc] initWithContentsOfFile:@"scroller.png"];

		//Setup Paddle 1
		paddle1 = [[SPImage alloc] initWithTexture:paddleTexture];
//		paddle1.scaleX = paddle1.scaleY = 0.4;
		paddle1.y = (self.height - paddle1.height - (self.height*0.045));
		paddle1.x = (self.width*0.5)-(paddle1.width*0.5);
		[self addChild:paddle1];


		/***** The Paddles Position Guides *****/
		//Again these need to be added to the screen before the paddle but their positions
		guideX1.color = 0x666666; //are relative to the paddle so we have to split the setup
		guideX1.alpha = 0.15;
		guideX1.visible = NO;
		guideX1.x = paddle1.x;
		guideX1.y = (paddle1.y-guideX1.height+1);
		guideX1.width = paddle1.width;

		guideY1.color = 0x666666;
		guideY1.alpha = 0.06;
		guideY1.visible = NO;
		guideY1.y = paddle1.y;
		/***** The Paddles Position Guides *****/


		//Setup Paddle 2
		paddle2 = [[SPImage alloc] initWithTexture:paddleTexture];
//		paddle2.scaleX = paddle2.scaleY = 0.4;
		paddle2.y = (self.height*0.025)+infoSprite.height;
		paddle2.x = (self.width*0.5)-(paddle2.width*0.5);
		[self addChild:paddle2];

		[paddleTexture release]; //Release the paddle texture now we've finnishes with it.


		//These aren't even display objects they are just give us a box for each half of the screen to check where the ball is.
		//Really these isn't actually needed for this (we could use some basic math + the balls y location) but it uses another part of
		player2Side = [[SPRectangle alloc] initWithX:0 y:0 width:self.width height:((self.height*0.5)-1)]; //sparrow so is good for
		player1Side = [[SPRectangle alloc] initWithX:0 y:((self.height*0.5)+1) width:self.width height:((self.height*0.5)-1)]; //learning.

		//Default Values
		gamePaused = NO;
		p1Score = 0;
		p2Score = 0;
		kAISpeed = ((4.5/320.0)*self.width);
		ballYSpeed = -((5.0/480.0)*self.height);
		ballXSpeed = -((5.0/320.0)*self.width);

		NSLog(@"Game Started");
		[paddle2 addEventListener:@selector(remove:) atObject:self forType:SP_EVENT_TYPE_TOUCH]; //Leave Game View
		[self addEventListener:@selector(movementController:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME]; //Ball's movement
		[self addEventListener:@selector(collisionController:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME]; //Collsions
		[self addEventListener:@selector(AIController:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME]; //AI

		[paddle1 addEventListener:@selector(paddleTouched:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
		}
	return self;
}
-(void)remove:(SPTouchEvent*)event{
	SPTouch *touch = [[event touchesWithTarget:self] anyObject];
	if (touch.phase == SPTouchPhaseEnded) {
		[delegate removeGameView];
	}
}


-(void)movementController:(SPEnterFrameEvent*)event{
	if (!gamePaused) {
		//Move The Ball
		ball.x += ballXSpeed;
		ball.y += ballYSpeed;

		static int totalTime = 0;
		totalTime += event.passedTime;
	}
}

-(void)collisionController:(SPEnterFrameEvent*)event{
	if (!gamePaused) {
		//Check the ball's sides
		if ((ball.x+ball.width) >= self.width && ballXSpeed >= 0) {
			ballXSpeed = -ballXSpeed;
		}
		else if (ball.x <= 0 && ballXSpeed < 0){
			ballXSpeed = -ballXSpeed;
		}
		//Check the ball's top & bottom
		if ((ball.y+ball.height) >= self.height && ballYSpeed >= 0) {
			ballYSpeed = -ballYSpeed;
			p2Score++;
			p2ScoreFeild.text = [NSString stringWithFormat:@"AI: %d",p2Score];
			[self gameOver];
		}
		else if (ball.y <= infoSprite.height && ballYSpeed < 0){
			ballYSpeed = -ballYSpeed;
			p1Score++;
			p1ScoreFeild.text = [NSString stringWithFormat:@"Player1: %d",p1Score];
			[self gameOver];
		}

		/*** Check Ball and paddles ***/
		//Check Paddle 1
		if ((ball.y+ball.height) >= paddle1.y && ballYSpeed >= 0) {
			if ((ball.x+ball.width) >= paddle1.x && ball.x <= (paddle1.x+paddle1.width)) {
				ballYSpeed = -ballYSpeed;
			}
		}
		//Check Paddle 2
		if (ball.y <= (paddle2.y+paddle2.height) && ballYSpeed < 0) {
			if ((ball.x+ball.width) >= paddle2.x && ball.x <= (paddle2.x+paddle2.width)) {
				ballYSpeed = -ballYSpeed;
			}
		}
	}
}

-(void)AIController:(SPEnterFrameEvent*)event{
	if (!gamePaused) {
		if ([ball.bounds intersectsRectangle:player2Side]) {
			//NSLog(@"AI should be moving");
			if (((ball.x+ball.width)*0.5) < ((paddle2.x+paddle2.width)*0.5) && (paddle2.x) > 0) {
				paddle2.x += -(kAISpeed);
			}
			else if (((ball.x+ball.width)*0.5) > ((paddle2.x+paddle2.width)*0.5) && (paddle2.x+paddle2.width) < self.width) {
				paddle2.x += kAISpeed;
			}
		}
	}
}

-(void)paddleTouched:(SPTouchEvent*)event{
	SPTouch *touch = [[event touchesWithTarget:self] anyObject];
	if (touch.phase == SPTouchPhaseBegan) {
		guideX1.visible = YES;
		guideY1.visible = YES;
	}
	else if (touch.phase == SPTouchPhaseMoved) {
			SPPoint *currentPos = [touch locationInSpace:self];
			SPPoint *previousPos = [touch previousLocationInSpace:self];
			SPPoint *dist = [currentPos subtractPoint:previousPos];

			paddle1.x += dist.x;
			guideX1.x = paddle1.x;
	}
	else if (touch.phase == SPTouchPhaseEnded || touch.phase == SPTouchPhaseCancelled) {
		guideX1.visible = NO;
		guideY1.visible = NO;
	}
}

-(void)pausePressed:(SPTouchEvent*)event{
	SPTouch *touch = [[event touchesWithTarget:self] anyObject];
	if (touch.phase == SPTouchPhaseEnded) {
		[self pauseAnimated:YES];
	}
}

-(void)pauseAnimated:(BOOL)yesOrNo{
	gamePaused = YES;

	PauseScreen *pauseScreen = [[PauseScreen alloc] initWithHeight:self.height andWidth:self.width];
	pauseScreen.delegate = self;
	[self addChild:pauseScreen];
	[pauseScreen showAnimated:yesOrNo];
	[pauseScreen release];
}

-(void)unPause{
	gamePaused = NO;
}
-(void)quit{
	[delegate removeGameView];
}

-(void)gameOver{
	if (p1Score >= [Prefs sharedInstance].currentGameMax || p2Score >= [Prefs sharedInstance].currentGameMax) {
		NSLog(@"Game Ended");
	}
}


- (void)dealloc {
	NSLog(@"Game Released");
	[ball release];
	[paddle1 release];
	[paddle2 release];
	[guideX1 release];
	[guideY1 release];
	[player1Side release];
	[player2Side release];
	[p1ScoreFeild release];
	[p2ScoreFeild release];
	[super dealloc];
}

@end
