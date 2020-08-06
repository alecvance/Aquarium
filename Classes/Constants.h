/*
 *  Constants.h
 *  Aquarium
 *
 *  Created by Alec Vance on 8/17/10.
 *  Copyright 2010 Juggleware, LLC. All rights reserved.
 *
 */

//
// Configuration constants
//
#define kDiscID @"4a9d93fb956f4162a88b974735055dc9"
#define kShowDebugStatus 0

#define kHtmlBaseDir @"Pages"

#define RANDOM_SEED() srandom(time(NULL))
#define RANDOM_INT(__MIN__, __MAX__) ((__MIN__) + random() % ((__MAX__+1) - (__MIN__)))

#define kAccelerometerFrequency 10 //Hz
#define kFilteringFactor 0.25 // for accelerometer gravity lowpass filter compensation 

#define kFPS 30.0 // not applicable when using CADisplayLink
#define kPi  3.1415927

#define kMinSwipeDistance 200
#define kMaxSwipeTolerance 20

// a handy constant to keep around
#define APRADIANS_TO_DEGREES 57.2958

// material import settings
#define AP_CONVERT_TO_4444 0
#define RANDOM_PCT() (((CGFloat)(arc4random() % 40001) )/40000.0)

// Various constants 
#define kScreenWidth ((int)[UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ((int)[UIScreen mainScreen].bounds.size.height)

#define kWheelControllerX 0.0
#define kWheelControllerY 0.0
#define kWheelRadius 100.0

#define kBlockSize 16

//Audio

#define kMixerChannels 8
#define kFadeVolumeIncrement 0.05

#define kDefaultFont			@"Helvetica"
#define kDefaultFontSize		14

// Various states
//#define kUnknown	-1
//#define kScore		@"score"
//#define kLevel		@"level"
//#define kLife		@"life"
//#define kDied		@"dead"
//#define kGameOver	@"over"
//
//#define kGameState			@"gameState"
//#define kGameStatePlay		0
//#define kGameStateLevel		1
//#define kGameStateNewLife	2
//#define kGameStateDone		3

//#define kEnemySpacing 32
//#define kTotalBlocks 1900
//#define kMaxRows 6
//#define kAngleOfView 45
//#define kMaxLeaderDistance 100

