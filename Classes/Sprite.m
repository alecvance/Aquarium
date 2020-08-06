//
//  Sprite.m
//  Squadron
//
//  Created by Alec Vance on 8/15/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "Sprite.h"
#import "Constants.h"
#import "UIColor-Expanded.h"

@implementation Sprite
@synthesize x, y, speed, angle, width, height, scale, frame, box, rotation, wrap, render;
@synthesize r, g, b, alpha, offScreen;
@synthesize autoSpin, spinTo, spinAccel, spinSpeed;
@synthesize palette, colorIndex;

- (id) init
{
	self = [super init];
	if (self) {
		wrap = NO;
		x = y = 0.0;
		width = height = 0.0;
		scale = 1.0;
		speed = 0.0;
		angle = 0.0;
		rotation = 0.0;
		cosTheta = 1.0;
		sinTheta = 0.0;
		r = 1.0;
		g = 1.0;
		b = 1.0;
		alpha = 1.0;
		offScreen = NO;
		box = CGRectMake(0, 0, 0, 0);
		frame = 0;
		render = YES;
		autoSpin = 0;
		spinTo = angle;
		spinSpeed = 0.0;
		spinAccel = 0.0;
		colorIndex = 0;
	}
	return self;
}

// convenience methods:
// (over-ride methods for setting and getting rotation so we can use degrees)

- (void) setRotation:(CGFloat) degrees
{
	rotation = degrees * kPi/180.0;
}

- (CGFloat) rotation
{
	return rotation*180.0/kPi;
}

- (void) setAngle:(CGFloat)degrees
{
	angle = degrees * kPi/180.0;
	cosTheta = cos(rotation);
	sinTheta = sin(rotation);
}

- (CGFloat) angle{
	return angle * 180.0/kPi; 
}

- (void) scaleTo: (CGFloat) zoom;
{
	scale = zoom;
	[self updateBox];
}

- (void) moveTo: (CGPoint) p
{
	x = p.x;
	y = p.y;
	[self updateBox];
}

-(void)updateBox
{
	CGFloat w = width*scale;
	CGFloat h = height*scale;
	CGFloat w2 = w*0.5;
	CGFloat h2 = h*0.5;
	CGPoint origin = box.origin;
	CGSize bsize = box.size;
	CGFloat left = -kScreenWidth*0.5;
	CGFloat right = -left;
	CGFloat top = kScreenHeight*0.5;
	CGFloat bottom = -top;
	
	offScreen = NO;
	if (wrap) {
		if ((x+w2) < left) x = right + w2;
		else if ((x-w2) > right) x = left - w2;
		else if ((y+h2) < bottom) y = top + h2;
		else if ((y-h2) > top) y = bottom - h2; 
	}
	else {
		offScreen = 
		((x+w2) < left) ||
		((x-w2) > right) ||
		((y+h2) < bottom) ||
		((y-h2) > top);
	}
	
	origin.x = x-w2*scale;
	origin.y = y-h2*scale;
	bsize.width = w;
	bsize.height = h;
	box.origin = origin;
	box.size = bsize;
}

- (void) outlinePath: (CGContextRef) context
{
	//By default, just draw our box outline, assuming our center is at (0,0)
	
	CGFloat w2 = box.size.width * 0.5;
	CGFloat h2 = box.size.height * 0.5;
	
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, -w2, h2); // top left
	CGContextAddLineToPoint(context, w2, h2); // top right
	CGContextAddLineToPoint(context, w2, -h2); // bottom right
	CGContextAddLineToPoint(context, -w2, -h2); // bottom left
	CGContextAddLineToPoint(context, -w2, h2); //back to top left
	CGContextClosePath(context);

}

- (void) drawBody: (CGContextRef) context
{
	CGContextSetRGBFillColor(context, r, g, b, alpha);
	[self outlinePath: context];
	CGContextDrawPath(context, kCGPathFill);
	
	
}

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
	t = CGAffineTransformTranslate(t, kScreenWidth/2+x, kScreenHeight/2-y); // step 3: move/position
	t = CGAffineTransformRotate(t, kPi * 0.5 - rotation); // step 2: rotate
	t = CGAffineTransformScale(t, scale, -scale); // step 1: scale
	
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

