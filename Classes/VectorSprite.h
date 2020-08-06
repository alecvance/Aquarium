//
//  VectorSprite.h
//  Squadron
//
//  Created by Alec Vance on 8/16/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

@interface VectorSprite : Sprite {
	CGFloat *points;
	int count;
	CGFloat vectorScale;
}
@property (assign) int count;
@property (assign) CGFloat vectorScale;
@property (assign) CGFloat *points;
+ (VectorSprite *) withPoints: (CGFloat *) rawPoints count: (int) count;
- (void) updateSize;
@end
