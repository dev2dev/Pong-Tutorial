//
//  Prefs.m
//	Pong
//
//	Created by H4CK3R on 09/02/2011.
//	Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar ( http://mugunthkumar.com )
//

#define DEFAULTS_SET @"DefaultSet"
#define CURRENT_GAME_MAX @"currentGameMax"


#import "Prefs.h"


static Prefs *_instance;
@implementation Prefs

@synthesize currentGameMax, currentPlayerScore, currentAIScore;

+ (Prefs*)sharedInstance{
	@synchronized(self) {
		if (_instance == nil) {
			_instance = [[super allocWithZone:NULL] init];
			[_instance activate];
			_instance.currentGameMax = [[NSUserDefaults standardUserDefaults] integerForKey:CURRENT_GAME_MAX];
			_instance.currentPlayerScore = 0;	//The Game class sets this not the prefs class.
			_instance.currentAIScore = 0;	//Again it can't be left nil but we won't set it here.
		}
	}
	return _instance;
}


-(int)currentGameMax{
	return [defaults integerForKey:CURRENT_GAME_MAX];
}
-(void)setCurrentGameMax:(int)i{
	[defaults setInteger:i forKey:CURRENT_GAME_MAX];
	[defaults synchronize];
}


-(void)activate{
	defaults = [NSUserDefaults standardUserDefaults];
}




#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone
{
	return [[self sharedInstance]retain];
}


- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain
{
	return self;
}

- (unsigned)retainCount
{
	return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
	//do nothing
}

- (id)autorelease
{
	return self;	
}

@end
