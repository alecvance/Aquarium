//
//  PlasmaBlock.h
//  Aquarium
//
//  Created by Alec Vance on 9/13/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sprite.h"

@interface PlasmaBlock : Sprite {
	NSTimeInterval totalTime;
	int blockNum;
}

@property int blockNum;
- (void) tic: (NSTimeInterval) dt withAcceleration:(UIAccelerationValue[])acceleration;
@end
