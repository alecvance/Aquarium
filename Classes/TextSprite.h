//
//  TextSprite.h
//  Squadron
//
//  Created by Alec Vance on 8/17/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"
#import "Constants.h"

@interface TextSprite : Sprite {
	NSString *text;
	NSString *font;
	uint fontSize;
	uint textLength;
	
	char *charFont;
	char *charText;
}

@property (assign) NSString *text;
@property (assign) NSString *font;
@property (assign) uint fontSize;

+ (TextSprite *) withString: (NSString *) label;
- (void) moveUpperLeftTo: (CGPoint) p;
- (void) newText: (NSString *) val;

@end
