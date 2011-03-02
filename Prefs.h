//
//  Prefs.h
//  Pong
//
//  Created by H4CK3R on 09/02/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>

@interface Prefs : NSObject {
	NSUserDefaults *defaults;
}

@property (nonatomic, assign) int currentGameMax;

@property (nonatomic, assign) int currentPlayerScore;
@property (nonatomic, assign) int currentAIScore;


+ (Prefs*) sharedInstance;

-(void)activate;


@end
