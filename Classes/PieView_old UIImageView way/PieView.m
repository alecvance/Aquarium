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
#import "PieWedgeView.h"

@implementation PieView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
			
    }
    return self;
}

-(void) createWheel{
	// Make pie wheel controller with UIImages	
	NSArray *imageSet = [NSArray arrayWithObjects: 
						 [UIImage imageNamed:@"1-nav-pie-yellow.png"],
						 [UIImage imageNamed:@"2-nav-pie-lightblue.png"],
						 [UIImage imageNamed:@"3-nav-pie-darkblue.png"],
						 [UIImage imageNamed:@"4-nav-pie-pink.png"],
						 [UIImage imageNamed:@"5-nav-pie-peach.png"], nil];
	
	static CGFloat kAnchorPoints[] = {  1.0-1.0/176.0, 1.0,
		1.0/176.0, 1.0,
		1.0/185.0, 58.0/207.0,
		0.5, 1.0/185.0,
		1.0-1.0/185.0, 58.0/207.0};
	
	
	for (int i = 0; i<[imageSet count]; i++) {
		PieWedgeView *iv = [[PieWedgeView alloc] initWithImage:[imageSet objectAtIndex:i]];
		iv.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		iv.layer.anchorPoint = CGPointMake(kAnchorPoints[i*2],kAnchorPoints[i*2+1]);	
		iv.layer.contentsScale = 0.5;
		[iv setWedgeNum: i];
		[iv setDelegate: self];
		
		/*
		 Override canBecomeFirstResponder and return YES to indicate that the view can become 
		 the focus of touch events (the default is NO).
		 
		 Set the userInteractionEnabled property to YES. The default for UIViews is YES, but 
		 for UIImageViews is NO so you have to explicitly turn it on.
		 
		 If you want to respond to multi-touch events (i.e. pinch, zoom, etc) you'll want to 
		 set multipleTouchEnabled to YES.
		 
		*/
		
		//iv.userInteractionEnabled = YES;
		
		
		[self addSubview:iv];		
	}
	
}

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//	[[[UIApplication sharedApplication] delegate] showTabBar];
	NSLog(@"Got pie touch");
}

#pragma mark PieWedgeViewDelegate methods
-(void) userSelectedPieWedgeNum:(int)number{
//	NSLog(@"Selected wedge #%i", number);
	[delegate userSelectedPieWedgeNum:(int)number];
}


- (void)dealloc {
	delegate = nil;
    [super dealloc];
}


@end
