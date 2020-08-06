//
//  PlasmaView.m
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "PlasmaView.h"
#import "Constants.h"

@implementation PlasmaView

@synthesize model;

- (void)dealloc{
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
	//CGAffineTransform t0 = CGContextGetCTM(context);
//	t0 = CGAffineTransformInvert(t0);
//	CGContextConcatCTM(context, t0);
	
	/*
	 http://stackoverflow.com/questions/3896968/how-do-i-adjust-a-quartz-2d-context-to-account-for-a-retina-display
	 
	 Removing the Transformation reset above abd replacing it with the below to make coordinates
	 conform to Quartz space.
	 
	 
	 */
	CGContextTranslateCTM(context, 0.0f, self.frame.size.height); CGContextScaleCTM(context, 1.0f, -1.0f);
	
	NSMutableArray *sprites = [model blocks];
	for(Sprite *sprite in sprites){
		[sprite draw: context];
	}
	
	CGContextRestoreGState(context);
	
	
}

- (void) tic: (NSTimeInterval) dt
{
	if (!model) return;
	[self setNeedsDisplay];
}




@end
