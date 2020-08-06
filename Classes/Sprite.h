//
//  Sprite.h
//  Squadron
//
//  Created by Alec Vance on 8/15/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColorModel.h"

@interface Sprite : NSObject {
	CGFloat x, y;			// location
	CGFloat r, g, b, alpha; // color
	CGFloat speed;			// speed (pixels/frame)
	CGFloat angle;			// angle of movement in degrees
	CGFloat rotation;		// rotation of our sprite in degrees, about the center
	CGFloat width, height; 
	CGFloat scale;			// uniform scaling factor for size
	int frame;				// for animation
	
	CGFloat cosTheta;		// precomputed for speed
	CGFloat sinTheta;
	CGRect box;				// our bounding box
	
	BOOL render;			// true when we're rendering
	BOOL offScreen;			// true when we're off the screen
	BOOL wrap;				//true if you want the motion to wrap on the screen
	
	BOOL autoSpin;
	CGFloat spinTo;
	CGFloat spinAccel;
	CGFloat spinSpeed;
	ColorModel *palette;
	int colorIndex;
	
}

@property (assign) BOOL wrap, render, offScreen;
@property (assign) CGFloat x, y, r, g, b, alpha;
@property (assign) CGFloat speed, angle, rotation;
@property (assign) CGFloat width, height, scale;
@property (assign) CGRect box;
@property (assign) int frame;
@property (assign) BOOL autoSpin;
@property (assign) CGFloat spinTo, spinAccel, spinSpeed;
@property (nonatomic, retain) ColorModel *palette;
@property (assign) int colorIndex;

- (void) updateBox;
- (void) moveTo: (CGPoint) p;
- (void) scaleTo: (CGFloat) s;
- (void) drawBody: (CGContextRef) context;
- (void) draw: (CGContextRef) context;
- (void) gradientFill: (CGContextRef) myContext;
- (void) tic: (NSTimeInterval) dt;
- (float) getAngleTo: (Sprite *) otherSprite;

// utility function. should be moved?
- (float) angleFromVectorWithDx: (float)dx Dy: (float)dy;

-(void) setColorToIndex: (NSUInteger) colorNum;
-(NSString *)colorAsRGBString;

@end
