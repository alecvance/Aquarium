//
//  PlasmaController.h
//  Squadron
//
//  Created by Alec Vance on 8/16/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlasmaModel.h"
#import "PlasmaView.h"
#import "PieView.h"

@interface PlasmaController : NSObject {
	PlasmaModel *model;
	PlasmaView *view;
	PieView *pieView;
	//AudioController *audio;
	BOOL start;
	int restartDelay;
	
	UIAccelerationValue _accelerometer[3];

}

@property (assign) PlasmaModel *model;
@property (assign) PlasmaView *view;
@property (assign) PieView *pieView;

//@property (nonatomic, retain) AudioController *audio;
@property (assign) BOOL start;

- (id) initWithView: (PlasmaView *) v palette: (ColorModel *)palette;
- (void) addPieView: (PieView *)v;

- (void) tic: (NSTimeInterval) dt;
- (void) updateModel: (NSTimeInterval) dt;
- (void) updateView: (NSTimeInterval) dt;
- (void) updatePieView: (NSTimeInterval) dt;

- (void) movePlasmaBlocks: (NSTimeInterval) dt;
- (void) moveColorWheel: (NSTimeInterval) dt;

- (void) updateAccelerometerWith:(UIAcceleration *)acceleration;
@end
