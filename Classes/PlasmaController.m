//
//  PlasmaController.m
//  Squadron
//
//  Created by Alec Vance on 8/16/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "PlasmaController.h"
#import "Constants.h"

@implementation PlasmaController

@synthesize model, view, pieView, start;

-(void) dealloc{
	[model release];
	[view release];
	[pieView release];

	[super dealloc];
}

- (id) initWithView: (PlasmaView *) v palette: (ColorModel *)palette;
{
	self = [super init];
	if (self) {
		//PlasmaModel *m = [PlasmaModel sharedModel];
		
		//self.audio = [[AudioController alloc] init];
		self.model = [[PlasmaModel alloc] initWithPalette:palette];
		self.view = v;
		self.start = YES;
		
		_accelerometer[0] = 0.0;
		_accelerometer[1] = 0.0;
		_accelerometer[2] = 0.0;
		
		[model initState];
		[v useModel: model];
	}
	return self;
}


-(void) addPieView: (PieView *)v
{
	self.pieView = v;
	[v useModel: model];
}

- (void) tic: (NSTimeInterval) dt
{
	
	
	if (start) {
		start = NO;
		model.time = 0;
	}else {
		[self updateModel: dt];
		[self updateView: dt];
		[self updatePieView: dt];
		// [audio tic: dt];
	}

}

- (void) updateModel: (NSTimeInterval) dt
{
	model.time += dt;
	[self movePlasmaBlocks: dt];
	[self moveColorWheel:dt];
}


- (void) updateView: (NSTimeInterval) dt
{
	[view tic: dt];
}		

- (void) updatePieView: (NSTimeInterval) dt
{
	[pieView tic: dt];
}		

- (void) movePlasmaBlocks: (NSTimeInterval) dt
{
	for (PlasmaBlock *block	in model.blocks) {
		// we use our own autorelease pool so that we can control when garbage gets collected
	//	NSAutoreleasePool * apool = [[NSAutoreleasePool alloc] init];
	//	PlasmaBlock *block = (PlasmaBlock *)sprite;
		[block tic: dt withAcceleration:_accelerometer];
	//	[apool drain];
	//	[apool release];
	}
}

- (void) moveColorWheel: (NSTimeInterval) dt
{
	for (Sprite *sprite	in model.wedges) {
		// we use our own autorelease pool so that we can control when garbage gets collected
		//	NSAutoreleasePool * apool = [[NSAutoreleasePool alloc] init];
		//	PlasmaBlock *block = (PlasmaBlock *)sprite;
		[sprite tic:dt	];
		//	[apool drain];
		//	[apool release];
	}
}



- (void) updateAccelerometerWith:(UIAcceleration *)acceleration {
	/*
	_accelerometer[0] = acceleration.x;
	_accelerometer[1] = acceleration.y;
	_accelerometer[2] = acceleration.z;
	*/
	
	 //Use a basic low-pass filter to only keep the gravity in the accelerometer values
	 _accelerometer[0] = acceleration.x * kFilteringFactor + _accelerometer[0] * (1.0 - kFilteringFactor);
	 _accelerometer[1] = acceleration.y * kFilteringFactor + _accelerometer[1] * (1.0 - kFilteringFactor);
	 _accelerometer[2] = acceleration.z * kFilteringFactor + _accelerometer[2] * (1.0 - kFilteringFactor);
	
}

@end
