//
//  ArcWedge.h
//  Aquarium
//
//  Created by Alec Vance on 9/22/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
// 
// defines a pie slice type shape

#import <Foundation/Foundation.h>
#import "Sprite.h"

@interface ArcWedge : Sprite {
	// uses x and y from Sprite to define the center;
	// width and height are not used (?)
	// rotation is used to define where the arc starts

	// CGFloat x,y are in
	CGFloat radius; // radius of the circle that this wedge is part of.
	CGFloat startAngle; // starting angle of the wedge shape (before moving clockwise)
	CGFloat arcTheta; // angle of the arc inside the wedge
	
	int pieceNum; // position in the array of wedges
	BOOL animatingTouch;
	NSTimeInterval animatingTouchTime, highlightTime;
	CGFloat r0, g0, b0; // store original rgb
	BOOL highlightState;
}


@property (assign) CGFloat radius;
@property (assign) CGFloat startAngle;
@property (assign) CGFloat arcTheta;
@property (assign) int pieceNum;
@property (assign, nonatomic) BOOL highlightState;

- (void) wasTouched;

@end