- (void) gradientFill: (CGContextRef) myContext
{
	CGGradientRef myGradient;
	CGColorSpaceRef myColorspace;
	
	CGPoint myStartPoint, myEndPoint;
	CGFloat myStartRadius, myEndRadius;
	
	CGFloat w2 = box.size.width*0.5;
	CGFloat h2 = box.size.height*0.5;
	myStartPoint.x = 0;
	myStartPoint.y = 0;
	myEndPoint.x = 0;
	myEndPoint.y = 0;
	myStartRadius = 0.0;
	myEndRadius = (w2 > h2) ? w2*1.5 : h2*1.5;
	size_t num_locations = 2;
	CGFloat locations[2] = { 0, 1.0 };
	CGFloat components[8] = { 
		r,g,b, 1.0,
		r,g,b, 0.1, 
	};
	myColorspace = CGColorSpaceCreateDeviceRGB();
	myGradient = CGGradientCreateWithColorComponents (myColorspace, components,
													  locations, num_locations);
	CGContextDrawRadialGradient (myContext, myGradient, myStartPoint,
								 myStartRadius, myEndPoint, myEndRadius,
								 kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(myGradient);
	CGColorSpaceRelease(myColorspace);
}


- (void) tic: (NSTimeInterval) dt
{
	if (!render) return;

   CGFloat spinBy = 0.0; // this round
	
	// disable this to make spinSpeed  endlessly cycle
	CGFloat spinByTotal = self.spinTo - self.rotation;

	if(spinByTotal!= 0.0){
		if(spinByTotal>180) spinByTotal = spinByTotal - 360;
		
		if(spinByTotal>0) {
			spinBy = MIN(spinSpeed*dt, spinByTotal);

		}else{
			spinBy = MAX(-spinSpeed*dt, spinByTotal);

		} 		
	}
	
	//if(spinBy>180) spinBy = spinBy-360;
	
	//if(autoSpin || spinBy){
		
	if(spinBy){

		[self setRotation: self.rotation + spinBy];
		if (self.rotation>180.0) {
			self.rotation = self.rotation -360.0;
		}
		if (self.rotation<-180.0) {
			self.rotation = self.rotation +360.0;
		}
		
		//[self setAngle: self.angle + spinSpeed];
		
		//NSLog(@"rotation: %f   angle %f",self.rotation,self.angle);
		
	}
	CGFloat sdt = speed*dt;
	x += sdt*cosTheta;
	y += sdt*sinTheta;
	if (sdt) [self updateBox];
}

- (float) getAngleTo: (Sprite *) otherSprite{
	/* return the absolute angle to other sprite
	 */
	
	float dx = otherSprite.x - self.x;
	float dy = otherSprite.y - self.y;
	
	float absoluteAngleTo =atan(dy/dx); // radians
	//float relativeAngleTo = angle - absoluteAngleTo; // <--if our rotation facing forward is normalized to 0, how much would we have to spin to face the other sprite ?
	return absoluteAngleTo * 180.0/kPi;

}

-(float) angleFromVectorWithDx: (float)dx Dy: (float)dy{

	/*
	 dx = 3; dy = 0; NSLog(@"%f,%f => %f",dx,dy, atan(dy/dx) * 180.0/kPi);
	dx = 3; dy = 3; NSLog(@"%f,%f => %f",dx,dy, atan(dy/dx) * 180.0/kPi);
	dx = 0; dy = 3; NSLog(@"%f,%f => %f",dx,dy, atan(dy/dx) * 180.0/kPi);
	dx = -3; dy = 3; NSLog(@"%f,%f => %f",dx,dy, atan(dy/dx) * 180.0/kPi);
	dx = -3; dy = 0; NSLog(@"%f,%f => %f",dx,dy, atan(dy/dx) * 180.0/kPi);
	dx = -3; dy = -3; NSLog(@"%f,%f => %f",dx,dy, atan(dy/dx) * 180.0/kPi);
	dx = 0; dy = -3; NSLog(@"%f,%f => %f",dx,dy, atan(dy/dx) * 180.0/kPi);
	dx = 3; dy = -3; NSLog(@"%f,%f => %f",dx,dy, atan(dy/dx) * 180.0/kPi);
	
	 problem:
	 
	 2010-08-26 09:30:07.383 Squadron[32108:207] 3.000000,0.000000 => 0.000000   OK
	 2010-08-26 09:30:07.387 Squadron[32108:207] 3.000000,3.000000 => 44.999999	OK
	 2010-08-26 09:30:07.388 Squadron[32108:207] 0.000000,3.000000 => 89.999999	OK
	 2010-08-26 09:30:07.388 Squadron[32108:207] -3.000000,3.000000 => -44.999999	ADD 180
	 2010-08-26 09:30:07.389 Squadron[32108:207] -3.000000,0.000000 => -0.000000	ADD 180
	 2010-08-26 09:30:07.390 Squadron[32108:207] -3.000000,-3.000000 => 44.999999	ADD 180
	 2010-08-26 09:30:07.390 Squadron[32108:207] 0.000000,-3.000000 => -89.999999 OK
	 2010-08-26 09:43:31.697 Squadron[32312:207] 3.000000,-3.000000 => -44.999999 OK

*/	 
	
	if (dx < 0) {
		return atan(dy/dx) * 180.0/kPi + 180;
	}
	
	return atan(dy/dx) * 180.0/kPi;
	
}

/*
// over-ride
-(void) setPalette:(ColorModel *) newPalette{
	palette = newPalette;
	[self setColorIndex: colorIndex]; // redraw
}
*/
-(void) setColorToIndex: (NSUInteger) colorNum{
	colorIndex = colorNum;
	
	//if (colorIndex>[palette.colors count]-1) {
//		//NSLog(@"UH OH!");
//		colorIndex = [palette.colors count] -1;
//	}
	//PlasmaModel *m = [PlasmaModel sharedModel];
	//ColorModel *palette = m.palette;
	
	//	NSAssert(colorNum<15, @"ColorNum is out of range");
	//
	//	if (colorNum>14) {
	//		colorNum = 14;
	//	}
	
	UIColor *color = [palette getColorAtIndex:colorIndex];
	self.r = [color red];
	self.g = [color green];
	self.b = [color blue];
	//NSLog(@"RGB = %f,%f,%f", self.r, self.g, self.b);
}

-(NSString *)colorAsRGBString{
	return [NSString stringWithFormat: @"%x%x%x", (int)(self.r *256), (int)(self.g*256), (int)(self.b*256)];
}

@end
