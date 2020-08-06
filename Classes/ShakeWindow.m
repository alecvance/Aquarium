//
//  ShakeWindow.m
//  Aquarium
//
//  Created by Alec Vance on 12/2/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "ShakeWindow.h"


@implementation ShakeWindow

- (void)dealloc {
    [super dealloc];
}

/*
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}
*/
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceShaken" object:self];
    }
}


@end
