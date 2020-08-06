//
//  PlasmaBlock.m
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "PlasmaBlock.h"
#import "PlasmaModel.h"
#import "Constants.h"

#define dist(A,B,C,D) sqrt(((A - C) * (A - C) + (B - D) * (B - D)))

@implementation PlasmaBlock

@synthesize blockNum;


- (id) init
{
	self = [super init];
	if (self) {
		totalTime = 0;
	}
	return self;
}

-(void) dealloc {
	[palette release];
	[super dealloc];
}

/*
	colors
	
	dkblue 61,93,170
	ltblue 56,191,239
	yellow 218,225,31
	orange 243,123,132
	magenta 219,81,158
	
 
	
 
 
 */


- (void) tic: (NSTimeInterval)dt withAcceleration:(UIAccelerationValue[])acceleration{
	
	UIAccelerationValue Ax = acceleration[0];
	UIAccelerationValue Ay = acceleration[1];
	UIAccelerationValue Az = acceleration[2];
	
		
	/*
	It’s actually quite simple… we’re just calculating the colour for each pixel using the following code :
		
		v = Math.sin(dist(x + time, y, 128.0, 128.0) / 8.0)
		+ Math.sin(dist(x, y, 64.0, 64.0) / 8.0)
		+ Math.sin(dist(x, y  , 192.0, 64) / 7.0)
		+ Math.sin(dist(x, y+ time/ 7, 192.0, 100.0) / 8.0);
	colour = int((4 + v)) * 32;
	where x and y are the positions of the pixel, t is a value for time, incrementing by 1 every frame. The sin function is the Math.sin function, and dist is a function that calculates distance between two points:
		
		function dist(a:Number, b:Number, c:Number, d:Number)
	{
		return Math.sqrt(((a - c) * (a - c) + (b - d) * (b - d)))
	}
	
	*/
	totalTime = totalTime + dt;
	double tt = totalTime * 25;
	
/*
	THREE COLOR MODEL
 
 
	// R
	 double vR =    sin(dist(x + tt/2, y       , 128.0, 128.0) / 8.0)
	 + sin(dist(x     , y       ,  64.0,  64.0) / 8.0)
	 + sin(dist(x     , y       , 192.0,  64.0) / 7.0)
	 + sin(dist(x     , y + tt/2, 192.0, 100.0) / 8.0);
	
	float colorR = (4+vR) * 11;

	//G
	double vG =    sin(dist(x + tt/3, y       , 0.0, 0.0) / 22.0)
	+ sin(dist(x     , y       ,  320.0,  0.0) / 32.0)
	+ sin(dist(x     , y       , 320.0,  480.0) / 72.0)
	+ sin(dist(x     , y - tt/3, 320.0, 480.0) / 38.0);
	
	float colorG = (4+vG) * 15;
	
	
	//B
	
	double vB =   sin(dist(x     , y  -tt/7, -228.0, -228.0) / 8.0)
				+ sin(dist(x     , y       ,  -64.0,  -640.0) / 9.0)
				+ sin(dist(x     , y       , -0.0, -0.0) / 11.0)
				+ sin(dist(x +tt , y , 100.0, -1192.0) / 13.0);
	
		
	
	float colorB = (4+vB) * 32;
	
	if (blockNum ==1) {
	//	NSLog(@"v=%f color = %i", v, (int)color); 

	}
	
	self.r = colorR / 256.0;
	self.g = colorG / 256.0;
	self.b = colorB / 256.0;
	*/
	
	
	// BLUEscale model
	 /*
	double v =    sin(dist(x + tt/2, y       , 128.0, 128.0) / 8.0)
	+ sin(dist(x     , y       ,  64.0,  64.0) / 8.0)
	+ sin(dist(x     , y       , 192.0,  64.0) / 7.0)
	+ sin(dist(x     , y + tt/7, 192.0, 100.0) / 8.0);
	

	int color = (4+v) * 32;
	self.r = 0.0; //(color & 224)/224.0;
	self.g = 0.0; // (color & 28)/28.0;
	self.b = color/256.0;//(color & 3)/3.0;
	
	*/
	float x0 = x/9 -Ax*100;
	float y0 = y/7 -Ay*100;
	
	/*
	double v =    sin(dist(x0 + tt/2, y0 , 128.0, 128.0) / 8.0)
	+ sin(dist(x0, y0 , 192.0,  64.0) / (7.0+Ax))
	+ sin(dist(x0 -tt/22, y0 +tt/14    , 12.0,  64.0) / (5.0+Ay))
	+ sin(dist(x0     , y0 + tt/7, 192.0, 100.0) / (8.0-Az));
	*/
	
	double v =    sin(dist(x0 + tt/2, y0 , 128.0, 128.0) / 8.0)
				+ sin(dist(x0, y0 , 192.0,  64.0) / (7.0))
				+ sin(dist(x0 -tt/22, y0 +tt/14    , 12.0,  64.0) / (5.0))
				+ sin(dist(x0     , y0 + tt/7, 192.0, 100.0) / (8.0));
	
	
	int colorNum = 30+(4+v)*5.0; // hopefully 0-39 ?
	//NSLog(@"colorNum = %i",colorNum);
	
	[self setColorToIndex: colorNum * (1.0-Az/2.0)];
	
	[super tic:dt];
	
}@end
