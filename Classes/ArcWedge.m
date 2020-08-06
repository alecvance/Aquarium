//
//  ArcWedge.m
//  Aquarium
//
//  Created by Alec Vance on 9/22/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//
	
#import "ArcWedge.h"
#import "Constants.h"

@implementation ArcWedge

@synthesize radius, startAngle, arcTheta, pieceNum, highlightState;

#pragma mark convenience methods
// (over-ride methods for setting and getting rotation so we can use degrees)

- (void) setStartAngle:(CGFloat) degrees
{
	startAngle = degrees * kPi/180.0;
}

- (CGFloat) startAngle
{
	return startAngle*180.0/kPi;
}

- (void) setArcTheta:(CGFloat) degrees
{
	arcTheta = degrees * kPi/180.0;
}

- (CGFloat) arcTheta
{
	return arcTheta*180.0/kPi;
}

#pragma mark drawing methods


- (void) draw: (CGContextRef) context
{
	CGContextSaveGState(context);
	
	//Position the sprite.....
	
	//start with no transformation (identity)
	CGAffineTransform t = CGAffineTransformIdentity;
	
	// transforms happen in reverse...
	//	t = CGAffineTransformTranslate(t, x, y); // step 3: move/position
	//	t = CGAffineTransformRotate(t, rotation); // step 2: rotate
	//	t = CGAffineTransformScale(t, scale, scale); // step 1: scale
	
	
	/* use these transforms instead of the above for centered origin  */
	t = CGAffineTransformTranslate(t, kScreenWidth/2.0+x, kScreenHeight/2.0-y); // step 3: move/position
	t = CGAffineTransformRotate(t, - rotation); // step 2: rotate
	t = CGAffineTransformScale(t, scale, -scale); // step 1: scale (also flips Y axis!)
	
	/* use these transforms instead of the above for centered origin with UIDeviceOrientationLandscapeRight */
	//	t = CGAffineTransformTranslate(t, y+160, 240-x); // step 3: move/position
	//	t = CGAffineTransformRotate(t, rotation - kPi * 0.5); // step 2: rotate
	//	t = CGAffineTransformScale(t, scale, scale); // step 1: scale
	
	
	
	//apply the transformations
	CGContextConcatCTM(context, t);
	
	//Draw our body
	[self drawBody: context];
	
	CGContextRestoreGState(context);
	
}

- (void) outlinePath: (CGContextRef) context
{	
	
	// center point of circle within local coordinate system
	CGFloat Cx = 0.0;
	CGFloat Cy = 0.0;
	
	/*
	// draw box around circle (for debugging)
	CGContextBeginPath(context);
	CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, .95);
	CGContextSetLineWidth(context, 0.25);
	CGContextSetRGBFillColor(context, 0.0, 1.0, 0.0, .15);
	CGContextMoveToPoint(context, Cx-radius, Cy-radius);     
	CGContextAddLineToPoint(context, Cx+radius, Cy-radius); 
	CGContextAddLineToPoint(context, Cx+radius, Cy+radius); 
	CGContextAddLineToPoint(context, Cx-radius, Cy+radius); 
	CGContextClosePath(context);
	//CGContextFillPath(context); 
	CGContextStrokePath(context);
	CGContextClosePath(context);
	*/
	
	
	//draw pie piece
	//CGContextBeginPath(context);
	//CGContextSetRGBStrokeColor(context, r, g, b, alpha);
	//CGContextSetRGBFillColor(context, r, g, b, alpha);
	CGContextMoveToPoint(context, Cx, Cy);     

	// rotation was already being applied again elsewhere, so start from 0 here.
//	CGFloat startAngle = 0; // -rotation; 
	CGFloat endAngle = (startAngle + arcTheta);
	
	int clockwise = true; 
	//CGContextAddArc(context, Cx, Cy, radius, 1.5*kPi-startAngle, 1.5*kPi-endAngle, clockwise);
	// "clockwise" seems to work backwards, so we put !clockwise in CGContextAddArc
	CGContextAddArc(context, Cx, Cy, radius, startAngle, endAngle, !clockwise);

	CGContextAddLineToPoint(context, Cx, Cy);
	//CGContextClosePath(context);
	//CGContextFillPath(context); 
	
}

- (void) tic: (NSTimeInterval) dt{
	//self.rotation++;
	[super tic: dt];

	if(animatingTouch){
		animatingTouchTime = animatingTouchTime + dt;
		float t = animatingTouchTime*16.0;
		if (t>2*kPi) {
			// done
			self.r = r0;
			self.g = g0;
			self.b = b0;
						
			animatingTouch = NO;
		}else{
			float a = sin(t)/10.0;
			self.r = r0 + a;
			self.g = g0 + a;
			self.b = b0 + a;
		}
	}else {
		// only show highlight state if not animating touch
		
		if (highlightState) {
			highlightTime = highlightTime + dt;
			float t = highlightTime*16.0;
			float a = sin(t/3.0)/5.0; // less extreme, and pulse slower
			self.r = r0 + a;
			self.g = g0 + a;
			self.b = b0 + a;
		}
	}
}

#pragma mark UI
- (void) wasTouched {
	if (! animatingTouch) {
		animatingTouch = YES;
		animatingTouchTime = 0;
		r0 = self.r;
		g0 = self.g;
		b0 = self.b;
	}
}

- (void) setHighlightState:(BOOL)isLit{
	
	if (isLit == highlightState) {
		//NSLog(@"Setting highlight state to state already set.");
		
		return; //error?
		
	}
	
	if (isLit) {
		highlightState = YES;
		highlightTime = 0;
		r0 = self.r;
		g0 = self.g;
		b0 = self.b;
	}else {
		highlightState = NO;
		self.r = r0;
		self.g = g0;
		self.b = b0;
	}

	
}

@end
