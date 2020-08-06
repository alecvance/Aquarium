//
//  PieView.m
//  Aquarium
//
//  Created by Alec Vance on 9/28/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "PieView.h"
#import "Constants.h"
#import <QuartzCore/CALayer.h>
#import <QuartzCore/CAAnimation.h>

@implementation PieView
//@synthesize delegate;
@synthesize model;


- (void)dealloc {
	//delegate = nil;
	
	[model release];
    [super dealloc];
}

- (void) useModel: (PlasmaModel *) m
{
	
	self.model = m;
	ready = YES;
}


- (void)drawRect:(CGRect)rect {
	
	
	if (!ready) return;
	
	// Not really sure why I have to do this?!? for iPhone 4 only.
	//self.contentScaleFactor = 1.0;
	
	//Get a graphics context with no transformations
	
	//Get a graphics context, saving its state
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	//Reset the transformation
	//Doing this means you have to reset the contentScaleFactor to 1.0
//	CGAffineTransform t0 = CGContextGetCTM(context);
//	t0 = CGAffineTransformInvert(t0);
//	CGContextConcatCTM(context, t0);
	
	CGContextTranslateCTM(context, 0.0f, self.frame.size.height); CGContextScaleCTM(context, 1.0f, -1.0f);

	
	// Draw shadow
	[model.wheelShadow draw:context];
	
	NSMutableArray *sprites = [model wedges];
	for(Sprite *sprite in sprites){
		[sprite draw: context];
	} 
	
	
	/* 
	 //test draw arcwedge 
	 CGContextSetRGBFillColor(context, 0.3, 0.6, 0.5, 1.0);
	 CGFloat Cx = 0;
	 CGFloat Cy = 0;
	 CGFloat radius = 150;
	 CGFloat startAngle = 0; // -rotation; 
	 CGFloat endAngle = .25* kPi;
	 int clockwise = 0;
	 CGContextBeginPath(context);
	 CGContextMoveToPoint(context, Cx, Cy);  
	 CGContextAddArc(context, Cx, Cy, radius, startAngle, endAngle, clockwise);
	 CGContextAddLineToPoint(context, Cx, Cy);
	 CGContextClosePath(context);
	 CGContextDrawPath(context, kCGPathFill);
	 // end test draw arcwedge 
	 */
	
	
	CGContextRestoreGState(context);
	
	
}

- (void) tic: (NSTimeInterval) dt
{
	if (!model) return;
	[self setNeedsDisplay];
}


/*
-(void) startAnimation{
	// pie layer rotation
	CABasicAnimation *rotationAnimation = [CABasicAnimation 
										   animationWithKeyPath:@"transform.rotation.z"];
	
	[rotationAnimation setFromValue:0];
	[rotationAnimation setToValue:[NSNumber numberWithFloat: 2*kPi]];
	[rotationAnimation setDuration:24.0f];
	[rotationAnimation setRepeatCount:HUGE_VALF];
	
	[[self layer] addAnimation:rotationAnimation forKey:@"rotate"];
	
}

-(void) stopAnimation {
	[[self layer] removeAllAnimations];
}
*/





@end
