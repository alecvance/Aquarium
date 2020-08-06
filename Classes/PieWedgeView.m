//
//  PieWedgeView.m
//  Aquarium
//
//  Created by Alec Vance on 9/28/10.
//  Copyright 2010 Juggleware, LLC. All rights reserved.
//

#import "PieWedgeView.h"


@implementation PieWedgeView
@synthesize delegate;
@synthesize wedgeNum;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	//	[[[UIApplication sharedApplication] delegate] showTabBar];
	//NSLog(@"Got pie wedge touch");
	[delegate userSelectedPieWedgeNum:self.wedgeNum];

}

-(BOOL)canBecomeFirstResponder{
	return YES;
}

- (void)dealloc {
	
	delegate = nil;
	
    [super dealloc];
}


@end
